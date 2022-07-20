//
//  LoginViewModel.swift
//  AuthApp
//
//  Created by Neal Archival on 7/12/22.
//

import Foundation


extension LoginView {
    @MainActor class ViewModel: ObservableObject {
        @Published var username: String = ""
        @Published var password: String = ""
        
        @Published var authSuccessful: Bool = true
        
        @Published var errorMessage: String = ""
        
        @Published var isLoading: Bool = false
        
        @Published var userData: UserData?
        
        func initUserData(_ ud: UserData) {
            self.userData = ud
        }
        
        func attemptLogin() async {
            isLoading.toggle()
            do {
                let token = try await AuthenticationModel().attepmtLogin(username, password)
                // Since authentication is successful, set the userData auth token
//                objectWillChange.send()
                userData!.authToken = token
            } catch let error {
                if type(of: error) == AuthenticationModel.self.AuthenticationError.self {
                    errorMessage = error.localizedDescription
                } else {
                    print("Application error: ", error.localizedDescription)
                    errorMessage = "Connection error"
                }
                authSuccessful = false
            }
            isLoading.toggle()
        }
    }
}