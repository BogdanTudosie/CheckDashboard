//
//  ResetDrawerView.swift
//  CheckDashboard
//
//  Created by Bogdan Tudosie on 9.3.2026.
//

import SwiftUI

struct ResetDrawerView: View {
    let onClose: () -> Void

    @AppStorage("reset.todaysWin") private var storedTodaysWin: String = ""
    @AppStorage("reset.blockers") private var storedBlockersData: Data = Data()
    @AppStorage("reset.done") private var storedDoneData: Data = Data()

    @State private var newBlocker: String = ""
    @State private var newDone: String = ""

    private var blockers: [String] {
        get { Persist.decodeStringArray(storedBlockersData) }
        nonmutating set { storedBlockersData = Persist.encodeStringArray(newValue) }
    }

    private var done: [String] {
        get { Persist.decodeStringArray(storedDoneData) }
        nonmutating set { storedDoneData = Persist.encodeStringArray(newValue) }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            header

            GroupBox("Today’s win") {
                TextField("What would make today a win?", text: $storedTodaysWin)
                    .textFieldStyle(.roundedBorder)
            }

            GroupBox("What’s in the way?") {
                VStack(spacing: 10) {
                    HStack {
                        TextField("Add blocker…", text: $newBlocker)
                            .textFieldStyle(.roundedBorder)
                            .onSubmit(addBlocker)

                        Button(action: addBlocker) { Image(systemName: "plus.circle.fill") }
                            .buttonStyle(.plain)
                    }

                    ForEach(blockers.indices, id: \.self) { idx in
                        HStack {
                            Text(blockers[idx])
                            Spacer()
                            Button {
                                var b = blockers
                                b.remove(at: idx)
                                blockers = b
                            } label: {
                                Image(systemName: "xmark.circle.fill")
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
            }

            GroupBox("What did you finish?") {
                VStack(spacing: 10) {
                    HStack {
                        TextField("Add win…", text: $newDone)
                            .textFieldStyle(.roundedBorder)
                            .onSubmit(addDone)

                        Button(action: addDone) { Image(systemName: "plus.circle.fill") }
                            .buttonStyle(.plain)
                    }

                    ForEach(done.indices, id: \.self) { idx in
                        HStack {
                            Image(systemName: "checkmark.circle.fill")
                            Text(done[idx])
                            Spacer()
                            Button {
                                var d = done
                                d.remove(at: idx)
                                done = d
                            } label: {
                                Image(systemName: "xmark.circle.fill")
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
            }

            Spacer()

            Button {
                exportToday()
            } label: {
                Label("Export today", systemImage: "square.and.arrow.down")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)

            Text("Small steps count ✨")
                .font(.footnote)
                .foregroundStyle(.secondary)
                .frame(maxWidth: .infinity, alignment: .center)
        }
        .padding(16)
        .background(.regularMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .shadow(radius: 12)
    }

    private var header: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("Reset").font(.title2).bold()
                Text("Your daily reset space").foregroundStyle(.secondary)
            }
            Spacer()
            Button(action: onClose) { Image(systemName: "xmark.circle.fill").font(.title3) }
                .buttonStyle(.plain)
        }
    }

    private func addBlocker() {
        let t = newBlocker.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !t.isEmpty else { return }
        var b = blockers
        b.insert(t, at: 0)
        blockers = b
        newBlocker = ""
    }

    private func addDone() {
        let t = newDone.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !t.isEmpty else { return }
        var d = done
        d.insert(t, at: 0)
        done = d
        newDone = ""
    }

    private func exportToday() {
        // Keep it simple for now: just copy to clipboard
        let text = """
        Today’s win: \(storedTodaysWin.isEmpty ? "—" : storedTodaysWin)

        Blockers:
        \(blockers.isEmpty ? "—" : blockers.map { "• \($0)" }.joined(separator: "\n"))

        Done:
        \(done.isEmpty ? "—" : done.map { "• \($0)" }.joined(separator: "\n"))
        """

        NSPasteboard.general.clearContents()
        NSPasteboard.general.setString(text, forType: .string)
    }
}
