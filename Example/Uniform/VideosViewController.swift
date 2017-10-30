//
//  VideosViewController.swift
//  ConsistencyTest
//
//  Created by King, Gavin on 9/27/17.
//  Copyright © 2017 Vimeo. All rights reserved.
//

import UIKit
import Uniform

class VideosViewController: UIViewController
{
    struct Constants
    {
        struct Cell
        {
            static let Name = "VideoCell"
            static let Height: CGFloat = 80
        }
    }
    
    @IBOutlet weak var collectionView: UICollectionView!

    private var videos: [Video] = []
    
    init(videos: [Video])
    {
        self.videos = videos
        
        super.init(nibName: nil, bundle: nil)
        
        self.title = "Videos"
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        ConsistencyManager.shared.register(self)
        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.register(UINib(nibName: Constants.Cell.Name, bundle: nil), forCellWithReuseIdentifier: Constants.Cell.Name)
    }
}

// MARK: Collection View

extension VideosViewController: UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        return CGSize(width: self.collectionView.frame.size.width, height: Constants.Cell.Height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        let video = self.videos[indexPath.item]
        
        let playerViewController = PlayerViewController(video: video)
        
        self.navigationController?.pushViewController(playerViewController, animated: true)
    }
}

extension VideosViewController: UICollectionViewDataSource
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return self.videos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.Cell.Name, for: indexPath) as! VideoCell
        
        let video = self.videos[indexPath.item]
        
        cell.titleLabel.text = video.title
        cell.userLabel.text = "\(video.user.name) - \(video.user.age) years old"
        
        return cell
    }
}

// MARK: Object Consistency

extension VideosViewController: ConsistentEnvironment
{
    var objects: [ConsistentObject]
    {
        return self.videos
    }
    
    func update(with object: ConsistentObject)
    {
        self.videos.updated(with: object) { (videos, updatedIndexes) in
            
            self.videos = videos
            
            let indexPaths = updatedIndexes.map({ IndexPath(item: $0, section: 0) })
            
            self.collectionView.reloadItems(at: indexPaths)
        }
    }
}

/*
 
// MARK: Object Membership

DynamicMembershipManager.shared.register(self, for: .likes)

extension VideosViewController: DynamicMembershipEnvironment
{
    func add(object: Video)
    {
        self.videos.insert(object, at: 0)
        
        let indexPath = IndexPath(item: 0, section: 0)

        self.collectionView.insertItems(at: [indexPath])
 
        // TODO: Invalidate cache
    }
    
    func remove(object: Video)
    {
        guard let index = self.videos.index(of: object) else
        {
            assertionFailure()
            
            return
        }
        
        self.videos.remove(at: index)
        
        let indexPath = IndexPath(item: index, section: 0)
        
        self.collectionView.deleteItems(at: [indexPath])
 
        // TODO: Invalidate cache
    }
}
 
*/
