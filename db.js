const Pool = require("pg").Pool;
require("dotenv").config();

const pool = new Pool({
  DATABASE_URL,
});

module.exports = pool;
