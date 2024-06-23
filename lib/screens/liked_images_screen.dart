import 'package:flutter/material.dart';
import 'package:vrit/service/liked_images.dart';

class LikedPhotosScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Liked Photos'),
      ),
      body: ListView.builder(
        itemCount: LikedPhotoService.likedPhotos.length,
        itemBuilder: (context, index) {
          final likedPhoto = LikedPhotoService.likedPhotos[index];
          return ListTile(
            title: Text(likedPhoto.imageUrl),
            subtitle: Text('Liked on ${likedPhoto.likedDate.toString()}'),
            leading: Image.network(likedPhoto.imageUrl),
          );
        },
      ),
    );
  }
}
