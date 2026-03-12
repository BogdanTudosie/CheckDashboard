//
//  ContentView.swift
//  CheckDashboard
//
//  Created by Bogdan Tudosie on 9.3.2026.
//

import SwiftUI

struct ContentView: View {
    @State private var selection: SidebarItem? = .dashboard
    
    var body: some View {
        NavigationSplitView {
            List(selection: $selection) {
                Label("Dashboard", systemImage: "rectangle.grid.2x2")
                    .tag(SidebarItem.dashboard)
                
                Label("History", systemImage: "clock")
                    .tag(SidebarItem.history)
                
                Label("Settings", systemImage: "gearshape")
                    .tag(SidebarItem.settings)
            }
        }
        detail: {
            switch selection ?? .dashboard {
            case .dashboard:
                DashboardView()
            case .history:
                Text("History")
            case .settings:
                Text("Settings")
            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
