//
//  AccountTab.swift
//  PayLeash
//
//  Created by Balazs Erdesz on 2021. 03. 10..
//

import SwiftUI

struct AccountTab: View {
    @State private var selectedItemId: Int = 0
    
    var body: some View {
        TabView(selection: $selectedItemId) {
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.green, lineWidth: 3)
                .frame(width: 200, height: 155)
                .tag(0)
            RoundedRectangle(cornerRadius: 8)
                .frame(width: 200, height: 155)
                .tag(1)
            RoundedRectangle(cornerRadius: 8)
                .frame(width: 200, height: 155)
                .tag(2)
        }.tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
    }
}

struct AccountTab_Previews: PreviewProvider {
    static var previews: some View {
        AccountTab()
    }
}
