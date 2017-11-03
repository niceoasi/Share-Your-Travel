//
//  TableHeaderView.swift
//  ShareYourTravel
//
//  Created by Daeyun Ethan Kim on 10/10/2017.
//  Copyright © 2017 Daeyun Ethan Kim. All rights reserved.
//

import UIKit
// MARK: - TableHeaderViewDelegate
protocol TableHeaderViewDelegate: class {
}

class TableHeaderView: UIView {
    // MARK: Properties
        // Constants
    let datas: [UIImage?] = [UIImage(named: "chess"), UIImage(named: "flash"), UIImage(named: "ocean")]
    
    weak var delegate: TableHeaderViewDelegate?
    weak var containerView: UIView?
    
    // MARK: Outlets
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout?
    @IBOutlet weak var imageCollectionView: UICollectionView?
    @IBOutlet weak var pageControl: UIPageControl?
    
    
    // MARK: Life Cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInitialization()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInitialization()
    }
    
    func commonInitialization() {
        containerView = Bundle.main.loadNibNamed("TableHeaderView", owner: self, options: nil)?.first as? UIView
        guard let containerView = containerView else {
            print("Error: MainNavigationView - commonInitialization => containerView doesn't exist")
            return
        }
        
        containerView.frame = bounds
        containerView.backgroundColor = kClearColor
        
        addSubview(containerView)
    }
    
    func initVars() {
        
    }
    
    func initBackgroundView() {
        
    }
    
    func initNibs() {
        let simpleCVCellNib = UINib(nibName: kSimpleCollectionViewCellID, bundle: nil)
        imageCollectionView?.register(simpleCVCellNib, forCellWithReuseIdentifier: kSimpleCollectionViewCellID)
    }
    
    func initFlowLayOut() {
        flowLayout?.minimumInteritemSpacing = 0
        if let imageCollectionView = imageCollectionView {
            flowLayout?.itemSize = CGSize(width: imageCollectionView.frame.width, height: imageCollectionView.frame.height)
        }
        
    }
    
    func initCollectionView() {
        let flowLayout = UICollectionViewFlowLayout.init()
        flowLayout.itemSize = CGSize.init(width: UIScreen.main.bounds.size.width, height: 200.0)
        flowLayout.scrollDirection = UICollectionViewScrollDirection.horizontal
        flowLayout.minimumLineSpacing = 0.0
        flowLayout.minimumInteritemSpacing = 0.0
        
        imageCollectionView?.dataSource = self
        imageCollectionView?.delegate = self
        imageCollectionView?.backgroundColor = kClearColor
        imageCollectionView?.alwaysBounceHorizontal = true
        imageCollectionView?.collectionViewLayout = flowLayout
        imageCollectionView?.showsHorizontalScrollIndicator = false
        imageCollectionView?.isPagingEnabled = true
    }
    
    func initPageControl() {
        pageControl?.hidesForSinglePage = true
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        initVars()
        initBackgroundView()
        initNibs()
        initFlowLayOut()
        initCollectionView()
    }
    
    // MARK: setVars
    func setBGColor(color: UIColor) {
        containerView?.backgroundColor = color
    }
}

// MARK: - TableHeaderView: UICollectionViewDataSource, UICollectionViewDelegate
extension TableHeaderView: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return datas.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kSimpleCollectionViewCellID, for: indexPath) as? SimpleCollectionViewCell, let image = datas[indexPath.row] else {
            return UICollectionViewCell()
        }
        cell.setEntities(image: image)
        
        return cell
    }
    
//    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
//        var visibleRect = CGRect()
//
//        guard let origin = imageCollectionView?.contentOffset, let size = imageCollectionView?.bounds.size else {
//            return
//        }
//
//        visibleRect.origin = origin
//        visibleRect.size = size
//
//        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
//
//        let visibleIndexPath = imageCollectionView?.indexPathForItem(at: visiblePoint)
//
//        guard let row = visibleIndexPath?.row else {
//            print("Error: collectionView Scroll error")
//            return
//        }
//
//        pageControl?.currentPage = row
//    }
}


