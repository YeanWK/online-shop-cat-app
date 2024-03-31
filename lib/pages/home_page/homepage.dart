import 'package:flutter/material.dart';
import '../../widgets/body_head.dart';
import '../../widgets/my_drawer.dart';
import '../news_page/news.dart';
import '../profile_page/profile.dart';
import 'home.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePage();
}

class _HomePage extends State<HomePage> {
  double height = 0;
  double width = 0;
  int activePage = 1;
  late PageController pageController;

  int _selectedIndex = 0;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    pageController = PageController(viewportFraction: 0.8, initialPage: 1);

    super.initState();
  }

  final List<Widget> _widgetOptions = <Widget>[
    const HomePage2(),
    const News(),
    const ProfilePage(),
  ];
  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: SafeArea(
        child: Scaffold(
          appBar: const MyAppbar(),
          bottomNavigationBar: Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: const Offset(0, 3), // changes position of shadow
                ),
              ],
            ),
            child: (BottomAppBar(
              child: SizedBox(
                height: 66,
                child: BottomNavigationBar(
                  currentIndex: _selectedIndex,
                  selectedItemColor: const Color(0xFFFF914D),
                  unselectedItemColor: Colors.black,
                  onTap: _onItemTapped,
                  items: const [
                    BottomNavigationBarItem(
                      icon: Icon(Icons.shopping_cart),
                      label: "SHOP",
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.newspaper),
                      label: "NEWS",
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.account_circle),
                      label: "ME",
                    ),
                  ],
                ),
              ),
            )),
          ),
          drawer: const MyDrawer(),
          body: _widgetOptions.elementAt(_selectedIndex),
        ),
      ),
    );
  }
}
