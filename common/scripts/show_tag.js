//
// Copyright © 2024 Hardcore Engineering Inc.
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

const fs = require('fs')
const path = require('path')
const exec = require('child_process').exec

function emit (raw) {
  const parts = raw.replace(/^v/, '').replace(/^s/, '').split('.')
  if (parts.length === 3) {
    console.log(`"${parseInt(parts[0])}.${parseInt(parts[1])}.${parseInt(parts[2])}"`)
    return true
  }
  return false
}

function main () {
  // Prefer common/scripts/version.txt — git describe fails when HEAD has no
  // reachable tag (e.g. building from a develop SHA), and the hardcoded
  // "0.6.0" fallback then leaks into the UI. version.txt is upstream's
  // source of truth for the in-development version.
  try {
    const raw = fs.readFileSync(path.resolve(__dirname, 'version.txt'), 'utf8')
      .trim().replace(/^"/, '').replace(/"$/, '')
    if (raw && emit(raw)) return
  } catch (_) {
    // version.txt missing — fall back to git describe
  }

  exec('git describe --tags --abbrev=0', (err, stdout) => {
    if (err !== null) {
      console.log('"0.6.0"')
      return
    }
    emit(stdout.trim())
  })
}

main()
