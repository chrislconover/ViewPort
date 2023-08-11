//
//  CollectionViewSeparatorFlowLayout.swift
//
//  Created by Chris Conover on 1/10/20.
//  Copyright © 2020 Curious Applications. All rights reserved.
//

import UIKit


final class CollectionViewSeparatorFlowLayout: UICollectionViewFlowLayout {
    init(separatorKind: String) {
        self.separatorKind = separatorKind
        super.init()
        register(UICollectionReusableView.self, forDecorationViewOfKind: separatorKind)
    }
    required init?(coder: NSCoder) { fatalError("nope") }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let layoutAttributes = super.layoutAttributesForElements(in: rect) ?? []
        let lineWidth = self.minimumLineSpacing
        
        var decorationAttributes: [UICollectionViewLayoutAttributes] = []
        
        for layoutAttribute in layoutAttributes where layoutAttribute.indexPath.item > 0 {
            let separatorAttribute = UICollectionViewLayoutAttributes(
                forDecorationViewOfKind: separatorKind,
                with: layoutAttribute.indexPath)
            let cellFrame = layoutAttribute.frame
            separatorAttribute.frame = CGRect(x: cellFrame.origin.x,
                                              y: cellFrame.origin.y - lineWidth,
                                              width: cellFrame.size.width,
                                              height: lineWidth)
            separatorAttribute.zIndex = Int.max
            decorationAttributes.append(separatorAttribute)
        }
        
        return layoutAttributes + decorationAttributes
    }
    
    private let separatorKind: String
}


//
//
//final class CollectionViewSeparatorFlowLayout<T: UIView & Constructable>: UICollectionViewFlowLayout {
//
//    private let separatorDecorationKey = "separator"
//    class SeparatorCell: UICollectionReusableView {
//        override init(frame: CGRect) {
//            super.init(frame: frame)
//            self.l(T()).padding()
//        }
//        required init?(coder aDecoder: NSCoder) { fatalError("nope") }
//
//        override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
//            self.frame = layoutAttributes.frame
//        }
//    }
//
//    override init() {
//        super.init()
//        register(SeparatorCell.self, forDecorationViewOfKind: separatorDecorationKey)
//    }
//    required init?(coder: NSCoder) { fatalError("nope") }
//
//    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
//        let layoutAttributes = super.layoutAttributesForElements(in: rect) ?? []
//        let attrs = UICollectionViewLayoutAttributes(
//            forDecorationViewOfKind: separatorDecorationKey,
//            with: IndexPath())
//        attrs.zIndex = -1
//        attrs.frame = layoutAttributes.reduce(CGRect(), { $0.union($1.frame) })
//        return layoutAttributes + [attrs]
//    }
//}
