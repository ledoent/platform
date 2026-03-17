//
// Copyright © 2025 Hardcore Engineering Inc.
//
// Licensed under the Eclipse Public License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License. You may
// obtain a copy of the License at https://www.eclipse.org/legal/epl-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//
// See the License for the specific language governing permissions and
// limitations under the License.
//

/**
 * Tests for CJK (Chinese/Japanese/Korean) name handling in auth providers.
 * Validates fix for #10628: OIDC login fails for users with single-word names.
 *
 * The auth providers parse display names from OIDC/GitHub into first/last.
 * CJK names typically have no space, so `name.split(' ')` returns a single
 * element and last name was undefined, crashing the DB insert.
 */

import {
  SocialIdType,
  type MeasureContext,
  type PersonUuid
} from '@hcengineering/core'
import { generateToken } from '@hcengineering/server-token'

import { loginOrSignUpWithProvider } from '../utils'
import { type AccountDB } from '../types'

jest.mock('@hcengineering/platform', () => {
  const actual = jest.requireActual('@hcengineering/platform')
  return {
    ...actual,
    ...actual.default,
    getMetadata: jest.fn(),
    translate: jest.fn((id: string, params: any) => `${id} << ${JSON.stringify(params)}`)
  }
})

jest.mock('@hcengineering/server-token', () => {
  class TokenError extends Error {
    constructor (msg: string) {
      super(msg)
      this.name = 'TokenError'
    }
  }
  return {
    decodeTokenVerbose: jest.fn(),
    decodeToken: jest.fn(),
    TokenError,
    generateToken: jest.fn().mockReturnValue('mocked-token')
  }
})

// ── Name parsing logic (mirrors auth provider inline code) ──
// These test the exact same expressions used in openid.ts and github.ts

function parseOidcName (user: {
  name?: string
  username?: string
  given_name?: string
  family_name?: string
}): { first: string, last: string } {
  const nameParts = (user.name ?? user.username ?? '').split(' ')
  const first: string = user.given_name ?? nameParts[0] ?? ''
  const last: string = user.family_name ?? nameParts.slice(1).join(' ')
  return { first, last }
}

function parseGithubName (user: {
  displayName?: string
  username?: string
}): { first: string, last: string } {
  const nameParts = (user.displayName ?? user.username ?? '').split(' ')
  const first: string = nameParts[0] ?? ''
  const last: string = nameParts.slice(1).join(' ')
  return { first, last }
}

describe('OIDC name parsing', () => {
  test('CJK single-word name: 西门吹雪', () => {
    const { first, last } = parseOidcName({ name: '西门吹雪' })
    expect(first).toBe('西门吹雪')
    expect(last).toBe('')
  })

  test('Japanese single-word name: 田中', () => {
    const { first, last } = parseOidcName({ name: '田中' })
    expect(first).toBe('田中')
    expect(last).toBe('')
  })

  test('Korean single-word name: 김철수', () => {
    const { first, last } = parseOidcName({ name: '김철수' })
    expect(first).toBe('김철수')
    expect(last).toBe('')
  })

  test('Western multi-word name splits correctly', () => {
    const { first, last } = parseOidcName({ name: 'Jean Claude' })
    expect(first).toBe('Jean')
    expect(last).toBe('Claude')
  })

  test('Western three-part name keeps middle+last together', () => {
    const { first, last } = parseOidcName({ name: 'Jean Claude Van Damme' })
    expect(first).toBe('Jean')
    expect(last).toBe('Claude Van Damme')
  })

  test('single-word Western name (Madonna)', () => {
    const { first, last } = parseOidcName({ name: 'Madonna' })
    expect(first).toBe('Madonna')
    expect(last).toBe('')
  })

  test('prefers given_name/family_name claims when available', () => {
    const { first, last } = parseOidcName({
      name: '吹雪 西门',
      given_name: '吹雪',
      family_name: '西门'
    })
    expect(first).toBe('吹雪')
    expect(last).toBe('西门')
  })

  test('falls back to name split when given_name/family_name absent', () => {
    const { first, last } = parseOidcName({ name: 'Alice Bob' })
    expect(first).toBe('Alice')
    expect(last).toBe('Bob')
  })

  test('falls back to username when name is undefined', () => {
    const { first, last } = parseOidcName({ username: 'jdoe' })
    expect(first).toBe('jdoe')
    expect(last).toBe('')
  })

  test('handles completely empty user', () => {
    const { first, last } = parseOidcName({})
    expect(first).toBe('')
    expect(last).toBe('')
  })
})

describe('GitHub name parsing', () => {
  test('CJK single-word displayName', () => {
    const { first, last } = parseGithubName({ displayName: '西门吹雪' })
    expect(first).toBe('西门吹雪')
    expect(last).toBe('')
  })

  test('Western multi-word displayName', () => {
    const { first, last } = parseGithubName({ displayName: 'John Doe' })
    expect(first).toBe('John')
    expect(last).toBe('Doe')
  })

  test('falls back to username when displayName is undefined', () => {
    const { first, last } = parseGithubName({ username: 'octocat' })
    expect(first).toBe('octocat')
    expect(last).toBe('')
  })

  test('handles empty input', () => {
    const { first, last } = parseGithubName({})
    expect(first).toBe('')
    expect(last).toBe('')
  })
})

describe('loginOrSignUpWithProvider with CJK names', () => {
  const mockCtx = {
    info: jest.fn(),
    error: jest.fn()
  } as unknown as MeasureContext

  const mockDb = {
    socialId: {
      find: jest.fn(() => []),
      findOne: jest.fn(),
      insertOne: jest.fn(),
      update: jest.fn()
    },
    account: {
      findOne: jest.fn(),
      insertOne: jest.fn()
    },
    accountEvent: {
      findOne: jest.fn(),
      insertOne: jest.fn()
    },
    person: {
      findOne: jest.fn(),
      insertOne: jest.fn(),
      update: jest.fn()
    },
    userProfile: {
      insertOne: jest.fn()
    },
    resetPassword: jest.fn()
  } as unknown as AccountDB

  beforeEach(() => {
    jest.clearAllMocks()
    ;(generateToken as jest.Mock).mockReturnValue('mocked-token')
  })

  test('creates account with CJK single-word name (empty last name)', async () => {
    const personUuid = 'new-person' as PersonUuid
    ;(mockDb.socialId.findOne as jest.Mock).mockResolvedValue(null)
    ;(mockDb.socialId.insertOne as jest.Mock).mockResolvedValue('social-id')
    ;(mockDb.person.insertOne as jest.Mock).mockResolvedValue(personUuid)
    ;(mockDb.person.findOne as jest.Mock).mockResolvedValue({ firstName: '西门吹雪', lastName: '' })
    ;(mockDb.account.findOne as jest.Mock).mockResolvedValue(null)

    const result = await loginOrSignUpWithProvider(
      mockCtx,
      mockDb,
      null,
      'user@example.com',
      '西门吹雪',
      '', // empty last name from CJK parsing
      { type: SocialIdType.OIDC, value: 'oidc-sub-123' }
    )

    expect(result).toBeDefined()
    expect(result?.account).toBe(personUuid)

    // Verify DB insert was called with empty string, not undefined
    expect(mockDb.person.insertOne).toHaveBeenCalledWith({
      firstName: '西门吹雪',
      lastName: ''
    })
  })

  test('creates account with undefined last name (defensive fallback)', async () => {
    const personUuid = 'new-person' as PersonUuid
    ;(mockDb.socialId.findOne as jest.Mock).mockResolvedValue(null)
    ;(mockDb.socialId.insertOne as jest.Mock).mockResolvedValue('social-id')
    ;(mockDb.person.insertOne as jest.Mock).mockResolvedValue(personUuid)
    ;(mockDb.person.findOne as jest.Mock).mockResolvedValue({ firstName: '田中', lastName: '' })
    ;(mockDb.account.findOne as jest.Mock).mockResolvedValue(null)

    // Simulate the old broken behavior where last could be undefined
    const result = await loginOrSignUpWithProvider(
      mockCtx,
      mockDb,
      null,
      'tanaka@example.jp',
      '田中',
      undefined as any, // this is what the old code produced
      { type: SocialIdType.OIDC, value: 'oidc-sub-456' }
    )

    expect(result).toBeDefined()

    // With the fix, the ?? '' fallback ensures lastName is never undefined
    const insertCall = (mockDb.person.insertOne as jest.Mock).mock.calls[0][0]
    expect(insertCall.lastName).toBeDefined()
    expect(typeof insertCall.lastName).toBe('string')
  })
})
