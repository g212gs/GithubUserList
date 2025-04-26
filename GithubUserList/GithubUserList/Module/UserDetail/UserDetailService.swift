//
//  UserDetailService.swift
//  GithubUserList
//
//  Created by Gaurang Lathiya on 26/04/25.
//

import Foundation

protocol UserDetailProtocol {
    func fetchUserDetail(withUserId id: Int) async throws -> GHUserDetailResponse
}

class UserDetailService: UserDetailProtocol {
    
    func fetchUserDetail(withUserId id: Int) async throws -> GHUserDetailResponse {
        try await APIManager.shared.request(APIEndPoint.getUserDetails(id: id))
    }
}
