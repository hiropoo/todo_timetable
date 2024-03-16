import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:todo_timetable/all_todo_page.dart';
import 'package:todo_timetable/router.dart';
import 'package:todo_timetable/time_table.dart';

void main() {
  // debugPaintSizeEnabled = true;

  initializeDateFormatting('ja_JP').then((_) => runApp(const ProviderScope(child: MyApp()))); // 日本でローカライズ
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'todo&timeTable',
      routerDelegate: router.routerDelegate,
      routeInformationParser: router.routeInformationParser,
      routeInformationProvider: router.routeInformationProvider,
    );


  }
}

class AppHomePage extends StatefulWidget {
  const AppHomePage({super.key});

  @override
  State<AppHomePage> createState() => _AppHomePageState();
}

class _AppHomePageState extends State<AppHomePage> {
  int _selectedIndex = 0; // 選択されたnavのインデックス
  final PageController _pageController = PageController();  // タブ切り替え用のコントローラ

  static final List<Widget> _widgetOptions = <Widget>[
    const TimeTable(),
     AllTodoPage(),
  ];

  //Iconクリック時の処理
  void _onItemTapped(int index) {
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 180), 
      curve: Curves.easeOut,
      );

    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        onPageChanged: _onItemTapped,
        controller: _pageController,
        children: _widgetOptions,
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: const Color.fromARGB(255, 99, 110, 184),
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.stacked_bar_chart),
            label: '時間割',
          ),
          BottomNavigationBarItem( 
            icon: Icon(Icons.calendar_month),
            label: '課題',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
