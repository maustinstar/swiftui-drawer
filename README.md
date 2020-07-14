# SwiftUI Drawer

A SwiftUI bottom-up controller, like in the Maps app. Drag to expand or minimize.

## Package

Add a dependency in your your `Package.swift`

`.package(url: "https://github.com/maustinstar/swiftui-drawer.git", from: "0.0.0"),`

## Usage

Embed your view content in a `ZStack` with the Drawer as the last element.

```
ZStack {

    ScrollView {
        //...
    }
    
    Drawer(heights: [100, 340]) {
        Color.blue
    }
}
```

## Example 1


<img src=Previews/white-drawer.mov width=200 />

```
Drawer(heights: [100, 340, UIScreen.main.bounds.height - 40]) {
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
```

## Example 2

<img src=Previews/blue-drawer.mov width=200 />

```
Drawer(heights: [100, 340]) {
    Color.blue
}
```

## Authors

* [**Michael Verges**](https://github.com/maustinstar) - *Initial work* - mverges3@gatech.edu
