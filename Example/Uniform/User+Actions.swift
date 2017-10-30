//
//  User+Actions.swift
//  ConsistencyTest
//
//  Created by King, Gavin on 9/27/17.
//  Copyright © 2017 Vimeo. All rights reserved.
//

import Foundation
import Uniform

extension User
{
    func incrementAge()
    {
        var builder = UserBuilder(object: self)
        builder.age += 1
        let updatedUser = builder.build()
        
        ConsistencyManager.shared.update(with: updatedUser)
    }
}
