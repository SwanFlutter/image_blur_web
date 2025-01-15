// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:image_blur_web/image_blur_web.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ImageBlurWeb Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.dark,
      ),
      home: ImageGalleryPage(),
    );
  }
}

class ImageGalleryPage extends StatefulWidget {
  const ImageGalleryPage({super.key});

  @override
  _ImageGalleryPageState createState() => _ImageGalleryPageState();
}

class _ImageGalleryPageState extends State<ImageGalleryPage> {
  final List<ImageItem> images = [
    ImageItem(
      thumbnailUrl: 'https://picsum.photos/id/1/200/200',
      imageUrl: 'https://picsum.photos/id/1/800/800',
      title: 'Nature 1',
    ),
    ImageItem(
      thumbnailUrl: 'https://picsum.photos/id/2/200/200',
      imageUrl: 'https://picsum.photos/id/2/800/800',
      title: 'Nature 2',
    ),
    ImageItem(
      thumbnailUrl: 'https://picsum.photos/id/3/200/200',
      imageUrl: 'https://picsum.photos/id/3/800/800',
      title: 'Nature 3',
    ),
    // Add more images...
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Image Gallery'),
        elevation: 0,
      ),
      body: GridView.builder(
        padding: EdgeInsets.all(16),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: MediaQuery.of(context).size.width > 600 ? 3 : 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 1,
        ),
        itemCount: images.length,
        itemBuilder: (context, index) {
          return ImageGridItem(imageItem: images[index]);
        },
      ),
    );
  }
}

class ImageGridItem extends StatelessWidget {
  final ImageItem imageItem;

  const ImageGridItem({
    super.key,
    required this.imageItem,
  });

  @override
  Widget build(BuildContext context) {
    return ImageBlurWeb(
      placeholder: AssetImage('assets/placeholder.jpg'),
      thumbnail: NetworkImage(imageItem.thumbnailUrl),
      image: NetworkImage(imageItem.imageUrl),
      width: double.infinity,
      height: double.infinity,
      fit: BoxFit.cover,
      blur: 20,
      fadeDuration: Duration(milliseconds: 500),
      borderRadius: BorderRadius.circular(12),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.2),
          blurRadius: 8,
          offset: Offset(0, 4),
        ),
      ],
      backgroundColor: Colors.grey[900],
      enableHover: true,
      onTap: () => showFullScreenImage(context),
      errorWidget: (context, error) => Container(
        color: Colors.grey[800],
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, color: Colors.red, size: 40),
            SizedBox(height: 8),
            Text(
              'Error loading image',
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return Stack(
          children: [
            child,
            Positioned.fill(
              child: Container(
                color: Colors.black26,
                child: Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void showFullScreenImage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FullScreenImageView(imageItem: imageItem),
      ),
    );
  }
}

class FullScreenImageView extends StatelessWidget {
  final ImageItem imageItem;

  const FullScreenImageView({
    super.key,
    required this.imageItem,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(imageItem.title),
      ),
      body: Center(
        child: InteractiveViewer(
          minScale: 0.5,
          maxScale: 4.0,
          child: Hero(
            tag: imageItem.imageUrl,
            child: ImageBlurWeb(
              placeholder: NetworkImage(imageItem.thumbnailUrl),
              thumbnail: NetworkImage(imageItem.thumbnailUrl),
              image: NetworkImage(imageItem.imageUrl),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              fit: BoxFit.contain,
              blur: 0,
              enableHover: false,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Stack(
                  children: [
                    child,
                    Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class ImageItem {
  final String thumbnailUrl;
  final String imageUrl;
  final String title;

  ImageItem({
    required this.thumbnailUrl,
    required this.imageUrl,
    required this.title,
  });
}
