/*
 * Developed by Nhan Cao on 10/24/19 5:19 PM.
 * Last modified 10/9/19 4:38 PM.
 * Copyright (c) 2019 Beesight Soft. All rights reserved.
 */

import 'package:bflutter/bcache.dart';
import 'package:bflutter_poc/pages/login/login_screen.dart';
import 'package:bflutter_poc/widgets/app_loading.dart';
import 'package:flutter/material.dart';

import 'main_bloc.dart';

void main() async {
  // @nhancv 2019-10-24: Start services later
  WidgetsFlutterBinding.ensureInitialized();
  // @nhancv 10/23/2019: Init bflutter caching
  await BCache().init();
  // @nhancv 10/23/2019: Run Application
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    /**
     * App flow:
     * - First, login
     * - Second, navigate to Home with auto fetch beesightsoft github info
     * - Then, navigate Search screen
     * - Last, navigate to Detail screen
     */
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: AppContent(),
    );
  }
}

class AppContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) => onAfterBuild(context));

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: <Widget>[
          LoginScreen(),
          StreamBuilder(
            stream: MainBloc().appLoading.stream,
            builder: (context, snapshot) =>
                snapshot.hasData && snapshot.data ? AppLoading() : SizedBox(),
          ),
        ],
      ),
    );
  }

  // @nhancv 10/25/2019: After widget initialized.
  void onAfterBuild(BuildContext context) {
    MainBloc().initContext(context);
  }
}
