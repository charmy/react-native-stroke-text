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

    override func drawText(in rect: CGRect) {
        let shadowOffset = self.shadowOffset
        let textColor = self.textColor

        let c = UIGraphicsGetCurrentContext()

        c?.setLineWidth(outlineWidth)
        c?.setLineJoin(.round)
        c?.setTextDrawingMode(.stroke)
        self.textAlignment = .center
        self.textColor = outlineColor

        super.drawText(in: rect)

        if let shadowColor = shadowColor {
            super.shadowColor = shadowColor
            super.shadowOffset = shadowOffset
            super.drawText(in: rect)
        }

        c?.setTextDrawingMode(.fill)
        self.textColor = textColor
        self.shadowOffset = CGSize(width: 0, height: 0)
        super.drawText(in: rect)

        self.shadowOffset = shadowOffset
    }


    override var intrinsicContentSize: CGSize {
        get {
            var contentSize = super.intrinsicContentSize
//            contentSize.height += outlineWidth * 2
            contentSize.width += outlineWidth * 2
            return contentSize
        }
    }

}
