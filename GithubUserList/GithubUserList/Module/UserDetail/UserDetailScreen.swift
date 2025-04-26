//
//  UserDetailScreen.swift
//  GithubUserList
//
//  Created by Gaurang Lathiya on 26/04/25.
//

import SwiftUI

struct UserDetailScreen: View {
    @StateObject var viewModel = UserDetailViewModel()
    var userId: Int
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                AsyncImage(url: URL(string: viewModel.userDetail?.avatarURL ?? "")) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 120, height: 120)
                        .clipShape(Circle())
                        .shadow(radius: 10)
                } placeholder: {
                    ProgressView()
                        .frame(width: 120, height: 120)
                }
                
                Text((viewModel.userDetail?.name ?? viewModel.userDetail?.login) ?? "")
                    .font(.title)
                    .fontWeight(.bold)
                
                if let bio = viewModel.userDetail?.bio {
                    Text(bio)
                        .font(.body)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }
                
                HStack(spacing: 20) {
                    VStack {
                        Text("\(viewModel.userDetail?.followers ?? 0)")
                            .font(.headline)
                        Text("Followers")
                            .font(.caption)
                    }
                    VStack {
                        Text("\(viewModel.userDetail?.following ?? 0)")
                            .font(.headline)
                        Text("Following")
                            .font(.caption)
                    }
                    VStack {
                        Text("\(viewModel.userDetail?.publicRepos ?? 0)")
                            .font(.headline)
                        Text("Repos")
                            .font(.caption)
                    }
                }
                .padding(.top)
                
                if let location = viewModel.userDetail?.location {
                    Label(location, systemImage: "mappin.and.ellipse")
                        .font(.subheadline)
                        .padding(.top, 8)
                }
                
                if let blog = viewModel.userDetail?.blog, let blogURL = URL(string: blog) {
                    Link(destination: blogURL) {
                        Label("Website", systemImage: "link")
                            .font(.subheadline)
                    }
                    .padding(.top, 4)
                }
                
                if let twitter = viewModel.userDetail?.twitterUsername {
                    Link(destination: URL(string: "https://twitter.com/\(twitter)")!) {
                        Label("@\(twitter)", systemImage: "bird")
                            .font(.subheadline)
                    }
                    .padding(.top, 4)
                }
                
                if let htmlString = viewModel.userDetail?.htmlURL,
                   let htmlUrl = URL(string: htmlString) {
                    Link("View GitHub Profile", destination: htmlUrl)
                        .font(.headline)
                        .padding(.top, 16)
                }
                
            }
            .padding()
        }
        .navigationTitle("Profile")
        .onAppear {
            viewModel.fetchUsersDetails(forUserId: userId)
        }
    }
    
}

#Preview {
    UserDetailScreen(userId: 0)
}
