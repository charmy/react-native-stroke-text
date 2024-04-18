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
            if width != oldValue {
                self.label.customWidth = CGFloat(truncating: width)
                label.setNeedsDisplay()
            }
        }
    }

    @objc var text: String = "" {
        didSet {
            if text != oldValue {
                label.text = text
                label.setNeedsDisplay()
            }
        }
    }

    @objc var fontSize: NSNumber = 14 {
        didSet {
            if fontSize != oldValue {
                label.font = label.font.withSize(CGFloat(truncating: fontSize))
                label.setNeedsDisplay()
            }
        }
    }

    @objc var color: String = "#000000" {
        didSet {
            if color != oldValue {
                label.textColor = colorStringToUIColor(colorString: color)
                label.setNeedsDisplay()
            }
        }
    }

    @objc var strokeColor: String = "#FFFFFF" {
        didSet {
            if strokeColor != oldValue {
                label.outlineColor = colorStringToUIColor(colorString: strokeColor)
                label.setNeedsDisplay()
            }
        }
    }

    @objc var strokeWidth: NSNumber = 1 {
        didSet {
            if strokeWidth != oldValue {
                label.outlineWidth = CGFloat(truncating: strokeWidth)
                label.setNeedsDisplay()
            }
        }
    }

    @objc var fontFamily: String = "Helvetica" {
        didSet {
            if fontFamily != oldValue {
                if let font = UIFont(name: fontFamily, size: CGFloat(truncating: fontSize)) {
                    label.font = font
                }
                label.setNeedsDisplay()
            }
        }
    }

    @objc var align: String = "center" {
        didSet {
            if align != oldValue {
                if align == "left" {
                    label.align = .left
                } else if align == "right" {
                    label.align = .right
                } else {
                    label.align = .center
                }

                label.setNeedsDisplay()
            }
        }
    }

    @objc var ellipsis: Bool = false {
        didSet {
            if ellipsis != oldValue {
                label.ellipsis = ellipsis
                label.setNeedsDisplay()
            }
        }
    }

    @objc var numberOfLines: NSNumber = 0 {
        didSet {
            if numberOfLines != oldValue {
                label.numberOfLines = Int(truncating: numberOfLines)
                label.setNeedsDisplay()
            }
        }
    }

    private func colorStringToUIColor(colorString: String) -> UIColor {
        var string = colorString.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        if string.hasPrefix("#") {
            if string.count == 4 {
                string = "#" + string.dropFirst().map { "\($0)\($0)" }.joined()
            }
            if string.count == 7 {
                var rgbValue: UInt64 = 0
                Scanner(string: String(string.dropFirst())).scanHexInt64(&rgbValue)
                return UIColor(
                        red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
                        green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
                        blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
                        alpha: 1.0
                )
            }
        } else if string.hasPrefix("RGBA") {
            let components = string.dropFirst(5).dropLast(1).split(separator: ",").map { CGFloat(Double($0.trimmingCharacters(in: .whitespaces)) ?? 0) }
            if components.count == 4 {
                return UIColor(red: components[0] / 255.0, green: components[1] / 255.0, blue: components[2] / 255.0, alpha: components[3])
            }
        } else if string.hasPrefix("RGB") {
            let components = string.dropFirst(4).dropLast(1).split(separator: ",").map { CGFloat(Double($0.trimmingCharacters(in: .whitespaces)) ?? 0) }
            if components.count == 3 {
                return UIColor(red: components[0] / 255.0, green: components[1] / 255.0, blue: components[2] / 255.0, alpha: 1.0)
            }
        }

        return UIColor.gray
    }
}
