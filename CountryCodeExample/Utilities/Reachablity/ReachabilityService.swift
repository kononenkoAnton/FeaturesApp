//
//  Reachability.swift
//  CountryCodeExample
//
//  Created by Anton Kononenko on 11/19/24.
//

import Network

final class WeakWrapper: ReachabilityObservable, Hashable {
    weak var value: ReachabilityObservable?

    init(object: ReachabilityObservable) {
        value = object
    }

    static func == (lhs: WeakWrapper,
                    rhs: WeakWrapper) -> Bool {
        return lhs.value === rhs.value
    }

    func hash(into hasher: inout Hasher) {
        if let value {
            hasher.combine(ObjectIdentifier(value))
        }
    }

    func didReachabilityChange(to status: ReachabilityStatus) {
        value?.didReachabilityChange(to: status)
    }
}

enum ReachabilityStatus {
    case reachable
    case noInternet
    case restricted
    case unknown
}

protocol ReachabilityObservable: AnyObject {
    func didReachabilityChange(to type: ReachabilityStatus)
}

protocol ReachabilityService {
    func addObserver(_ observer: ReachabilityObservable)
    func removeObserver(_ observer: ReachabilityObservable)
    var currentStatus: ReachabilityStatus { get }
}

protocol NetworkMonitoring {
    @preconcurrency var pathUpdateHandler: (@Sendable (_ newPath: NWPath) -> Void)? { get set }
    func start(queue: DispatchQueue)
    func cancel()
}

extension NWPathMonitor: NetworkMonitoring {}
class DefaultReachablity {
    static let shared = DefaultReachablity()
    private(set) var currentStatus: ReachabilityStatus = .unknown

    private var monitor: NetworkMonitoring

    private var observers: Set<WeakWrapper> = []
    let queue = DispatchQueue(label: "NetworkMonitor")

    init(monitor: NetworkMonitoring = NWPathMonitor()) {
        self.monitor = monitor
        prepareMonitor()
    }

    deinit {
        monitor.cancel()
    }

    func prepareMonitor() {
        monitor.pathUpdateHandler = { [weak self] path in
            guard let self else { return }
            let newStatus: ReachabilityStatus
            if path.status == .satisfied {
                if path.isConstrained {
                    newStatus = .restricted
                } else {
                    newStatus = .reachable
                }
            } else {
                newStatus = .noInternet
            }

            self.queue.async {
                if self.currentStatus != newStatus {
                    self.currentStatus = newStatus
                    self.notifyObservers(type: newStatus)
                }
            }
        }

        monitor.start(queue: queue)
    }

    func notifyObservers(type: ReachabilityStatus) {
        queue.async {
            self.observers.forEach { $0.didReachabilityChange(to: type) }
            self.observers = self.observers.filter { $0.value != nil }
        }
    }
}

extension DefaultReachablity: ReachabilityService {
    func addObserver(_ observer: ReachabilityObservable) {
        queue.sync {
            guard !observers.contains(where: { $0.value === observer }) else {
                print("addObserver: can not add same observer, skiping")
                return
            }

            observers.insert(WeakWrapper(object: observer))
            observer.didReachabilityChange(to: currentStatus)
        }
    }

    func removeObserver(_ observer: ReachabilityObservable) {
        queue.sync {
            let wrapper = WeakWrapper(object: observer)
            observers.remove(wrapper)
        }
    }
}
