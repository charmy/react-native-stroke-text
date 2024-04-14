import UIKit
import Foundation

class StrokedTextLabel: UILabel {


    var outlineWidth: CGFloat = 0 {
        didSet {
            setNeedsLayout()
        }
    }

    var outlineColor: UIColor = .clear {
        didSet {
            setNeedsLayout()
        }
    }

    var align: NSTextAlignment = .center {
        didSet {
            setNeedsLayout()
        }
    }

    override func drawText(in rect: CGRect) {
        // Enable multiline
        self.numberOfLines = 0

        let shadowOffset = self.shadowOffset
        let textColor = self.textColor

        // Adjust the text drawing area to accommodate the outline width
        let strokePadding = outlineWidth / 2
        let insets = UIEdgeInsets(top: 0, left: strokePadding, bottom: 0, right: strokePadding)
        let adjustedRect = rect.inset(by: insets)

        let c = UIGraphicsGetCurrentContext()

        c?.setLineWidth(outlineWidth)
        c?.setLineJoin(.round)
        c?.setTextDrawingMode(.stroke)
        self.textAlignment = align
        self.textColor = outlineColor

        super.drawText(in: adjustedRect)

        if let shadowColor = shadowColor {
            super.shadowColor = shadowColor
            super.shadowOffset = shadowOffset
            super.drawText(in: adjustedRect)
        }

        c?.setTextDrawingMode(.fill)
        self.textColor = textColor
        self.shadowOffset = CGSize(width: 0, height: 0)
        super.drawText(in: adjustedRect)

        self.shadowOffset = shadowOffset
    }


    override var intrinsicContentSize: CGSize {
        get {
            var contentSize = super.intrinsicContentSize
            contentSize.width += outlineWidth
            return contentSize
        }
    }

}
