//
//  iCoreAnimationView_SPM.swift
//  iCoreAnimations-SPM
//
//  Created by Mythrai Boga on 17/07/22.
//

import UIKit

public struct iCoreAnimation_SPM {
    public private(set) var text = "Hello, World!"

    public init() {
    }
}

struct iCoreSpace {
    static let space16: CGFloat = 16
    static let space24: CGFloat = 24
    static let space48: CGFloat = 48
    static let space44: CGFloat = 44
    static let space66: CGFloat = 66
    static let space88: CGFloat = 88
}

public enum iCoreSize {
    case small
    case medium
    case large
}

public enum LoaderStyle {
    case dot

    var size: CGSize {
        switch self {
        case .dot:
            return .init(iCoreSpace.space48 + iCoreSpace.space16)
        }
    }
}

public class iCoreAnimationView: UIView {

    public var style: LoaderStyle = .dot {
        didSet {
            applyStyle()
        }
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        applyStyle()
    }

    func applyStyle() {
        switch style {
        case .dot:
            addRoundedRect(to: self)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Layout
    public override var intrinsicContentSize: CGSize {
        style.size
    }

    // MARK: Rounded Animation
    private  func addRoundedRect(to view: UIView) {
        let dotHeight: CGFloat = 22
        let dotOffset: CGFloat = dotHeight*1.66
        let dotCount = 5
        let duration: TimeInterval = 1.0

        let viewSize = CGSize(width: (view.bounds.width - dotHeight -
                                      CGFloat(dotCount-1)*dotOffset),
                              height: dotHeight)

        let replicatorLayer = CAReplicatorLayer()
        let animation = CABasicAnimation(keyPath: #keyPath(CALayer.opacity))

        let dot = CAShapeLayer()
        dot.frame.size = CGSize(width: viewSize.height,
                                height: viewSize.height)
        dot.backgroundColor = UIColor.black.cgColor

        replicatorLayer.instanceTransform = CATransform3DMakeTranslation(dotOffset, 0, 0)
        replicatorLayer.instanceCount = dotCount
        replicatorLayer.instanceDelay = duration / TimeInterval(dotCount)

        replicatorLayer.frame = CGRect(x: (view.frame.width - viewSize.width)/2.0,
                                       y: (view.frame.height - viewSize.height)/2.0,
                                       width: viewSize.width,
                                       height: viewSize.height)

        replicatorLayer.addSublayer(dot)
        view.layer.addSublayer(replicatorLayer)

        animation.fromValue = 1.0
        animation.toValue = 0.0
        animation.repeatCount = Float.greatestFiniteMagnitude
        animation.timingFunction = CAMediaTimingFunction(name: .linear)
        animation.duration = duration

        dot.add(animation, forKey: "alphaOffset")
    }
}

extension CGSize {
    init(_ dimension: CGFloat) {
        self.init(width: dimension, height: dimension)
    }
}
