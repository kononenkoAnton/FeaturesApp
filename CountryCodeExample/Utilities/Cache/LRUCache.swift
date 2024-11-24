//
//  LRUCache.swift
//  CountryCodeExample
//
//  Created by Anton Kononenko on 11/15/24.
//

protocol LRUCache: Actor {
    associatedtype Key: Hashable
    associatedtype Value
    func retrieve(_ key: Key) -> Value?
    func store(_ key: Key, value: Value)
    func retrieveAllValues() -> [Value]
}

/// Least Recently Used (LRU)
actor DefaultLRUCache<Key: Hashable, Value>: LRUCache {
    /// Doubly Linked List
    private class CacheNode {
        let key: Key
        var value: Value
        var prev: CacheNode?
        var next: CacheNode?

        init(key: Key, value: Value) {
            self.key = key
            self.value = value
        }
    }

    private let maxCapacity: Int

    private var cache: [Key: CacheNode] = [:]
    private var head: CacheNode?
    private var tail: CacheNode?

    init(maxCapacity: Int) {
        self.maxCapacity = maxCapacity
    }

    func retrieve(_ key: Key) -> Value? {
        guard let node = cache[key] else {
            return nil
        }
        moveToHead(node)
        return node.value
    }

    func store(_ key: Key, value: Value) {
        if let node = cache[key] {
            node.value = value
            moveToHead(node)
        } else {
            let newNode = CacheNode(key: key, value: value)
            cache[key] = newNode
            addNodeToHead(newNode)

            if cache.count > maxCapacity {
                if let tailNode = tail {
                    removeNode(tailNode)
                    cache.removeValue(forKey: tailNode.key)
                }
            }
        }
    }

    func retrieveAllValues() -> [Value] {
        var values = [Value]()
        var node = head
        while let currentNode = node {
            values.append(currentNode.value)
            node = currentNode.next
        }
        
        return values
    }

    private func moveToHead(_ node: CacheNode) {
        removeNode(node)
        addNodeToHead(node)
    }

    private func addNodeToHead(_ node: CacheNode) {
        node.next = head
        node.prev = nil
        head?.prev = node
        head = node

        if tail == nil {
            tail = node
        }
    }

    private func removeNode(_ node: CacheNode) {
        node.prev?.next = node.next
        node.next?.prev = node.prev

        if node === head {
            head = node.next
        }

        if node === tail {
            tail = node.prev
        }

        node.prev = nil
        node.next = nil
    }
}
