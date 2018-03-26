require('dotenv').config()
const fs = require('fs')
const jsonlint = require('jsonlint')
const { Pool, Client } = require('pg')
const query = fs.readFileSync('query.sql').toString()

// const pool = new Pool({
//   connectionString: connectionString,
// })

// pool.query('SELECT * FROM gda.d_cedex', (err, res) => {
//   console.log(err, res)
//   pool.end()
// })

const fileCreate = table => {
  let json = JSON.stringify(table)
  fs.writeFile('export/titres.json', json, 'utf8', err => {
    if (err) {
      console.log('fileCreate error', err)
    } else {
      console.log('File saved')
    }
  })
}

const client = new Client()
client.connect()

client.query(query, (err, res) => {
  if (err) {
    console.log('error', err)
  } else {
    console.log('success', res.rows)
    fileCreate(res.rows)
  }
  client.end()
})
