import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:start/data/network/graphql_client.dart';
import 'package:start/data/sharedprefs/shared_preference_helper.dart';
import 'package:start/model/user/uservfa.dart';
import 'package:start/screens/home/user/widgets/CustomTextField.dart';
import 'package:start/widgets/app.dart';

import '../../../constants/constants.dart';
import '../../../data/network/constants/constants.dart';

class InfoScreen extends StatefulWidget {
  const InfoScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _InfoScreenState();
}

class _InfoScreenState extends State<InfoScreen> {
  //shared prefs
  SharedPreferencesHelper prefs = SharedPreferencesHelper();

  //Store
  //final UserStore _userStore = UserStore();
  late Future<UserVfa> userVfaFT;
  late UserVfa userVfa;

  //controller textInput
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _birthdayController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  //
  Future<UserVfa> getUser() async {
    QueryResult queryResult = await GraphQLConfig.client().value.query(
          QueryOptions(
            document: gql(GraphQLConstants.userInformation),
          ),
        );
    if (queryResult.data!['userInformation'].toString() == 'null') {
      return UserVfa();
    } else {
      Map<String, dynamic> mapData =
          queryResult.data!['userInformation']['response'];
      print(mapData);
      UserVfa userVfa = UserVfa.fromJson(mapData);
      return userVfa;
    }
  }

  @override
  void initState() {
    userVfaFT = getUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<UserVfa>(
        future: userVfaFT,
        builder: (context, AsyncSnapshot<UserVfa> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            print('waiting');
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              userVfa = snapshot.data ?? UserVfa();
              _nameController.text = userVfa.userFullName!;
              _emailController.text = userVfa.vfaEmail!;
              _phoneController.text = userVfa.vfaPhoneWork!;
              return SafeArea(
                child: Scaffold(
                  appBar: createAppbar(
                    context,
                    title: 'My Info',
                  ),
                  body: Stack(
                    children: [
                      NotificationListener<OverscrollIndicatorNotification>(
                        onNotification:
                            (OverscrollIndicatorNotification overscroll) {
                          overscroll.disallowGlow();
                          return true;
                        },
                        child: MediaQuery.removePadding(
                          context: context,
                          removeTop: true,
                          child: Container(
                            color: primaryColor,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    borderRadius(20.0, 20.0, 0.0, 0.0),
                              ),
                              child: ListView(
                                children: <Widget>[
                                  const SizedBox(height: 12),
                                  _buildAvatar(),
                                  const SizedBox(height: 12),
                                  _buildBody(),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      _buildButtonFloat(MediaQuery.of(context).size),
                    ],
                  ),
                ),
              );
            } else if (snapshot.hasError) {
              return const Text('Error');
            }
          }
          return Container();
        });
  }

  //
  Widget _buildAvatar() {
    return Center(
      child: ClipOval(
        child: Image.asset(
          'assets/images/default_avatar.png',
          width: 150,
          height: 150,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  //
  Widget _buildBody() {
    return ListView(
      shrinkWrap: true,
      children: [
        const SizedBox(height: 15.0),
        CustomTextField(
          controller: _nameController,
          title: 'Full Name',
          isImportant: true,
          hintText: 'Input your full name',
          textInputType: TextInputType.text,
          suffixIcon: _nameController.text.isNotEmpty
              ? IconButton(
                  onPressed: _nameController.clear,
                  icon: const Icon(Icons.clear),
                )
              : const SizedBox(
                  height: 0.0,
                  width: 0.0,
                ),
        ),
        const SizedBox(height: 20.0),
        CustomTextField(
          readOnly: true,
          controller: _emailController,
          title: 'Email',
          isImportant: true,
          hintText: 'Your email',
          textInputType: TextInputType.emailAddress,
          /*suffixIcon: _emailController.text.isNotEmpty
              ? IconButton(
            onPressed: _emailController.clear,
            icon: const Icon(Icons.clear),
          )
              : const SizedBox(
            height: 0.0,
            width: 0.0,
          ),*/
        ),
      ],
    );
  }

  ///BUILD BOTTOM BUTTON
  Widget _buildButtonFloat(Size _size) {
    return Positioned(
        bottom: 0,
        child: Container(
          color: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            width: _size.width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const SizedBox(width: 10),
                Flexible(
                  flex: 1,
                  fit: FlexFit.tight,
                  child: InkWell(
                    onTap: () {
                      print('ink');
                    },
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: primaryColor.withOpacity(0.8),
                      ),
                      child: MaterialButton(
                        minWidth: _size.width / 2.5,
                        padding:
                            const EdgeInsets.fromLTRB(5.0, 10.0, 5.0, 10.0),
                        child: const Text(
                          'Cập nhật',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18.0,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onPressed: () async {
                          try {
                            print('Lưu');
                          } catch (e) {
                            print(e);
                          }
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
