# Persist

Persist is a RxSwift helper for persisting stuff line (Codable) Encodable-Decodable, UIImage (.png or .jpg) along with Data into disk.

  - Supports Coddable (Encodable or Decodable)
  - UIImage as .jpg or .png
  - Data as binary
  - Can add Folder or File hierarchy easily

# New Features (v1.0.0)

  - RxSwift 4.5 for Swift 4.2 support
  - Lazy initialization on call (not allocated on memory until needed)

Easy to use interface on access only allocation with singleton pattern, you can even expend image caching into more robust way with this read and write operations.

### Tech

Persist uses open source project to work properly:

* [RxSwift](https://github.com/ReactiveX/RxSwift) - Checkout RxSwift on github

### Installation

Persist requires [Swift4.2](https://swift.org/blog/swift-4-2-released/)

Install Persist via CocoaPods.

```pod
pod 'Persist', :git => "https://github.com/droideveloper/Persist", :branch => "release/1.0.0"
```

### How to use

```swift
let persist = Persist.default()
// create file inside of documents folder (there are some more options in here, including more paths)
let file = File.create(.document, name: "people.cache")

// if we read array
let disposable: Disposable = persist.readAsync(file) { people: [Person] in 
    // we can grab our array in here
}
// if we read single object
let disposable: Disposable = persist.readAsync(file) { person: Person in
    // we can grab our person in here
}

// if we want to cancel operation of reading before compeleted, RxSwift will be help
disposable.dispose()

// example object
struct Person: Codable {
    var name: String?
    var surname: String?
}

```

License
----

MIT

Copyright 2019, Fatih Şen (aka [droideveloper](https://github.com/droideveloper))

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
