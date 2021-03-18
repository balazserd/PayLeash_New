//
//  ComplexPicker.swift
//  PayLeash
//
//  Created by Balazs Erdesz on 2021. 03. 18..
//

import SwiftUI

/// Provides a solution to showing images and text together in a Picker.
struct ComplexPicker: View {
    @Binding var selection: Int
    
    /// The array of `Text` views that are the options for the Picker.
    var options: [Text]
    
    private let gridItems = [
        GridItem(.flexible()),
        GridItem(.fixed(1), spacing: 0),
        GridItem(.flexible()),
        GridItem(.fixed(1), spacing: 0),
        GridItem(.flexible())
    ]
    
    var body: some View {
        ZStack {
            LazyVGrid(columns: gridItems) {
                ForEach(0..<options.count) { i in
                    drawItem(id: i)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .backgroundPreferenceValue(LocationPreferenceKey.self) { anchorsDataArray in
            GeometryReader { proxy in
                drawSelectionSignal(by: proxy, dataArray: anchorsDataArray)
            }
        }
        .padding(.vertical, 3).padding(.horizontal, 2)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(Colors.Green.typed(.lightGreen))
        )
        .frame(height: 35)
    }
    
    @ViewBuilder
    private func drawItem(id i: Int) -> some View {
        options[i]
            .foregroundColor(selection == i ? .white : Colors.Green.typed(.mediumGreen))
            .font(.system(size: selection == i ? 16 : 15,
                          weight: selection == i ? .bold : .semibold))
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .anchorPreference(key: LocationPreferenceKey.self, value: .bounds, transform: { anchor in
                [LocationPreferenceKey.Data(id: i, bounds: anchor)]
            })
            .onTapGesture {
                selection = i
            }
        
        if i + 1 != options.count {
            Rectangle()
                .fill(Colors.Green.typed(.mediumGreen))
                .frame(width: 1)
                .opacity(i - selection > 0 || selection - i > 1 ? 1 : 0)
        }
    }
    
    private func drawSelectionSignal(by proxy: GeometryProxy, dataArray: [LocationPreferenceKey.Data]) -> some View {
        let bounds = proxy[dataArray.first { $0.id == selection }!.bounds]
        
        return RoundedRectangle(cornerRadius: 7)
            .fill(Colors.Green.typed(.prominentGreen))
            .offset(x: bounds.minX)
            .animation(.easeOut(duration: 0.3), value: selection)
            .frame(width: bounds.width, height: bounds.height + 12)
            .offset(y: bounds.minY - 6)
            .shadow(color: Color.gray.opacity(0.4), radius: 5, x: 0, y: 0)
            .animation(nil)
    }
}

private extension ComplexPicker {
    struct LocationPreferenceKey: PreferenceKey {
        typealias Value = [Data]
        
        static var defaultValue: [Data] { [Data]() }
        
        static func reduce(value: inout [Data], nextValue: () -> [Data]) {
            value.append(contentsOf: nextValue())
        }
        
        struct Data {
            var id: Int
            var bounds: Anchor<CGRect>
        }
    }
}

struct ComplexPicker_Previews: PreviewProvider {
    @State private static var selection: Int = 2
    static var previews: some View {
        ComplexPicker(selection: $selection,
                      options:
                        [
                            Text("\(Image(systemName: "arrow.down.square.fill")) Expense"),
                            Text("\(Image(systemName: "arrow.up.square.fill")) Income"),
                            Text("\(Image(systemName: "arrow.up.arrow.down.square.fill")) Both")
                        ])
            .padding(.horizontal, 10)
    }
}
