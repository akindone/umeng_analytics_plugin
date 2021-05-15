/*
 * @Author: Cao Shixin
 * @Date: 2021-05-15 13:35:21
 * @LastEditors: Cao Shixin
 * @LastEditTime: 2021-05-15 15:37:10
 * @Description: 
 */
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:umeng_analytics_plugin/umeng_analytics_plugin.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    var result = await UmengAnalyticsPlugin.init(
      androidKey: '5dfc5b91cb23d26df0000a90',
      iosKey: '5dfc5c034ca35748d1000c4c',
    );

    print('Umeng initialized.');

    if (!mounted) {
      return;
    }

    setState(() {
      _platformVersion = (result ?? false) ? 'OK' : 'ERROR';
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
            child: Column(
          children: [
            Text('Running on: $_platformVersion\n'),
            SizedBox(
              height: 10,
            ),
            ElevatedButton(
                onPressed: () {
                  UmengAnalyticsPlugin.pageStart('myStart');
                },
                child: Text('pageStart')),
            ElevatedButton(
                onPressed: () {
                  UmengAnalyticsPlugin.pageEnd('myEnd');
                },
                child: Text('pageEnd')),
            ElevatedButton(
                onPressed: () {
                  UmengAnalyticsPlugin.event('my123');
                },
                child: Text('eventId')),
            ElevatedButton(
                onPressed: () {
                  UmengAnalyticsPlugin.event('my123label', label: 'label');
                },
                child: Text('eventIdLabel'))
          ],
        )),
      ),
    );
  }
}
