# SwiftUI Drawer

A SwiftUI bottom-up controller, like in the Maps app. Drag to expand or minimize.

<img src=https://raw.githubusercontent.com/maustinstar/swiftui-drawer/master/Docs/Media/white-drawer.gif width=200 align="right" />

## Contents

- [Add the Package](#package)
- [Basic Usage](#basic-usage)
- [Examples](#examples)
- [Credits](#credits)

## Package

### For Xcode Projects

File > Swift Packages > Add Package Dependency: https://github.com/maustinstar/swiftui-drawer

### For Swift Packages

Add a dependency in your your `Package.swift`

```swift
.package(url: "https://github.com/maustinstar/swiftui-drawer.git", from: "0.1.0"),
```

## Basic Usage

Embed your view content in a `ZStack` with the Drawer as the last element. The `heights` parameter defines a list of resting heights for the drawer.

```swift
ZStack {

    ScrollView {
        //...
    }
    
    Drawer(heights: [100, 340]) {
        Color.blue
    }.edgesIgnoringSafeArea(.vertical)
}
```

**See the full [Reference Guide](https://github.com/maustinstar/swiftui-drawer/blob/master/Docs/Reference.md).**

## Examples

<img src=https://raw.githubusercontent.com/maustinstar/swiftui-drawer/master/Docs/Media/white-drawer.gif width=200 align="right" />

A multi-height drawer with haptic impact.

```swift
Drawer {
    ZStack {
        
        RoundedRectangle(cornerRadius: 12)
            .foregroundColor(.white)
            .shadow(radius: 100)
        
        VStack(alignment: .center) {
            Spacer().frame(height: 4.0)
            RoundedRectangle(cornerRadius: 3.0)
                .foregroundColor(.gray)
                .frame(width: 30.0, height: 6.0)
            Spacer()
        }
    }
}.edgesIgnoringSafeArea(.vertical)
.rest(at: .constant([100, 340, UIScreen.main.bounds.height - 40]))
.impact(.light)
```
**See more [Examples](https://github.com/maustinstar/swiftui-drawer/blob/master/Docs/Examples.md)**

## 🚀 Looking for more fun SwiftUI Packages?

**Take your SwiftUI apps to the next level with these Packages!**

<a href="https://github.com/maustinstar/shiny">
  <img src="https://github-readme-stats.vercel.app/api/pin/?username=maustinstar&repo=shiny" height=130 align="left" />
</a>

<a href="https://github.com/maustinstar/liquid">
  <img src="https://github-readme-stats.vercel.app/api/pin/?username=maustinstar&repo=liquid" height=130 />
</a>

## Credits

* [**Michael Verges**](https://github.com/maustinstar) - *Initial work* - mverges3@gatech.edu
