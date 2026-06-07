//
//  SummaryView.swift
//  Recap AI
//
//  Created by Hiren on 03/06/26.
//

import SwiftUI

struct SummaryView: View {
    let summary: MeetingSummary?

    var body: some View {
        if let summary {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {

                    SummarySection(title: "Overview", icon: "doc.text") {
                        Text(summary.overview)
                    }

                    if !summary.actionItems.isEmpty {
                        SummarySection(title: "Action Items", icon: "checklist") {
                            ForEach(summary.actionItems, id: \.self) { item in
                                CheckableRow(text: item)
                            }
                        }
                    }

                    if !summary.followUpTasks.isEmpty {
                        SummarySection(title: "Follow-up Tasks", icon: "arrow.clockwise.circle") {
                            ForEach(summary.followUpTasks, id: \.self) { task in
                                BulletRow(text: task)
                            }
                        }
                    }

                    if !summary.keyDecisions.isEmpty {
                        SummarySection(title: "Key Decisions", icon: "lightbulb") {
                            ForEach(summary.keyDecisions, id: \.self) { decision in
                                BulletRow(text: decision)
                            }
                        }
                    }

                    if !summary.participants.isEmpty {
                        SummarySection(title: "Participants", icon: "person.2") {
                            FlowLayout(items: summary.participants) { name in
                                Text(name)
                                    .font(.caption)
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 4)
                                    .background(Color.accentColor.opacity(0.12))
                                    .clipShape(Capsule())
                            }
                        }
                    }
                }
                .padding()
            }
        } else {
            ContentUnavailableView(
                "No Summary",
                systemImage: "sparkles",
                description: Text("Summary will appear here after processing.")
            )
        }
    }
}

struct SummarySection<Content: View>: View {
    let title: String
    let icon: String
    @ViewBuilder let content: () -> Content

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Label(title, systemImage: icon).font(.headline)
            content()
        }
    }
}

struct CheckableRow: View {
    let text: String
    @State private var isChecked = false

    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            Image(systemName: isChecked ? "checkmark.circle.fill" : "circle")
                .foregroundStyle(isChecked ? .green : .secondary)
                .onTapGesture { isChecked.toggle() }
            Text(text)
                .strikethrough(isChecked, color: .secondary)
                .foregroundStyle(isChecked ? .secondary : .primary)
        }
    }
}

struct BulletRow: View {
    let text: String
    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            Text("•").foregroundStyle(.secondary)
            Text(text)
        }
    }
}

struct FlowLayout<Item: Hashable, ItemView: View>: View {
    let items: [Item]
    let itemView: (Item) -> ItemView
    var body: some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 80), spacing: 8)], spacing: 8) {
            ForEach(items, id: \.self) { item in itemView(item) }
        }
    }
}
