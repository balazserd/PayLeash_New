//
//  PageScrollView.swift
//  PayLeash
//
//  Created by Balazs Erdesz on 2021. 03. 11..
//

import SwiftUI
import Combine

struct PageScrollView: UIViewControllerRepresentable {
    typealias UIViewControllerType = UIViewController
    
    @Binding var selectedPageNumber: Int
    let views: [AnyView]
    
    func makeUIViewController(context: Context) -> UIViewController {
        let viewController = PageScrollViewController()
        viewController.subViews = self.views
        
        context.coordinator.scrollViewController = viewController
        
        return viewController
    }
    
    func updateUIViewController(_ uiView: UIViewController, context: Context) {
        context.coordinator.scrollViewController.selectedPageNumber.send(self.selectedPageNumber)
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    
    class Coordinator {
        var parent: PageScrollView
        var scrollViewController: PageScrollView.PageScrollViewController! = nil {
            didSet {
                setupBindings(for: scrollViewController)
            }
        }
        
        private var cancellableSet = Set<AnyCancellable>()
        
        init(parent: PageScrollView) {
            self.parent = parent
        }
        
        private func setupBindings(for viewController: PageScrollViewController) {
            viewController.selectedPageNumber
                .receive(on: DispatchQueue.main)
                .assign(to: \._selectedPageNumber.wrappedValue, on: parent)
                .store(in: &cancellableSet)
        }
    }
}

struct PageScrollView_Previews: PreviewProvider {
    @State static private var selectedPage: Int = 2
    
    static var previews: some View {
        VStack {
            Spacer()
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
