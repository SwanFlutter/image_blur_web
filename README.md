## ImageBlurWeb
A Flutter widget that displays an image with a blur effect on the thumbnail image and transitions to the full-resolution image with a fade animation. This widget is perfect for improving the user experience when loading images, especially on the web.


## Features
- Display a blurred thumbnail while the full image is being loaded.
- Smooth fade transition from the thumbnail to the full-resolution image.
- Fully customizable with support for:
  - Image alignment, fitting, and repeating.
  - Customizable border radius and box shadows.
  - Custom loading indicators and error widgets.
  - Custom hover effects for web platforms.
- Supports semantic labels for accessibility.
- Optional background color and tap gestures.
- High performance and flexibility, ideal for web and mobile platforms.



![20250115_051444](https://github.com/user-attachments/assets/7907c1f9-09f5-4ffc-a689-faa0302110fa)




## Getting started

- Installation
Add the dependency to your pubspec.yaml:

```yaml
dependencies:
  image_blur_web: latest_version
```

Run the following command to fetch the package:

```yaml
flutter pub get
```

Import the package into your Dart file:

```yaml
import 'package:image_blur_web/image_blur_web.dart';
```

## Usage

- Here’s an example of how to use the ImageBlurWeb widget:

```dart
import 'package:flutter/material.dart';
import 'package:image_blur_web/image_blur_web.dart';

class ExamplePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Image Blur Web Example')),
      body: Center(
        child: ImageBlurWeb(
          placeholder: AssetImage('assets/placeholder.jpg'),
          thumbnail: AssetImage('assets/thumbnail.jpg'),
          image: NetworkImage('https://example.com/full-image.jpg'),
          width: 300,
          height: 200,
          blur: 15, // Blur intensity for the thumbnail
          fadeDuration: Duration(seconds: 1), // Smooth fade duration
          borderRadius: BorderRadius.circular(12), // Rounded corners
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10,
              offset: Offset(2, 4),
            ),
          ],
          backgroundColor: Colors.grey[200], // Background color
          onTap: () {
            print('Image tapped!');
          },
          enableHover: true, // Enable hover effects for web
        ),
      ),
    );
  }
}
```

## Parameters

| Parameter               | Type                          | Default                     | Description                                                                 |
|-------------------------|-------------------------------|-----------------------------|-----------------------------------------------------------------------------|
| placeholder              | ImageProvider                 | Required                    | The placeholder image that is displayed while the thumbnail or full image is loading. |
| thumbnail               | ImageProvider                 | Required                    | The thumbnail image to display before the full-resolution image is loaded. |
| image                   | ImageProvider                 | Required                    | The final high-resolution image to display.                                |
| width                   | double                        | Required                    | The width of the widget.                                                   |
| height                  | double                        | Required                    | The height of the widget.                                                  |
| fit                     | BoxFit                       | BoxFit.cover                | How the image should fit within its bounds.                                 |
| blur                    | double                        | 20                          | The intensity of the blur effect applied to the thumbnail.                 |
| fadeDuration            | Duration                      | Duration(milliseconds: 800)  | The duration of the fade animation from the thumbnail to the full image.   |
| alignment               | AlignmentGeometry             | Alignment.center             | How to align the image within its bounds.                                   |
| repeat                  | ImageRepeat                   | ImageRepeat.noRepeat        | How the image should be repeated if it does not fill its allocated space.   |
| matchTextDirection      | bool                          | false                       | Whether to match the text direction of the surrounding layout.              |
| excludeFromSemantics    | bool                          | false                       | Whether to exclude the image from the semantics tree.                      |
| imageSemanticLabel      | String?                       | null                        | A semantic label for the image, useful for accessibility.                  |
| errorWidget             | Widget Function(BuildContext, Object)?  | null                        | Widget to display if an error occurs while loading the image.              |
| loadingBuilder          | Widget Function(BuildContext, Widget, ImageChunkEvent?)?  | null                        | Custom widget to display while the image is loading.                       |
| borderRadius            | BorderRadius?                 | null                        | The border radius of the widget, allowing for rounded corners.             |
| boxShadow               | List<BoxShadow>?              | null                        | A list of box shadows to apply to the widget.                              |
| backgroundColor         | Color?                        | null                        | The background color of the widget.                                        |
| onTap                   | VoidCallback?                 | null                        | A callback triggered when the widget is tapped.                           |
| enableHover             | bool                          | true                        | Whether to enable hover effects for web platforms.                         |


## Notes
Hover effects are only visible on platforms that support pointer devices (e.g., web or desktop).
If errorWidget is not provided, no widget will be displayed when an error occurs while loading the image.

## Example
- Full Example
Here’s a full example with all parameters:

```dart

ImageBlurWeb(
  placeholder: AssetImage('assets/placeholder.jpg'),
  thumbnail: AssetImage('assets/thumbnail.jpg'),
  image: NetworkImage('https://example.com/full-image.jpg'),
  width: 400,
  height: 250,
  fit: BoxFit.cover,
  blur: 10,
  fadeDuration: Duration(milliseconds: 1200),
  alignment: Alignment.topCenter,
  repeat: ImageRepeat.noRepeat,
  matchTextDirection: false,
  excludeFromSemantics: true,
  imageSemanticLabel: "Example Image",
  errorWidget: (context, error) => Icon(Icons.error, size: 50),
  loadingBuilder: (context, child, loadingProgress) {
    if (loadingProgress == null) return child;
    return Center(child: CircularProgressIndicator());
  },
  borderRadius: BorderRadius.circular(16),
  boxShadow: [
    BoxShadow(
      color: Colors.black45,
      blurRadius: 8,
      offset: Offset(2, 4),
    ),
  ],
  backgroundColor: Colors.grey.withOpacity(0.1),
  onTap: () {
    print('Image clicked!');
  },
  enableHover: true,
);

```


