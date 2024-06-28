import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vrit_interview/screens/homeScreen.dart';
import 'package:vrit_interview/screens/liked_images_screen.dart';
import 'package:vrit_interview/screens/profile_screen.dart';

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
      appBar: _currentPage == 0 || _currentPage == 1
          ? AppBar(
              backgroundColor: Colors.blue[400],
              title: Center(
                child: Image.asset(
                  "assets/vrit-logo-c.png",
                  fit: BoxFit.contain,
                  scale: 1.8,
                ),
              ),
            )
          : null,
      body: SafeArea(
        child: Column(
          children: [
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
    return [const HomeScreen(), LikedPhotosScreen(), const ProfileScreen()];
  }
}
