//
//  PageScrollView+Controller.swift
//  PayLeash
//
//  Created by Balazs Erdesz on 2021. 03. 13..
//

import Foundation
import UIKit
import SwiftUI
import Combine

extension PageScrollView {
    class PageScrollViewController: UIViewController {
        private var cancellableSet = Set<AnyCancellable>()
        /// The currently selected page number. The numbering begins with 0 for the first page.
        private(set) var selectedPageNumber = CurrentValueSubject<Int, Never>(0)
        
        var subViews: [AnyView]! = nil
        private var subViewCountAsCGFloat: CGFloat { CGFloat(subViews.count) }
        
        private var scrollView: UIScrollView! = nil
        
        init() {
            super.init(nibName: nil, bundle: nil)
            setupSubscriptions()
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        //MARK:- View Lifecycle
        override func viewDidLoad() {
            super.viewDidLoad()
            
            scrollView = UIScrollView(frame: view.bounds)
            scrollView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            
            scrollView.isOpaque = false
            scrollView.showsHorizontalScrollIndicator = false
            scrollView.clipsToBounds = false
            scrollView.isPagingEnabled = true
            scrollView.delegate = self
            
            self.view.addSubview(scrollView)
            
            let insetSize: CGFloat = 25
            let spacing: CGFloat = 30
            let originalFrame = scrollView.frame
            scrollView.frame = CGRect(origin: CGPoint(x: originalFrame.origin.x + insetSize,
                                                      y: originalFrame.origin.y),
                                      size: CGSize(width: originalFrame.size.width - (insetSize * 2 + spacing),
                                                   height: originalFrame.size.height))
            
            let scrollViewWidth = scrollView.frame.size.width
            
            for i in 0..<subViews.count {
                let hostingController = UIHostingController(rootView: subViews[i])
                hostingController.view.bounds = scrollView.bounds
                
                self.addChild(hostingController)
                scrollView.addSubview(hostingController.view)
                hostingController.didMove(toParent: self)
                
                hostingController.view.frame.origin.x = CGFloat(i) * scrollViewWidth + spacing
                hostingController.view.frame.origin.y = scrollView.frame.origin.y
                hostingController.view.frame.size.width = scrollViewWidth - spacing
                hostingController.view.frame.size.height = scrollView.frame.size.height
                hostingController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            }
        }
        
        override func viewDidAppear(_ animated: Bool) {
            super.viewDidAppear(animated)
            
            scrollView.contentSize = CGSize(width: subViewCountAsCGFloat * scrollView.frame.size.width,
                                            height: scrollView.frame.size.height)
        }
        
        //MARK:- Responding to outer events
        private func setupSubscriptions() {
            //When the binding is set from the outside, scroll to the bound page
            selectedPageNumber
                .filter { [weak self] number in
                    guard
                        let self = self,
                        self.subViews != nil
                    else { return false }
                    
                    return number >= 0 && number < self.subViews.count
                }
                .map { CGFloat($0) }
                .sink { [weak self] pageNumberAsCGFloat in
                    guard let self = self else { return }
                    
                    //Note: this should do nothing when called from the scrollViewDidEndDecelerating, so it won't cause an infinite loop.
                    self.scrollView.scrollRectToVisible(CGRect(x: self.scrollView.frame.size.width * pageNumberAsCGFloat, y: 0,
                                                               width: self.scrollView.frame.size.width, height: 1),
                                                        animated: true)
                }
                .store(in: &cancellableSet)
        }
    }
}

//MARK:- UIScrollViewDelegate
extension PageScrollView.PageScrollViewController : UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let shownPageNumber = Int(round(scrollView.contentOffset.x / scrollView.frame.size.width))
        print(shownPageNumber)
        selectedPageNumber.send(shownPageNumber)
    }
}
