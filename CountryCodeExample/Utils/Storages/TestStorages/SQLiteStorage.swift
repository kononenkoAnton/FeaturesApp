//
//  SQLiteStorage.swift
//  CountryCodeExample
//
//  Created by Anton Kononenko on 11/15/24.
//


//import Foundation
//import SQLite3
//
////TODO: Just test, not implemnted fully
//actor SQLiteStorage<Value: Hashable & Codable>: Storage {
//    typealias Key = String
//
//    private var db: OpaquePointer?
//
//    init(databaseName: String = "storage.sqlite") throws {
//        let dbURL = try FileManager.default
//            .url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
//            .appendingPathComponent(databaseName)
//
//        if sqlite3_open(dbURL.path, &db) != SQLITE_OK {
//            defer { if db != nil { sqlite3_close(db) } }
//            throw SQLiteStorageError.databaseInitializationFailed(message: errorMessage)
//        }
//
//        try createTableIfNeeded()
//    }
//
//    deinit {
//        if db != nil {
//            sqlite3_close(db)
//        }
//    }
//
//    func retrieve(forKey key: String) async throws -> Value? {
//        let query = "SELECT value FROM storage WHERE key = ?;"
//        var statement: OpaquePointer?
//
//        if sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK {
//            defer { sqlite3_finalize(statement) }
//
//            sqlite3_bind_text(statement, 1, key, -1, nil)
//
//            if sqlite3_step(statement) == SQLITE_ROW {
//                if let dataPointer = sqlite3_column_blob(statement, 0) {
//                    let dataSize = sqlite3_column_bytes(statement, 0)
//                    let data = Data(bytes: dataPointer, count: Int(dataSize))
//                    let value = try JSONDecoder().decode(Value.self, from: data)
//                    return value
//                } else {
//                    return nil
//                }
//            } else {
//                return nil
//            }
//        } else {
//            throw SQLiteStorageError.databaseError(message: errorMessage)
//        }
//    }
//
//    func store(forKey key: String, value: Value) async throws {
//        let query = "INSERT OR REPLACE INTO storage (key, value) VALUES (?, ?);"
//        var statement: OpaquePointer?
//
//        let data = try JSONEncoder().encode(value)
//
//        if sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK {
//            defer { sqlite3_finalize(statement) }
//
//            sqlite3_bind_text(statement, 1, key, -1, nil)
//            data.withUnsafeBytes { (bytes: UnsafeRawBufferPointer) in
//                sqlite3_bind_blob(statement, 2, bytes.baseAddress, Int32(data.count), nil)
//            }
//
//            if sqlite3_step(statement) != SQLITE_DONE {
//                throw SQLiteStorageError.databaseError(message: errorMessage)
//            }
//        } else {
//            throw SQLiteStorageError.databaseError(message: errorMessage)
//        }
//    }
//
//    func deleteValue(forKey key: String) async throws {
//        let query = "DELETE FROM storage WHERE key = ?;"
//        var statement: OpaquePointer?
//
//        if sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK {
//            defer { sqlite3_finalize(statement) }
//
//            sqlite3_bind_text(statement, 1, key, -1, nil)
//
//            if sqlite3_step(statement) != SQLITE_DONE {
//                throw SQLiteStorageError.databaseError(message: errorMessage)
//            }
//        } else {
//            throw SQLiteStorageError.databaseError(message: errorMessage)
//        }
//    }
//
//    func clearCache() async throws {
//        let query = "DELETE FROM storage;"
//        var statement: OpaquePointer?
//
//        if sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK {
//            defer { sqlite3_finalize(statement) }
//
//            if sqlite3_step(statement) != SQLITE_DONE {
//                throw SQLiteStorageError.databaseError(message: errorMessage)
//            }
//        } else {
//            throw SQLiteStorageError.databaseError(message: errorMessage)
//        }
//    }
//
//    // Helper Methods
//    private func createTableIfNeeded() throws {
//        let createTableQuery = """
//        CREATE TABLE IF NOT EXISTS storage (
//            key TEXT PRIMARY KEY,
//            value BLOB
//        );
//        """
//        var statement: OpaquePointer?
//
//        if sqlite3_prepare_v2(db, createTableQuery, -1, &statement, nil) == SQLITE_OK {
//            defer { sqlite3_finalize(statement) }
//
//            if sqlite3_step(statement) != SQLITE_DONE {
//                throw SQLiteStorageError.databaseError(message: errorMessage)
//            }
//        } else {
//            throw SQLiteStorageError.databaseError(message: errorMessage)
//        }
//    }
//
//    private var errorMessage: String {
//        if let errorPointer = sqlite3_errmsg(db) {
//            return String(cString: errorPointer)
//        } else {
//            return "No error message provided from sqlite."
//        }
//    }
//
//    // Error Handling
//    enum SQLiteStorageError: Error {
//        case encodingFailed(underlyingError: Error)
//        case decodingFailed(underlyingError: Error)
//        case databaseInitializationFailed(message: String)
//        case databaseError(message: String)
//    }
//}
