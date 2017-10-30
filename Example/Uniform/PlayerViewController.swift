//
//  PlayerViewController.swift
//  Uniform_Example
//
//  Created by King, Gavin on 9/27/17.
//  Copyright © 2017 Vimeo. All rights reserved.
//

import UIKit
import Uniform

class PlayerViewController: UIViewController
{
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var userLabel: UILabel!
    
    private var video: Video
    {
        didSet
        {
            self.populate()
        }
    }
    
    init(video: Video)
    {
        self.video = video
        
        super.init(nibName: nil, bundle: nil)
        
        self.title = "Player"
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        ConsistencyManager.shared.register(self)
        
        self.populate()
    }
    
    // MARK: Population
    
    private func populate()
    {
        self.titleLabel.text = self.video.title
        self.userLabel.text = "\(self.video.user.name) - \(self.video.user.age) years old"
    }
}

// MARK: Object Consistency

extension PlayerViewController: ConsistentEnvironment
{
    var objects: [ConsistentObject]
    {
        return [self.video]
    }
    
    func update(with object: ConsistentObject)
    {
        self.video = self.video.updated(with: object)
    }
}
