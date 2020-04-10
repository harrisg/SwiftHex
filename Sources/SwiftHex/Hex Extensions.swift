//
//  Hex Extensions.swift
//  SwiftHex
//
//  Created by Steffan Andrews on 2017-12-29.
//  MIT License
//  https://github.com/orchetect/SwiftHex
//

import Foundation

extension Hex: Hashable {

    public func hash(into hasher: inout Hasher) {
        hasher.combine(Int(exactly: value) ?? 0)
    }
}
