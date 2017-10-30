//
//  ProfileViewController.swift
//  Uniform_Example
//
//  Created by King, Gavin on 9/27/17.
//  Copyright © 2017 Vimeo. All rights reserved.
//

import UIKit
import Uniform

class ProfileViewController: UIViewController
{
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    
    private var user: User
    {
        didSet
        {
            self.populate()
        }
    }
    
    init(user: User)
    {
        self.user = user
        
        super.init(nibName: nil, bundle: nil)
        
        self.title = "Profile"
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
        self.nameLabel.text = self.user.name
        self.ageLabel.text = "\(self.user.age) years old"
    }
    
    // MARK: Actions
    
    @IBAction func didTapIncrementAgeButton(sender: UIButton)
    {
        self.user.incrementAge()
    }
}

// MARK: Object Consistency

extension ProfileViewController: ConsistentEnvironment
{
    var objects: [ConsistentObject]
    {
        return [self.user]
    }
    
    func update(with object: ConsistentObject)
    {
        self.user = self.user.updated(with: object)
    }
}
