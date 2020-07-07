//
//  PagingCollectionView.swift
//  RRFormValidation
//
//  Created by Rahul Mayani on 29/06/20.
//  Copyright © 2020 RR. All rights reserved.
//

import UIKit

@objc public protocol PagingCollectionViewDelegate {

  @objc optional func didPaginateCtn(_ collectionView: PagingCollectionView, to page: Int)
  func paginateCtn(_ collectionView: PagingCollectionView, to page: Int)

}

let footerIdentifier = "LoadingHeaderFooter"

class LoadingHeaderFooter: UICollectionReusableView {

    private var indicator: UIActivityIndicatorView!
    
    override init(frame: CGRect) {
       super.init(frame: frame)
       self.backgroundColor = UIColor.clear

       // Customize here
       indicator = UIActivityIndicatorView()
       indicator.color = UIColor.red
       indicator.translatesAutoresizingMaskIntoConstraints = false
       indicator.startAnimating()
       addSubview(indicator)
       centerIndicator()
    }

    required init?(coder aDecoder: NSCoder) {
       super.init(coder: aDecoder)

    }
    
    private func centerIndicator() {
        let xCenterConstraint = NSLayoutConstraint(
            item: self, attribute: .centerX, relatedBy: .equal,
            toItem: indicator, attribute: .centerX, multiplier: 1, constant: 0
        )
        self.addConstraint(xCenterConstraint)
        
        let yCenterConstraint = NSLayoutConstraint(
            item: self, attribute: .centerY, relatedBy: .equal,
            toItem: indicator, attribute: .centerY, multiplier: 1, constant: 0
        )
        self.addConstraint(yCenterConstraint)
    }
}

open class PagingCollectionView: UICollectionView {
    
    internal var page: Int = 0
    internal var previousItemCount: Int = 0
    
    open var currentPage: Int {
        get {
            return page
        }
    }
    
    open weak var pagingDelegate: PagingCollectionViewDelegate? {
        didSet {
            pagingDelegate?.paginateCtn(self, to: page)
        }
    }
    
    open var isLoading: Bool = false {
        didSet {
            isLoading ? showLoading() : hideLoading()
        }
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        register(LoadingHeaderFooter.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: footerIdentifier)
    }
    
    open func reset() {
        page = 0
        previousItemCount = 0
    }
    
    private func paginate(_ collectionView: PagingCollectionView, forIndexAt indexPath: IndexPath) {
        let itemCount = collectionView.dataSource?.collectionView(collectionView, numberOfItemsInSection: indexPath.section) ?? 0
        guard indexPath.item == itemCount - 1 else { return }
        guard previousItemCount != itemCount else { return }
        page += 1
        previousItemCount = itemCount
        pagingDelegate?.paginateCtn(self, to: page)
    }
    
    private func showLoading() {
        reloadData()
    }
    
    private func hideLoading() {
        reloadData()
        pagingDelegate?.didPaginateCtn?(self, to: page)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {

        switch kind {
        case UICollectionView.elementKindSectionHeader:
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "Header", for: indexPath as IndexPath)
            headerView.backgroundColor = UIColor.clear
            return headerView
        case UICollectionView.elementKindSectionFooter:
            let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: footerIdentifier, for: indexPath as IndexPath)
            footerView.backgroundColor = UIColor.clear
            return footerView
        default:
            assert(false, "Unexpected element kind")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize.init(width: 0, height: 0)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        if isLoading {
            return CGSize.init(width: 50, height: 265)
        }
        return CGSize.init(width: 0, height: 0)
    }
    
    override open func dequeueReusableCell(withReuseIdentifier identifier: String, for indexPath: IndexPath) -> UICollectionViewCell {
        paginate(self, forIndexAt: indexPath)
        return super.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath)
    }
}
