//
//  AccountCardView.swift
//  PayLeash
//
//  Created by Balazs Erdesz on 2021. 03. 13..
//

import SwiftUI

struct AccountCardView: View {
    @ObservedObject var model: Model
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(model.bankName)
                .font(.system(size: 13))
                .foregroundColor(.white)
                
            ZStack(alignment: .leading) {
                Rectangle()
                    .frame(height: 40)
                    .padding(EdgeInsets(top: 0, leading: -10, bottom: 0, trailing: -13))
                
                Text(model.accountName)
                    .font(.system(size: 17, weight: .bold))
                    .foregroundColor(.white)
            }
            
            Spacer()
            
            HStack(alignment: .firstTextBaseline) {
                Spacer()
                
                Text(model.currencyShortString)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.white)
                
                Text(NumberFormatter.regularNumberFormatter.string(from: model.balance)!)
                    .font(.system(size: 28, weight: .semibold))
                    .foregroundColor(.white)
            }
        }
        .padding(EdgeInsets(top: 8, leading: 10, bottom: 13, trailing: 13))
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(Colors.Green.typed(.cardBackgroundGreen))
        )
        .frame(height: 153)
        .shadow(color: .black, x: 0, y: 3, blur: 7, spread: 0)
    }
}

extension AccountCardView {
    class Model: ObservableObject {
        var bankName: String = "OTP Bank"
        var accountName: String = "Student+ Account"
        var balance: Double = 3_245_117
        var currencyShortString: String = "HUF"
    }
}

struct AccountCardView_Previews: PreviewProvider {
    static var previews: some View {
        AccountCardView(model: AccountCardView.Model())
            .frame(width: 265)
    }
}
