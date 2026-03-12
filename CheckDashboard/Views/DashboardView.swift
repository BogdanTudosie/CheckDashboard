//
//  DashboardView.swift
//  CheckDashboard
//
//  Created by Bogdan Tudosie on 9.3.2026.
//

import SwiftUI

import SwiftUI

struct DashboardView: View {
    @State private var isResetOpen = true // set true just to see it immediately
    @StateObject private var vm = DashboardViewModel()

    var body: some View {
        ZStack(alignment: .trailing) {
            // Main content
            ScrollView {
                VStack(alignment: .leading, spacing: 32) {
                    header

                    LazyVGrid(
                        columns: [GridItem(.adaptive(minimum: 260), spacing: 16)],
                        spacing: 16
                    ) {
                        ForEach(vm.cards) { card in
                            CardView(model: card,
                                     onRun: { vm.run(id: card.id) },
                                     onOpenSettings: {})
                        }
                    }
                }
            }
            .padding()

            // Right drawer overlay
            if isResetOpen {
                Color.black.opacity(0.20)
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            isResetOpen = false
                        }
                    }

                ResetDrawerView {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        isResetOpen = false
                    }
                }
                .frame(width: 360)
                .padding(.trailing, 12)
                .transition(.move(edge: .trailing))
            }
        }
        .toolbar {
            ToolbarItem(placement: .automatic) {
                Button {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        isResetOpen.toggle()
                    }
                } label: {
                    Label("Reset", systemImage: "sun.max.fill")
                }
                
                Button("Run All Checks") { vm.runAll() }
            }
        }
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Quick check. No drama. 👋")
                .font(.title3).fontWeight(.semibold)
            Text("See how your Mac is doing today.")
                .foregroundStyle(.secondary)
        }
        .padding()
    }
}

#Preview {
    DashboardView()
}
