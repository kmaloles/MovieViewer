//
//  CollectionViewMatrixLayout.swift
//  MovieViewer
//
//  Created by Kevin Maloles on 4/23/18.
//  Copyright © 2018 Kevin Maloles. All rights reserved.
//

import UIKit

class CollectionViewMatrixLayout: UICollectionViewFlowLayout {
    
//    var itemSize: CGSize
    var interItemSpacingY: CGFloat
    var interItemSpacingX: CGFloat
    var layoutInfo: [IndexPath: UICollectionViewLayoutAttributes]
    
    override init() {
//        itemSize = CGSize(width: 50, height: 50)
        interItemSpacingY = 1
        interItemSpacingX = 1
        layoutInfo = [IndexPath: UICollectionViewLayoutAttributes]()
        
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepare() {
        guard let collectionView = self.collectionView else {
            return
        }
        
        var cellLayoutInfo = [IndexPath: UICollectionViewLayoutAttributes]()
        var indexPath = IndexPath(item: 0, section: 0)
        
        let sectionCount = collectionView.numberOfSections
        for section in 0..<sectionCount {
            
            let itemCount = collectionView.numberOfItems(inSection: section)
            for item in 0..<itemCount {
                indexPath = IndexPath(item: item, section: section)
                let itemAttributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                itemAttributes.frame = frameForCell(at: indexPath)
                cellLayoutInfo[indexPath] = itemAttributes
            }
            
            self.layoutInfo = cellLayoutInfo
        }
    }
    
    func frameForCell(at indexPath: IndexPath) -> CGRect {
        let row = indexPath.section
        let column = indexPath.item
        
        let originX = (itemSize.width + interItemSpacingX) * CGFloat(column)
        let originY = (itemSize.height + interItemSpacingY) * CGFloat(row)
        
        return CGRect(x: originX, y: originY, width: itemSize.width, height: itemSize.height)
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]?
    {
        var allAttributes = Array<UICollectionViewLayoutAttributes>()
        
        for (_, attributes) in self.layoutInfo {
            if (rect.intersects(attributes.frame)) {
                allAttributes.append(attributes)
            }
        }
        return allAttributes
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return self.layoutInfo[indexPath]
    }
    
    override var collectionViewContentSize: CGSize {
        guard let collectionView = self.collectionView else {
            return .zero
        }
        
        let sectionCount = collectionView.numberOfSections
        let height = (itemSize.height + interItemSpacingY) * CGFloat(sectionCount)
        
        let itemCount = Array(0..<sectionCount)
            .map { collectionView.numberOfItems(inSection: $0) }
            .max() ?? 0
        
        let width  = (itemSize.width + interItemSpacingX) * CGFloat(itemCount)
        
        return CGSize(width: width, height: height)
        
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    override func prepareForTransition(to newLayout: UICollectionViewLayout) {
        guard let collectionView = self.collectionView else {
            return
        }
        
        var cellLayoutInfo = [IndexPath: UICollectionViewLayoutAttributes]()
        var indexPath = IndexPath(item: 0, section: 0)
        
        let sectionCount = collectionView.numberOfSections
        for section in 0..<sectionCount {
            
            let itemCount = collectionView.numberOfItems(inSection: section)
            for item in 0..<itemCount {
                indexPath = IndexPath(item: item, section: section)
                let itemAttributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                itemAttributes.frame = frameForCell(at: indexPath)
                cellLayoutInfo[indexPath] = itemAttributes
            }
            
            self.layoutInfo = cellLayoutInfo
        }
    }
}
