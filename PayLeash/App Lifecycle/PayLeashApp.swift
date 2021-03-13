//
//  PayLeashApp.swift
//  PayLeash
//
//  Created by Balazs Erdesz on 2021. 03. 10..
//

import Foundation
import SwiftUI

@main
struct PayLeashApp : App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, appDelegate.persistentContainer.viewContext)
        }
    }
}
