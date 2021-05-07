//
//  MainView.swift
//  PayLeash
//
//  Created by Balazs Erdesz on 2021. 02. 23..
//

import SwiftUI
import AuthenticationServices

struct MainView: View {
    @State private var selectedPage: Int = 3
    @State private var showBottomSheet: Bool = false
    
    @StateObject private var authService = AuthService.shared
    
    init() {
        UINavigationBar.appearance().largeTitleTextAttributes = [
            .foregroundColor : UIColor(Colors.Green.typed(.prominentGreen))
        ]
        UINavigationBar.appearance().backgroundColor = UIColor(Colors.Gray.typed(.extraLightGray))
    }
    
    @State private var result: Double = 0.0
    
    var body: some View {
        ZStack {
            Colors.Gray.typed(.extraLightGray)
                .ignoresSafeArea()
            
            TabView {
                AccountTab()
                    .offset(x: 0, y: -1) //1
                    .tabItem {
                        Image(systemName: "creditcard.fill")
                        Text("Accounts")
                    }
                
                VStack {
                    Text("\(result)")
                    
                    CalculatorView(currentResult: $result, doneAction: { })
                }
                .tabItem {
                    Text("calculator")
                }
                
                VStack {
                    if authService.authorizationResultMessage != nil {
                        Text(authService.authorizationResultMessage!.message)
                    }
                    
                    SignInWithAppleButton(onRequest: { authService.transformSignInWithAppleRequest($0) },
                                          onCompletion: { authService.handleSignInWithAppleResult($0) })
                }
            }
            .accentColor(Colors.Green.typed(.mediumGreen))
            .offset(x: 0, y: 1) //1
        }
        .allowFullScreenOverlays()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}

//MARK:- Notes

//1: -This hack is needed to extend the background color to the safe area.
