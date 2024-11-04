//
//  Observable.swift
//  CountryCodeExample
//
//  Created by Anton Kononenko on 11/3/24.
//

import Foundation

struct WeakObserver<Item> {
    weak var observer: AnyObject?
    let observerBlock: (Item) -> Void
}

protocol ObservableProtocol {
    associatedtype Item

    func addObserver(observer: AnyObject,
                     observerBlock: @escaping (Item) -> Void,
                     notifyImmediately: Bool)
    func removeObserver(observer: AnyObject)
}

final class Observable<Item>: ObservableProtocol {
    private var observers: [WeakObserver<Item>] = []
    private let queue = DispatchQueue(label: "com.observable.queue", attributes: .concurrent)
    private(set) var item: Item {
        didSet {
            removeDeadObservers()
            notifyObservers()
        }
    }

    init(item: Item) {
        self.item = item
    }

    public func setItem(_ newItem: Item) {
        queue.async(flags: .barrier) {
            self.item = newItem
        }
    }

    public func addObserver(observer: AnyObject,
                            observerBlock: @escaping (Item) -> Void,
                            notifyImmediately: Bool = true) {
        queue.async(flags: .barrier) { [weak self] in
            guard let self else { return }

            guard !observers.contains(where: { $0.observer === observer }) else {
                return
            }

            observers.append(WeakObserver(observer: observer,
                                          observerBlock: observerBlock))
            if notifyImmediately {
                DispatchQueue.main.async {
                    observerBlock(self.item)
                }
            }
        }
    }

    public func removeObserver(observer: AnyObject) {
        queue.async(flags: .barrier) { [weak self] in
            guard let self else { return }
            observers = observers.filter { $0.observer !== observer }
        }
    }

    private func removeDeadObservers() {
        observers = observers.filter { $0.observer !== nil }
    }

    private func notifyObservers() {
        let currentObservers = queue.sync {
            observers
        }

        for weakObserver in currentObservers {
            if weakObserver.observer != nil {
                DispatchQueue.main.async {
                    weakObserver.observerBlock(self.item)
                }
            }
        }
    }
}
