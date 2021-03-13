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
        VStack {
            Spacer()
            Stepper("Page", value: $selectedPage, in: 0...5)
            PageScrollView(
                selectedPageNumber: $selectedPage,
                views: [
                    AnyView(
                        RoundedRectangle(cornerRadius: 8)
                            .foregroundColor(.blue)
                            .frame(height: 150)
                    ),
                    AnyView(
                        RoundedRectangle(cornerRadius: 8)
                            .foregroundColor(.green)
                            .frame(height: 150)
                    ),
                    AnyView(
                        RoundedRectangle(cornerRadius: 8)
                            .foregroundColor(.orange)
                            .frame(height: 150)
                    ),
                    AnyView(
                        RoundedRectangle(cornerRadius: 8)
                            .foregroundColor(.red)
                            .frame(height: 150)
                    ),
                    AnyView(
                        RoundedRectangle(cornerRadius: 8)
                            .foregroundColor(.yellow)
                            .frame(height: 150)
                    ),
                    AnyView(
                        RoundedRectangle(cornerRadius: 8)
                            .foregroundColor(.pink)
                            .frame(height: 150)
                    )
                ]
            )
            .frame(height: 155)
            Spacer()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
