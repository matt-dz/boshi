import { Pool } from 'pg'
import { Kysely, Migrator, PostgresDialect } from 'kysely'
import { DatabaseSchema } from './schema'
import { migrationProvider } from './migrations'
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
    dialect,
  })
}

export const migrateToLatest = async (db: Database) => {
  const migrator = new Migrator({ db, provider: migrationProvider })
  const { error } = await migrator.migrateToLatest()
  if (error) throw error
}

export type Database = Kysely<DatabaseSchema>
