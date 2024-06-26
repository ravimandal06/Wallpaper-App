import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vrit_tech/service/liked_images.dart';

class LikedPhotosScreen extends StatefulWidget {
  LikedPhotosScreen({super.key, this.isLikedScreen = false});
  bool isLikedScreen;

  @override
  _LikedPhotosScreenState createState() => _LikedPhotosScreenState();
}

class _LikedPhotosScreenState extends State<LikedPhotosScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.isLikedScreen
          ? AppBar(
              backgroundColor: Colors.white,
              leading: GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: Colors.black,
                ),
              ),
            )
          : null,
      body: LikedPhotoService.likedPhotos.isEmpty
          ? const Center(
              child: Text('No liked photos'),
            )
          : ListView.builder(
              itemCount: LikedPhotoService.likedPhotos.length,
              itemBuilder: (context, index) {
                final likedPhoto = LikedPhotoService.likedPhotos[index];
                return Dismissible(
                  key: Key(likedPhoto.imageUrl),
                  direction: DismissDirection.endToStart,
                  onDismissed: (direction) {
                    setState(() {
                      LikedPhotoService.removeLikedPhoto(likedPhoto.imageUrl);
                    });

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Photo removed from liked!'),
                      ),
                    );
                  },
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: const Icon(
                      Icons.delete,
                      color: Colors.white,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Container(
                      height: 130.h,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: const Color.fromARGB(255, 247, 213, 213),
                            blurRadius: 10.r,
                            offset: const Offset(0, 5),
                          )
                        ],
                        borderRadius: BorderRadius.circular(25.r),
                      ),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 120.w,
                            height: 130.h,
                            child: ClipRRect(
                              borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(25.r),
                                  topLeft: Radius.circular(25.r)),
                              child: Image.network(
                                likedPhoto.imageUrl,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10.w,
                          ),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  likedPhoto.name,
                                  style: TextStyle(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.black),
                                ),
                                Text(
                                  "By ${likedPhoto.by}",
                                  style: TextStyle(
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.black),
                                ),
                              ],
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                LikedPhotoService.removeLikedPhoto(
                                    likedPhoto.imageUrl);
                              });

                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Photo removed from liked!'),
                                ),
                              );
                            },
                            child: Container(
                              width: 44.w,
                              decoration: BoxDecoration(
                                color: Colors.grey[100],
                                borderRadius: BorderRadius.only(
                                  bottomRight: Radius.circular(25.r),
                                  topRight: Radius.circular(25.r),
                                ),
                              ),
                              child: Center(
                                child: Icon(
                                  Icons.favorite_rounded,
                                  color: Colors.pink[400],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
