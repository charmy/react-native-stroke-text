import UIKit

class StrokedTextLabel: UILabel {
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.numberOfLines = 0
    }

    var outlineWidth: CGFloat = 0
    var outlineColor: UIColor = .clear
    var align: NSTextAlignment = .center
    var customWidth: CGFloat = 0
    var ellipsis: Bool = false

    override func drawText(in rect: CGRect) {
        let shadowOffset = self.shadowOffset
        let textColor = self.textColor

        self.lineBreakMode = ellipsis ? .byTruncatingTail : .byWordWrapping

        let strokePadding = outlineWidth / 2
        let insets = UIEdgeInsets(top: 0, left: strokePadding, bottom: 0, right: strokePadding)
        let adjustedRect = rect.inset(by: insets)

        let context = UIGraphicsGetCurrentContext()
        context?.setLineWidth(outlineWidth)
        context?.setLineJoin(.round)
        context?.setTextDrawingMode(.stroke)
        self.textAlignment = align
        self.textColor = outlineColor

        super.drawText(in: adjustedRect)

        context?.setTextDrawingMode(.fill)
        self.textColor = textColor
        self.shadowOffset = CGSize(width: 0, height: 0)
        super.drawText(in: adjustedRect)

        self.shadowOffset = shadowOffset
    }

    override var intrinsicContentSize: CGSize {
        var contentSize = super.intrinsicContentSize
        if customWidth > 0 {
            contentSize.width = customWidth
        }
        contentSize.width += outlineWidth
        return contentSize
    }
}
