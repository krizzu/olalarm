import Foundation
import Logging
import SQLiteData

public actor AppDatabase {
    public static let shared: DatabaseWriter = createAppDatabase()

    private init() {}
}

let logger = Logger(label: "olalarm.AppDatabase")
private func createAppDatabase() -> any DatabaseWriter {
    var config = Configuration()
    config.journalMode = .wal
    #if DEBUG
    #endif

    let database = try! DatabasePool(path: databasePath, configuration: config)
    logger.info("database open at '\(database.path)'")

    var migrator = DatabaseMigrator()

    #if DEBUG
        migrator.eraseDatabaseOnSchemaChange = true
    #endif

    migrator.registerMigration("create_tables", migrate: { db in
        try! #sql("""
        CREATE TABLE olalarms (
            id TEXT PRIMARY KEY,
            name TEXT NOT NULL,
            trigger_time TEXT NOT NULL,
            state TEXT NOT NULL,
            snooze INTEGER,
            sound_id TEXT,
            created_at INTEGER NOT NULL default current_timestamp
        )
        """).execute(db)
    })

    try! migrator.migrate(database)
    logger.info("database migration done")

    return database
}

private var databasePath: String {
    get throws {
        let applicationSupportDirectory = try FileManager.default.url(
            for: .applicationSupportDirectory,
            in: .userDomainMask,
            appropriateFor: nil,
            create: true
        )
        return applicationSupportDirectory.appendingPathComponent("olalarm_database.db").absoluteString
    }
}
