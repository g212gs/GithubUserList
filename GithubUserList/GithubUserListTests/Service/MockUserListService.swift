//
//  MockUserListService.swift
//  GithubUserListTests
//
//  Created by Gaurang Lathiya on 01/05/25.
//

import Foundation
@testable import GithubUserList

class MockUserListService: UserListProtocol {
    
    func fetchUsers(forQuery query: String?, pageNumber: Int, pageSize: Int) async throws -> GithubUserList.GHUserResponseModel {
        
        debugPrint("fetchUsers mock for query: \(query ?? "") pageNumber: \(pageNumber) pageSize: \(pageSize)")
        
        var arrUserList: [GithubUserList.GHUserModel] = []
        let userListCout: Int = 147793519
                
        for index in 1...10 {
            let user: GithubUserList.GHUserModel = .init(login: "\(index)",
                                                         id: index,
                                                         nodeID: "\(index)",
                                                         avatarURL:  "https://avatars.githubusercontent.com/u/17027\(index)?v=4",
                                                         gravatarID: "",
                                                         url: "https://api.github.com/users/mojombo",
                                                         htmlURL:  "https://github.com/yyx990803",
                                                         followersURL: "https://api.github.com/users/sindresorhus/followers",
                                                         followingURL: "https://api.github.com/users/sindresorhus/following{/other_user}",
                                                         gistsURL: "https://api.github.com/users/sindresorhus/gists{/gist_id}",
                                                         starredURL: "https://api.github.com/users/sindresorhus/starred{/owner}{/repo}",
                                                         subscriptionsURL: "https://api.github.com/users/sindresorhus/subscriptions",
                                                         organizationsURL: "https://api.github.com/users/sindresorhus/orgs",
                                                         reposURL: "https://api.github.com/users/sindresorhus/repos",
                                                         eventsURL: "https://api.github.com/users/sindresorhus/events{/privacy}",
                                                         receivedEventsURL: "https://api.github.com/users/sindresorhus/received_events",
                                                         type: "User",
                                                         userViewType: "public",
                                                         siteAdmin: false,
                                                         score: 1)
            arrUserList.append(user)
        }
        
        let responseModel: GithubUserList.GHUserResponseModel = .init(totalCount: userListCout, incompleteResults: false, userList: arrUserList)
        return responseModel
    }
    
}
