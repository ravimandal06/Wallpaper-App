import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:vrit/screens/pixel_detail_screen.dart';

class PixelScreen extends StatefulWidget {
  const PixelScreen({Key? key}) : super(key: key);

  @override
  _PixelScreenState createState() => _PixelScreenState();
}

class _PixelScreenState extends State<PixelScreen> {
  String apiKey = 'rxxN8DFuTO7bxctrRxCYUhGXOVqshs2wxqtnS69jz5BiAGRqZCuhu9nX';
  String query = 'nature';
  int perPage = 20;
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
          'https://api.pexels.com/v1/search?query=$query&per_page=$perPage';
      var response = await http.get(Uri.parse(apiUrl), headers: {
        'Authorization': apiKey,
      });

      if (response.statusCode == 200) {
        Map<String, dynamic> data = jsonDecode(response.body);
        setState(() {
          photos = data['photos'];
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
    });
    fetchPhotos();
  }

  void navigateToDetailScreen(String imageUrl) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PhotoDetailScreen(imageUrl: imageUrl),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
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
            child: TextField(
              controller: searchController,
              style: const TextStyle(color: Colors.black),
              decoration: InputDecoration(
                border: InputBorder.none,
                enabledBorder: const OutlineInputBorder(),
                fillColor: Colors.blue[100],
                hintText: 'Enter search keyword...',
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
          Expanded(
            child: isLoading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : photos.isEmpty
                    ? const Center(
                        child: Text('No photos found'),
                      )
                    : ListView.builder(
                        itemCount: photos.length,
                        itemBuilder: (context, index) {
                          var photo = photos[index];
                          return GestureDetector(
                            onTap: () {
                              navigateToDetailScreen(photo['src']['original']);
                            },
                            child: ListTile(
                              title: Image.network(photo['src']['medium']),
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}
