import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/file.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vrit_tech/screens/liked_images_screen.dart';
import 'package:vrit_tech/service/liked_images.dart';
import 'package:shimmer/shimmer.dart';
import 'package:http/http.dart' as http;
import 'dart:typed_data';
// import 'package:wallpaper_manager_flutter/wallpaper_manager_flutter.dart';

class PhotoDetailScreen extends StatefulWidget {
  final String imageUrl;
  final String imageName;
  final String auther;
  final bool isLiked;
  final String colors;

  const PhotoDetailScreen({
    Key? key,
    required this.imageUrl,
    required this.imageName,
    required this.auther,
    required this.isLiked,
    required this.colors,
  }) : super(key: key);

  @override
  State<PhotoDetailScreen> createState() => _PhotoDetailScreenState();
}

class _PhotoDetailScreenState extends State<PhotoDetailScreen> {
  static const platform = MethodChannel('example.com/channel');
  String home = "home",
      lock = "Lock Screen",
      both = "Both Screen",
      system = "System";

  var result = "Waiting to set wallpaper";
  final bool _isDisable = false;

  late Stream<String> progressString;
  late String res;
  bool downloading = false;

  final String _wallpaperUrlHome = 'Unknown';
  late bool goToHome;

  bool _isLiked = false;
  final bool _isLoading = true;

  //
  final String _platformVersion = 'Unknown';
  final String __heightWidth = "Unknown";

  @override
  void initState() {
    super.initState();
    _loadLikeStatus();
    goToHome = false;
  }


  void likeImage(BuildContext context) async {
    setState(() {
      _isLiked = !_isLiked;
    });
    if (_isLiked) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Image liked!'),
          duration: Duration(seconds: 2),
        ),
      );
      LikedPhotoService.addLikedPhoto(widget.imageUrl, widget.imageName,
          widget.auther); // Store liked photo
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(widget.imageUrl, _isLiked);
  }
  Future<void> _loadLikeStatus() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isLiked = prefs.getBool(widget.imageUrl) ?? widget.isLiked;
    });
  }

  Future<void> _setWallpaper() async {
    try {
      debugPrint("printing first ${widget.imageUrl}");
      await platform.invokeMethod('setWallpaper', widget.imageUrl);
    } on PlatformException catch (e) {
      print(
          "From pixel details screen - Failed to set wallpaper: '${e.message}'.");
    }
  }

  // Future<void> setWallpaper() async {
  //   try {
  //     // Retrieve the cached image file
  //     File cachedImage =
  //         await DefaultCacheManager().getSingleFile(widget.imageUrl);

  //     // Choose screen type
  //     int location = WallpaperManagerFlutter.HOME_SCREEN;

  //     // Set wallpaper from file
  //     await WallpaperManagerFlutter()
  //         .setwallpaperfromFile(cachedImage, location);

  //     print('Wallpaper set successfully');
  //   } catch (e) {
  //     print('Error setting wallpaper: $e');
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        bottomOpacity: 10,
        elevation: 0.5,
        scrolledUnderElevation: 5,
        title: const Text(
          "Photo Details",
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        leading: GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.black,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.favorite,
              size: 25.sp,
              color: const Color.fromARGB(255, 255, 147, 147),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => LikedPhotosScreen(
                          isLikedScreen: true,
                        )),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(32).add(EdgeInsets.only(top: 30.h)),
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(25.r),
                        topRight: Radius.circular(25.r)),
                    child:
                    Image.network(
                      widget.imageUrl,
                      fit: BoxFit.cover,
                      width: MediaQuery.of(context).size.width,
                      height: 350.h,
                      loadingBuilder: (BuildContext context, Widget child,
                          ImageChunkEvent? loadingProgress) {
                        if (loadingProgress == null) {
                          return child;
                        } else {
                          var c = widget.colors;
                          var co = '0xff${c.substring(1)}';
                          return Shimmer.fromColors(
                            baseColor: Colors.grey[200]!,
                            highlightColor: Colors.white,
                            enabled: true,
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              height: 300.h,
                              color: Colors.grey[200]!,
                            ),
                          );
                        }
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(Icons.error);
                      },
                      frameBuilder:
                          (context, child, frame, wasSynchronouslyLoaded) {
                        if (wasSynchronouslyLoaded) {
                          return child;
                        } else {
                          return AnimatedOpacity(
                            opacity: frame == null ? 0 : 1,
                            duration: const Duration(seconds: 1),
                            curve: Curves.easeOut,
                            child: child,
                          );
                        }
                      },
                    ),

                  ),
                  AnimatedContainer(
                    duration: const Duration(seconds: 1),
                    curve: Curves.easeIn,
                    width: MediaQuery.of(context).size.width,
                    height: 60.h,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: const [
                        BoxShadow(
                            color: Colors.black12,
                            blurRadius: 7,
                            spreadRadius: 2,
                            offset: Offset(0, 4))
                      ],
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(25.r),
                          bottomRight: Radius.circular(25.r)),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        GestureDetector(
                          onTap: _setWallpaper,
                          child: AnimatedContainer(
                            duration: const Duration(microseconds: 400),
                            curve: Curves.easeIn,
                            height: 65.h,
                            decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 255, 218, 218),
                                borderRadius: BorderRadius.circular(10.r)),
                            margin: const EdgeInsets.all(10),
                            child: Padding(
                              padding: EdgeInsets.only(left: 10.w, right: 10.w),
                              child: Row(
                                children: [
                                  const Icon(Icons.wallpaper_rounded),
                                  SizedBox(
                                    width: 15.w,
                                  ),
                                  Text(
                                    "Set Wallpaper",
                                    style: TextStyle(
                                        fontSize: 16.sp,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w400),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            likeImage(context);
                          },
                          child: AnimatedContainer(
                            duration: const Duration(seconds: 1),
                            curve: Curves.easeIn,
                            height: 65.h,
                            decoration: BoxDecoration(
                                color: const Color(0xFFFFDADA),
                                borderRadius: BorderRadius.circular(10.r)),
                            margin: const EdgeInsets.all(10),
                            child: Padding(
                              padding: EdgeInsets.only(left: 10.w, right: 10.w),
                              child: Row(
                                children: [
                                  Icon(_isLiked
                                      ?Icons.favorite_rounded: Icons.favorite_outline_rounded
                                  ),
                                  SizedBox(
                                    width: 15.w,
                                  ),
                                  Text(
                                    _isLiked ? "Liked" : "Like",
                                    style: TextStyle(
                                        fontSize: 16.sp,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w400),
                                  )
                                ],
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Future<void> dowloadImage(BuildContext context) async {
  //   progressString = Wallpaper.imageDownloadProgress(widget.imageUrl);
  //   progressString.listen((data) {
  //     setState(() {
  //       res = data;
  //       downloading = true;
  //     });
  //     print("DataReceived: $data");
  //   }, onDone: () async {
  //     setState(() {
  //       downloading = false;

  //       // _isDisable = false;
  //     });
  //     print("Task Done");
  //   }, onError: (error) {
  //     setState(() {
  //       downloading = false;
  //       // _isDisable = true;
  //     });
  //     print("Some Error");
  //   });
  // }

  Widget imageDownloadDialog() {
    return SizedBox(
      height: 120.0,
      width: 200.0,
      child: Card(
        color: Colors.black,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const CircularProgressIndicator(),
            const SizedBox(height: 20.0),
            Text(
              "Downloading File : $res",
              style: const TextStyle(color: Colors.white),
            )
          ],
        ),
      ),
    );
  }
}
