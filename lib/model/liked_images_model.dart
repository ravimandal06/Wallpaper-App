class LikedPhoto {
  final String imageUrl;
  final DateTime likedDate;
  final String name;
  final String by;
  final bool likedImage;

  LikedPhoto({
    required this.imageUrl,
    required this.likedDate,
    required this.name,
    required this.by,
    required this.likedImage,
  });
}
