# SwiftUI Drawer

A SwiftUI bottom-up controller, like in the Maps app. Drag to expand or minimize.

<img src=Previews/white-drawer.gif width=200 />

## Contents

- [Add the Package](#package)
- [Usage](#usage)
- [View Modifiers](#view-modifiers)
    - [`rest`](#rest)
    - [`width`](#width)
    - [`alignment`](#alignment)
    - [`impact`](#impact)
    - [`spring`](#spring)
    - [`locked`](#locked)
    - [`onRest`](#onrest)
    - [`onLayoutForSizeClass`](#onlayoutforsizeclass)
- [Example 1](#example-1)
- [Example 2](#example-2)

## Package

Add a dependency in your your `Package.swift`

```swift
.package(url: "https://github.com/maustinstar/swiftui-drawer.git", from: "0.0.4"),
```

## Usage

Embed your view content in a `ZStack` with the Drawer as the last element. The `heights` parameter defines a list of resting heights for the drawer.

```swift
ZStack {

    ScrollView {
        //...
    }
    
    Drawer(heights: [100, 340]) {
        Color.blue
    }
}
```

## View Modifiers

Following SwiftUI's declarative syntax, these view modifiers return a modified Drawer.

### Rest

#### 🛏️ `rest(at heights: Binding<[CGFloat]>) -> Drawer`

Sets the active possible resting heights of the drawer.


**Usage**
Set a spring distance
```swift
Drawer {
    Color.blue
}.rest(at: $heights)
```

### Width

#### 📏 `width(_: Binding<CGFloat?>) -> Drawer`

Defines a width for the drawer when not in fullscreen alignment.

**Usage**
```swift
Drawer(heights: [100, 340]) {
    Color.blue
}.width(.constant(340))
```

### Alignment

#### 📐 `alignment(_: Binding<DrawerAlignment>) -> Drawer`

Defines the horizontal alignment for the drawer. Default is fullscreen.

**Alignment**
```swift
public enum DrawerAlignment {
    case leading, center, trailing, fullscreen
}
```

**Usage**
```swift
Drawer(heights: [100, 340]) {
    Color.blue
}
.width(.constant(340))
.alignment($alignment)
```

### Impact

#### 💥 `impact(_: UIImpactFeedbackGenerator.FeedbackStyle) -> Drawer`

Sets the haptic impact of the drawer when resting.

**Feedback Style**
Choose from the possible impact styles. [Apple Docs](https://developer.apple.com/documentation/uikit/uiimpactfeedbackgenerator/feedbackstyle)
```swift
public enum FeedbackStyle : Int {

    /// A collision between small, light user interface elements.
    case light = 0
    
    /// A collision between moderately sized user interface elements.
    case medium = 1
    
    /// A collision between large, heavy user interface elements.
    case heavy = 2
    
    @available(iOS 13.0, *)
    case soft = 3
    
    @available(iOS 13.0, *)
    case rigid = 4
}
```

**Usage**
```swift
Drawer(heights: [100, 340]) {
    Color.blue
}.impact(.light)
```

### Spring

#### 🪀 `spring(_: CGFloat) -> Drawer`

Sets the springiness of the drawer when pulled past boundaries.

**Spring Level**
A positive number, in pixels, to define how far the drawer can be streched beyond bounds.

A spring of 0 will not let the user drag the drawer beyond the bound of the minimum and maximum heights.

A positive spring level will allow users to pull the drawer a specified number of pixels beyond the bounds. The user's drag displacement is transformed by a [logistic curve](https://en.wikipedia.org/wiki/Logistic_function) for a natural hard-spring pull that reaches an asymptote.

Default is 12px.

**Usage**
Set a spring distance
```swift
Drawer(heights: [100, 340]) {
    Color.blue
}.spring(20)
```

Toggle a spring distance
```swift
Drawer(heights: [100, 340]) {
    Color.blue
}.spring(isSpringy ? 0 : 20)
```

### Locked

#### 🔒 `locked(_: Binding<Bool>, to height: @escaping (_ restingHeight: CGFloat) -> CGFloat) -> Drawer`

Locks the drawer in a controlled position. When set to true, the drawer will animate into the locked height.

**isLocked**
A Binding Bool indicating if the drawer should be locked.

**height**
A closure returning the height to lock the drawer. The closure's argument is the drawer's current resting height.

**Usage**
Lock into a fixed position.
```swift
Drawer(heights: [100, 340]) {
    Color.blue
}.locked($locked) {_ in
    return 30
}
```

Lock into the current resting height
```swift
Drawer(heights: [100, 340]) {
    Color.blue
}.locked($locked) { (current) in
    return current
}
```

### OnRest

#### 😴 `onRest(_: @escaping (_ height: CGFloat) -> ()) -> Drawer`

A callback to receive updates when the drawer reaches a new resting level.

**Closure**
This closure is executed every time the drawer reaches a new resting hieght. Use this when you want to receive updates on the drawer's changes. 

**Usage**
Lock into a fixed position.
```swift
Drawer(heights: [100, 340]) {
    Color.blue
}.onRest { (restingHeight) in
    print(restingHeight)
}
```

### OnLayoutForSizeClass

#### 🔄 `onLayoutForSizeClass(_: @escaping (SizeClass) -> ()) -> Drawer`

A callback to receive updates when the drawer is layed out for a new size class.

**Closure**
This closure is executed every time the device layout changes (portrait, landscape, and splitview).
Use this to modify your view when the drawer's layout changes. 

**Usage**
Alter the resting heights and alignment when the screen layout changes.
```swift
Drawer(heights: [100, 340]) {
    Color.blue
}
.rest(at: $heights)
.width(.constant(340))
.alignment($alignment)
.onLayoutForSizeClass { (sizeClass) in
    switch (sizeClass.horizontal, sizeClass.vertical) {
    case (.compact, .compact):
        // smaller iPhone landscape
        self.heights = [100, UIScreen.main.bounds.height - 40]
        self.alignment = .trailing
        break
    case (.compact, .regular):
        // iPhone portrait
        // iPad portrait splitview
        // iPad landscape smaller splitview
        self.heights = [100, 340, UIScreen.main.bounds.height - 40]
        self.alignment = .fullscreen
        break
    case (.regular, .compact):
        // larger iPhone landscape
        self.heights = [100, UIScreen.main.bounds.height - 40]
        self.alignment = .trailing
        break
    case (.regular, .regular):
        // iPad fullscreen
        // iPad landscape larger splitview
        self.heights = [100, UIScreen.main.bounds.height - 40]
        self.alignment = .trailing
        break
    default:
        // Unknown layout
        break
    }
}
```

## Example 1

<img src=Previews/white-drawer.gif width=200 />

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
}
.rest(at: .constant([100, 340, UIScreen.main.bounds.height - 40]))
.impact(.light)
```

## Example 2

<img src=Previews/blue-drawer.gif width=200 />

A basic two-height drawer.

```swift
Drawer {
    Color.blue
}.rest(at: .constant([100, 340]))
```

## Authors

* [**Michael Verges**](https://github.com/maustinstar) - *Initial work* - mverges3@gatech.edu
