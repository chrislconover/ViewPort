//
//  NSLayoutConstraint+Modifiers.swift
//  Curious Applications
//
//  Created by Chris Conover on 11/6/17.
//  Copyright © 2017 Curious Applications. All rights reserved.
//

import UIKit

extension NSLayoutConstraint {

    @discardableResult
    func isActive(_ active: Bool) -> NSLayoutConstraint {
        self.isActive = active
        return self
    }

    @discardableResult
    func priority(_ priority: UILayoutPriority) -> NSLayoutConstraint {
        self.priority = priority
        return self
    }

    @discardableResult
    func priority(_ priority: Float) -> NSLayoutConstraint {
        self.priority = UILayoutPriority(rawValue: priority)
        return self
    }

    class func activate(_ constraints: NSLayoutConstraint...) {
        return activate(constraints)
    }
}


extension NSLayoutConstraint {
    static func constraints(_ views: [String: UIView],
                            metrics: [String: Any] = [:],
                            options: NSLayoutConstraint.FormatOptions = [], formats:String...) -> [NSLayoutConstraint] {
        return formats.flatMap {
            NSLayoutConstraint.constraints(
                withVisualFormat: $0, options: options, metrics: metrics, views: views)
        }
    }

    static func constraints(_ views: [String: UIView],
                            metrics: [String: Any] = [:],
                            options: NSLayoutConstraint.FormatOptions = [], formats: [String]) -> [NSLayoutConstraint] {
        return formats.flatMap {
            NSLayoutConstraint.constraints(
                withVisualFormat: $0, options: options, metrics: metrics, views: views)
        }
    }
}


extension UIView {
    @discardableResult func addConstraints(_ views: [String: UIView],
                     metrics: [String: Any] = [:],
                     options: NSLayoutConstraint.FormatOptions = [],
                     formats:String...) -> [NSLayoutConstraint] {
        return addConstraints(views, metrics: metrics, options: options, formats: formats)
    }

    @discardableResult func addConstraints(_ views: [String: UIView],
                            metrics: [String: Any] = [:],
                            options: NSLayoutConstraint.FormatOptions = [],
                            formats: [String]) -> [NSLayoutConstraint] {
        views.values.filter({ $0.superview == nil }).forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            addSubview($0)
        }
        let constraints = NSLayoutConstraint.constraints(
            views, metrics: metrics, options: options, formats: formats)
        addConstraints(constraints)
        return constraints
    }
}

extension UILayoutPriority {
    static func of(_ priority: Float) -> UILayoutPriority {
        return UILayoutPriority(rawValue: priority) }
}

func +(lhs:UILayoutPriority, rhs:Float) -> UILayoutPriority {
    return .of(min(lhs.rawValue + rhs, UILayoutPriority.required.rawValue))
}

func -(lhs:UILayoutPriority, rhs:Float) -> UILayoutPriority {
    return .of(max(lhs.rawValue - rhs, 0))
}


