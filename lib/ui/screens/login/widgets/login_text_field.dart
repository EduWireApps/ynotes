import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:ynotes_packages/theme.dart';

class LoginTextField extends StatefulWidget {
  final bool password;
  final String label;
  final TextEditingController controller;
  const LoginTextField({Key? key, this.password = false, required this.label, required this.controller})
      : super(key: key);

  @override
  _LoginTextFieldState createState() => _LoginTextFieldState();
}

class _LoginTextFieldState extends State<LoginTextField> {
  late bool obscured;
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(
        widget.label.toUpperCase(),
        style: TextStyle(
            fontFamily: "Asap", fontSize: 14, fontWeight: FontWeight.w600, color: theme.colors.neutral.shade500),
      ),
      SizedBox(
        height: 5,
      ),
      Container(
          height: 40,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: theme.colors.neutral.shade200),
          padding: EdgeInsets.zero,
          child: Row(
            children: [
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 5),
                  child: TextField(
                    maxLines: 1,
                    controller: widget.controller,
                    obscureText: obscured,
                    style: TextStyle(color: theme.colors.neutral.shade500),
                    textAlignVertical: TextAlignVertical.center,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.only(
                          bottom: 16, // HERE THE IMPORTANT PART
                        )),
                  ),
                ),
              ),
              if (widget.password)
                IconButton(
                    onPressed: () {
                      setState(() {
                        obscured = !obscured;
                      });
                    },
                    iconSize: 30,
                    icon: Center(
                        child: Icon(obscured ? MdiIcons.eye : MdiIcons.eyeOff,
                            size: 30, color: theme.colors.neutral.shade400))),
            ],
          ))
    ]));
  }

  @override
  void initState() {
    super.initState();
    obscured = widget.password;
  }
}
