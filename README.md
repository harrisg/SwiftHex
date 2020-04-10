# SwiftHex
<p>
<a href="https://developer.apple.com/swift"><img src="https://img.shields.io/badge/Swift5.2-compatible-orange.svg?style=flat" alt="Swift 5.2 compatible" /></a>
<a href="https://raw.githubusercontent.com/uraimo/Bitter/master/LICENSE"><img src="http://img.shields.io/badge/license-MIT-blue.svg?style=flat" alt="License: MIT" /></a>
</p>

A new lightweight value type of `Hex<T>` containing any integer type (`T`) capable of being represented as hexadecimal, providing constructors and methods to translate integers to/from hex strings and vice-versa using simple, clean syntax.

## Summary

```swift
// convert to or from hex strings

255.hex.stringValue                   // "FF"
255.hex.stringValue(withPrefix: true) // "0xFF"
"FF".hex?.value                       // Optional(255)
"0xFF".hex?.value                     // Optional(255)
"ZZ".hex?.value                       // nil (not valid hex string, so init fails)

// work with arrays of any integer type, or hex strings and convert between them

[0, 255, 0, 255].hex.stringValue                      // "00 FF 00 FF"
[0, 255, 0, 255].hex.stringValues                     // ["00", "FF", "00", "FF"]
[0, 255, 0, 255].hex.stringValue(withPrefix: true)    // "0x00 0xFF 0x00 0xFF"
[0, 255, 0, 255].hex.stringValues(withPrefix: true)   // ["0x00", "0xFF", "0x00", "0xFF"]

[0, 65535, 4000].hex.stringValue                      // "00 FFFF FA0"
[0, 65535, 4000].hex.stringValue(padToEvery: 4)       // "0000 FFFF 0FA0"

["00", "FF", "ZZ"].valuesFromHexStrings               // [Optional(0), Optional(255), nil]

// nibbles: get, set, and bitwise shift

var h = 0x1F.hex
h[nibble: 0]                          // 0xF
h[nibble: 1]                          // 0x1
h[nibble: 1] = 0x7
h.value                               // 0x7F

0x1F.hex <<<< 1                       // 0x1F0 (bitwise nibble shift left)
0x10.hex >>>> 1                       // 0x1   (bitwise nibble shift right)

// test for equatability with ultimate flexibility,
// without needing to extract the .value first, casting or converting

UInt8(123).hex == Int16(123)  // true (can equate to any integer type, whether Hex<T> or not)

```



## Constructors

The `Hex<T>` struct acts as a shell around a type-preserved `BinaryInteger`:

`Hex(n)` == `Hex<T of n>(n)`

The `Hex` type can be constructed using initializers, or convenience extensions. Both are identical.

```swift
Hex(123)                  // Hex<Int>(123)
123.hex                   // Hex<Int>(123)
```

Any `BinaryInteger` type that is expressable as hexadecimal can be used.

```swift
Int(123).hex              // Hex<Int>(123)
Int8(123).hex             // Hex<Int8>(123)
UInt8(123).hex            // Hex<UInt8>(123)
Int16(123).hex            // Hex<Int16>(123)
UInt16(123).hex           // Hex<UInt16>(123)
Int32(123).hex            // Hex<Int32>(123)
UInt32(123).hex           // Hex<UInt32>(123)
Int64(123).hex            // Hex<Int64>(123)
UInt64(123).hex           // Hex<UInt64>(123)
```

A valid hexadecimal string can be used to construct the `Hex<T>` struct. This constructor returns an optional, since if the string is not valid hexadecimal, the constructor will fail and `nil` will be returned. If no integer type is specified, the type will defult to `Hex<Int>`.

```swift
Hex("FF")                 // Hex<Int>(255)?
"FF".hex                  // Hex<Int>(255)?
"0xFF".hex                // Hex<Int>(255)?

"ZZZZ".hex                // nil - not a valid hex string
```

To construct from a hex string to a specific desired internal integer value type, specify it in the constructor.

```swift
Hex<UInt8>("FF")          // Hex<UInt8>(255)?
Hex<UInt8>("FFFFFF")      // nil -- 0xFFFFFF does not fit in UInt8, so init fails
```



## Getting and Setting Values

Once the `Hex<T>` object is constructed, various methods become available.

```swift
let h = 255.hex                           // Hex<Int>(255)
h.value                                   // 255, type Int
h.stringValue                             // "FF"
h.stringValue(withPrefix: true)           // "0xFF"

h.stringValue = "7F"                      // can also set the hex String and get value...
h.value                                   // 127, type Int
```

Padding to *n* number of leading zeros can be specified if you need uniform string formatting:

```swift
0xF.hex.stringValue                       // "F"
0xF.hex.stringValue(padTo: 2)             // "0F"
0xF.hex.stringValue(padTo: 3)             // "00F"

0xFFFF.hex.stringValue(padTo: 3)          // "FFFF" - has no effect; it's > 3 places
```

It is also possible to pad leading zeros to every *n* multiple of digit places.

```swift
    0xF.hex.stringValue(padToEvery: 2)    // "0F"
   0xFF.hex.stringValue(padToEvery: 2)    // "FF"
  0xFFF.hex.stringValue(padToEvery: 2)    // "0FFF"
 0xFFFF.hex.stringValue(padToEvery: 2)    // "FFFF"

    0x1.hex.stringValue(padToEvery: 4)    // "0001"
0x12345.hex.stringValue(padToEvery: 4)    // "00012345"
```



## Related Methods

`.nibble(Int)`
`[nibble: Int] { get set }`

- gets nibble (4-byte) value at specified position right-to-left
- subscript can also be used to get or set nibble values

```swift
var h = 0x1234.hex

h.nibble(0)               // 0x4 (type T, which is Int in this case)
h.nibble(3)               // 0x1 (type T, which is Int in this case)

h[nibble: 0]              // 0x4 (type T, which is Int in this case)
h[nibble: 3]              // 0x1 (type T, which is Int in this case)
h[nibble: 3] = 0xF
h.value                   // == 0xF234
```



`.nibbleString(Int)`
`.nibbleString(Int, padTo: Int)`

- same as `nibble(Int)` but returns a hex String instead, optionally padded to specified number of places

```swift
let h = 0x1234.hex

h.nibbleString(0)             // "4"
h.nibbleString(3, padTo: 2)   // "01"
```



## Equatability

`Hex<T>` can be tested for equatability directly using typical operators (`==`, `!=`, `>`, `<`) without needing to access the `.value` property. This makes for cleaner, more convenient code.

```swift
let h1 = 10.hex        // Hex<Int>
let h2 = 20.hex        // Hex<Int>

h1.value == h2.value   // this works but it's easier to just do this...
h1 == h2               // false
```

They can be compared with great flexibility -- even between different integer types directly without requiring casting or conversions.

```swift
let h1 = 10.hex        // Hex<Int>
let h2 = 20.hex        // Hex<Int>
h1 == h2               // false  (comparing Hex<Int> with Hex<Int>)
h1 > 20                // true   (comparing Hex<Int> with Int)
h1 != UInt8(20)        // true   (comparing Hex<Int> with UInt8)

// even though "FF".hex produces an Optional,
// the comparison still works safely without requiring the optional to be unwrapped first
255.hex == "FF".hex    // true
255.hex == "ZZ".hex    // false - optional is nil
```



## Additional Operators

Additional operators similarly supported, allowing mixing of types as with equatability:

- `+=, -=, *=, /=, <<, >>, &`



## Bitwise Shifting

```swift
// traditional bit shift left/right still work as usual

0b0100.hex << 1        // 0b1000
0b0100.hex >> 1        // 0b0010

// nibble shift (multiples of 4 bits)

0x2F.hex <<<< 1        // 0x2F0    (bitwise nibble shift left)
0x2F.hex >>>> 1        // 0x2      (bitwise nibble shift right)

0xF0.hex >>>> 1        // 0xF      (bitwise nibble shift right)
0xF0.hex <<<< 4        // 0xF00000 (bitwise nibble shift left)
```



## Extensions on Arrays

Any `[BinaryInteger]` Array can be converted to an equivalent `[Hex<T>]` Array:
```swift
let a = [1, 2].hex                    // [Hex<Int>(1), Hex<Int>(2)]

let uint8array: [UInt8] = [3, 4]
let b = uint8array.hex                // [Hex<UInt8>(3), Hex<UInt8>(4)]

[UInt8](arrayLiteral: 5, 6).hex       // [Hex<UInt8>(5), Hex<UInt8>(6)]

// and back again:

a.values                              // [1, 2] of type [Int]
b.values                              // [3, 4] of type [UInt8]
```

It can also be flattened into a concatenated `String` or an array of hex `String`:
```swift
[0, 255, 0, 255].hex.stringValue                     // "00 FF 00 FF"
[0, 255, 0, 255].hex.stringValues                    // ["00", "FF", "00", "FF"]

[0, 255, 0, 255].hex.stringValue(withPrefix: true)   // "0x00 0xFF 0x00 0xFF"
[0, 255, 0, 255].hex.stringValues(withPrefix: true)  // ["0x00", "0xFF", "0x00", "0xFF"]
```

Which can be useful when debugging binary data to the console, or presenting binary data in a human-readable format easily:

```swift
let d = Data([0x1, 0x2, 0x3, 0xFF])

[UInt8](d).hex.stringValue            // "01 02 03 FF"
```

`String` arrays can also be translated into an array of `Hex<T>?` . There is no `.values` property but you can easily render the array down, or iterate over it.

```swift
["00", "0xFF", "ZZ"].hex.map({ $0?.value }))         // [Optional(0), Optional(255), nil]
["00", "0xFF", "ZZ"].hex.map({ $0?.value ?? -1 }))   // [0, 255, -1]

// or use the convenience property .hexValues

["00", "0xFF", "ZZ"].valuesFromHexStrings            // [Optional(0), Optional(255), nil]
```



## Limitations

The max integer size storable and representable as a hex `String` is `UInt64` which is the natural limitation of Swift.

```swift
Hex<UInt64>(0xFFFF_FFFF_FFFF_FFFF)
```

Negative numbers will be stored in `.value` normally but may produce unexpected hex `String`s. You do not have to exclusively use unsigned integers, but it's best to avoid using negative numbers which will have an ambigious hex representation.

> Use of, and formatting, negative numbers may be expanded in future updates to SwiftHex, or if you feel generous, feel free to tackle this and submit your code.

```swift
(-1).hex.value         // -1
(-1).hex == -1         // true
(-1).hex               // 0xFFFFFFFFFFFFFFFF
```

