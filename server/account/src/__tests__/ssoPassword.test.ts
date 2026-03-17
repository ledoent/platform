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

import {
  type MeasureContext,
  type PersonUuid,
  type AccountUuid
} from '@hcengineering/core'
import platform, { PlatformError, Severity, Status } from '@hcengineering/platform'
import { decodeTokenVerbose } from '@hcengineering/server-token'

import { type AccountDB } from '../types'
import { getMethods } from '../operations'

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

describe('checkHasPassword', () => {
  const mockCtx = { error: jest.fn(), info: jest.fn(), warn: jest.fn() } as unknown as MeasureContext
  const accountUuid = 'account-uuid' as PersonUuid

  const mockDb = {
    account: { findOne: jest.fn() }
  } as unknown as AccountDB

  const methods = getMethods()
  const checkHasPassword = methods.checkHasPassword!

  beforeEach(() => {
    jest.clearAllMocks()
    ;(decodeTokenVerbose as jest.Mock).mockReturnValue({ account: accountUuid })
  })

  test('returns true when account has password hash', async () => {
    ;(mockDb.account.findOne as jest.Mock).mockResolvedValue({
      uuid: accountUuid,
      hash: Buffer.from('hash'),
      salt: Buffer.from('salt')
    })

    const result = await checkHasPassword(mockCtx, mockDb, null, { id: 1, params: {} }, 'token')
    expect(result.result).toBe(true)
  })

  test('returns false when account has no password hash (SSO-only)', async () => {
    ;(mockDb.account.findOne as jest.Mock).mockResolvedValue({
      uuid: accountUuid,
      hash: null,
      salt: null
    })

    const result = await checkHasPassword(mockCtx, mockDb, null, { id: 1, params: {} }, 'token')
    expect(result.result).toBe(false)
  })

  test('returns false for partial state (hash set but salt null)', async () => {
    ;(mockDb.account.findOne as jest.Mock).mockResolvedValue({
      uuid: accountUuid,
      hash: Buffer.from('hash'),
      salt: null
    })

    const result = await checkHasPassword(mockCtx, mockDb, null, { id: 1, params: {} }, 'token')
    expect(result.result).toBe(false)
  })

  test('returns false for partial state (salt set but hash null)', async () => {
    ;(mockDb.account.findOne as jest.Mock).mockResolvedValue({
      uuid: accountUuid,
      hash: null,
      salt: Buffer.from('salt')
    })

    const result = await checkHasPassword(mockCtx, mockDb, null, { id: 1, params: {} }, 'token')
    expect(result.result).toBe(false)
  })

  test('throws AccountNotFound for missing account', async () => {
    ;(mockDb.account.findOne as jest.Mock).mockResolvedValue(null)

    const result = await checkHasPassword(mockCtx, mockDb, null, { id: 1, params: {} }, 'token')
    expect(result.error).toBeDefined()
  })
})

describe('changePassword SSO flow', () => {
  const mockCtx = { error: jest.fn(), info: jest.fn(), warn: jest.fn() } as unknown as MeasureContext
  const accountUuid = 'account-uuid' as PersonUuid

  const mockDb = {
    account: { findOne: jest.fn() },
    accountEvent: { insertOne: jest.fn() },
    setPassword: jest.fn()
  } as unknown as AccountDB

  const methods = getMethods()
  const changePassword = methods.changePassword!

  beforeEach(() => {
    jest.clearAllMocks()
    ;(decodeTokenVerbose as jest.Mock).mockReturnValue({ account: accountUuid })
  })

  test('SSO-only: allows setting password with empty oldPassword', async () => {
    ;(mockDb.account.findOne as jest.Mock).mockResolvedValue({
      uuid: accountUuid,
      hash: null,
      salt: null
    })

    const result = await changePassword(
      mockCtx, mockDb, null,
      { id: 1, params: { oldPassword: '', newPassword: 'newpass123' } },
      'token'
    )

    expect(result.result).toBeUndefined() // void return = success
    expect(result.error).toBeUndefined()
    expect(mockDb.setPassword).toHaveBeenCalled()
  })

  test('SSO-only: rejects empty newPassword', async () => {
    ;(mockDb.account.findOne as jest.Mock).mockResolvedValue({
      uuid: accountUuid,
      hash: null,
      salt: null
    })

    const result = await changePassword(
      mockCtx, mockDb, null,
      { id: 1, params: { oldPassword: '', newPassword: '' } },
      'token'
    )

    expect(result.error).toBeDefined()
    expect(mockDb.setPassword).not.toHaveBeenCalled()
  })

  test('existing password: rejects empty oldPassword', async () => {
    ;(mockDb.account.findOne as jest.Mock).mockResolvedValue({
      uuid: accountUuid,
      hash: Buffer.from('hash'),
      salt: Buffer.from('salt')
    })

    const result = await changePassword(
      mockCtx, mockDb, null,
      { id: 1, params: { oldPassword: '', newPassword: 'newpass123' } },
      'token'
    )

    expect(result.error).toBeDefined()
    expect(mockDb.setPassword).not.toHaveBeenCalled()
  })

  test('existing password: rejects wrong oldPassword', async () => {
    ;(mockDb.account.findOne as jest.Mock).mockResolvedValue({
      uuid: accountUuid,
      hash: Buffer.from('hash'),
      salt: Buffer.from('salt')
    })

    const result = await changePassword(
      mockCtx, mockDb, null,
      { id: 1, params: { oldPassword: 'wrongpass', newPassword: 'newpass123' } },
      'token'
    )

    expect(result.error).toBeDefined()
    expect(mockDb.setPassword).not.toHaveBeenCalled()
  })
})
