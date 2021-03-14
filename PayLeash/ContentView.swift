//
//  ContentView.swift
//  PayLeash
//
//  Created by Balazs Erdesz on 2021. 02. 23..
//

import SwiftUI

struct ContentView: View {
    @State private var selectedPage: Int = 3
    
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
                    .offset(x: 0, y: -1)
                    .tag(1)
            }
            .offset(x: 0, y: 1)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
