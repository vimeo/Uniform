//
//  TabBarController.swift
//  Uniform_Example
//
//  Created by King, Gavin on 9/27/17.
//  Copyright © 2017 Vimeo. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController
{
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        let canon7D = Camera(id: "1", name: "Canon 7D")

        let basicBadge = Badge(id: "1", type: "basic")
        let staffBadge = Badge(id: "2", type: "staff")
        
        let gavin = User(id: "1", name: "Gavin King", age: 67, badge: staffBadge, camera: canon7D)
        let nivag = User(id: "2", name: "Nivag Gnik", age: 42, badge: basicBadge, camera: canon7D)
        
        let video1 = Video(id: "1", title: "Video 1", user: nivag)
        let video2 = Video(id: "2", title: "Video 2", user: gavin)
        let video3 = Video(id: "3", title: "Video 3", user: nivag)
        let video4 = Video(id: "4", title: "Video 4", user: gavin)
        let video5 = Video(id: "5", title: "Video 5", user: gavin)
            
        let videosViewController = VideosViewController(videos: [video1, video2, video3, video4, video5])
        let profileViewController = ProfileViewController(user: gavin)

        let tab1 = UINavigationController(rootViewController: videosViewController)
        let tab2 = UINavigationController(rootViewController: profileViewController)
        
        self.viewControllers = [tab1, tab2]
    }
}
