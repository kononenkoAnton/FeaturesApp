//
//  CoreDataStorage.swift
//  CountryCodeExample
//
//  Created by Anton Kononenko on 11/15/24.
//


//import Foundation
//import CoreData
//
////TODO: Just test, not implemnted fully
//
//actor CoreDataStorage<Value: Hashable & Codable>: Storage {
//    typealias Key = String
//
//    private let container: NSPersistentContainer
//    private let entityName = "StoredValue"
//
//    init(modelName: String = "StorageModel") async throws {
//        container = NSPersistentContainer(name: modelName)
//        let description = NSPersistentStoreDescription()
//        description.type = NSSQLiteStoreType
//        container.persistentStoreDescriptions = [description]
//
//        try await withCheckedThrowingContinuation { continuation in
//            container.loadPersistentStores { _, error in
//                if let error = error {
//                    continuation.resume(throwing: error)
//                } else {
//                    continuation.resume()
//                }
//            }
//        }
//    }
//
//    func retrieve(forKey key: String) async throws -> Value? {
//        let context = container.viewContext
//        let request: NSFetchRequest<StoredValue> = StoredValue.fetchRequest()
//        request.predicate = NSPredicate(format: "key == %@", key)
//        if let result = try context.fetch(request).first, let data = result.value {
//            do {
//                let value = try JSONDecoder().decode(Value.self, from: data)
//                return value
//            } catch {
//                throw CoreDataStorageError.decodingFailed(underlyingError: error)
//            }
//        }
//        return nil
//    }
//
//    func store(forKey key: String, value: Value) async throws {
//        let context = container.viewContext
//        let data: Data
//        do {
//            data = try JSONEncoder().encode(value)
//        } catch {
//            throw CoreDataStorageError.encodingFailed(underlyingError: error)
//        }
//
//        let request: NSFetchRequest<StoredValue> = StoredValue.fetchRequest()
//        request.predicate = NSPredicate(format: "key == %@", key)
//        if let existingObject = try context.fetch(request).first {
//            existingObject.value = data
//        } else {
//            let newObject = StoredValue(context: context)
//            newObject.key = key
//            newObject.value = data
//        }
//        try context.save()
//    }
//
//    func deleteValue(forKey key: String) async throws {
//        let context = container.viewContext
//        let request: NSFetchRequest<StoredValue> = StoredValue.fetchRequest()
//        request.predicate = NSPredicate(format: "key == %@", key)
//        if let object = try context.fetch(request).first {
//            context.delete(object)
//            try context.save()
//        }
//    }
//
//    func clearCache() async throws {
//        let context = container.viewContext
//        let request: NSFetchRequest<NSFetchRequestResult> = StoredValue.fetchRequest()
//        let deleteRequest = NSBatchDeleteRequest(fetchRequest: request)
//        try context.execute(deleteRequest)
//        try context.save()
//    }
//
//    // Error Handling
//    enum CoreDataStorageError: Error {
//        case encodingFailed(underlyingError: Error)
//        case decodingFailed(underlyingError: Error)
//    }
//}
//
//// Core Data Entity
//extension CoreDataStorage {
//    @objc(StoredValue)
//    class StoredValue: NSManagedObject {
//        @NSManaged var key: String
//        @NSManaged var value: Data?
//    }
//}
//
//// Core Data Model Setup
//// Note: You need to create a Core Data model file (.xcdatamodeld) named "StorageModel" with an entity "StoredValue" that has attributes "key" (String) and "value" (Binary Data).
