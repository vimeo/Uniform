//
//  Model.swift
//  ConsistencyTest
//
//  Created by King, Gavin on 9/25/17.
//  Copyright © 2017 Vimeo. All rights reserved.
//

// MARK: Model

protocol Model
{
    var id: String { get }
}

// MARK: Builder

enum BuilderError: Error
{
    case invalidType
    case invalidProperty
}

protocol Builder
{
    associatedtype ModelType

    init(object: ModelType)

    func build() -> ModelType

    mutating func set(property label: String, with value: Any) throws
}
