import 'package:anonka/src/feature/create_post/presentation/screen/create_post_screen.dart';
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
  int currentTabIndex = 0;

  final List<Widget> screens = [PostsScreen(), SizedBox(), ProfileScreen()];

  onTabTapped(int selectedIndex) async {
    if (selectedIndex == currentTabIndex) return;

    if (selectedIndex == 1) {
      final bool? isPostCreate = await Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => CreatePostScreen()),
      );

      if (isPostCreate != null && isPostCreate) {
        (screens[0] as PostsScreen).bloc.loadInitial();
      }

      return;
    }

    setState(() {
      currentTabIndex = selectedIndex;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: IndexedStack(index: currentTabIndex, children: screens),
      bottomNavigationBar: SizedBox(
        height: 80,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            for (final (iconIndex, icon) in [
              Icons.local_post_office_outlined,
              Icons.add,
              Icons.person_outline,
            ].indexed) ...[
              IconButton(
                icon: Icon(icon, size: 38, color: const Color(0xFFFFFFFF)),
                onPressed: () => onTabTapped(iconIndex),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
