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
                    .padding(.top, 8)
                
                Text("Placeholder for pageControl")
                    .padding(EdgeInsets(top: 10, leading: 0, bottom: 3, trailing: 0))
                
                HStack {
                    Text("Transactions")
                        .font(.system(size: 19, weight: .bold))
                    
                    Spacer()
                    
                    Button(action: {}, label: {
                        HStack(spacing: 2) {
                            Text("Add")
                                .font(.system(size: 13, weight: .semibold))
                                .foregroundColor(.white)
                            
                            Image(systemName: "plus")
                                .font(.system(size: 12, weight: .semibold))
                                .foregroundColor(.white)
                        }
                        .padding(EdgeInsets(top: 4, leading: 8, bottom: 4, trailing: 6))
                        .background(
                            RoundedRectangle(cornerRadius: 4)
                                .fill(Colors.Green.typed(.mediumGreen))
                                .shadow(color: Color.gray.opacity(0.8), radius: 7, x: 0, y: 2)
                        )
                    })
                }
                .padding(.horizontal, 25)
                
                ScrollView {
                    
                }
            }
            .navigationBarTitleDisplayMode(.large)
            .navigationBarTitle("Accounts")
            .background(Colors.Gray.typed(.extraLightGray))
        }
    }
}

struct AccountTab_Previews: PreviewProvider {
    static var previews: some View {
        AccountTab()
    }
}
