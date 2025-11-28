import 'package:anonka/src/core/constants.dart';
import 'package:anonka/src/feature/add_post/ui/screen/add_post_screen.dart';
import 'package:anonka/src/feature/home/home_bloc.dart';
import 'package:anonka/src/feature/home/home_state.dart';
import 'package:anonka/src/feature/posts/posts_screen.dart';
import 'package:anonka/src/feature/profile/profile_screen.dart';
import 'package:anonka/src/core/widgets/custom_app_bar.dart';
import 'package:anonka/src/core/widgets/statebloc_widget.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StateblocWidget<HomeBloc, HomeState> {
  HomeScreen({super.key});

  void goToAddPostScreen(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => AddPostScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: IndexedStack(
        index: state.tabIndex,
        children: [PostsScreen(), ProfileScreen()],
      ),
      bottomNavigationBar: _buildBottomNavigationBar(
        currentIndex: state.tabIndex,
        onTap: bloc.changeTab,
      ),
      floatingActionButton: state.tabIndex == 0
          ? _buildFloatingActionButton(context, goToAddPostScreen)
          : null,

      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildFloatingActionButton(
    BuildContext context,
    Function(BuildContext) goToAddPostScreen,
  ) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withAlpha(220),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(50),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: FloatingActionButton(
        onPressed: () => goToAddPostScreen(context),
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: Icon(Icons.add, size: 32, color: Colors.purple[500]),
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
      items: _buildBottomNavigationBarItems(),
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

  List<BottomNavigationBarItem> _buildBottomNavigationBarItems() {
    return [
      BottomNavigationBarItem(
        icon: Container(
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.purple[700],
          ),
          child: const Icon(
            Icons.local_post_office_outlined,
            size: 28,
            color: Colors.white,
          ),
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
      BottomNavigationBarItem(
        icon: Container(
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.purple[700],
          ),
          child: const Icon(
            Icons.person_outline,
            size: 28,
            color: Colors.white,
          ),
        ),
        label: AppStrings.profile,
        activeIcon: Container(
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.purple[500],
          ),
          child: const Icon(Icons.person, size: 28, color: Colors.white),
        ),
      ),
    ];
  }
}
