//
//  NetworkMonitor.swift
//  Weather
//
//  Created by Mano on 04/08/23.
//

import Foundation
import SwiftUI
import Network

class NetworkMonitor: ObservableObject {
    private let networkMonitor = NWPathMonitor()
    private let workerQueue = DispatchQueue(label: "Monitor")
    var isConnected = false

    init() {
        networkMonitor.pathUpdateHandler = { path in
            self.isConnected = path.status == .satisfied
            DispatchQueue.main.async {
                self.objectWillChange.send()
            }
        }
        networkMonitor.start(queue: workerQueue)
    }
}
