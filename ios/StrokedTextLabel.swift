import UIKit

class StrokedTextLabel: UILabel {
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.numberOfLines = 0
    }

    var outlineWidth: CGFloat = 0 {
        didSet {
            if outlineWidth != oldValue {
                updateTextInsets()
                setNeedsDisplay()
            }
        }
    }

    var outlineColor: UIColor = .clear {
        didSet {
            if outlineColor != oldValue {
                setNeedsDisplay()
            }
        }
    }

    var align: NSTextAlignment = .center {
        didSet {
            if align != oldValue {
                setNeedsDisplay()
            }
        }
    }

    var customWidth: CGFloat = 0 {
        didSet {
            if customWidth != oldValue {
                setNeedsDisplay()
            }
        }
    }

    var ellipsis: Bool = false {
        didSet {
            if ellipsis != oldValue {
                setNeedsDisplay()
            }
        }
    }

    private var textInsets: UIEdgeInsets = .zero {
        didSet {
            if textInsets != oldValue {
                invalidateIntrinsicContentSize()
            }
        }
    }

    private func updateTextInsets() {
        let strokePadding = outlineWidth / 2
        textInsets = UIEdgeInsets(top: 0, left: strokePadding, bottom: 0, right: strokePadding)
    }

    override func drawText(in rect: CGRect) {
        let shadowOffset = self.shadowOffset
        let textColor = self.textColor

        self.lineBreakMode = ellipsis ? .byTruncatingTail : .byWordWrapping

        let adjustedRect = rect.inset(by: textInsets)

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
        }else{
            contentSize.width += (textInsets.left + textInsets.right)
        }

        return contentSize
    }
}
