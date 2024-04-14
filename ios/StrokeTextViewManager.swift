import Foundation
import UIKit

@objc(StrokeTextViewManager)
class StrokeTextViewManager: RCTViewManager {

    override func view() -> UIView! {
        let newView = StrokeTextView(bridge: self.bridge)
        return newView
    }

    @objc override static func requiresMainQueueSetup() -> Bool {
        return false
    }
}
