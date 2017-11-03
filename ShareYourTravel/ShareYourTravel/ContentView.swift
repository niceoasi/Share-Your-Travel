//
//  ContentView.swift
//  ShareYourTravel
//
//  Created by Daeyun Ethan Kim on 23/08/2017.
//  Copyright © 2017 Daeyun Ethan Kim. All rights reserved.
//

import UIKit

// MARK: - ContentView
class ContentView: UIView {
    
    // MARK: Properties
    var containerView: UIView?
    var images: [UIImage]?
    
    // MAKR: Outlets
    @IBOutlet weak var imageCollectionView: UICollectionView?
    @IBOutlet weak var heightConstrainForImageCollectionView: NSLayoutConstraint?
    @IBOutlet weak var contentTextView: UITextView?
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout?
    
    
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
        containerView = Bundle.main.loadNibNamed("ContentView", owner: self, options: nil)?.first as? UIView
        containerView?.frame = self.bounds
        containerView?.backgroundColor = .clear
        
        guard let containerView = containerView else {
            print("Error: ContentView - commonInitialization() => containerView doesn't exist")
            return
        }
        
        addSubview(containerView)
    }
    
    // MARK: Init
    func initVars() {
        
    }
    
    func initBackgroundView() {
        
    }
    
    func initNib() {
        let simpleCVCellNib = UINib(nibName: kSimpleCollectionViewCellID, bundle: nil)
        imageCollectionView?.register(simpleCVCellNib, forCellWithReuseIdentifier: kSimpleCollectionViewCellID)
    }
    
    func initSubjectTextField() {
        
    }
    
    func initContentTextView() {
        
    }
    
    func initCollectionView() {
        imageCollectionView?.dataSource = self
        imageCollectionView?.delegate = self
        
        if let _ = images {
            heightConstrainForImageCollectionView?.constant = 160.0
        } else {
            heightConstrainForImageCollectionView?.constant = 0
        }
        
        layoutIfNeeded()
        initFlowLayOut()
        imageCollectionView?.reloadData()
        
    }
    
    func initFlowLayOut() {
        flowLayout?.minimumInteritemSpacing = 0
        if let imageCollectionView = imageCollectionView {
            flowLayout?.itemSize = CGSize(width: imageCollectionView.frame.width, height: imageCollectionView.frame.height)
        }
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        initVars()
        initBackgroundView()
        initNib()
        initSubjectTextField()
        initContentTextView()
        initCollectionView()
    }
    
    // MARK: SetVars
    func setContentTextViewUserInteractionEnabled(at isEnable: Bool) {
        
        contentTextView?.isUserInteractionEnabled = isEnable
    }
}


// MARK: ContentView: UICollectionViewDataSource, UICollectionViewDelegate
extension ContentView: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let images = images else {
            return 0
        }
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kSimpleCollectionViewCellID, for: indexPath) as? SimpleCollectionViewCell, let image = images?[indexPath.row] else {
            return UICollectionViewCell()
        }
        
        cell.setEntities(image: image)
        return cell
    }
}

