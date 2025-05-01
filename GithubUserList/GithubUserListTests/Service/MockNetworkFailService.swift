//
//  MockNetworkFailService.swift
//  GithubUserListTests
//
//  Created by Gaurang Lathiya on 01/05/25.
//

import Foundation
@testable import GithubUserList

class MockNetworkFailService: NetworkCheckServiceProtocol {
    
    func isNetworkAvailable() -> Bool {
        return false
    }

}
