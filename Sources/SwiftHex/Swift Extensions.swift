//
//  Swift Extensions.swift
//  SwiftHex
//
//  Created by Steffan Andrews on 2017-12-29.
//  MIT License
//  https://github.com/orchetect/SwiftHex
//

import Foundation

extension BinaryInteger {
	/// Returns a new `Hex` struct from an integer, preserving the integer type.
	public var hex: Hex<Self> {
		return Hex(self)
	}
}

extension String {
	/// Returns a new `Hex` struct from a hex string, defaulting to storing its value as Int type.
	public var hex: Hex<Int>? {
		return Hex(self)
	}
}

extension Array where Element == String {
	/// Returns an array of `Hex<Int>` structs constructed from an array of hex strings.
	public var hex: [Hex<Int>?] {
		return self.map( { Hex($0) })
	}
	
	/// Returns an array of `Int?` values translated from an array of hex strings. If any string is not a valid hex string, it will be returned as nil.
	public var valuesFromHexStrings: [Int?] {
		return self.map( { Hex<Int>($0)?.value })
	}
}

extension Collection where Element: BinaryInteger {
	/// Returns an array of `Hex` structs built from an integer array, preserving the integer type.
	public var hex: [Hex<Element>] {
		return self.map( { Hex($0) })
	}
}

extension Collection where Element: HexStringRepresentable {
	/// Returns an array of values extracted from an array of `Hex` structs.
	public var values: [Element.NumberType] {
		return self.map( { $0.value })
	}
	
	/// Convert an array of `Hex` to a concatenated String of hex string values, each value padded to two characters by default.
	public var stringValue: String {
		return self.stringValue(padTo: 2)
	}
	/// Convert an array of `Hex` to a concatenated String of hex string values, each value padded to the number of characters specified.
	public func stringValue(padTo: Int = 2, withPrefix: Bool = false) -> String {
		return self.reduce("", { String($0) + $1.stringValue(padTo: padTo, withPrefix: withPrefix) + " " }).trimmingCharacters(in: CharacterSet(charactersIn: " "))
	}
	/// Convert an array of `Hex` to a concatenated String of hex string values, each value padded to two characters or multiples of the number of characters specified.
	public func stringValue(padToEvery: Int, withPrefix: Bool = false) -> String {
		return self.reduce("", { String($0) + $1.stringValue(padToEvery: padToEvery, withPrefix: withPrefix) + " " }).trimmingCharacters(in: CharacterSet(charactersIn: " "))
	}
	
	/// Convert an array of `Hex` to an Array of hex string values, each padded to two characters by default.
	public var stringValues: [String] {
		return self.stringValues(padTo: 2)
	}
	/// Convert an array of `Hex` to an Array of hex string values, each padded to two characters the number of characters specified.
	public func stringValues(padTo: Int = 2, withPrefix: Bool = false) -> [String] {
		return self.map( { $0.stringValue(padTo: padTo, withPrefix: withPrefix) } )
	}
	/// Convert an array of `Hex` to an Array of hex string values, each value padded to two characters or multiples of the number of characters specified.
	public func stringValues(padToEvery: Int, withPrefix: Bool = false) -> [String] {
		return self.map( { $0.stringValue(padToEvery: padToEvery, withPrefix: withPrefix) } )
	}

}

