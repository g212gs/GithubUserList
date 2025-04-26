//
//  UserListService.swift
//  GithubUserList
//
//  Created by Gaurang Lathiya on 22/04/25.
//

import Foundation

protocol UserListProtocol {
    func fetchUsers(forQuery query: String?, pageNumber: Int, pageSize: Int) async throws -> GHUserResponse
}

class UserListService: UserListProtocol {
    
    func fetchUsers(forQuery query: String?, pageNumber: Int, pageSize: Int) async throws -> GHUserResponse {
        try await APIManager.shared.request(APIEndPoint.getUsers(query: query, pageNumber: pageNumber, pageSize: pageSize))
    }
}
