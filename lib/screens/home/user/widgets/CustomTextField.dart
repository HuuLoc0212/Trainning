import 'package:flutter/material.dart';
import 'package:start/constants/constants.dart';

class CustomTextField extends StatefulWidget {
  CustomTextField({
    Key? key,
    required this.title,
    required this.isImportant,
    this.hintText,
    required this.controller,
    required this.textInputType,
    this.suffixIcon,
    this.readOnly
  }) : super(key: key);

  String title;
  bool isImportant;
  String? hintText;
  TextEditingController controller;
  TextInputType textInputType;
  Widget? suffixIcon;
  bool? readOnly = false;

  @override
  State<StatefulWidget> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  @override
  Widget build(BuildContext context) {
    InputBorder? outlineBorder = OutlineInputBorder(
      borderRadius: const BorderRadius.all(Radius.circular(10)),
      borderSide: BorderSide(color: Colors.black.withOpacity(0.5), width: 1),
    );

    InputBorder? focusOutlineBorder = OutlineInputBorder(
      borderRadius: const BorderRadius.all(Radius.circular(10)),
      borderSide: BorderSide(color: primaryColor, width: 1),
    );

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Text(widget.title, style: const TextStyle(fontSize: 16)),
              Text(widget.isImportant ? ' *' : '',
                  style: const TextStyle(color: Colors.redAccent))
            ],
          ),
          const SizedBox(height: 5),
          TextField(
            readOnly: widget.readOnly ?? false,
            keyboardType: widget.textInputType,
            textAlignVertical: TextAlignVertical.center,
            textAlign: TextAlign.left,
            maxLines: 1,
            textInputAction: TextInputAction.next,
            controller: widget.controller,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
              suffixIcon: widget.suffixIcon,
              //border: outlineBorder,
              border: outlineBorder,
              enabledBorder: outlineBorder,
              focusedBorder: focusOutlineBorder,
              hintText: widget.hintText ?? '',
              labelStyle: TextStyle(color: Colors.black.withOpacity(0.5)),
            ),
          )
        ],
      ),
    );
  }
}
