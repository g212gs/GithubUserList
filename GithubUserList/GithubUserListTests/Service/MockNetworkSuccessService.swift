//
//  MockNetworkSuccessService.swift
//  GithubUserListTests
//
//  Created by Gaurang Lathiya on 01/05/25.
//

import Foundation
@testable import GithubUserList

class MockNetworkSuccessService: NetworkCheckServiceProtocol {
    
    func isNetworkAvailable() -> Bool {
        return true
    }

}
