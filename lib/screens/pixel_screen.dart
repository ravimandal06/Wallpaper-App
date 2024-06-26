import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:vrit_tech/screens/pixel_detail_screen.dart';

class PixelScreen extends StatefulWidget {
  const PixelScreen({Key? key}) : super(key: key);

  @override
  _PixelScreenState createState() => _PixelScreenState();
}

class _PixelScreenState extends State<PixelScreen> {
  String apiKey = 'rxxN8DFuTO7bxctrRxCYUhGXOVqshs2wxqtnS69jz5BiAGRqZCuhu9nX';
  String query = 'nature';
  int perPage = 20;
  int page = 1; // Added page variable for pagination
  List<dynamic> photos = [];
  bool isLoading = false;
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchPhotos();
  }

  void fetchPhotos() async {
    setState(() {
      isLoading = true;
    });
    try {
      String apiUrl =
          'https://api.pexels.com/v1/search?query=$query&per_page=$perPage&page=$page';
      var response = await http.get(Uri.parse(apiUrl), headers: {
        'Authorization': apiKey,
      });

      if (response.statusCode == 200) {
        Map<String, dynamic> data = jsonDecode(response.body);
        setState(() {
          photos.addAll(data['photos']); // Append new photos
        });
      } else {
        print('Failed to load photos: ${response.statusCode}');
      }
    } catch (e) {
      print('Failed to load photos: $e');
    }
    setState(() {
      isLoading = false;
    });
  }

  void performSearch(String query) {
    setState(() {
      this.query = query;
      photos.clear();
      page = 1; // Reset page number for new search
    });
    fetchPhotos();
  }

  void navigateToDetailScreen(
    String imageUrl,
    String name,
    String auther,
    bool isLikedImage,
    String colors,
  ) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PhotoDetailScreen(
          imageUrl: imageUrl,
          imageName: name,
          auther: auther,
          isLiked: isLikedImage,
          colors: colors,
        ),
      ),
    );
  }

  void loadMorePhotos() {
    setState(() {
      page++;
    });
    fetchPhotos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        bottomOpacity: 10,
        elevation: 0.5,
        scrolledUnderElevation: 5,
        title: Text(
          "Pixel Gallery",
          style: TextStyle(
            color: Colors.black,
          ),
        ),
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
        actions: [
          IconButton(
            icon: Icon(Icons.search, size: 25.sp, color: Colors.black),
            onPressed: () {
              performSearch(searchController.text.trim());
              FocusScope.of(context).unfocus();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              height: 60.h,
              child: TextField(
                controller: searchController,
                style: const TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.r),
                      borderSide: BorderSide(
                          color: Colors.black.withOpacity(0.3),
                          width: 2,
                          style: BorderStyle.solid)),
                  fillColor: Colors.blue[100],
                  hintText: 'Search',
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      searchController.clear();
                    },
                  ),
                ),
                onSubmitted: (value) {
                  performSearch(value.trim());
                },
              ),
            ),
          ),
          Expanded(
            child: isLoading && photos.isEmpty
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : photos.isEmpty
                    ? const Center(
                        child: Text('No photos found'),
                      )
                    : Padding(
                        padding: const EdgeInsets.all(16),
                        child: GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 8.0,
                            mainAxisSpacing: 8.0,
                            childAspectRatio: 0.75,
                          ),
                          itemCount: photos.length +
                              1, // Add one more item for the button
                          itemBuilder: (context, index) {
                            if (index == photos.length) {
                              return isLoading
                                  ? const Center(
                                      child: CircularProgressIndicator())
                                  : ElevatedButton(
                                      onPressed: loadMorePhotos,
                                      child: const Text('More Images'),
                                    );
                            }
                            var photo = photos[index];
                            return GestureDetector(
                              onTap: () {
                                debugPrint("heyyy,, ${photo['alt']}");
                                navigateToDetailScreen(
                                    photo['src']['original'],
                                    photo['alt'],
                                    photo['photographer'],
                                    true,
                                    photo['avg_color']);
                              },
                              child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                elevation: 5,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(15.0),
                                  child: Image.network(
                                    photo['src']['medium'],
                                    fit: BoxFit.cover,
                                    loadingBuilder: (context, child, progress) {
                                      if (progress == null) return child;
                                      return Center(
                                        child: CircularProgressIndicator(
                                          value: progress.expectedTotalBytes !=
                                                  null
                                              ? progress.cumulativeBytesLoaded /
                                                  progress.expectedTotalBytes!
                                              : null,
                                        ),
                                      );
                                    },
                                    errorBuilder: (context, error, stackTrace) {
                                      return Center(child: Icon(Icons.error));
                                    },
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
          ),
        ],
      ),
    );
  }
}
