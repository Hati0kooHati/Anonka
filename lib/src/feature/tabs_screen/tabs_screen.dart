import 'package:anonka/src/feature/create_post/presentation/screen/create_post_screen.dart';
import 'package:anonka/src/feature/post/model/post.dart';
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

  final List<Widget> screens = [PostsScreen(), ProfileScreen()];

  onTabTapped(int selectedIndex) async {
    if (selectedIndex == currentTabIndex) return;

    setState(() {
      currentTabIndex = selectedIndex;
    });
  }

  void goToCreatePostScreen() async {
    final Post? createdPost = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => CreatePostScreen()),
    );

    if (createdPost != null) {
      (screens[0] as PostsScreen).bloc.insertCreatedPost(createdPost);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        leading: currentTabIndex == 0
            ? IconButton(
                onPressed: goToCreatePostScreen,
                icon: Icon(Icons.add, size: 40),
              )
            : null,
      ),
      body: IndexedStack(index: currentTabIndex, children: screens),
      backgroundColor: Colors.black,
      bottomNavigationBar: SizedBox(
        height: 80,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            for (final (iconIndex, icon) in [
              Icons.home_filled,
              Icons.person_outline,
            ].indexed) ...[
              Padding(
                padding: const EdgeInsets.only(top: 5),
                child: SizedBox(
                  height: 55,
                  width: 80,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: currentTabIndex == iconIndex
                          ? Colors.white.withAlpha(50)
                          : null,
                    ),
                    child: Center(
                      child: IconButton(
                        icon: Icon(
                          icon,
                          size: 38,
                          color: const Color(0xFFFFFFFF),
                        ),
                        onPressed: () => onTabTapped(iconIndex),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
