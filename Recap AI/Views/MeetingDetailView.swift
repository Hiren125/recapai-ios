//
//  MeetingDetailView.swift
//  Recap AI
//
//  Created by Hiren on 05/06/26.
//

import SwiftUI
import UIKit

struct MeetingDetailView: View {
    let meeting: Meeting
    @State private var selectedTab = 0
    private let pdfService = PDFExportService()

    var body: some View {
        VStack(spacing: 0) {
            Picker("View", selection: $selectedTab) {
                Text("Summary").tag(0)
                Text("Transcript").tag(1)
            }
            .pickerStyle(.segmented)
            .padding()

            TabView(selection: $selectedTab) {
                SummaryView(summary: meeting.summary)
                    .tag(0)
                ScrollView {
                    Text(meeting.transcript.isEmpty ? "No transcript." : meeting.transcript)
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .tag(1)
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
        }
        .navigationTitle(meeting.title)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button {
                    exportPDF()
                } label: {
                    Image(systemName: "square.and.arrow.up")
                }
            }
        }
    }

    private func exportPDF() {
        // Generate PDF
        let data = pdfService.generatePDF(for: meeting)
        let url = FileManager.default.temporaryDirectory
            .appendingPathComponent("\(meeting.title).pdf")
        try? data.write(to: url)

        // Present share sheet directly via UIKit — no SwiftUI sheet needed
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let rootVC = windowScene.windows.first?.rootViewController else { return }

        let activityVC = UIActivityViewController(activityItems: [url], applicationActivities: nil)

        // For iPad — required to avoid crash
        if let popover = activityVC.popoverPresentationController {
            popover.sourceView = windowScene.windows.first
            popover.sourceRect = CGRect(x: UIScreen.main.bounds.width - 60, y: 100, width: 0, height: 0)
        }

        // Find the topmost presented view controller
        var topVC = rootVC
        while let presented = topVC.presentedViewController {
            topVC = presented
        }

        topVC.present(activityVC, animated: true)
    }
}
