//
//  AccountTab.swift
//  PayLeash
//
//  Created by Balazs Erdesz on 2021. 03. 10..
//

import SwiftUI
import CoreData

struct AccountTab: View {
    @AppStorage("selectedPageNumber") private var selectedPageNumber: Int = 0
    
    @FetchRequest(entity: Account.entity(),
                  sortDescriptors: [NSSortDescriptor(keyPath: \Account.name, ascending: true)])
    private var accounts: FetchedResults<Account>
    
    @Binding var showBottomSheet: Bool
    
    var body: some View {
        NavigationView {
            VStack {
                PageScrollView(selectedPageNumber: $selectedPageNumber,
                               views: accounts.map {
                                AnyView(AccountCardView(model: AccountCardView.Model(account: $0)))
                               })
                    .frame(height: 160)
                    .padding(.top, 8)
                
                pageControl
                
                transactionsHeader
                    .padding(.horizontal, 25)
                
                ZStack(alignment: .top) {
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(Array(accounts[selectedPageNumber].transactions!.sorted { $0.time! > $1.time! })) {
                                TransactionView(model: TransactionView.Model(balanceChange: $0))
                                    .padding(.horizontal, 25)
                            }
                        }
                        .padding(.top, 12)
                    }
                    
                    Rectangle()
                        .fill(
                                LinearGradient(gradient: Gradient(colors: [Colors.Gray.typed(.extraLightGray),
                                                                           Colors.Gray.typed(.extraLightGray).opacity(0)]),
                                               startPoint: .top, endPoint: .bottom)
                        )
                        .frame(height: 5)
                }
                .padding(.top, -2)
                
            }
            .navigationBarTitleDisplayMode(.large)
            .navigationBarTitle("Accounts")
            .background(Colors.Gray.typed(.extraLightGray))
        }
    }
    
    @ViewBuilder
    private var pageControl: some View {
        HStack {
            ForEach(0..<accounts.count) { i in
                Circle()
                    .fill(selectedPageNumber == i ? Color.black : Color.secondary)
                    .frame(width: 8, height: 8)
            }
        }
        .padding(EdgeInsets(top: 10, leading: 0, bottom: 3, trailing: 0))
    }
    
    @ViewBuilder
    private var transactionsHeader: some View {
        HStack {
            Text("Transactions")
                .font(.system(size: 19, weight: .bold))
            
            Spacer()
            
            Button(action: { showBottomSheet.toggle() }, label: {
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
                )
                .shadow(color: Color.gray.opacity(0.6), radius: 4, x: 0, y: 0)
            })
        }
    }
}

struct AccountTab_Previews: PreviewProvider {
    static var previews: some View {
        AccountTab(showBottomSheet: .constant(false))
    }
}
