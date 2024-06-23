import 'package:async_wallpaper/async_wallpaper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vrit/service/liked_images.dart';
import 'package:wallpaper/wallpaper.dart';

class PhotoDetailScreen extends StatefulWidget {
  final String imageUrl;

  const PhotoDetailScreen({Key? key, required this.imageUrl}) : super(key: key);

  @override
  State<PhotoDetailScreen> createState() => _PhotoDetailScreenState();
}

class _PhotoDetailScreenState extends State<PhotoDetailScreen> {
  String home = "Home Screen",
      lock = "Lock Screen",
      both = "Both Screen",
      system = "System";

  var result = "Waiting to set wallpaper";
  bool _isDisable = false;

  late Stream<String> progressString;
  late String res;
  bool downloading = false;

  String _wallpaperUrlHome = 'Unknown';
  late bool goToHome;
  final String _platformVersion = 'Unknown';

  @override
  void initState() {
    super.initState();
    goToHome = false;
  }

  void likeImage(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Image liked!'),
        duration: Duration(seconds: 2),
      ),
    );
    LikedPhotoService.addLikedPhoto(widget.imageUrl); // Store liked photo
  }

  Future<void> setWallpaperHome() async {
    setState(() {
      _wallpaperUrlHome = 'Loading';
    });

    try {
      bool result = await AsyncWallpaper.setWallpaper(
        url: widget.imageUrl,
        wallpaperLocation: AsyncWallpaper.HOME_SCREEN,
        goToHome: goToHome,
        toastDetails: ToastDetails.success(),
        errorToastDetails: ToastDetails.error(),
      );

      if (result) {
        setState(() {
          _wallpaperUrlHome = 'Wallpaper set successfully!';
        });
      } else {
        setState(() {
          _wallpaperUrlHome = 'Failed to set wallpaper.';
        });
      }
    } on PlatformException catch (e) {
      setState(() {
        _wallpaperUrlHome = 'Failed to set wallpaper: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Photo Detail'),
        actions: [
          IconButton(
            icon: const Icon(Icons.wallpaper),
            onPressed: () {
              // setWallpaper(context);
              setWallpaperHome();
            },
          ),
          IconButton(
            icon: const Icon(Icons.favorite),
            onPressed: () {
              likeImage(context);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.network(widget.imageUrl),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: downloading
                    ? null
                    : () async {
                        setState(() {
                          downloading = true;
                        });
                        try {
                          both = await Wallpaper.homeScreen();
                          dowloadImage(
                              context); // Replace with your download image logic

                          setState(() {
                            downloading = false;
                            both = 'Wallpaper Set'; // Update state as needed
                          });
                          print('Task Done');
                        } catch (e) {
                          debugPrint("printing the error cached here $e");
                        }
                      },
                child: Text(both),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  likeImage(context);
                },
                child: const Text('Like Image'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> dowloadImage(BuildContext context) async {
    progressString = Wallpaper.imageDownloadProgress(widget.imageUrl);
    progressString.listen((data) {
      setState(() {
        res = data;
        downloading = true;
      });
      print("DataReceived: $data");
    }, onDone: () async {
      setState(() {
        downloading = false;

        _isDisable = false;
      });
      print("Task Done");
    }, onError: (error) {
      setState(() {
        downloading = false;
        _isDisable = true;
      });
      print("Some Error");
    });
  }

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
