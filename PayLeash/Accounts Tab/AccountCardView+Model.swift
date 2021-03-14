//
//  AccountCardView+Model.swift
//  PayLeash
//
//  Created by Balazs Erdesz on 2021. 03. 14..
//

import Foundation
import Combine

extension AccountCardView {
    class Model: ObservableObject {
        @Published var account: Account! = nil
        @Published var balance: Double! = 0.0
        
        init(account: Account) {
            setupSubscriptions()
            self.account = account
        }
        
        private var cancellableSet = Set<AnyCancellable>()
        
        private func setupSubscriptions() {
            $account
                .compactMap { $0?.transactions }
                .map {
                    $0.map { $0.amount }
                        .reduce(0, +)
                }
                .weakAssign(to: \.balance, on: self)
                .store(in: &cancellableSet)
        }
    }
}
