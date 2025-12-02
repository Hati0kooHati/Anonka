import 'package:anonka/src/core/constants/constants.dart';
import 'package:anonka/src/feature/post/presentation/screen/posts_screen.dart';
import 'package:anonka/src/feature/profile/profile_screen.dart';
import 'package:anonka/src/core/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';

class TabsScreen extends StatefulWidget {
  const TabsScreen({super.key});

  @override
  State<TabsScreen> createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  int tabIndex = 0;

  final screens = [PostsScreen(), ProfileScreen()];

  final List<IconData> tabIcons = const [
    Icons.local_post_office_outlined,
    Icons.person_outline,
  ];

  _onTabTapped(int selectedIndex) {
    if (selectedIndex != tabIndex) {
      setState(() {
        tabIndex = selectedIndex;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: IndexedStack(index: tabIndex, children: screens),
      bottomNavigationBar: _buildBottomNavigationBar(
        currentIndex: tabIndex,
        onTap: _onTabTapped,
      ),
    );
  }

  BottomNavigationBar _buildBottomNavigationBar({
    required int currentIndex,
    required Function(int) onTap,
  }) {
    return BottomNavigationBar(
      backgroundColor: Colors.black,
      elevation: 0,
      currentIndex: currentIndex,
      onTap: onTap,
      items: tabIcons
          .map(
            (icon) => BottomNavigationBarItem(
              icon: Container(
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.purple[700],
                ),
                child: Icon(icon, size: 28, color: const Color(0xFFFFFFFF)),
              ),
              label: AppStrings.posts,
              activeIcon: Container(
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.purple[500],
                ),
                child: const Icon(
                  Icons.local_post_office,
                  size: 28,
                  color: Colors.white,
                ),
              ),
            ),
          )
          .toList(),
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.white.withAlpha(150),
      selectedLabelStyle: const TextStyle(
        fontFamily: 'Montserrat',
        fontWeight: FontWeight.bold,
        fontSize: 16,
        shadows: [
          Shadow(color: Colors.black26, blurRadius: 4.0, offset: Offset(1, 1)),
        ],
      ),
      unselectedLabelStyle: const TextStyle(
        fontFamily: 'Montserrat',
        fontSize: 14,
      ),
      type: BottomNavigationBarType.fixed,
      showUnselectedLabels: true,
      selectedIconTheme: const IconThemeData(size: 30),
      unselectedIconTheme: const IconThemeData(size: 26),
    );
  }
}
