#  Examples

## Basic Usage

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

## Multi-height drawer with haptic impact

<img src=https://raw.githubusercontent.com/maustinstar/swiftui-drawer/blob/master/Docs/Media/white-drawer.gif width=200 />

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

<img src=https://raw.githubusercontent.com/maustinstar/swiftui-drawer/blob/master/Docs/Media/blue-drawer.gif width=200 />

A basic two-height drawer.

```swift
Drawer {
    Color.blue
}.rest(at: .constant([100, 340]))
```
