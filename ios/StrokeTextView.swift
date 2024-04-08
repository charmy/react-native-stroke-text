import Foundation
import UIKit

class StrokeTextView: RCTView {
    public var label: StrokedTextLabel
    weak var bridge: RCTBridge?

    init(bridge: RCTBridge) {
        label = StrokedTextLabel()
        self.bridge = bridge
        super.init(frame: .zero)

        label.translatesAutoresizingMaskIntoConstraints = false
        addSubview(label)
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: centerXAnchor),
            label.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        bridge?.uiManager.setSize(label.intrinsicContentSize, for: self)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc var text: String = "" {
        didSet {
            label.text = text
        }
    }

    @objc var fontSize: NSNumber = 14 {
        didSet {
            updateFont()
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
            updateFont()
        }
    }

    @objc var fontWeight: String = "Regular" {
        didSet {
            updateFont()
        }
    }

    private func updateFont() {
        let fontSizeValue = CGFloat(truncating: fontSize)
        var finalFont: UIFont?

        let weight: UIFont.Weight
        switch fontWeight.lowercased() {
        case "ultralight": weight = .ultraLight
        case "thin": weight = .thin
        case "light": weight = .light
        case "regular": weight = .regular
        case "medium": weight = .medium
        case "semibold": weight = .semibold
        case "bold": weight = .bold
        case "heavy": weight = .heavy
        case "black": weight = .black
        default: weight = .regular // Fallback to regular if no match found
        }

        if let font = UIFont(name: fontFamily, size: fontSizeValue) {
            finalFont = font
        } else {
            finalFont = UIFont.systemFont(ofSize: fontSizeValue, weight: weight)
        }

        label.font = finalFont
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
