//
//  AccountTab.swift
//  PayLeash
//
//  Created by Balazs Erdesz on 2021. 03. 10..
//

import SwiftUI

struct AccountTab: View {
    @State private var selectedPageNumber: Int = 0
    
    var body: some View {
        NavigationView {
            VStack {
                PageScrollView(selectedPageNumber: $selectedPageNumber,
                               views: Array(repeating: AnyView(AccountCardView(model: AccountCardView.Model())), count: 5))
                    .frame(height: 160)
                
                ScrollView {
                    
                }
            }
            .navigationBarTitle("Accounts")
        }
    }
}

struct AccountTab_Previews: PreviewProvider {
    static var previews: some View {
        AccountTab()
    }
}
