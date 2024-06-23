import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vrit/main.dart';
import 'package:vrit/widgets/form_field.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  TextEditingController dobController_ = TextEditingController();
  final CollectionReference _reference =
      FirebaseFirestore.instance.collection('vrit');
  bool _uploading = false;
  File? _imageFile;
  String downloadUrl = '';
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
        debugPrint("printing here $_imageFile");
        _uploadFile();
      });
    }
  }

  void _showPickerDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.blue[300],
          title: const Text('Select Image Source'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Gallery'),
                onTap: () {
                  _pickImage(ImageSource.gallery);
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Camera'),
                onTap: () {
                  _pickImage(ImageSource.camera);
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _uploadFile() async {
    // final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (_imageFile == null) return;

    setState(() {
      _uploading = true;
    });

    try {
      final storageRef =
          FirebaseStorage.instance.ref('images/${_imageFile!.path}');
      final uploadTask = storageRef.putFile(_imageFile!);
      final snapshot = await uploadTask;
      downloadUrl = await snapshot.ref.getDownloadURL();
      // await prefs.setString('action', downloadUrl);
      debugPrint('printing the downloadUrl here $downloadUrl');
      // final String? action = prefs.getString('action');
      // debugPrint('printing the downloadUrl from sharedPreferences $action');

      setState(() {
        _uploading = false;
      });
    } catch (e) {
      print('Error occurred while uploading the file: $e');
      setState(() {
        _uploading = false;
      });
    }
  }

  Future<void> _scheduleNotification() async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails('47365d468', 'com.example.vrit',
            importance: Importance.max,
            priority: Priority.high,
            showWhen: false);
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
        0, 'Happy Birthday', 'wish you HBD!', platformChannelSpecifics,
        payload: 'item id 2');
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(top: 10.h),
                child: Center(
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          Container(
                            height: 80,
                            width: 80,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              border: Border.all(
                                color: Colors.black.withOpacity(0.4),
                                width: 4,
                              ),
                            ),
                            child: GestureDetector(
                              onTap: () async {},
                              child: CircleAvatar(
                                radius: 50.0,
                                backgroundColor: Colors.blue[100],
                                backgroundImage: NetworkImage(downloadUrl),
                                child: (_uploading)
                                    ? const CircularProgressIndicator()
                                    : null,
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 0.h,
                            right: 0.w,
                            child: GestureDetector(
                              onTap: () {
                                _showPickerDialog(context);
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.blue,
                                  borderRadius: BorderRadius.circular(50.r),
                                ),
                                child: const Padding(
                                  padding: EdgeInsets.all(3.0),
                                  child: Icon(
                                    Icons.edit,
                                    size: 20,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        FirebaseAuth.instance.currentUser!.displayName! ?? '',
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 20,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        FirebaseAuth.instance.currentUser!.email! ?? '',
                        style: const TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 12,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 24.h,
              ),
              /**
               * 
                
               */
              FormFields(
                  suffixIcon: Icon(Icons.calendar_today_rounded,
                      color: Colors.blue[300]),
                  onTap: () async {
                    //   DateTime? pickedDate = await showDatePicker(
                    //     builder: (context, child) {
                    //       return Theme(
                    //         data: Theme.of(context).copyWith(
                    //           dialogBackgroundColor: Colors.grey.shade700,
                    //           colorScheme: const ColorScheme.dark(),
                    //         ),
                    //         child: child!,
                    //       );
                    //     },
                    //     context: context,
                    //     initialDate: (dobController_.text.isNotEmpty)
                    //         ? DateTime.parse(dobController_.text)
                    //         : DateTime.now(),
                    //     firstDate: DateTime(1920),
                    //     lastDate: DateTime.now(),
                    //   );
                    //   if (pickedDate != null) {
                    //     String formattedDate =
                    //         pickedDate.toIso8601String().substring(0, 10);

                    //     setState(() {
                    //       dobController_.text = formattedDate;

                    //       // Check if the selected date is today
                    //       if (pickedDate.isAtSameMomentAs(DateTime.now())) {
                    //         ScaffoldMessenger.of(context).showSnackBar(
                    //           const SnackBar(content: Text('Happy B!')),
                    //         );
                    //         debugPrint("Printing Happy Birthday!");
                    //       }
                    //     });
                    //   }
                    DateTime? pickedDate = await showDatePicker(
                      builder: (context, child) {
                        return Theme(
                          data: Theme.of(context).copyWith(
                            dialogBackgroundColor: Colors.grey.shade700,
                            colorScheme: const ColorScheme.dark(),
                          ),
                          child: child!,
                        );
                      },
                      context: context,
                      initialDate: (dobController_.text.isNotEmpty)
                          ? DateTime.parse(dobController_.text)
                          : DateTime.now(),
                      firstDate: DateTime(1920),
                      lastDate: DateTime.now(),
                    );
                    if (pickedDate != null) {
                      String formattedDate =
                          pickedDate.toIso8601String().substring(0, 10);

                      setState(() {
                        dobController_.text = formattedDate;

                        // Check if the selected date's month and day match today's month and day
                        DateTime today = DateTime.now();
                        if (pickedDate.month == today.month &&
                            pickedDate.day == today.day) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Happy Birthday!')),
                          );
                        }
                      });
                    }
                  },
                  textEditingController: dobController_,
                  labelText: 'Date Of Birth'),
              ElevatedButton(
                  onPressed: () {
                    _scheduleNotification();
                  },
                  child: const Text("Notification"))
            ],
          ),
        ),
      )),
    );
  }
}
