import { randomInt } from 'node:crypto'
let results = parseInt(process.argv[2])
if (typeof results !== 'number')
  results = 1
else if (!Number.isSafeInteger(results))
  results = 1
else if (results < 1)
  results = 1
else if (results > 100)
  results = 100
const symbols = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789'
for (let result = 0; result < results; ++result) {
  const suid = Array.from({ length: 15 })
  for (let index = 0; index < suid.length; ++index)
    suid[index] = symbols[randomInt(symbols.length)]
  console.log(`~${suid.join('')}`)
}
