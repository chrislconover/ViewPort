//
//  LayoutBuilder.swift
//  Curious Applications
//
//  Created by Chris Conover on 10/2/18.
//

import UIKit


// Motivation:
// implement a light, convenient, chainable layout builder for batching layouts.
//
// It has been my experience that StackView can be endothermic, by the time you have to find
// and set all the settings and compression resistance priorities to get it to render, and it
// it can be hard to have it size to the contents, instead of assuming an outside size.
//
// The following is incomplete but can be extened as needed.
//  - instead of acting on an array of views, instead act on an array of layout-able things,
//    allowing for dimensions and spacing


public protocol LayoutAnchorable {
    var leadingAnchor: NSLayoutXAxisAnchor { get }
    var trailingAnchor: NSLayoutXAxisAnchor { get }
    
    var leftAnchor: NSLayoutXAxisAnchor { get }
    var rightAnchor: NSLayoutXAxisAnchor { get }
    
    var topAnchor: NSLayoutYAxisAnchor { get }
    var bottomAnchor: NSLayoutYAxisAnchor { get }
    
    var widthAnchor: NSLayoutDimension { get }
    var heightAnchor: NSLayoutDimension { get }
    
    var centerXAnchor: NSLayoutXAxisAnchor { get }
    var centerYAnchor: NSLayoutYAxisAnchor { get }
    
    var safeAreaLayoutGuide: UILayoutGuide { get }
    
    func removeFromSuperview()
    func addTo(parent: LayoutAnchorable, translatesAutoresizingMaskIntoConstraints: Bool)
    var layoutContext: UIView? { get }
    var deferredChildren: [LayoutAnchorable]? { get }
}

public protocol LayoutBuilderType {
    var toLayout: LayoutAnchorable { get }
}

extension UILayoutGuide: LayoutBuilderType {
    public var toLayout: LayoutAnchorable { self }
}

extension LayoutAnchorable {
    func addTo(parent: LayoutAnchorable) {
        addTo(parent: parent, translatesAutoresizingMaskIntoConstraints: false)
    }
}

extension UILayoutGuide: LayoutAnchorable {
    public var safeAreaLayoutGuide: UILayoutGuide { self }
    
    public func addTo(parent: LayoutAnchorable, translatesAutoresizingMaskIntoConstraints: Bool) {
        guard let parentContext = parent.layoutContext
        else { return assert(false, "containing view is not defined!") }
        guard layoutContext == nil || layoutContext == parentContext
        else { return assert(false, "already assigned to another view!") }
        
        parentContext.addLayoutGuide(self)
    }
    
    public func removeFromSuperview() {
        layoutContext?.removeLayoutGuide(self)
    }
    
    public var layoutContext: UIView? { owningView }
    public var deferredChildren: [LayoutAnchorable]? { nil }
}

extension UIView: LayoutAnchorable {
    public func addTo(parent: LayoutAnchorable,
                      translatesAutoresizingMaskIntoConstraints translates: Bool) {
        guard let parentContext = parent.layoutContext
        else { return assert(false, "containing view is not defined!") }
        guard superview == nil || superview == parent.layoutContext
        else { return assert(false, "already assigned to another view!") }
        
        parentContext.add(self, translatesAutoresizingMaskIntoConstraints: translates)
    }
    
    public var toLayout: LayoutAnchorable { self }
    public var layoutContext: UIView? { self }
    public var deferredChildren: [LayoutAnchorable]? { nil }
}


public protocol ViewBuilderType: LayoutBuilderType {
    var toView: UIView { get }
}

extension ViewBuilderType {
    public var toLayout: LayoutAnchorable { toView }
}

extension UIView: ViewBuilderType {
    public var toView: UIView { self }
}

public protocol IntrinsicLayout {
    @discardableResult func aspect(_ widthToHeight: CGFloat, priority: UILayoutPriority) -> Self
    
    @discardableResult func width(_ of: CGFloat, priority: UILayoutPriority) -> Self
    @discardableResult func width(equalTo: NSLayoutDimension,
                                  multiplier: CGFloat,
                                  constant: CGFloat,
                                  priority: UILayoutPriority) -> Self
    
    @discardableResult func width(lessThanOrEqualTo: CGFloat,
                                  priority: UILayoutPriority) -> Self
    @discardableResult func width(lessThanOrEqualTo: NSLayoutDimension,
                                  multiplier: CGFloat,
                                  constant: CGFloat,
                                  priority: UILayoutPriority) -> Self
    
    @discardableResult func width(greaterThanOrEqualTo: CGFloat,
                                  priority: UILayoutPriority) -> Self
    @discardableResult func width(greaterThanOrEqualTo: NSLayoutDimension,
                                  multiplier: CGFloat,
                                  constant: CGFloat,
                                  priority: UILayoutPriority) -> Self
    
    @discardableResult func height(_ of: CGFloat, priority: UILayoutPriority) -> Self
    @discardableResult func height(equalTo: NSLayoutDimension,
                                   multiplier: CGFloat,
                                   constant: CGFloat,
                                   priority: UILayoutPriority) -> Self
    
    @discardableResult func height(lessThanOrEqualTo: CGFloat,
                                   priority: UILayoutPriority) -> Self
    @discardableResult func height(lessThanOrEqualTo: NSLayoutDimension,
                                   multiplier: CGFloat,
                                   constant: CGFloat,
                                   priority: UILayoutPriority) -> Self
    
    @discardableResult func height(greaterThanOrEqualTo: CGFloat,
                                   priority: UILayoutPriority) -> Self
    @discardableResult func height(greaterThanOrEqualTo: NSLayoutDimension,
                                   multiplier: CGFloat,
                                   constant: CGFloat,
                                   priority: UILayoutPriority) -> Self
}

extension IntrinsicLayout {
    
    @discardableResult public func aspect(_ widthToHeight: CGFloat,
                                   priority: UILayoutPriority = .required) -> Self {
        aspect(widthToHeight, priority: priority)
    }
    
    @discardableResult public func width(_ of: CGFloat, priority: UILayoutPriority = .required) -> Self {
        width(of, priority: priority)
    }
    
    @discardableResult public func width(equalTo dimensions: NSLayoutDimension,
                                  multiplier: CGFloat = 1,
                                  constant: CGFloat = 0,
                                  priority: UILayoutPriority = .required) -> Self {
        width(equalTo: dimensions, multiplier: multiplier, constant: constant, priority: priority)
    }
    
    @discardableResult public func width(lessThanOrEqualTo: CGFloat,
                                  priority: UILayoutPriority = .required) -> Self {
        width(lessThanOrEqualTo: lessThanOrEqualTo, priority: priority)
    }
    
    @discardableResult public func width(lessThanOrEqualTo dimension: NSLayoutDimension,
                                  multiplier: CGFloat = 1,
                                  constant: CGFloat = 0,
                                  priority: UILayoutPriority = .required) -> Self {
        width(lessThanOrEqualTo: dimension, multiplier: multiplier, constant: constant, priority: priority)
    }
    
    
    @discardableResult public func width(greaterThanOrEqualTo: CGFloat,
                                  priority: UILayoutPriority = .required) -> Self {
        width(greaterThanOrEqualTo: greaterThanOrEqualTo, priority: priority)
    }
    
    @discardableResult public func width(greaterThanOrEqualTo dimension: NSLayoutDimension,
                                  multiplier: CGFloat = 1,
                                  constant: CGFloat = 0,
                                  priority: UILayoutPriority = .required) -> Self {
        width(greaterThanOrEqualTo: dimension, multiplier: multiplier, constant: constant, priority: priority)
    }
    
    
    
    @discardableResult public func height(_ of: CGFloat, priority: UILayoutPriority = .required) -> Self {
        height(of, priority: priority)
    }
    
    @discardableResult public func height(equalTo dimension: NSLayoutDimension,
                                   multiplier: CGFloat = 1,
                                   constant: CGFloat = 0,
                                   priority: UILayoutPriority = .required) -> Self {
        height(equalTo: dimension, multiplier: multiplier, constant: constant, priority: priority)
    }
    
    
    @discardableResult public func height(lessThanOrEqualTo: CGFloat,
                                   priority: UILayoutPriority = .required) -> Self {
        height(lessThanOrEqualTo: lessThanOrEqualTo, priority: priority)
    }
    
    @discardableResult public func height(lessThanOrEqualTo dimension: NSLayoutDimension,
                                   multiplier: CGFloat = 1,
                                   constant: CGFloat = 0,
                                   priority: UILayoutPriority = .required) -> Self {
        height(lessThanOrEqualTo: dimension, multiplier: multiplier, constant: constant, priority: priority)
    }
    
    @discardableResult public func height(greaterThanOrEqualTo: CGFloat,
                                   priority: UILayoutPriority = .required) -> Self {
        height(greaterThanOrEqualTo: greaterThanOrEqualTo, priority: priority)
    }
    
    @discardableResult public func height(greaterThanOrEqualTo dimension: NSLayoutDimension,
                                   multiplier: CGFloat = 1,
                                   constant: CGFloat = 0,
                                   priority: UILayoutPriority = .required) -> Self {
        height(greaterThanOrEqualTo: dimension, multiplier: multiplier, constant: constant, priority: priority)
    }
}

public protocol IntrinsicLayoutViewSource {
    var layout: LayoutAnchorable { get }
}

public protocol MultiViewLayoutSource {
    var views: [LayoutAnchorable] { get }
    var spacingViews: ArraySlice<LayoutAnchorable> { get }
}

extension IntrinsicLayout where Self: IntrinsicLayoutViewSource {
    @discardableResult
    public func aspect(_ ratio: CGFloat, priority: UILayoutPriority) -> Self {
        layout.widthAnchor.constraint(equalTo: layout.heightAnchor, multiplier: ratio)
            .priority(priority).isActive = true
        return self
    }
    
    @discardableResult
    public func width(_ of: CGFloat, priority: UILayoutPriority) -> Self {
        layout.widthAnchor.constraint(equalToConstant: of)
            .priority(priority).isActive = true
        return self
    }
    
    @discardableResult public func width(equalTo dimensions: NSLayoutDimension...,
                                  multiplier: CGFloat = 1,
                                  constant: CGFloat = 0,
                                  priority: UILayoutPriority = .required) -> Self {
        width(equalTo: dimensions, multiplier: multiplier, constant: constant, priority: priority)
    }
    
    @discardableResult public func width(equalTo dimensions: [NSLayoutDimension],
                                  multiplier: CGFloat = 1,
                                  constant: CGFloat = 0,
                                  priority: UILayoutPriority = .required) -> Self {
        dimensions.forEach { dimension in
            layout.widthAnchor.constraint(equalTo: dimension,
                                          multiplier: multiplier,
                                          constant: constant)
                .priority(priority).isActive = true
        }
        return self
    }
    
    @discardableResult
    public func width(lessThanOrEqualTo: CGFloat, priority: UILayoutPriority = .required) -> Self {
        layout.widthAnchor.constraint(lessThanOrEqualToConstant: lessThanOrEqualTo)
            .priority(priority).isActive = true
        return self
    }
    
    @discardableResult
    public func width(lessThanOrEqualTo dimension: NSLayoutDimension,
               multiplier: CGFloat,
               constant: CGFloat,
               priority: UILayoutPriority) -> Self {
        layout.widthAnchor.constraint(lessThanOrEqualTo: dimension,
                                      multiplier: multiplier,
                                      constant: constant)
            .priority(priority).isActive = true
        return self
    }
    
    
    @discardableResult
    public func width(greaterThanOrEqualTo: CGFloat,
               priority: UILayoutPriority = .required) -> Self {
        layout.widthAnchor.constraint(greaterThanOrEqualToConstant: greaterThanOrEqualTo)
            .priority(priority).isActive = true
        return self
    }
    
    @discardableResult
    public func width(greaterThanOrEqualTo: NSLayoutDimension,
               multiplier: CGFloat,
               constant: CGFloat,
               priority: UILayoutPriority) -> Self {
        layout.widthAnchor.constraint(greaterThanOrEqualTo: greaterThanOrEqualTo,
                                      multiplier: multiplier,
                                      constant: constant)
            .priority(priority).isActive = true
        return self
    }
    
    
    @discardableResult public func height(_ of: CGFloat,
                                   priority: UILayoutPriority = .required) -> Self {
        layout.heightAnchor.constraint(equalToConstant: of)
            .priority(priority).isActive = true
        return self
    }
    
    @discardableResult public func height(equalTo dimension: NSLayoutDimension,
                                   multiplier: CGFloat,
                                   constant: CGFloat,
                                   priority: UILayoutPriority) -> Self {
        layout.heightAnchor.constraint(equalTo: dimension,
                                       multiplier: multiplier,
                                       constant: constant)
            .priority(priority).isActive = true
        return self
    }
    
    
    @discardableResult public func height(lessThanOrEqualTo value: CGFloat,
                                   priority: UILayoutPriority = .required) -> Self {
        layout.heightAnchor.constraint(lessThanOrEqualToConstant: value)
            .priority(priority).isActive = true
        return self
    }
    
    @discardableResult
    public func height(lessThanOrEqualTo dimension: NSLayoutDimension,
                multiplier: CGFloat,
                constant: CGFloat,
                priority: UILayoutPriority) -> Self {
        layout.heightAnchor.constraint(
            lessThanOrEqualTo: dimension,
            multiplier: multiplier,
            constant: constant)
            .priority(priority).isActive = true
        return self
    }
    
    
    @discardableResult
    public func height(greaterThanOrEqualTo value: CGFloat, priority: UILayoutPriority) -> Self {
        layout.heightAnchor.constraint(greaterThanOrEqualToConstant: value)
            .priority(priority).isActive = true
        return self
    }
    
    @discardableResult
    public func height(greaterThanOrEqualTo dimension: NSLayoutDimension,
                multiplier: CGFloat,
                constant: CGFloat,
                priority: UILayoutPriority) -> Self {
        layout.heightAnchor.constraint(
            greaterThanOrEqualTo: dimension,
            multiplier: multiplier,
            constant: constant)
            .priority(priority).isActive = true
        return self
    }
}

extension IntrinsicLayout where Self: MultiViewLayoutSource {
    
    @discardableResult
    public func aspect(_ ratio: CGFloat, priority: UILayoutPriority) -> Self {
        spacingViews.forEach { view in view.l.aspect(ratio, priority: priority) }
        return self
    }
    
    @discardableResult
    public func width(_ of: CGFloat, priority: UILayoutPriority) -> Self {
        spacingViews.forEach { view in view.l.width(of, priority: priority) }
        return self
    }
    
    public func width(equalTo dimension: NSLayoutDimension,
               multiplier: CGFloat,
               constant: CGFloat,
               priority: UILayoutPriority) -> Self {
        spacingViews.forEach { view in
            view.l.width(equalTo: dimension,
                         multiplier: multiplier,
                         constant: constant,
                         priority: priority)
        }
        return self
    }
    
    @discardableResult
    public func width(lessThanOrEqualTo: CGFloat, priority: UILayoutPriority) -> Self {
        spacingViews.forEach { view in
            view.l.width(lessThanOrEqualTo: lessThanOrEqualTo, priority: priority)
        }
        return self
    }
    
    @discardableResult
    public func width(lessThanOrEqualTo dimension: NSLayoutDimension,
               multiplier: CGFloat,
               constant: CGFloat,
               priority: UILayoutPriority) -> Self {
        spacingViews.forEach { view in
            view.l.width(lessThanOrEqualTo: dimension,
                         multiplier: multiplier,
                         constant: constant,
                         priority: priority)
        }
        return self
    }
    
    @discardableResult
    public func width(greaterThanOrEqualTo: CGFloat, priority: UILayoutPriority) -> Self {
        spacingViews.forEach { view in
            view.l.width(greaterThanOrEqualTo: greaterThanOrEqualTo, priority: priority)
        }
        return self
    }
    
    @discardableResult
    public func width(greaterThanOrEqualTo: NSLayoutDimension,
               multiplier: CGFloat,
               constant: CGFloat,
               priority: UILayoutPriority) -> Self {
        spacingViews.forEach { view in
            view.l.width(greaterThanOrEqualTo: greaterThanOrEqualTo,
                         multiplier: multiplier,
                         constant: constant,
                         priority: priority)
        }
        return self
    }
    
    @discardableResult
    public func height(_ of: CGFloat, priority: UILayoutPriority) -> Self {
        spacingViews.forEach { view in view.l.height(of, priority: priority) }
        return self
    }
    
    @discardableResult
    public func height(equalTo dimension: NSLayoutDimension,
                multiplier: CGFloat,
                constant: CGFloat,
                priority: UILayoutPriority) -> Self {
        spacingViews.forEach { view in
            view.l.height(
                equalTo: dimension,
                multiplier: multiplier,
                constant: constant,
                priority: priority)
        }
        
        return self
    }
    
    @discardableResult
    public func height(lessThanOrEqualTo value: CGFloat, priority: UILayoutPriority) -> Self {
        spacingViews.forEach { view in
            view.l.height(lessThanOrEqualTo: value, priority: priority)
        }
        return self
    }
    
    @discardableResult
    public func height(lessThanOrEqualTo dimension: NSLayoutDimension,
                multiplier: CGFloat,
                constant: CGFloat,
                priority: UILayoutPriority) -> Self {
        spacingViews.forEach { view in
            view.l.height(lessThanOrEqualTo: dimension,
                          multiplier: multiplier,
                          constant: constant,
                          priority: priority)
        }
        return self
    }
    
    @discardableResult
    public func height(greaterThanOrEqualTo value: CGFloat, priority: UILayoutPriority) -> Self {
        spacingViews.forEach { view in
            view.l.height(greaterThanOrEqualTo: value, priority: priority)
        }
        return self
    }
    
    @discardableResult
    public func height(greaterThanOrEqualTo dimension: NSLayoutDimension,
                multiplier: CGFloat,
                constant: CGFloat,
                priority: UILayoutPriority) -> Self {
        spacingViews.forEach { view in
            view.l.height(greaterThanOrEqualTo: dimension,
                          multiplier: multiplier,
                          constant: constant,
                          priority: priority)
        }
        return self
    }
}


public protocol InterViewLayout: IntrinsicLayout {
    
    @discardableResult func equal(_ attributes: [NSLayoutConstraint.Attribute],
                                  priority: UILayoutPriority) -> Self
    
    @discardableResult func centerX(multiplier: CGFloat, offset: CGFloat, priority: UILayoutPriority) -> Self
    @discardableResult func centerY(multiplier: CGFloat, offset: CGFloat, priority: UILayoutPriority) -> Self
    
    @discardableResult func top(_ offset: CGFloat, priority: UILayoutPriority) -> Self
    @discardableResult func top(lessThanOrEqualTo: CGFloat, priority: UILayoutPriority) -> Self
    @discardableResult func top(greaterThanOrEqualTo: CGFloat, priority: UILayoutPriority) -> Self
    
    @discardableResult func bottom(_ offset: CGFloat, priority: UILayoutPriority) -> Self
    @discardableResult func bottom(lessThanOrEqualTo: CGFloat, priority: UILayoutPriority) -> Self
    @discardableResult func bottom(greaterThanOrEqualTo: CGFloat, priority: UILayoutPriority) -> Self
    
    @discardableResult func leading(_ offset: CGFloat, priority: UILayoutPriority) -> Self
    @discardableResult func leading(lessThanOrEqualTo: CGFloat, priority: UILayoutPriority) -> Self
    @discardableResult func leading(greaterThanOrEqualTo: CGFloat, priority: UILayoutPriority) -> Self
    
    @discardableResult func trailing(_ offset: CGFloat, priority: UILayoutPriority) -> Self
    @discardableResult func trailing(lessThanOrEqualTo: CGFloat, priority: UILayoutPriority) -> Self
    @discardableResult func trailing(greaterThanOrEqualTo: CGFloat, priority: UILayoutPriority) -> Self
    
    @discardableResult func horizontal(_ separation: CGFloat, priority: UILayoutPriority) -> Self
    @discardableResult func horizontal(greaterThanOrEqualTo constant: CGFloat,
                                       priority: UILayoutPriority) -> Self
    @discardableResult func horizontal(lessThanOrEqualTo constant: CGFloat,
                                       priority: UILayoutPriority) -> Self
    @discardableResult func vertical(_ separation: CGFloat, priority: UILayoutPriority) -> Self
    @discardableResult func vertical(greaterThanOrEqualTo constant: CGFloat, priority: UILayoutPriority) -> Self
    @discardableResult func vertical(lessThanOrEqualTo constant: CGFloat, priority: UILayoutPriority) -> Self
}

extension InterViewLayout {
    
    @discardableResult public func equal(_ attributes: NSLayoutConstraint.Attribute...,
                                  priority: UILayoutPriority = .required) -> Self {
        equal(attributes, priority: priority)
    }
    
    @discardableResult public func equal(_ attributes: [NSLayoutConstraint.Attribute]) -> Self {
        equal(attributes, priority: .required)
    }
    
    @discardableResult public func center(priority: UILayoutPriority = .required) -> Self {
        centerX(priority: priority).centerY(priority: priority)
    }
    
    @discardableResult public func centerX(multiplier: CGFloat = 1, offset: CGFloat = 0,
                                    priority: UILayoutPriority = .required) -> Self {
        centerX(multiplier: multiplier, offset: offset, priority: priority)
    }
    
    @discardableResult public func centerY(multiplier: CGFloat = 1, offset: CGFloat = 0,
                                    priority: UILayoutPriority = .required) -> Self {
        centerY(multiplier: multiplier, offset: offset, priority: priority)
    }
    
    
    @discardableResult public func leading(_ offset: CGFloat = 0,
                                    priority: UILayoutPriority = .required) -> Self {
        leading(offset, priority: priority)
    }
    
    @discardableResult public func leading(lessThanOrEqualTo: CGFloat,
                                    priority: UILayoutPriority = .required) -> Self {
        leading(lessThanOrEqualTo: lessThanOrEqualTo, priority: priority)
    }
    
    @discardableResult public func leading(greaterThanOrEqualTo: CGFloat,
                                    priority: UILayoutPriority = .required) -> Self {
        leading(greaterThanOrEqualTo: greaterThanOrEqualTo, priority: priority)
    }
    
    
    @discardableResult public func trailing(_ offset: CGFloat = 0,
                                     priority: UILayoutPriority = .required) -> Self {
        trailing(offset, priority: priority)
    }
    
    @discardableResult public func trailing(lessThanOrEqualTo: CGFloat,
                                     priority: UILayoutPriority = .required) -> Self {
        trailing(lessThanOrEqualTo: lessThanOrEqualTo, priority: priority)
    }
    
    @discardableResult public func trailing(greaterThanOrEqualTo: CGFloat,
                                     priority: UILayoutPriority = .required) -> Self {
        trailing(greaterThanOrEqualTo: greaterThanOrEqualTo, priority: priority)
    }
    
    
    @discardableResult public func top(_ offset: CGFloat = 0,
                                priority: UILayoutPriority = .required) -> Self {
        top(offset, priority: priority)
    }
    
    @discardableResult public func top(lessThanOrEqualTo: CGFloat,
                                priority: UILayoutPriority = .required) -> Self {
        top(lessThanOrEqualTo: lessThanOrEqualTo, priority: priority)
    }
    
    @discardableResult public func top(greaterThanOrEqualTo: CGFloat,
                                priority: UILayoutPriority = .required) -> Self {
        top(greaterThanOrEqualTo: greaterThanOrEqualTo, priority: priority)
    }
    
    
    @discardableResult public func bottom(_ offset: CGFloat = 0,
                                   priority: UILayoutPriority = .required) -> Self {
        bottom(offset, priority: priority)
    }
    
    @discardableResult public func bottom(lessThanOrEqualTo: CGFloat,
                                   priority: UILayoutPriority = .required) -> Self {
        bottom(lessThanOrEqualTo: lessThanOrEqualTo, priority: priority)
    }
    
    @discardableResult public func bottom(greaterThanOrEqualTo: CGFloat,
                                   priority: UILayoutPriority = .required) -> Self {
        bottom(greaterThanOrEqualTo: greaterThanOrEqualTo, priority: priority)
    }
    
    
    @discardableResult public func horizontal(_ separation: CGFloat = 0,
                                       priority: UILayoutPriority = .required) -> Self {
        horizontal(separation, priority: priority)
    }
    
    @discardableResult public func horizontal(lessThanOrEqualTo constant: CGFloat,
                                       priority: UILayoutPriority = .required) -> Self {
        horizontal(lessThanOrEqualTo: constant, priority: priority)
    }
    
    @discardableResult public func horizontal(greaterThanOrEqualTo: CGFloat,
                                       priority: UILayoutPriority = .required) -> Self {
        horizontal(greaterThanOrEqualTo: greaterThanOrEqualTo, priority: priority)
    }
    
    
    @discardableResult public func vertical(_ separation: CGFloat = 0,
                                     priority: UILayoutPriority = .required) -> Self {
        vertical(separation, priority: priority)
    }
    
    @discardableResult public func vertical(lessThanOrEqualTo constant: CGFloat,
                                     priority: UILayoutPriority) -> Self {
        vertical(lessThanOrEqualTo: constant, priority: priority)
    }
    
    @discardableResult public func vertical(greaterThanOrEqualTo constant: CGFloat,
                                     priority: UILayoutPriority = .required) -> Self {
        vertical(greaterThanOrEqualTo: constant, priority: priority)
    }
}


extension InterViewLayout where Self: MultiViewLayoutSource {
    
    @discardableResult
    public func equal(_ attributes: [NSLayoutConstraint.Attribute],
                                  priority: UILayoutPriority) -> Self {
        guard let first = views.first else { return self }
        views.dropFirst().forEach { view in
            for attribute in attributes {
                NSLayoutConstraint(item: view, attribute: attribute, relatedBy: .equal,
                                   toItem: first, attribute: attribute,
                                   multiplier: 1, constant: 0)
                    .priority(priority).isActive = true
            }
        }
        
        return self
    }
    
    @discardableResult
    public func centerX(_ offset: CGFloat, priority: UILayoutPriority) -> Self {
        guard let first = views.first else { return self }
        views.dropFirst().forEach { view in
            view.centerXAnchor.constraint(
                equalTo: first.centerXAnchor, constant: offset)
                .priority(priority).isActive = true
        }
        return self
    }
    
    @discardableResult
    public func centerX(multiplier: CGFloat, offset: CGFloat, priority: UILayoutPriority) -> Self {
        guard let first = views.first else { return self }
        views.dropFirst().forEach { view in
            NSLayoutConstraint(item: view, attribute: .centerX, relatedBy: .equal,
                               toItem: first, attribute: .centerX, multiplier: multiplier,
                               constant: offset).priority(priority).isActive = true
        }
        
        return self
    }
    
    @discardableResult
    public func centerY(_ offset: CGFloat, priority: UILayoutPriority) -> Self  {
        guard let first = views.first else { return self }
        views.dropFirst().forEach { view in
            view.centerYAnchor.constraint(
                equalTo: first.centerYAnchor, constant: offset)
                .priority(priority).isActive = true
        }
        return self
    }
    
    @discardableResult
    public func centerY(multiplier: CGFloat, offset: CGFloat, priority: UILayoutPriority) -> Self {
        
        guard let first = views.first else { return self }
        views.dropFirst().forEach { view in
            NSLayoutConstraint(item: view, attribute: .centerY, relatedBy: .equal,
                               toItem: first, attribute: .centerY, multiplier: multiplier,
                               constant: offset).priority(priority).isActive = true
        }
        
        return self
    }
    
    @discardableResult
    public func leading(_ offset: CGFloat, priority: UILayoutPriority) -> Self {
        guard let first = views.first else { return self }
        views.dropFirst().forEach { view in
            view.leadingAnchor.constraint(equalTo: first.leadingAnchor, constant: offset)
                .priority(priority).isActive = true
        }
        return self
    }
    
    @discardableResult
    public func leading(lessThanOrEqualTo offset: CGFloat, priority: UILayoutPriority) -> Self {
        guard let first = views.first else { return self }
        views.dropFirst().forEach { view in
            view.leadingAnchor.constraint(lessThanOrEqualTo: first.leadingAnchor, constant: offset)
                .priority(priority).isActive = true
        }
        return self
    }
    
    @discardableResult
    public func leading(greaterThanOrEqualTo offset: CGFloat, priority: UILayoutPriority) -> Self {
        guard let first = views.first else { return self }
        views.dropFirst().forEach { view in
            view.leadingAnchor.constraint(greaterThanOrEqualTo: first.leadingAnchor, constant: offset)
                .priority(priority).isActive = true
        }
        return self
    }
    
    @discardableResult
    public func trailing(_ offset: CGFloat, priority: UILayoutPriority) -> Self {
        guard let first = views.first else { return self }
        views.dropFirst().forEach { view in
            first.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: offset)
                .priority(priority).isActive = true
        }
        return self
    }
    
    @discardableResult
    public func trailing(lessThanOrEqualTo offset: CGFloat, priority: UILayoutPriority) -> Self {
        guard let first = views.first else { return self }
        views.dropFirst().forEach { view in
            first.trailingAnchor.constraint(
                lessThanOrEqualTo: view.trailingAnchor, constant: offset)
                .priority(priority).isActive = true
        }
        return self
    }
    
    @discardableResult
    public func trailing(greaterThanOrEqualTo offset: CGFloat, priority: UILayoutPriority) -> Self {
        guard let first = views.first else { return self }
        views.dropFirst().forEach { view in
            first.trailingAnchor.constraint(
                greaterThanOrEqualTo: view.trailingAnchor, constant: offset)
                .priority(priority).isActive = true
        }
        return self
    }
    
    @discardableResult
    public func horizontal(_ separation: CGFloat, priority: UILayoutPriority) -> Self {
        spacingViews.withPrevious.forEach { previous, current in
            current.leadingAnchor.constraint(
                equalTo: previous.trailingAnchor, constant: separation)
                .priority(priority).isActive = true
        }
        return self
    }
    
    @discardableResult
    public func horizontal(greaterThanOrEqualTo constant: CGFloat, priority: UILayoutPriority) -> Self {
        spacingViews.withPrevious.forEach { previous, current in
            current.leadingAnchor.constraint(
                greaterThanOrEqualTo: previous.trailingAnchor, constant: constant)
                .priority(priority).isActive = true
        }
        return self
    }
    
    @discardableResult
    public func horizontal(lessThanOrEqualTo constant: CGFloat, priority: UILayoutPriority) -> Self {
        spacingViews.withPrevious.forEach { previous, current in
            current.leadingAnchor.constraint(
                lessThanOrEqualTo: previous.trailingAnchor, constant: constant)
                .priority(priority).isActive = true
        }
        return self
    }
    
    @discardableResult
    public func vertical(_ separation: CGFloat, priority: UILayoutPriority) -> Self {
        spacingViews.withPrevious.forEach { previous, current in
            current.topAnchor.constraint(equalTo: previous.bottomAnchor,
                                         constant: separation)
                .priority(priority).isActive = true
        }
        return self
    }
    
    @discardableResult
    public func vertical(greaterThanOrEqualTo constant: CGFloat, priority: UILayoutPriority) -> Self {
        spacingViews.withPrevious.forEach { previous, current in
            current.topAnchor.constraint(greaterThanOrEqualTo: previous.bottomAnchor,
                                         constant: constant)
                .priority(priority).isActive = true
        }
        return self
    }
    
    @discardableResult
    public func vertical(lessThanOrEqualTo constant: CGFloat, priority: UILayoutPriority) -> Self {
        spacingViews.withPrevious.forEach { previous, current in
            current.topAnchor.constraint(lessThanOrEqualTo: previous.bottomAnchor,
                                         constant: constant)
                .priority(priority).isActive = true
        }
        return self
    }
    
    @discardableResult
    public func top(_ offset: CGFloat, priority: UILayoutPriority) -> Self {
        guard let first = views.first else { return self }
        views.dropFirst().forEach { view in
            view.topAnchor.constraint(equalTo: first.topAnchor,
                                      constant: offset)
                .priority(priority).isActive = true
        }
        return self
    }
    
    @discardableResult
    public func top(lessThanOrEqualTo offset: CGFloat, priority: UILayoutPriority) -> Self {
        guard let first = views.first else { return self }
        views.dropFirst().forEach { view in
            view.topAnchor.constraint(lessThanOrEqualTo: first.topAnchor,
                                      constant: offset)
                .priority(priority).isActive = true
        }
        return self
    }
    
    @discardableResult
    public func top(greaterThanOrEqualTo offset: CGFloat, priority: UILayoutPriority) -> Self {
        guard let first = views.first else { return self }
        views.dropFirst().forEach { view in
            view.topAnchor.constraint(greaterThanOrEqualTo: first.topAnchor,
                                      constant: offset)
                .priority(priority).isActive = true
        }
        return self
    }
    
    @discardableResult
    public func bottom(_ offset: CGFloat, priority: UILayoutPriority) -> Self {
        guard let first = views.first else { return self }
        views.dropFirst().forEach { view in
            view.bottomAnchor.constraint(equalTo: first.bottomAnchor,
                                         constant: offset)
                .priority(priority).isActive = true
        }
        return self
    }
    
    @discardableResult
    public func bottom(lessThanOrEqualTo offset: CGFloat, priority: UILayoutPriority) -> Self {
        guard let first = views.first else { return self }
        views.dropFirst().forEach { view in
            view.bottomAnchor.constraint(lessThanOrEqualTo: first.bottomAnchor,
                                         constant: offset)
                .priority(priority).isActive = true
        }
        return self
    }
    
    @discardableResult
    public func bottom(greaterThanOrEqualTo offset: CGFloat, priority: UILayoutPriority) -> Self {
        guard let first = views.first else { return self }
        views.dropFirst().forEach { view in
            view.bottomAnchor.constraint(greaterThanOrEqualTo: first.bottomAnchor,
                                         constant: offset).priority(priority).isActive = true
        }
        return self
    }
}



public protocol ParentChildLayout: InterViewLayout {
    
    @discardableResult func safeTop(_ inset: CGFloat, priority: UILayoutPriority) -> Self
    @discardableResult func safeTop(greaterThanOrEqualTo: CGFloat, priority: UILayoutPriority) -> Self
    
    @discardableResult func safeBottom(_ inset: CGFloat, priority: UILayoutPriority) -> Self
    @discardableResult func safeBottom(greaterThanOrEqualTo: CGFloat, priority: UILayoutPriority) -> Self
    
    @discardableResult func safeLeading(_ inset: CGFloat, priority: UILayoutPriority) -> Self
    @discardableResult func safeLeading(greaterThanOrEqualTo: CGFloat, priority: UILayoutPriority) -> Self
    
    @discardableResult func safeTrailing(_ inset: CGFloat, priority: UILayoutPriority) -> Self
    @discardableResult func safeTrailing(greaterThanOrEqualTo: CGFloat, priority: UILayoutPriority) -> Self
    
    @discardableResult func padding(_ insets: CGFloat, priority: UILayoutPriority) -> Self
    @discardableResult func padding(_ insets: UIEdgeInsets, priority: UILayoutPriority) -> Self
    @discardableResult func padding(greaterThanOrEqualTo insets: CGFloat, priority: UILayoutPriority) -> Self
    
    @discardableResult func safePadding(_ insets: CGFloat, priority: UILayoutPriority) -> Self
    @discardableResult func safePadding(_ insets: UIEdgeInsets, priority: UILayoutPriority) -> Self
    @discardableResult func safePadding(greaterThanOrEqualTo insets: CGFloat, priority: UILayoutPriority) -> Self
    
    @discardableResult func row(insets: UIEdgeInsets, spacing: CGFloat, priority: UILayoutPriority) -> Self
    @discardableResult func rowCentered(insets: UIEdgeInsets, spacing: CGFloat, priority: UILayoutPriority) -> Self
    
    @discardableResult func column(insets: UIEdgeInsets, spacing: CGFloat, priority: UILayoutPriority) -> Self
    @discardableResult func columnCentered(insets: UIEdgeInsets, spacing: CGFloat, priority: UILayoutPriority) -> Self
}


extension ParentChildLayout {
    
    @discardableResult public func padding(_ insets: CGFloat = 0, priority: UILayoutPriority = .required) -> Self {
        leading(insets, priority: priority)
            .top(insets, priority: priority)
            .trailing(insets, priority: priority)
            .bottom(insets, priority: priority)
    }
    
    @discardableResult public func padding(_ insets: UIEdgeInsets, priority: UILayoutPriority = .required) -> Self {
        leading(insets.left, priority: priority)
            .top(insets.top, priority: priority)
            .trailing(insets.right, priority: priority)
            .bottom(insets.bottom, priority: priority)
    }
    
    @discardableResult public func padding(greaterThanOrEqualTo: CGFloat,
                                    priority: UILayoutPriority = .required) -> Self {
        leading(greaterThanOrEqualTo: greaterThanOrEqualTo, priority: priority)
            .top(greaterThanOrEqualTo: greaterThanOrEqualTo, priority: priority)
            .trailing(greaterThanOrEqualTo: greaterThanOrEqualTo, priority: priority)
            .bottom(greaterThanOrEqualTo: greaterThanOrEqualTo, priority: priority)
    }
    
    @discardableResult public func safePadding(_ insets: CGFloat = 0,
                                        priority: UILayoutPriority = .required) -> Self {
        safeLeading(insets, priority: priority)
            .safeTop(insets, priority: priority)
            .safeTrailing(insets, priority: priority)
            .safeBottom(insets, priority: priority)
    }
    
    
    @discardableResult public func safePadding(_ insets: UIEdgeInsets,
                                        priority: UILayoutPriority = .required) -> Self {
        safeLeading(insets.left, priority: priority)
            .safeTop(insets.top, priority: priority)
            .safeTrailing(insets.right, priority: priority)
            .safeBottom(insets.bottom, priority: priority)
    }
    
    @discardableResult public func safePadding(greaterThanOrEqualTo: CGFloat,
                                        priority: UILayoutPriority = .required) -> Self {
        safeLeading(greaterThanOrEqualTo: greaterThanOrEqualTo, priority: priority)
            .safeTop(greaterThanOrEqualTo: greaterThanOrEqualTo, priority: priority)
            .safeTrailing(greaterThanOrEqualTo: greaterThanOrEqualTo, priority: priority)
            .safeBottom(greaterThanOrEqualTo: greaterThanOrEqualTo, priority: priority)
    }
    
    @discardableResult public func safeLeading(_ insets: CGFloat = 0,
                                        priority: UILayoutPriority = .required) -> Self {
        safeLeading(insets, priority: priority)
    }
    
    @discardableResult public func safeLeading(greaterThanOrEqualTo: CGFloat = 0,
                                        priority: UILayoutPriority) -> Self {
        safeLeading(greaterThanOrEqualTo: greaterThanOrEqualTo, priority: priority)
    }
    
    @discardableResult public func safeTop(_ insets: CGFloat = 0,
                                    priority: UILayoutPriority = .required) -> Self {
        safeTop(insets, priority: priority)
    }
    
    @discardableResult public func safeTop(greaterThanOrEqualTo: CGFloat = 0,
                                    priority: UILayoutPriority) -> Self {
        safeTop(greaterThanOrEqualTo: greaterThanOrEqualTo, priority: priority)
    }
    
    @discardableResult public func safeTrailing(_ insets: CGFloat = 0,
                                         priority: UILayoutPriority = .required) -> Self {
        safeTrailing(insets, priority: priority)
    }
    
    @discardableResult public func safeTrailing(greaterThanOrEqualTo: CGFloat = 0,
                                         priority: UILayoutPriority) -> Self {
        safeTrailing(greaterThanOrEqualTo: greaterThanOrEqualTo, priority: priority)
    }
    
    @discardableResult public func safeBottom(_ insets: CGFloat = 0,
                                       priority: UILayoutPriority = .required) -> Self {
        safeBottom(insets, priority: priority)
    }
    
    @discardableResult public func safeBottom(greaterThanOrEqualTo: CGFloat = 0,
                                       priority: UILayoutPriority) -> Self {
        safeBottom(greaterThanOrEqualTo: greaterThanOrEqualTo, priority: priority)
    }
    
    @discardableResult public func row(insets: UIEdgeInsets = .init(), spacing: CGFloat = 0,
                                priority: UILayoutPriority = .required) -> Self {
        row(insets: insets, spacing: spacing, priority: priority)
    }
    
    @discardableResult public func rowCentered(insets: UIEdgeInsets = .init(), spacing: CGFloat = 0,
                                        priority: UILayoutPriority = .required) -> Self {
        rowCentered(insets: insets, spacing: spacing, priority: priority)
    }
    
    @discardableResult public func column(insets: UIEdgeInsets = .init(), spacing: CGFloat = 0,
                                   priority: UILayoutPriority = .required) -> Self {
        column(insets: insets, spacing: spacing, priority: priority)
    }
    
    @discardableResult public func columnCentered(insets: UIEdgeInsets = .init(), spacing: CGFloat = 0,
                                           priority: UILayoutPriority = .required) -> Self {
        columnCentered(insets: insets, spacing: spacing, priority: priority)
    }
}

extension ParentChildLayout where Self: MultiViewLayoutSource {
    
    @discardableResult public func width(equalTo dimension: NSLayoutDimension,
                                  multiplier: CGFloat,
                                  constant: CGFloat,
                                  priority: UILayoutPriority) -> Self {
        spacingViews.forEach { child in
            child.widthAnchor.constraint(
                equalTo: dimension,
                multiplier: multiplier,
                constant: constant)
                .priority(priority).isActive = true
        }
        
        return self
    }
    
    @discardableResult
    public func padding(greaterThanOrEqualTo insets: CGFloat, priority: UILayoutPriority) -> Self {
        return
            leading(greaterThanOrEqualTo: insets, priority: priority)
            .top(greaterThanOrEqualTo: insets, priority: priority)
            .trailing(greaterThanOrEqualTo: insets, priority: priority)
            .bottom(greaterThanOrEqualTo: insets, priority: priority)
    }
    
    @discardableResult public func row(insets: UIEdgeInsets, spacing: CGFloat,
                                priority: UILayoutPriority) -> Self {
        guard
            let first = views.dropFirst().first,
            let parent = views.first,
            let last = views.last
        else { return self }
        
        first.leadingAnchor.constraint(equalTo: parent.leadingAnchor,
                                       constant: insets.left)
            .priority(priority).isActive = true
        parent.trailingAnchor.constraint(equalTo: last.trailingAnchor,
                                         constant: insets.right)
            .priority(priority).isActive = true
        top(insets.top, priority: priority)
        bottom(insets.bottom, priority: priority)
        horizontal(spacing, priority: priority)
        return self
    }
    
    @discardableResult public func rowCentered(insets: UIEdgeInsets, spacing: CGFloat, priority: UILayoutPriority) -> Self {
        guard
            let first = views.dropFirst().first,
            let parent = views.first,
            let last = views.last
        else { return self }
        
        first.leadingAnchor.constraint(
            equalTo: parent.leadingAnchor,
            constant: insets.left).priority(priority).isActive = true
        parent.trailingAnchor.constraint(
            equalTo: last.trailingAnchor,
            constant: insets.right).priority(priority).isActive = true
        
        top(greaterThanOrEqualTo: insets.top, priority: priority)
        bottom(greaterThanOrEqualTo: insets.top, priority: priority)
        let lower = max(min(.fittingSizeLevel, priority - 1), UILayoutPriority(0))
        top(insets.top, priority: lower)
        bottom(insets.top, priority: lower)
        centerY((insets.top - insets.bottom) / 2, priority: priority)
        horizontal(spacing, priority: priority)
        return self
    }
    
    @discardableResult public func column(insets: UIEdgeInsets, spacing: CGFloat, priority: UILayoutPriority) -> Self {
        guard
            let first = views.dropFirst().first,
            let last = views.last,
            let parent = views.first
        else { return self }
        
        first.topAnchor.constraint(equalTo: parent.topAnchor,
                                   constant: insets.top).priority(priority).isActive = true
        parent.bottomAnchor.constraint(equalTo: last.bottomAnchor,
                                       constant: insets.bottom).priority(priority).isActive = true
        leading(insets.left, priority: priority)
        trailing(insets.right, priority: priority)
        vertical(spacing, priority: priority)
        return self
    }
    
    @discardableResult public func columnCentered(insets: UIEdgeInsets, spacing: CGFloat, priority: UILayoutPriority) -> Self {
        guard
            let first = views.dropFirst().first,
            let last = views.last,
            let parent = views.first
        else { return self }
        
        first.topAnchor.constraint(equalTo: parent.topAnchor, constant: insets.top)
            .priority(priority).isActive = true
        parent.bottomAnchor.constraint(equalTo: last.bottomAnchor, constant: insets.bottom)
            .priority(priority).isActive = true
        leading(greaterThanOrEqualTo: insets.left, priority: priority)
        trailing(greaterThanOrEqualTo: insets.right, priority: priority)
        let lower = max(min(.fittingSizeLevel, priority - 1), UILayoutPriority(0))
        leading(insets.left, priority: lower)
        trailing(insets.right, priority: lower)
        centerX((insets.left - insets.right) / 2, priority: priority)
        vertical(spacing)
        return self
    }
    
    
    @discardableResult
    public func trailing(_ insets: CGFloat, priority: UILayoutPriority) -> Self {
        guard let parent = views.first else { return self }
        spacingViews.forEach { child in
            parent.trailingAnchor.constraint(
                equalTo: child.trailingAnchor,
                constant: insets).priority(priority).isActive = true
        }
        
        return self
    }
    
    @discardableResult
    public func trailing(greaterThanOrEqualTo insets: CGFloat, priority: UILayoutPriority) -> Self {
        guard let parent = views.first else { return self }
        spacingViews.forEach { child in
            parent.trailingAnchor.constraint(
                greaterThanOrEqualTo: child.trailingAnchor,
                constant: insets).priority(priority).isActive = true
        }
        
        return self
    }
    
    @discardableResult
    public func bottom(_ insets: CGFloat, priority: UILayoutPriority) -> Self {
        guard let parent = views.first else { return self }
        spacingViews.forEach { child in
            parent.bottomAnchor.constraint(equalTo: child.bottomAnchor,
                                           constant: insets)
                .priority(priority).isActive = true
        }
        return self
    }
    
    @discardableResult
    public func bottom(greaterThanOrEqualTo insets: CGFloat, priority: UILayoutPriority) -> Self {
        guard let parent = views.first else { return self }
        spacingViews.forEach { child in
            parent.bottomAnchor.constraint(greaterThanOrEqualTo: child.bottomAnchor,
                                           constant: insets)
                .priority(priority).isActive = true
        }
        return self
    }
    
    @discardableResult
    public func safeTop(_ insets: CGFloat, priority: UILayoutPriority) -> Self {
        guard let parent = views.first else { return self }
        spacingViews.forEach { view in
            view.topAnchor.constraint(equalTo: parent.safeAreaLayoutGuide.topAnchor,
                                      constant: insets)
                .priority(priority).isActive = true
        }
        
        return self
    }
    
    @discardableResult
    public func safeTop(greaterThanOrEqualTo insets: CGFloat, priority: UILayoutPriority) -> Self {
        guard let parent = views.first else { return self }
        spacingViews.forEach { view in
            view.topAnchor.constraint(
                greaterThanOrEqualTo: parent.safeAreaLayoutGuide.topAnchor, constant: insets)
                .priority(priority).isActive = true
        }
        return self
    }
    
    @discardableResult
    public func safeTrailing(_ insets: CGFloat, priority: UILayoutPriority) -> Self {
        guard let parent = views.first else { return self }
        spacingViews.forEach { view in
            parent.safeAreaLayoutGuide.trailingAnchor.constraint(
                equalTo: view.trailingAnchor, constant: insets)
                .priority(priority).isActive = true
        }
        
        return self
    }
    
    @discardableResult
    public func safeTrailing(greaterThanOrEqualTo insets: CGFloat, priority: UILayoutPriority) -> Self {
        guard let parent = views.first else { return self }
        spacingViews.forEach { view in
            parent.safeAreaLayoutGuide.trailingAnchor.constraint(
                greaterThanOrEqualTo: view.trailingAnchor, constant: insets)
                .priority(priority).isActive = true
        }
        return self
    }
    
    @discardableResult
    public func safeBottom(_ insets: CGFloat, priority: UILayoutPriority) -> Self {
        guard let parent = views.first else { return self }
        spacingViews.forEach { view in
            parent.safeAreaLayoutGuide.bottomAnchor.constraint(
                equalTo: view.bottomAnchor, constant: insets)
                .priority(priority).isActive = true
        }
        
        return self
    }
    
    @discardableResult
    public func safeBottom(greaterThanOrEqualTo insets: CGFloat, priority: UILayoutPriority) -> Self {
        guard let parent = views.first else { return self }
        spacingViews.forEach { view in
            parent.safeAreaLayoutGuide.bottomAnchor.constraint(
                greaterThanOrEqualTo: view.bottomAnchor, constant: insets)
                .priority(priority).isActive = true
        }
        return self
    }
    
    @discardableResult
    public func safeLeading(_ insets: CGFloat, priority: UILayoutPriority) -> Self {
        guard let parent = views.first else { return self }
        spacingViews.forEach { view in
            view.leadingAnchor.constraint(
                equalTo: parent.safeAreaLayoutGuide.leadingAnchor, constant: insets)
                .priority(priority).isActive = true
        }
        
        return self
    }
    
    @discardableResult
    public func safeLeading(greaterThanOrEqualTo insets: CGFloat, priority: UILayoutPriority) -> Self {
        guard let parent = views.first else { return self }
        spacingViews.forEach { view in
            view.leadingAnchor.constraint(
                greaterThanOrEqualTo: parent.safeAreaLayoutGuide.leadingAnchor, constant: insets)
                .priority(priority).isActive = true
        }
        return self
    }
}


public class AnyIntrinsicLayoutImp: LayoutBuilderType, IntrinsicLayout, IntrinsicLayoutViewSource {
    
    init(layout: LayoutAnchorable) {
        self.layout = layout
    }
    
    func addTo(parent: UIView) {
        layout.addTo(parent: parent)
    }
    
    public var layout: LayoutAnchorable
    public var toLayout: LayoutAnchorable { layout }
    public var toView: UIView { toLayout.layoutContext! }
}


public class AnyInterViewLayoutImp: InterViewLayout, MultiViewLayoutSource {
    
    init<S: Sequence>(_ views: S) where S.Element == LayoutAnchorable {
        self.views = Array(views)
    }
    
    init(_ views: [LayoutAnchorable]) {
        self.views = views
    }
    
    public var views: [LayoutAnchorable]
    public var spacingViews: ArraySlice<LayoutAnchorable> { return ArraySlice(views) }
}

extension AnyInterViewLayoutImp {
    func row(insets: UIEdgeInsets = .init(),
             spacing: CGFloat = 0,
             priority: UILayoutPriority = .required) -> UIView {
        UIView().l(self).row(insets: insets, spacing: spacing, priority: priority).toView
    }
    
    func column(insets: UIEdgeInsets = .init(),
                spacing: CGFloat = 0,
                priority: UILayoutPriority = .required) -> UIView {
        UIView().l(self).column(insets: insets, spacing: spacing, priority: priority).toView
    }
}

extension UIView {
    
    @discardableResult
    func row<T: LayoutBuilderType>(
        _ views: T...,
        insets: UIEdgeInsets = .init(),
        spacing: CGFloat = 0,
        priority: UILayoutPriority = .required,
        configure: (([T]) -> Void)? = nil) -> UIView {
        row(views, insets: insets, spacing: spacing, priority: priority, configure: configure)
    }
    
    @discardableResult
    func row<T: LayoutBuilderType>(
        _ views: [T],
        insets: UIEdgeInsets = .init(),
        spacing: CGFloat = 0,
        priority: UILayoutPriority = .required,
        configure: (([T]) -> Void)? = nil) -> UIView {
        defer { configure?(views) }
        return l(views).row(insets: insets, spacing: spacing, priority: priority).toView
    }
    
    @discardableResult
    func column<T: LayoutBuilderType>(
        _ views: T...,
        insets: UIEdgeInsets = .init(),
        spacing: CGFloat = 0,
        priority: UILayoutPriority = .required,
        configure: (([T]) -> Void)? = nil) -> UIView {
        column(views, insets: insets, spacing: spacing, priority: priority, configure: configure)
    }
    
    @discardableResult
    func column<T: LayoutBuilderType>(
        _ views: [T],
        insets: UIEdgeInsets = .init(),
        spacing: CGFloat = 0,
        priority: UILayoutPriority = .required,
        configure: (([T]) -> Void)? = nil) -> UIView {
        defer { configure?(views) }
        return l(views).column(insets: insets, spacing: spacing, priority: priority).toView
    }
}

extension Array where Element: ViewBuilderType {
    public func row(insets: UIEdgeInsets = .init(),
             spacing: CGFloat = 0,
             priority: UILayoutPriority = .required) -> UIView {
        UIView().l(self).row(insets: insets, spacing: spacing, priority: priority).toView
    }
    
    public func column(insets: UIEdgeInsets = .init(),
                spacing: CGFloat = 0,
                priority: UILayoutPriority = .required) -> UIView {
        UIView().l(self).column(insets: insets, spacing: spacing, priority: priority).toView
    }
}


public class AnyParentChildLayoutImp: ViewBuilderType, ParentChildLayout, MultiViewLayoutSource {
    
    init<S: Sequence>(views: S, parent: LayoutAnchorable) where S.Element == LayoutAnchorable {
        self.views = [parent] + views
        deferredChildren = Array(spacingViews)
        
        if let _ = parent.layoutContext {
            spacingViews.forEach { anchorable in anchorable.addTo(parent: parent) }
            return
        }
    }
    
    init<S: Sequence>(views: S, parent: UIView) where S.Element == LayoutAnchorable {
        self.views = [parent] + views
        
        func orphans(of anchorable: LayoutAnchorable) -> [LayoutAnchorable]? {
            guard let deferred = anchorable.deferredChildren?.compactMap({ $0 })
            else { return nil }
            let nested = deferred.compactMap({ orphans(of: $0) }).flatMap { $0 }
            return deferred + nested
        }
        
        spacingViews.forEach { $0.addTo(parent: parent) }
        orphans(of: self.toLayout)?.forEach { $0.addTo(parent: parent) }
    }
    
    var deferredChildren: [LayoutAnchorable]?
    public var toView: UIView { views.first! as! UIView }
    public var views: [LayoutAnchorable]
    public var spacingViews: ArraySlice<LayoutAnchorable> { views.dropFirst() }
}


extension LayoutAnchorable {
    var l: AnyIntrinsicLayoutImp { AnyIntrinsicLayoutImp(layout: self) }
    
    func l(_ views: [LayoutBuilderType]) -> AnyParentChildLayoutImp {
        AnyParentChildLayoutImp(views: views.map({ $0.toLayout }), parent: self)
    }
    
    func l(_ views: LayoutBuilderType...) -> AnyParentChildLayoutImp {
        AnyParentChildLayoutImp(views: views.map({ $0.toLayout }), parent: self)
    }
}


extension UILayoutGuide {
    var l: AnyIntrinsicLayoutImp { AnyIntrinsicLayoutImp(layout: self) }
    
    func l(_ views: [LayoutBuilderType]) -> AnyParentChildLayoutImp {
        AnyParentChildLayoutImp(views: views.map({ $0.toLayout }), parent: self)
    }
    
    func l(_ views: LayoutBuilderType...) -> AnyParentChildLayoutImp {
        AnyParentChildLayoutImp(views: views.map({ $0.toLayout }), parent: self)
    }
}

extension UIView {
    public var l: AnyIntrinsicLayoutImp { AnyIntrinsicLayoutImp(layout: self) }
    
    public func l(_ source: MultiViewLayoutSource) -> AnyParentChildLayoutImp {
        AnyParentChildLayoutImp(views: source.views, parent: self)
    }
    
    public func l(_ views: [LayoutBuilderType]) -> AnyParentChildLayoutImp {
        AnyParentChildLayoutImp(views: views.map({ $0.toLayout }), parent: self)
    }
    
    public func l(_ views: LayoutBuilderType...) -> AnyParentChildLayoutImp {
        AnyParentChildLayoutImp(views: views.map({ $0.toLayout }), parent: self)
    }
}

extension Array where Element: LayoutAnchorable {
    public var l: AnyInterViewLayoutImp {
        AnyInterViewLayoutImp(self)
    }
}

extension Array where Element == LayoutBuilderType {
    var l: AnyInterViewLayoutImp { AnyInterViewLayoutImp(map { $0.toLayout }) }
}

extension NSLayoutDimension {
    
    // These methods return an inactive constraint of the form thisAnchor = otherAnchor * multiplier.
    func constraint(equalTo anchors: [NSLayoutDimension], multiplier m: CGFloat = 1,
                    priority: UILayoutPriority = .required) -> [NSLayoutConstraint] {
        anchors.map { constraint(equalTo: $0, multiplier: m).priority(priority) }
    }
    
    func constraint(equalTo anchors: NSLayoutDimension...,
                    multiplier m: CGFloat = 1,
                    priority: UILayoutPriority = .required) -> [NSLayoutConstraint] {
        constraint(equalTo: anchors, multiplier: m, priority: priority)
    }
    
    func constraint(greaterThanOrEqualTo anchors: [NSLayoutDimension],
                    multiplier m: CGFloat = 1,
                    priority: UILayoutPriority = .required) -> [NSLayoutConstraint] {
        anchors.map { constraint(greaterThanOrEqualTo: $0, multiplier: m)
            .priority(priority) }
    }
    
    func constraint(lessThanOrEqualTo anchors: [NSLayoutDimension],
                    multiplier m: CGFloat = 1,
                    priority: UILayoutPriority = .required) -> [NSLayoutConstraint] {
        anchors.map { constraint(lessThanOrEqualTo: $0, multiplier: m)
            .priority(priority) }
    }
    
    
    // These methods return an inactive constraint of the form thisAnchor = otherAnchor * multiplier + constant.
    func constraint(equalTo anchors: [NSLayoutDimension],
                    multiplier m: CGFloat = 1, constant c: CGFloat = 0,
                    priority: UILayoutPriority = .required) -> [NSLayoutConstraint] {
        anchors.map { constraint(equalTo: $0, multiplier: m, constant: c)
            .priority(priority) }
    }
    
    func constraint(greaterThanOrEqualTo anchors: [NSLayoutDimension],
                    multiplier m: CGFloat = 1, constant c: CGFloat = 0,
                    priority: UILayoutPriority = .required) -> [NSLayoutConstraint] {
        anchors.map { constraint(greaterThanOrEqualTo: $0, multiplier: m, constant: c)
            .priority(priority) }
    }
    
    func constraint(lessThanOrEqualTo anchors: [NSLayoutDimension],
                    multiplier m: CGFloat = 1, constant c: CGFloat = 0,
                    priority: UILayoutPriority = .required) -> [NSLayoutConstraint] {
        anchors.map { constraint(lessThanOrEqualTo: $0, multiplier: m, constant: c)
            .priority(priority) }
    }
}

extension Array where Element: NSLayoutConstraint {
    func isActive(_ value: Bool) {
        forEach { $0.isActive = value }
    }
}
