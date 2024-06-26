import 'package:vrit/model/liked_images_model.dart';

class LikedPhotoService {
  static List<LikedPhoto> _likedPhotos = [];

  static List<LikedPhoto> get likedPhotos => _likedPhotos;

  static void addLikedPhoto(
      String imageUrl, String name, String author, bool isLiked) {
    _likedPhotos.add(LikedPhoto(
      imageUrl: imageUrl,
      name: name,
      likedDate: DateTime.now(),
      by: author,
      likedImage: isLiked,
    ));
  }

  static void removeLikedPhoto(String imageUrl) {
    _likedPhotos.removeWhere((photo) => photo.imageUrl == imageUrl);
  }
}
