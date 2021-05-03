//
//  AppInitializer.swift
//  PayLeash
//
//  Created by Balazs Erdesz on 2021. 05. 03..
//

import Foundation
import CoreData

class AppInitializer {
    static private let latestVersionKey = "latestCategoriesJSONKey"
    static private(set) var shared = AppInitializer()
    
    func loadCategoriesFromJson() {
        let versionFilePath = Bundle.main.path(forResource: "LatestCategoriesVersion", ofType: "json")!
        let path = Bundle.main.path(forResource: "Categories", ofType: "json")!
        
        let decoder = JSONDecoder()
        decoder.userInfo[.context] = AppDelegate.sharedInstance.persistentContainer.viewContext
        
        let versionFileData = try! Data(contentsOf: URL(fileURLWithPath: versionFilePath))
        let latestVersionFileObject = try! decoder.decode(CategoriesVersionFile.self, from: versionFileData)
        
        if latestVersionFileObject.latestVersion > UserDefaults.standard.integer(forKey: Self.latestVersionKey) {
            let fileData = try! Data(contentsOf: URL(fileURLWithPath: path))
            let _ = try! decoder.decode([TransactionCategory].self, from: fileData) //This should auto-insert the new categories.
            
            UserDefaults.standard.set(latestVersionFileObject.latestVersion, forKey: Self.latestVersionKey)
        }
    }
}

private struct CategoriesVersionFile: Codable {
    var latestVersion: Int
}
