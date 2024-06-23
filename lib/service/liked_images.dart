import 'package:vrit/model/liked_images_model.dart';
import 'package:vrit/screens/pixel_detail_screen.dart';

class LikedPhotoService {
  static List<LikedPhoto> _likedPhotos = [];

  static List<LikedPhoto> get likedPhotos => _likedPhotos;

  static void addLikedPhoto(String imageUrl) {
    _likedPhotos.add(LikedPhoto(
      imageUrl: imageUrl,
      likedDate: DateTime.now(),
    ));
  }
}
