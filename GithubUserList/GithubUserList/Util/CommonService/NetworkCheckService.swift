//
//  NetworkCheckService.swift
//  GithubUserList
//
//  Created by Gaurang Lathiya on 01/05/25.
//

import Foundation

protocol NetworkCheckServiceProtocol {
    func isNetworkAvailable() -> Bool
}

class NetworkCheckService: NetworkCheckServiceProtocol {
    
    func isNetworkAvailable() -> Bool {
        return NetworkReachabilityManager.shared.isReachable
    }
}
