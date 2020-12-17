import 'package:vaccine_dist/views/aboutus.dart';
import 'package:vaccine_dist/views/mdnews.dart';
import 'package:vaccine_dist/views/businessnews.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vaccine_dist/shared/custom_style.dart';
import 'package:vaccine_dist/views/auth/settings.dart';
import 'package:vaccine_dist/views/auth/signup.dart';
import 'package:vaccine_dist/views/auth/login.dart';
import 'package:vaccine_dist/views/admin/reports.dart';
import 'package:vaccine_dist/views/admin/appointments.dart';
import 'package:vaccine_dist/views/admin/vaccine.dart';
import 'package:vaccine_dist/views/user/person.dart';
import 'package:vaccine_dist/views/user/records.dart';
import 'package:vaccine_dist/views/user/appointment.dart';
import 'package:vaccine_dist/views/scm/purchase.dart';
import 'package:vaccine_dist/views/scm/msr.dart';
import 'package:vaccine_dist/views/scm/center.dart';
import 'package:vaccine_dist/views/scm/vendor.dart';
import 'package:vaccine_dist/views/scm/warehouse.dart';
import 'package:vaccine_dist/views/scm/item.dart';

//import 'package:gallery/l10n/gallery_localizations.dart';

class App extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: cAppTitle,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: CupertinoTabBarMain(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class _TabInfo {
  const _TabInfo(this.title, this.icon);

  final String title;
  final IconData icon;
}

class CupertinoTabBarMain extends StatelessWidget {
  const CupertinoTabBarMain();

  @override
  Widget build(BuildContext context) {
    final _tabInfo = [
      _TabInfo(
        "About us",
        CupertinoIcons.home,
      ),
      _TabInfo(
        "MDNews",
        CupertinoIcons.news,
      ),
      _TabInfo(
        "Business News",
        CupertinoIcons.news_solid,
      ),
      _TabInfo(
        "Sign In",
        CupertinoIcons.settings,
      ),
    ];

    return DefaultTextStyle(
      style: CupertinoTheme.of(context).textTheme.textStyle,
      child: CupertinoTabScaffold(
        tabBar: CupertinoTabBar(
          items: [
            for (final tabInfo in _tabInfo)
              BottomNavigationBarItem(
                // title: Text(tabInfo.title),
                icon: Icon(tabInfo.icon),
              ),
          ],
        ),
        tabBuilder: (context, index) {
          return CupertinoTabView(
            routes: {
              // '/': (context) => ERPHomePage(), - can not set if home: ERPHomePage() is setup, only works with initiated route
              LogIn.routeName: (context) => LogIn(),
              Settings.routeName: (context) => Settings(),
              SignUp.routeName: (context) => SignUp(),
              Reports.routeName: (context) => Reports(),
              Person.routeName: (context) => Person(),
              Records.routeName: (context) => Records(),
              Appointment.routeName: (context) => Appointment(),
              Appointments.routeName: (context) => Appointments(),
              Vaccine.routeName: (context) => Vaccine(),
              Purchase.routeName: (context) => Purchase(),
              MSR.routeName: (context) => MSR(),
              Centre.routeName: (context) => Centre(),
              Vendor.routeName: (context) => Vendor(),
              Warehouse.routeName: (context) => Warehouse(),
              Item.routeName: (context) => Item(),
            },
            builder: (context) => _CupertinoTab(
              title: _tabInfo[index].title,
              icon: _tabInfo[index].icon,
            ),
            defaultTitle: _tabInfo[index].title,
          );
        },
      ),
    );
  }
}

class _CupertinoTab extends StatelessWidget {
  const _CupertinoTab({
    Key key,
    @required this.title,
    @required this.icon,
  }) : super(key: key);

  final String title;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
          backgroundColor: Colors.white10,
          leading: Icon(
            Icons.local_hospital,
            color: Colors.green,
            size: 24.0,
            semanticLabel: 'Elish Consulting Healthcare Management App',
          ),
          trailing: Icon(
            Icons.help,
            color: Colors.blue,
            size: 24.0,
            semanticLabel: 'Accounts setting',
          )),
      backgroundColor: CupertinoColors.systemBackground,
      child: ListView(
        children: [
          Container(height: 50),
          Center(
            child: title == "About us"
                ? AboutUs()
                : (title == "MDNews"
                    ? MDNews()
                    : (title == "Business News" ? BussNews() : LogIn())),
          ),
        ],
      ),
    );
  }
}
