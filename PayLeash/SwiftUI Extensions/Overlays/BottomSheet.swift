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
    
    private var handleTopPadding: CGFloat = 10
    private let kFullSizeCoordinateSpaceName = UUID()
    
    var body: some View {
        GeometryReader { proxy in
            ZStack {
                VStack(spacing: 5) {
                    Capsule()
                        .fill(Color.secondary)
                        .frame(width: 40, height: 6)
                        .padding(.top, handleTopPadding)
                    
                    content
                }
                .anchorPreference(key: ContentHeightPreferenceKey.self, value: .bounds, transform: { proxy[$0].height })
                .onPreferenceChange(ContentHeightPreferenceKey.self, perform: { contentHeight = $0 })
                .frame(width: UIScreen.main.bounds.width,
                       height: contentHeight + dragY + proxy.safeAreaInsets.bottom,
                       alignment: .top)
                .background(
                    ZStack {
                        Rectangle()
                            .fill(Color.white)
                            .cornerRadius(15, corners: [.topLeft, .topRight])
                            .shadow(color: isShown ? Color.gray.opacity(0.6) : .clear, radius: 7)
                    }
                )
                .gesture(
                    DragGesture(coordinateSpace: .named(kFullSizeCoordinateSpaceName))
                        .updating($dragY) { value, state, _ in
                            state = -value.translation.height
                        }
                        .onEnded { value in
                            //If the drag ends lower than half the total height, close the sheet. Otherwise, snap back.
                            if value.translation.height > contentHeight / 2 {
                                isShown = false
                            }
                        }
                )
            }
            .frame(maxHeight: .infinity, alignment: .bottom)
            .offset(y: (isShown ? 0 : contentHeight + proxy.safeAreaInsets.bottom) + proxy.safeAreaInsets.bottom)
        }
        .coordinateSpace(name: kFullSizeCoordinateSpaceName)
        .background(
            (isShown ? Color.gray.opacity(0.2) : Color.clear)
                .animation(.linear(duration: 0.2))
                .ignoresSafeArea()
                .onTapGesture {
                    isShown = false
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
    /// Presents a view inside a sheet, emerging from the bottom of the screen.
    /// - Parameter isShown: The binding that controls whether the sheet is visible on the screen.
    /// - Parameter content: The view that is shown inside the Bottom Sheet.
    ///
    /// - Important
    /// This view modifier should only be used when a top-level, full-screen, **parent** view received the `.allowsFullScreenOverlays()` modifier.
    /// Behavior is otherwise undefined and could result in a runtime exception.
    func bottomSheet<Content: View>(isShown: Binding<Bool>, @ViewBuilder content: @escaping () -> Content) -> some View {
        self.transformPreference(FullScreenCoverPreferenceKey.self) { preferenceKey in
            preferenceKey.append(FullScreenCoverPreferenceKey.OverlayView {
                BottomSheet(isShown: isShown) {
                    content()
                }
            })
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
