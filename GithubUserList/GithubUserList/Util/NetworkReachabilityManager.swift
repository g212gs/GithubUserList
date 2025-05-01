//
//  NetworkReachabilityManager.swift
//  GithubUserList
//
//  Created by Gaurang Lathiya on 01/05/25.
//

import Foundation
import Network
import Combine

struct NetworkStatusModel {
    var isReachable: Bool = false
    var isExpensive: Bool = false
}

final class NetworkReachabilityManager {
    
    private let monitor: NWPathMonitor
    static let shared = NetworkReachabilityManager()
    
    private let cancelableBag = Set<AnyCancellable>()
    let networkStatusPublisher = PassthroughSubject<NetworkStatusModel, Never>()
        
    private init() {
        monitor = NWPathMonitor()
        let queue = DispatchQueue(label: "NetworkReachabilityManager")
        monitor.start(queue: queue)
    }
    
    var isReachable: Bool {
        monitor.currentPath.status == .satisfied
    }
    
    func startMonitoring() {
        monitor.pathUpdateHandler = { [weak self] path in
            let isReachable = path.status == .satisfied
            let isExpensive = path.isExpensive
            
            let networkStatusModel = NetworkStatusModel(isReachable: isReachable,
                                                        isExpensive: isExpensive)
            
            self?.networkStatusPublisher.send(networkStatusModel)
        }
    }
    
    func stopMonitoring() {
        monitor.cancel()
    }
}
