//
//  MainView.swift
//  PayLeash
//
//  Created by Balazs Erdesz on 2021. 02. 23..
//

import SwiftUI

struct MainView: View {
    @State private var selectedPage: Int = 3
    @State private var showBottomSheet: Bool = false
    
    init() {
        UINavigationBar.appearance().largeTitleTextAttributes = [
            .foregroundColor : UIColor(Colors.Green.typed(.prominentGreen))
        ]
        UINavigationBar.appearance().backgroundColor = UIColor(Colors.Gray.typed(.extraLightGray))
    }
    
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
                
                NavigationView {
                    ZStack {
                        NavigationLink(
                            destination:
                                ZStack { Color.orange }
                                    .transformPreference(FullScreenCoverPreferenceKey.self) {
                                        $0.append(FullScreenCoverPreferenceKey.OverlayView {
                                            //The overlay
                                            ZStack {
                                                Color.green
                                                Text("I am full screen!")
                                            }
                                        })
                                    },
                            label: {
                                Text("Press me to show full screen!")
                            })
                    }
                }
                .tabItem {
                    Text("Tab")
                }
            }
            .accentColor(Colors.Green.typed(.mediumGreen))
            .offset(x: 0, y: 1) //1
        }
        .allowFullScreenOverlays()
        .bottomSheet(isShown: .constant(false), content: { EmptyView() })
        .blurringOverlay(isShown: .constant(false), content: { EmptyView() })
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}

//MARK:- Notes

//1: -This hack is needed to extend the background color to the safe area.
