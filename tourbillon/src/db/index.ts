import { Pool } from 'pg'
import { Kysely, PostgresDialect } from 'kysely'
import { DatabaseSchema } from './schema'
import { PostgresConfig } from '../config'

export const createDb = (config: PostgresConfig): Database => {
  const dialect = new PostgresDialect({
    pool: new Pool({
      database: config.database,
      user: config.username,
      password: config.password,
      host: config.host,
      port: Number(config.port),
      max: 10,
    }),
  })

  return new Kysely<DatabaseSchema>({
    log: ['query', 'error'],
    dialect,
  })
}

export type Database = Kysely<DatabaseSchema>
