import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vrit/screens/homeScreen.dart';
import 'package:vrit/screens/liked_images_screen.dart';
import 'package:vrit/screens/profile_screen.dart';

class HomeNavigation extends StatefulWidget {
  const HomeNavigation({
    Key? key,
  }) : super(key: key);

  @override
  State<HomeNavigation> createState() => _HomeNavigationState();
}

class _HomeNavigationState extends State<HomeNavigation> {
  PageController pageController = PageController();
  int _currentPage = 0;

  List<bool> isSelected = List.generate(4, (index) => false);

  bool loading = true;

  @override
  void initState() {
    super.initState();
    isSelected[0] = true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Visibility(
              visible: _currentPage == 0,
              child: Container(
                width: 390.w,
                height: 60.h,
                decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 173, 203, 228)),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Vrit",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 24.sp,
                            fontWeight: FontWeight.w600),
                      ),
                      const Icon(Icons.favorite_outline),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: PageView(
                physics: const NeverScrollableScrollPhysics(),
                controller: pageController,
                children: getTabScreens(),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentPage,
        onTap: (page) {
          if (page != _currentPage) {
            setState(() {
              _currentPage = page;
              pageController.animateToPage(page,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeInOutCubic);
            });
          }
        },
        elevation: 0,
        backgroundColor: const Color(0xffffffff),
        type: BottomNavigationBarType.fixed,
        useLegacyColorScheme: true,
        showUnselectedLabels: true,
        selectedLabelStyle: const TextStyle(
            fontFamily: "SourceSansPro-regular",
            fontSize: 12,
            fontWeight: FontWeight.w400,
            height: 25 / 12,
            letterSpacing: 0.5),
        unselectedLabelStyle: const TextStyle(
          fontFamily: "SourceSansPro-regular",
          fontSize: 12,
          fontWeight: FontWeight.w400,
          height: 25 / 12,
          letterSpacing: 0.5,
        ),
        unselectedItemColor: const Color(0xff9CA3AF),
        selectedItemColor: const Color(0xff2563EB),
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            activeIcon: Icon(Icons.home),
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            activeIcon: Icon(Icons.favorite),
            icon: Icon(Icons.favorite_outline_outlined),
            label: 'Favourite',
          ),
          BottomNavigationBarItem(
            activeIcon: Icon(Icons.person_outline_rounded),
            icon: Icon(Icons.person_rounded),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  Widget customUnActiveIcon(String path) {
    return Container(
      child: Image.asset(
        path,
        color: const Color(0xff9CA3AF),
        width: 24,
        height: 24,
      ),
    );
  }

  List<Widget> getTabScreens() {
    return [const HomeScreen(), LikedPhotosScreen(), ProfileScreen()];
  }
}
