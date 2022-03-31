import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:start/data/sharedprefs/constants/my_shared_prefs.dart';

import '../sharedprefs/shared_preference_helper.dart';

class GraphQLConfig {
  static HttpLink httpLink = HttpLink(
    'http://54.255.247.6:3001/graphql',
  );

  static ValueNotifier<GraphQLClient> client() {
    String token = '';

    AuthLink authLink = AuthLink(
      getToken: () async {
        SharedPreferencesHelper prefs = SharedPreferencesHelper();
        String tokenType = await prefs.get(MySharedPrefs.token_type) ?? '';
        String tk = await prefs.get(MySharedPrefs.token) ?? '';
        if (tokenType.isNotEmpty && tk.isNotEmpty) {
          token = tokenType + ' ' + tk;
        }
        return token;
      },
    );
  // concat ket noi link  graphql
    Link link = authLink.concat(httpLink);

    ValueNotifier<GraphQLClient> client = ValueNotifier(
      GraphQLClient(
        link: link,
        cache: GraphQLCache(),
      ),
    );
    return client;
  }
}
