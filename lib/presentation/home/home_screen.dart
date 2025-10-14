import 'package:anonka/constants.dart';
import 'package:anonka/presentation/add_post/add_post_screen.dart';
import 'package:anonka/presentation/home/home_bloc.dart';
import 'package:anonka/presentation/home/home_state.dart';
import 'package:anonka/presentation/posts/posts_screen.dart';
import 'package:anonka/presentation/profile/profile_screen.dart';
import 'package:anonka/widgets/custom_app_bar.dart';
import 'package:anonka/widgets/statebloc_widget.dart';
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
      bottomNavigationBar: _buildStyledBottomNavigationBar(
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
        gradient: LinearGradient(
          colors: [
            const Color.fromARGB(255, 242, 71, 59).withAlpha(220),
            const Color.fromARGB(255, 3, 15, 255).withAlpha(220),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
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
        child: const Icon(Icons.add, size: 32, color: Colors.white),
      ),
    );
  }

  BottomNavigationBar _buildStyledBottomNavigationBar({
    required int currentIndex,
    required Function(int) onTap,
  }) {
    return BottomNavigationBar(
      backgroundColor: Colors.deepPurple[900],
      elevation: 0,
      currentIndex: currentIndex,
      onTap: onTap,
      items: _buildBottomNavigationItems(),
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

  List<BottomNavigationBarItem> _buildBottomNavigationItems() {
    return [
      BottomNavigationBarItem(
        icon: Container(
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [Colors.black.withAlpha(200), Colors.blue.withAlpha(200)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
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
            gradient: LinearGradient(
              colors: [
                Colors.teal.withAlpha(220),
                const Color.fromARGB(255, 17, 1, 255),
              ],
            ),
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
            gradient: LinearGradient(
              colors: [Colors.teal.withAlpha(200), Colors.blue.withAlpha(200)],
            ),
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
            gradient: LinearGradient(
              colors: [Colors.teal.withAlpha(220), Colors.black.withAlpha(220)],
            ),
          ),
          child: const Icon(Icons.person, size: 28, color: Colors.white),
        ),
      ),
    ];
  }
}
