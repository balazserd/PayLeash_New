//
//  AccountCardView.swift
//  PayLeash
//
//  Created by Balazs Erdesz on 2021. 03. 13..
//

import SwiftUI

struct AccountCardView: View {
    var model: Model
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(model.account.bankName!)
                .font(.system(size: 13))
                .foregroundColor(.white)
                
            ZStack(alignment: .leading) {
                Rectangle()
                    .frame(height: 40)
                    .padding(EdgeInsets(top: 0, leading: -10, bottom: 0, trailing: -13))
                
                Text(model.account.name!)
                    .font(.system(size: 17, weight: .bold))
                    .foregroundColor(.white)
            }
            
            Spacer()
            
            HStack(alignment: .firstTextBaseline) {
                Spacer()
                
                Text(model.account.currency!.shortName!)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.white)
                
                Text(NumberFormatter.regularNumberFormatter.string(from: model.balance)!)
                    .font(.system(size: 28, weight: .semibold))
                    .foregroundColor(.white)
            }
        }
        .padding(EdgeInsets(top: 8, leading: 10, bottom: 10, trailing: 13))
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(Colors.Green.typed(.cardBackgroundGreen))
        )
        .frame(height: 153)
        .shadow(color: .black, x: 0, y: 3, blur: 7, spread: 0)
    }
}

struct AccountCardView_Previews: PreviewProvider {
    static var account: Account {
        return generateUnsavedMockData().0[0]
    }
    
    static var previews: some View {
        AccountCardView(model: AccountCardView.Model(account: account))
            .frame(width: 265)
    }
}
