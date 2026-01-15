//
//  SchmutzliNaughtyListAppApp.swift
//  SchmutzliNaughtyListApp
//
//  Created by app-kaihatsusha on 15/01/2026.
//  Copyright © 2026 app-kaihatsusha. All rights reserved.
//

import SwiftUI
import SwiftData

@main
struct SchmutzliNaughtyListAppApp: App {
    var body: some Scene {
        WindowGroup {
            ListView()
                .modelContainer(for: Child.self)
                .onAppear {
                    Thread.sleep(forTimeInterval: 3)
                }
        }
    }
    
    init() {
        print(URL.applicationSupportDirectory.path(percentEncoded: false))
    }
}
