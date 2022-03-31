import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:start/data/network/graphql_client.dart';
import 'package:start/data/sharedprefs/constants/my_shared_prefs.dart';
import 'package:start/screens/home/user/info_screen.dart';
import 'package:start/screens/home/todo/todo_screen.dart';
import 'package:start/data/sharedprefs/shared_preference_helper.dart';

import 'home/main_screen.dart';
import 'home/user/my_time_line_screen.dart';
import 'login/login_screen.dart';

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  SharedPreferencesHelper prefs = SharedPreferencesHelper();
  bool isRememberLogin = false;
  String accessToken = '';

  _getAccessToken() async {
    String tokenType = await prefs.get(MySharedPrefs.token_type) ?? '';
    String token = await prefs.get(MySharedPrefs.token) ?? '';
    accessToken = tokenType + ' ' + token;
    print(tokenType + ' ' + token);
  }

  // kiem tra da pass chua
  _getStatusRemember() async {
    isRememberLogin = await prefs.get(MySharedPrefs.isRemember) ?? false;
    print('Remember Login: ' + isRememberLogin.toString());
  }

  @override
  void initState() {
    _getStatusRemember();
    _getAccessToken();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GraphQLProvider(
      client: GraphQLConfig.client(),
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          theme: ThemeData(
            scaffoldBackgroundColor: Colors.white,
            primarySwatch: Colors.blue,
          ),
          routes: <String, WidgetBuilder>{
            '/login': (BuildContext context) => const LoginScreen(),
            '/home': (BuildContext context) => const MainScreen(),
            '/home/todolist': (BuildContext context) => const TodoScreen(),
            '/home/myInfo': (BuildContext context) => const InfoScreen(),
            '/home/myTimeline': (BuildContext context) =>
                const MyTimeLineScreen(),
          },
          home: isRememberLogin == true
              ? const MainScreen()
              : const LoginScreen()),
    );
  }
}
