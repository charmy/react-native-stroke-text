import UIKit
import Foundation

class StrokeTextView: RCTView {
    public var label: StrokedTextLabel
    weak var bridge: RCTBridge?

    init(bridge: RCTBridge) {
        label = StrokedTextLabel()
        self.bridge = bridge
        super.init(frame: .zero)

        label.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(label)
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.bridge?.uiManager.setSize(label.intrinsicContentSize, for: self)
    }


    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc var width: NSNumber = 0 {
        didSet {
            self.label.customWidth = CGFloat(truncating: width)
        }
    }

    @objc var text: String = "" {
        didSet {
            label.text = text
        }
    }

    @objc var fontSize: NSNumber = 14 {
        didSet {
            label.font = label.font.withSize(CGFloat(truncating: fontSize))
        }
    }

    @objc var color: String = "#000000" {
        didSet {
            label.textColor = hexStringToUIColor(hexColor: color)
        }
    }

    @objc var strokeColor: String = "#FFFFFF" {
        didSet {
            label.outlineColor = hexStringToUIColor(hexColor: strokeColor)
        }
    }

    @objc var strokeWidth: NSNumber = 1 {
        didSet {
            label.outlineWidth = CGFloat(truncating: strokeWidth)
        }
    }

    @objc var fontFamily: String = "Helvetica" {
        didSet {
            if let font = UIFont(name: fontFamily, size: CGFloat(truncating: fontSize)) {
                label.font = font
            }
        }
    }

    @objc var align: String = "center" {
        didSet {
            if align == "left" {
                label.align = .left
            }else if align == "right" {
                label.align = .right
            }else{
                label.align = .center
            }
        }
    }

    @objc var ellipsis: Bool = false {
        didSet {
            label.ellipsis = ellipsis
        }
    }

    @objc var numberOfLines: NSNumber = 0 {
        didSet {
            label.numberOfLines = Int(truncating: numberOfLines)
        }
    }

    private func hexStringToUIColor(hexColor: String) -> UIColor {
        var cString: String = hexColor.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        if cString.hasPrefix("#") {
            cString.removeFirst()
        }

        if cString.count != 6 {
            return UIColor.gray
        }

        var rgbValue: UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)

        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}
