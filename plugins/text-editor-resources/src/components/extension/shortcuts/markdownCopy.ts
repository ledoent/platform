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

import { markupToMarkdown } from '@hcengineering/text-markdown'
import { Extension } from '@tiptap/core'
import { type Slice } from '@tiptap/pm/model'
import { Plugin } from '@tiptap/pm/state'

export const MarkdownCopyExtension = Extension.create({
  name: 'markdownCopy',

  addProseMirrorPlugins () {
    return [
      new Plugin({
        props: {
          clipboardTextSerializer (slice: Slice) {
            const children: any[] = []
            slice.content.forEach((node) => {
              children.push(node.toJSON())
            })

            const markup = { type: 'doc', content: children }
            return markupToMarkdown(markup)
          }
        }
      })
    ]
  }
})
