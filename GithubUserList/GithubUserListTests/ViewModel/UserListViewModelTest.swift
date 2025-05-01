//
//  UserListViewModelTest.swift
//  GithubUserListTests
//
//  Created by Gaurang Lathiya on 01/05/25.
//

import Foundation
import Testing
@testable import GithubUserList

struct UserListViewModelTest {
    
    @Test
    func networkServiceFailCheck() {
        let mockNetworkCheckService = MockNetworkFailService()
        #expect(mockNetworkCheckService.isNetworkAvailable() == false)
    }
    
    @Test
    func fetchUsers() async {
        let mockNetworkCheckService = MockNetworkSuccessService()
        let mockUserListService = MockUserListService()
        
        let viewModel = UserListViewModel(userService: mockUserListService,
                                          networkCheckService: mockNetworkCheckService)
        
        try? await viewModel.fetchUsers()
        
        #expect(viewModel.users.count == 10)
        #expect(viewModel.isLoading == false)
        #expect(viewModel.pageNumber == 2)
    }
    
    @Test
    func fetchUsersWhenNoNetwork() async {
        let mockNetworkCheckService = MockNetworkFailService()
        let mockUserListService = MockUserListService()
        
        let viewModel = UserListViewModel(userService: mockUserListService,
                                          networkCheckService: mockNetworkCheckService)
        
        try? await viewModel.fetchUsers()
        
        #expect(viewModel.users.count == 0)
        #expect(viewModel.pageNumber == 1)
    }
    
}
