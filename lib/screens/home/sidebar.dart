import 'package:flutter/material.dart';
import 'package:start/data/sharedprefs/constants/my_shared_prefs.dart';
import 'package:start/data/sharedprefs/shared_preference_helper.dart';

import '../../constants/constants.dart';

class SideBar extends StatefulWidget {
  const SideBar({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SidebarState();
}

class _SidebarState extends State<SideBar> {
  //shared prefs
  SharedPreferencesHelper prefs = SharedPreferencesHelper();

  //value
  String vfaEmail = '';
  String vfaAvatar = 'null';

  @override
  void initState() {
    prefs.get(MySharedPrefs.vfaEmail).then((value) => setState(() {
          vfaEmail = value.toString();
          print(vfaEmail);
        }));
    prefs.get(MySharedPrefs.vfaAvatar).then((value) => setState(() {
          vfaAvatar = value.toString();
          print(vfaAvatar);
        }));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size _size = MediaQuery.of(context).size;

    //
    return Drawer(
        child: Stack(
      children: [
        Column(
          children: <Widget>[
            _buildDrawerHeader(),
            _buildBody(),
          ],
        ),
      ],
    ));
  }

  //build header

  Widget _buildDrawerHeader() {
    const color = Colors.white;
    return InkWell(
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.all(25),
        child: PhysicalModel(
          color: Color.fromARGB(255, 104, 11, 5),
          elevation: 6,
          borderRadius: BorderRadius.circular(20),
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            PhysicalModel(
              color: color,
              borderRadius: BorderRadius.circular(20),
              elevation: 1,
              shadowColor: Colors.white,
              child: const Padding(
                padding: EdgeInsets.all(25.0),
                child: Icon(
                  Icons.person,
                  size: 30,
                ),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  vfaEmail,
                  style: const TextStyle(color: color, fontSize: 20),
                ),
                const SizedBox(
                  height: 30,
                ),
                // Text(
                //   vfaAvatar,
                //   style: const TextStyle(color: color, fontSize: 20),
                // )
              ],
            )
          ]),
        ),
      ),
    );
  }

  //build ListTile
  Widget _buildBody() {
    return Column(
      children: <Widget>[
        ListTile(
          leading: const Icon(
            Icons.perm_identity_sharp,
            color: Color.fromARGB(255, 104, 11, 5),
          ),
          title: const Text('My Profile'),
          onTap: () => {Navigator.of(context).pushNamed('/home/myInfo')},
        ),
        ListTile(
          leading: const Icon(
            Icons.calendar_month,
            color: Color.fromARGB(255, 104, 11, 5),
          ),
          title: const Text('My Timeline'),
          onTap: () => {Navigator.of(context).pushNamed('/home/myTimeline')},
        ),
        ListTile(
          leading: const Icon(
            Icons.list_alt,
            color: Color.fromARGB(255, 104, 11, 5),
          ),
          title: const Text('Todo List'),
          onTap: () {
            Navigator.of(context).pushNamed('/home/todolist');
          },
        ),
        // ListTile(
        //   leading: const Icon(Icons.border_color),
        //   title: const Text('Edit Profile'),
        //   onTap: () => {Navigator.of(context).pop()},
        // ),
        ListTile(
          leading: const Icon(
            Icons.logout_outlined,
            color: Color.fromARGB(255, 104, 11, 5),
          ),
          title: const Text('Logout'),
          onTap: () => _showAlertDialog(),
        ),
      ],
    );
  }

  //Dialog
  _showAlertDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Đăng xuất'),
        content: const Text('Bạn có muốn thoát khỏi tài khoản này?'),
        actions: [
          TextButton(
            child: const Text('Hủy'),
            onPressed: () => Navigator.of(context).pop(),
          ),
          TextButton(
            child: const Text('Đồng ý'),
            onPressed: () async {
              await prefs.destroy(); // xoa het key
              Navigator.of(context).pushNamedAndRemoveUntil(
                  '/login', (Route<dynamic> route) => false);
            },
          ),
        ],
      ),
    );
  }
}
