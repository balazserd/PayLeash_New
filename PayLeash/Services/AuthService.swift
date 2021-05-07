//
//  AuthService.swift
//  PayLeash
//
//  Created by Balazs Erdesz on 2021. 05. 07..
//

import Foundation
import AuthenticationServices
import CryptoKit
import Combine
import FirebaseAuth

class AuthService : NSObject, ObservableObject {
    static private(set) var shared = AuthService()

    @Published var authorizationResultMessage: AuthorizationMessage? = nil
    
    private override init() { }
    
    //MARK:- Implementations
    private var currentNonce: String?
    
    func transformSignInWithAppleRequest(_ request: ASAuthorizationAppleIDRequest) {
        let nonce = randomNonceString()
        self.currentNonce = nonce
        
        request.nonce = sha256(nonce)
        request.requestedScopes = [.email, .fullName]
    }
    
    func handleSignInWithAppleResult(_ result: Result<ASAuthorization, Error>) {
        switch result {
            case .success(let authorization):
                guard
                    let credentials = authorization.credential as? ASAuthorizationAppleIDCredential,
                    let nonce = self.currentNonce,
                    let identityToken = credentials.identityToken,
                    let identityTokenString = String(data: identityToken, encoding: .utf8)
                else {
                    self.authorizationResultMessage = AuthorizationMessage.generalFailure(underlyingError: NSError(domain: NSCocoaErrorDomain, code: -1, userInfo: [
                        NSLocalizedDescriptionKey: "The successful response did not contain the correct credentials"
                    ]))
                    
                    return
                }
                
                let fbCredential = OAuthProvider.credential(withProviderID: "apple.com", idToken: identityTokenString, rawNonce: nonce)
                Auth.auth().signIn(with: fbCredential) { [weak self] authResult, error in
                    if error != nil {
                        self?.authorizationResultMessage = AuthorizationMessage.generalFailure(underlyingError: error!)
                        
                        return
                    }
                    
                    self?.authorizationResultMessage = AuthorizationMessage.generalSuccess
                }
                
            case .failure(let error):
                self.authorizationResultMessage = AuthorizationMessage.generalFailure(underlyingError: error)
        }
    }
    
    //MARK:- Security helpers
    private func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0, "Cannot generate random nonce string due to passed length being less than 1!")
        
        let charset: [Character] = Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        var result = ""
        
        var remainingLength = length
        while remainingLength > 0 {
            let randomChars: [UInt8] = (0..<16).map { _ in
                var random: UInt8 = 0
                let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
                
                if errorCode != errSecSuccess {
                    fatalError("Failed to generate random byte for nonce.")
                }
                
                return random
            }
            
            randomChars.forEach { rand in
                if remainingLength == 0 { return }
                
                if rand < charset.count {
                    result.append(charset[Int(rand)])
                    remainingLength -= 1
                }
            }
        }
        
        return result
    }
    
    private func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashedString = hashedData
            .compactMap { String(format: "%02x", $0) }
            .joined()
        
        return hashedString
    }
}

extension AuthService {
    struct AuthorizationMessage {
        static let generalSuccess = AuthorizationMessage(message: "Successfully logged in!", success: true)
        
        static func generalFailure(underlyingError: Error) -> AuthorizationMessage {
            AuthorizationMessage(message: "Authorization failed! - \(underlyingError.localizedDescription)", success: false)
        }
        
        var message: String
        var success: Bool
    }
}

enum AuthenticationType {
    case apple, google, email
}
