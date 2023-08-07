//
//  WeatherApp.swift
//  Weather
//
//  Created by Mano on 29/07/23.
//

import SwiftUI

@main
struct WeatherApp: App {
    let persistenceController = PersistenceController.shared
    @StateObject var networkMonitor = NetworkMonitor()
    var body: some Scene {
        WindowGroup {
            HomeScreen()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environmentObject(networkMonitor)
            
        }
    }
}


