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
    
    var body: some View {
        GeometryReader { proxy in
            ZStack {
                VStack {
                    Capsule()
                        .fill(Color.secondary)
                        .frame(width: 40, height: 6)
                        .padding(.top, 10)
                    
                    content
                        .padding(.bottom, proxy.safeAreaInsets.bottom)
                }
                .frame(width: UIScreen.main.bounds.width, height: 200 + dragY, alignment: .top)
                .background(
                    ZStack {
                        RoundedRectangle(cornerRadius: 15)
                            .fill(Color.white)
                            .shadow(color: Color.black.opacity(0.6), radius: 7)
                    }
                )
            }
            .frame(maxHeight: .infinity, alignment: .bottom)
        }
        .gesture(
            DragGesture()
                .updating($dragY) { value, state, _ in
                    state = value.startLocation.y - value.location.y
                }
                .onEnded { value in
                    if value.translation.height > 100 {
                        isShown = false
                    }
                }
        )
        .offset(y: isShown ? 0 : 250)
        .animation(.linear(duration: 0.2))
        .ignoresSafeArea()
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
    @State private static var showBottomSheet: Bool = true
    
    static var previews: some View {
        ZStack {
            Color.orange
            
            Toggle("", isOn: $showBottomSheet)
        }
        .bottomSheet(isShown: $showBottomSheet) {
            VStack {
                Text("Bottom Sheet")
            }
        }
    }
}
