//
//  UserListScreen.swift
//  GithubUserList
//
//  Created by Gaurang Lathiya on 22/04/25.
//

import SwiftUI

struct UserListScreen: View {
    
    @StateObject var viewModel: UserListViewModel = .init()
    
    var body: some View {
        NavigationView {
            List(viewModel.users, id: \.id) { user in
                NavigationLink {
                    UserDetailScreen(userId: user.id)
                } label: {
                    HStack(spacing: 16) {
                        AsyncImage(url: URL(string: user.avatarURL)) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                        } placeholder: {
                            ProgressView()
                        }
                        .frame(width: 50, height: 50)
                        .clipShape(Circle())
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text(user.login)
                                .font(.headline)
                            Text(user.type)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                        
                        if user.siteAdmin {
                            Text("Admin")
                                .font(.caption)
                                .padding(6)
                                .background(Color.blue.opacity(0.2))
                                .cornerRadius(8)
                        }
                    }
                    .padding(.vertical, 8)
                    .onAppear() {
                        viewModel.checkPagination(forUser: user)
                    }
                }
            }
            .navigationTitle("Users")
            .searchable(text: $viewModel.query, placement: .navigationBarDrawer(displayMode: .always))
            .onChange(of: viewModel.query) { _, newSearchText in
                if !newSearchText.isEmpty {
                    viewModel.searchUserName()
                }
            }
            .refreshable {
                viewModel.pullToRefresh()
            }
        }
        .onAppear() {
            viewModel.fetchUsers()
        }
    }
}

#Preview {
    UserListScreen()
}
