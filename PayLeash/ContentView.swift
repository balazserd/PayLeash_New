//
//  ContentView.swift
//  PayLeash
//
//  Created by Balazs Erdesz on 2021. 02. 23..
//

import SwiftUI

struct ContentView: View {
    @State private var selectedPage: Int = 3
    var body: some View {
        AccountTab()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
