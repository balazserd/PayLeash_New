//
//  BottomSheet.swift
//  PayLeash
//
//  Created by Balazs Erdesz on 2021. 03. 15..
//

import SwiftUI

fileprivate struct BottomSheet<Content: View>: View {
    
    var content: Content
    @Binding var isShown: Bool
    
    init(isShown: Binding<Bool>, @ViewBuilder content: () -> Content) {
        self._isShown = isShown
        self.content = content()
    }
    
    @GestureState private var dragY: CGFloat = 0.0
    @State private var contentHeight: CGFloat = 0.0
    
    var body: some View {
        GeometryReader { proxy in
            ZStack {
                VStack(spacing: 5) {
                    Capsule()
                        .fill(Color.secondary)
                        .frame(width: 40, height: 6)
                        .padding(.top, 10)
                    
                    content
                }
                .anchorPreference(key: ContentHeightPreferenceKey.self, value: .bounds, transform: { proxy[$0].height })
                .onPreferenceChange(ContentHeightPreferenceKey.self, perform: { print($0); contentHeight = $0 })
                .frame(width: UIScreen.main.bounds.width,
                       height: contentHeight + dragY + proxy.safeAreaInsets.bottom,
                       alignment: .top)
                .background(
                    ZStack {
                        RoundedRectangle(cornerRadius: 15)
                            .fill(Color.white)
                            .shadow(color: isShown ? Color.black.opacity(0.6) : .clear, radius: 7)
                    }
                )
            }
            .frame(maxHeight: .infinity, alignment: .bottom)
            .offset(y: (isShown ? 0 : contentHeight + proxy.safeAreaInsets.bottom) + proxy.safeAreaInsets.bottom)
        }
        .gesture(
            DragGesture()
                .updating($dragY) { value, state, _ in
                    state = value.startLocation.y - value.location.y
                }
                .onEnded { value in
                    if value.translation.height > contentHeight / 2 {
                        isShown = false
                    }
                }
        )
        .animation(.linear(duration: 0.2))
    }
}

extension BottomSheet {
    struct ContentHeightPreferenceKey: PreferenceKey {
        typealias Value = CGFloat
        static var defaultValue: CGFloat { 0.0 }
        
        static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
            value = nextValue()
        }
    }
}

extension View {
    func bottomSheet<Content: View>(isShown: Binding<Bool>, @ViewBuilder content: () -> Content) -> some View {
        ZStack {
            self
            
            BottomSheet(isShown: isShown) {
                content()
            }
        }
    }
}

struct BottomSheet_Previews: PreviewProvider {
    @State private static var showBottomSheet: Bool = false
    
    static var previews: some View {
        ZStack {
            Color.orange
            
            Toggle("", isOn: $showBottomSheet)
        }
        .bottomSheet(isShown: $showBottomSheet) {
            VStack {
                Text("Bottom Sheet")
                Text("Bottom Sheet")
                Text("Bottom Sheet")
                Text("Bottom Sheet")
                Text("Bottom Sheet")
                VStack {
                    Text("Bottom Sheet")
                    Text("Bottom Sheet")
                    Text("Bottom Sheet")
                    Text("Bottom Sheet")
                    Text("Bottom Sheet")
                }
                VStack {
                    Text("Bottom Sheet")
                    Text("Bottom Sheet")
                    Text("Bottom Sheet")
                    Text("Bottom Sheet")
                    Text("Bottom Sheet")
                }
            }
        }
    }
}
