//
//  ContentTableViewCell.swift
//  ShareYourTravel
//
//  Created by Daeyun Ethan Kim on 23/08/2017.
//  Copyright © 2017 Daeyun Ethan Kim. All rights reserved.
//

import UIKit

// MARK: - ContentTableViewCell
class ContentTableViewCell: UITableViewCell {

    // MARK: Properties
        // Constant
    var data: BoardData?
    
    // MARK: Outlets
    @IBOutlet weak var subjectLabel: UILabel?
    @IBOutlet weak var nickNameLabel: UILabel?
    @IBOutlet weak var postedDateLabel: UILabel?
    @IBOutlet weak var imageCollectionView: UICollectionView?
    @IBOutlet weak var pageControl: UIPageControl?
    @IBOutlet weak var heightConstraintForCollectionView: NSLayoutConstraint?
    @IBOutlet weak var heightConstrainForTitleView: NSLayoutConstraint?
    @IBOutlet weak var backgroundCardView: CustomView?
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout?
    
    // MARK: Life Cycle
    func initVars() {
        clipsToBounds = true
        
        if let imageCollectionView = imageCollectionView {
            imageCollectionView.layer.cornerRadius = 3.0
            imageCollectionView.layer.masksToBounds = true
        }
        
        backgroundCardView?.initCustomView(bgColor: .white)
        
        contentView.backgroundColor = UIColor(red: 240.0/255.0, green: 240.0/255.0, blue: 240.0/255.0, alpha: 1.0)
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
        flowLayout.itemSize = CGSize.init(width: UIScreen.main.bounds.size.width - 32.0, height: 200.0)
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
    
    
    func initSubjectLabel() {
        subjectLabel?.font = UIFont(name: kGeorgiaFont, size: 14.0)
    }
    
    func initNickNameAndHitsLabel() {
        nickNameLabel?.font = UIFont(name: kAvenirLight, size: 10.0)
        nickNameLabel?.textColor = .darkGray
    }

    func initPostedDateLabel() {
        postedDateLabel?.font = UIFont(name: kArialHebrew, size: 10.0)
        postedDateLabel?.textColor = .lightGray
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        initVars()
        initBackgroundView()
        initNibs()
        initCollectionView()
        initPageControl()
        initSubjectLabel()
        initNickNameAndHitsLabel()
        initPostedDateLabel()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    // MARK: Set Entities
    func setEntities(data: BoardData) {
        self.data = data
        nickNameLabel?.text = data.nickname
        
        let count = data.imageURLs.count
        
        if count != 0 {
            pageControl?.numberOfPages = count
            
            heightConstraintForCollectionView?.constant = kImageHeight
        }
        else {
            heightConstraintForCollectionView?.constant = 0.0
        }
        
        if let content = data.content {
            subjectLabel?.text = content
            heightConstrainForTitleView?.constant = kTitleHeight
        }
        else {
            heightConstrainForTitleView?.constant = 0.0
        }
        
        layoutIfNeeded()
        imageCollectionView?.reloadData()
    }
    
    class func getHeight(entity: BoardData) -> CGFloat {
        var cellHeight: CGFloat = 50.0
        
        if entity.imageURLs.count != 0 {
            cellHeight += CGFloat(kImageHeight)
        }
        
        if let _ = entity.content {
            cellHeight += 120.0
        }
        
        return cellHeight
    }
}


// MARK: ContentTableViewCell: UICollectionViewDataSource, UICollectionViewDelegate
extension ContentTableViewCell: UICollectionViewDataSource, UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let count = data?.imageURLs.count else {
            return 0
        }
    
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kSimpleCollectionViewCellID, for: indexPath) as? SimpleCollectionViewCell, let path = data?.imageURLs[indexPath.row] else {
            
            return UICollectionViewCell()
        }
        
        NetworkManager.downLoadImage(path: path) { (image) in
            
            cell.setEntities(image: image)
        }
        
        return cell
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        var visibleRect = CGRect()
        
        guard let origin = imageCollectionView?.contentOffset, let size = imageCollectionView?.bounds.size else {
            return
        }
        
        visibleRect.origin = origin
        visibleRect.size = size
        
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        
        let visibleIndexPath = imageCollectionView?.indexPathForItem(at: visiblePoint)
        
        guard let row = visibleIndexPath?.row else {
            print("Error: collectionView Scroll error")
            return
        }
        
        
        pageControl?.currentPage = row
    }
}
