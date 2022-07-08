import { readdir, readFile } from 'node:fs/promises'
import isValidUTF8 from 'utf-8-validate'

let queue = [ '../..' ]
let files = {}
let count = 0

while (queue.length) {
  let entries = await Promise.all(queue.slice(0, 100).map( path => readdir(path, { withFileTypes: true }) ))
  for (let i = 0; i < entries.length; ++i) {
    for (const entry of entries[i]) {
      if (entry.isDirectory()) {
        queue.push(`${queue[i]}/${entry.name}`)
      }
      else if (entry.isFile() && entry.name.endsWith('.dm')) {
        files[`${queue[i]}/${entry.name}`] = true
      }
    }
  }
  queue = queue.slice(entries.length)
}

files = Object.keys(files)

while (files.length) {
  let queue = files.slice(0, 100)
  let buffers = await Promise.all(queue.map( path => readFile(path) ))
  for (let i = 0; i < queue.length; ++i) {
    if (!isValidUTF8(buffers[i])) {
      console.log(queue[i])
      ++count
    }
  }
  files = files.slice(100)
}

if (count) {
  process.exit(1)
}
