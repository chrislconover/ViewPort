//
//  UIView+Layout.swift
//  Curious Applications
//
//  Created by Chris Conover on 11/6/17.
//

import UIKit


public extension UIView {

    convenience init(withSubviews views: UIView...) {
        self.init(withSubviews: views)
    }

    convenience init<T>(withSubviews views: T) where T: Collection, T.Element: UIView {
        self.init(frame: CGRect.zero)
        add(views)
    }

    func add<T: UIView>(_ views: T...,
        translatesAutoresizingMaskIntoConstraints translates: Bool = false) {
        add(views, translatesAutoresizingMaskIntoConstraints: translates)
    }

    func add<T>(_ views: T,
                translatesAutoresizingMaskIntoConstraints translates: Bool = false)
        where T: Sequence, T.Element: UIView {
        views.forEach {
            $0.translatesAutoresizingMaskIntoConstraints = translates
            addSubview($0)
        }
    }

    func add<T: UILayoutGuide>(_ views: T...,
        translatesAutoresizingMaskIntoConstraints translates: Bool = false) {
        add(views, translatesAutoresizingMaskIntoConstraints: translates)
    }

    func add<T>(_ views: T, translatesAutoresizingMaskIntoConstraints translates: Bool = false)
        where T: Sequence, T.Element: UILayoutGuide {
        views.forEach { addLayoutGuide($0) } }
}


public extension UIView {
    func priority(priority: UILayoutPriority) -> UIView {
        
        return self
    }
}
