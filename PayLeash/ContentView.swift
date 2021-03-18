//
//  ContentView.swift
//  PayLeash
//
//  Created by Balazs Erdesz on 2021. 02. 23..
//

import SwiftUI

struct ContentView: View {
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
            }
            .accentColor(Colors.Green.typed(.mediumGreen))
            .offset(x: 0, y: 1) //1
            .bottomSheet(isShown: $showBottomSheet) {
                VStack {
                    Text("Bottom Sheet")
                    Text("Bottom Sheet")
                    Text("Bottom Sheet")
                    Text("Bottom Sheet")
                    Text("Bottom Sheet")
                    VStack {
                        Text("Bottom Sheet")
                        Text("Bottom Sheet")
                        Text("Bottom Sheet")
                        Text("Bottom Sheet")
                        Text("Bottom Sheet")
                    }
                    VStack {
                        Text("Bottom Sheet")
                        Text("Bottom Sheet")
                        Text("Bottom Sheet")
                        Text("Bottom Sheet")
                        Text("Bottom Sheet")
                    }
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

//MARK:- Notes

//1: -This hack is needed to extend the background color to the safe area.
