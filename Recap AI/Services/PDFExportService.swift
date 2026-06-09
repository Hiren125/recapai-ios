//
//  PDFExportService.swift
//  Recap AI
//
//  Created by Hiren on 08/06/26.
//

import PDFKit
import UIKit

struct PDFExportService {

    func generatePDF(for meeting: Meeting) -> Data {
        let pageRect = CGRect(x: 0, y: 0, width: 595, height: 842) // A4
        let renderer = UIGraphicsPDFRenderer(bounds: pageRect)
        let margin: CGFloat = 48

        return renderer.pdfData { ctx in
            ctx.beginPage()
            var y: CGFloat = margin

            y = drawTitle(meeting.title, at: y, margin: margin, width: pageRect.width)
            y = drawSubtitle(
                meeting.date.formatted(date: .long, time: .shortened),
                at: y, margin: margin
            )
            y += 16

            if let summary = meeting.summary {
                y = drawSection("Overview", body: summary.overview,
                                at: y, margin: margin, pageWidth: pageRect.width)
                y = drawBullets("Action Items", items: summary.actionItems,
                                at: y, margin: margin, pageWidth: pageRect.width)
                y = drawBullets("Follow-up Tasks", items: summary.followUpTasks,
                                at: y, margin: margin, pageWidth: pageRect.width)
                y = drawBullets("Key Decisions", items: summary.keyDecisions,
                                at: y, margin: margin, pageWidth: pageRect.width)
            }

            y += 24
            drawSection("Full Transcript", body: meeting.transcript,
                        at: y, margin: margin, pageWidth: pageRect.width)
        }
    }

    @discardableResult
    private func drawTitle(_ text: String, at y: CGFloat, margin: CGFloat, width: CGFloat) -> CGFloat {
        let attrs: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 24, weight: .bold),
            .foregroundColor: UIColor.black
        ]
        text.draw(in: CGRect(x: margin, y: y, width: width - margin * 2, height: 36), withAttributes: attrs)
        return y + 44
    }

    @discardableResult
    private func drawSubtitle(_ text: String, at y: CGFloat, margin: CGFloat) -> CGFloat {
        let attrs: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 13),
            .foregroundColor: UIColor.gray
        ]
        text.draw(at: CGPoint(x: margin, y: y), withAttributes: attrs)
        return y + 20
    }

    @discardableResult
    private func drawSection(_ heading: String, body: String,
                             at y: CGFloat, margin: CGFloat, pageWidth: CGFloat) -> CGFloat {
        var cy = y
        let headingAttrs: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 14, weight: .semibold),
            .foregroundColor: UIColor.black
        ]
        heading.draw(at: CGPoint(x: margin, y: cy), withAttributes: headingAttrs)
        cy += 22

        let bodyAttrs: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 12),
            .foregroundColor: UIColor.darkGray
        ]
        let maxWidth = pageWidth - margin * 2
        let rect = body.boundingRect(
            with: CGSize(width: maxWidth, height: 2000),
            options: .usesLineFragmentOrigin,
            attributes: bodyAttrs,
            context: nil
        )
        body.draw(in: CGRect(x: margin, y: cy, width: maxWidth, height: rect.height),
                  withAttributes: bodyAttrs)
        return cy + rect.height + 20
    }

    @discardableResult
    private func drawBullets(_ heading: String, items: [String],
                             at y: CGFloat, margin: CGFloat, pageWidth: CGFloat) -> CGFloat {
        guard !items.isEmpty else { return y }
        let body = items.map { "• \($0)" }.joined(separator: "\n")
        return drawSection(heading, body: body, at: y, margin: margin, pageWidth: pageWidth)
    }
}
