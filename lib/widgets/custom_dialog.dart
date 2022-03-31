import 'package:flutter/material.dart';

import 'custom_alert_dialog.dart';

class CustomDialog extends StatelessWidget {
  CustomDialog({Key? key, required this.message, this.hasButton})
      : super(key: key);

  bool? hasButton = true;
  String message = '';

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return CustomAlertDialog(
      content: Container(
        width: MediaQuery.of(context).size.width / 4,
        //height: MediaQuery.of(context).size.height / 3,
        color: Colors.white,
        child: ListView(
          shrinkWrap: true,
          children: <Widget>[
            const Text(
              'Thông báo',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 25,
                  fontFamily: 'Cardo',
                  fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              message,
              style: const TextStyle(
                  fontSize: 18,
                  fontFamily: 'Cardo',
                  fontWeight: FontWeight.normal),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 5),
            (hasButton ?? true)
                ? Container(
                    padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                    child: Flexible(
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
                            color: Color.fromARGB(255, 170, 25, 15),
                          ),
                          child: MaterialButton(
                            minWidth: size.width / 2.5,
                            padding:
                                const EdgeInsets.fromLTRB(5.0, 10.0, 5.0, 10.0),
                            child: const Text(
                              'Tiếp tục',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 18.0,
                                color: Colors.white,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                            onPressed: () async {
                              try {
                                Navigator.of(context).pop();
                              } catch (e) {
                                print(e);
                              }
                            },
                          ),
                        ),
                      ),
                    ),
                  )
                : Container(height: 0, width: 0),
          ],
        ),
      ),
    );
  }
}
