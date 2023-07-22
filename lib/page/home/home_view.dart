import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_g2/main.dart';
import 'package:flutter_g2/page/fruits/fruits_view.dart';
import 'package:flutter_g2/page/techno/tecno_view.dart';
import 'package:flutter_g2/page/users/users_view.dart';
import 'package:flutter_g2/service/prefs.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  List<Widget?> pages = [
    const UsersView(),
    const FruitsView(),
    const TechnoView()
  ];
  void logout() async {
    try {
      final profileDeleted = await Prefs.deleteDataFromLocal(key: 'data');
      if (profileDeleted!) {
        log('Lokal xotiraga saqlandi');
        scaffoldMessangerKey.currentState!.showMaterialBanner(MaterialBanner(
            content: const Text('Siz muvofaqiyatli logut qildingiz'),
            actions: [
              TextButton(
                  onPressed: () => scaffoldMessangerKey.currentState!
                      .hideCurrentMaterialBanner(),
                  child: const Text('dismiss'))
            ]));

        // ignore: use_build_context_synchronously
        Navigator.of(context)
            .pushNamedAndRemoveUntil('/auth', (route) => false);
      }
    } catch (e) {
      log(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Database Example'),
        actions: [
          IconButton(onPressed: logout, icon: const Icon(Icons.logout))
        ],
      ),
      body: CupertinoTabScaffold(
          tabBar: CupertinoTabBar(items: const [
            BottomNavigationBarItem(
                icon: Icon(Icons.data_object_sharp), label: 'SQL'),
            BottomNavigationBarItem(
                icon: Icon(Icons.data_object_sharp), label: 'NoSQL'),
            BottomNavigationBarItem(
                icon: Icon(Icons.data_object_sharp), label: 'Local'),
          ]),
          tabBuilder: (context, index) => pages[index]!),
    );

    // body: Center(
    //   child: FutureBuilder<String?>(
    //       future: Prefs.loadDataFromLocal(key: 'data'),
    //       builder: (context, snapshot) {
    //         if (!snapshot.hasData) {
    //           return const Text('you have an error');
    //         }
    //         if (snapshot.connectionState == ConnectionState.waiting) {
    //           return const LinearProgressIndicator();
    //         }
    //         final ProfileModel profileModel =
    //             ProfileModel.fromJson(jsonDecode(snapshot.data!));

    //         return Card(
    //           child: ListTile(
    //             title: Text(profileModel.email ?? 'unknown'),
    //             subtitle: Text(profileModel.password ?? 'password'),
    //           ),
    //         );
    //       }),
    // ),
  }
}
