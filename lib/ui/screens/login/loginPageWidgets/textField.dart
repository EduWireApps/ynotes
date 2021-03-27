import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class LoginPageTextField extends StatefulWidget {
  final TextEditingController controller;
  final String hint;
  bool isObscured;
  final IconData icon;
  final bool eyeButton;

  LoginPageTextField(
    this.controller,
    this.hint,
    this.isObscured,
    this.icon,
    this.eyeButton, {
    Key key,
  }) : super(key: key);
  @override
  _LoginPageTextFieldState createState() => _LoginPageTextFieldState();
}

class _LoginPageTextFieldState extends State<LoginPageTextField> {
  @override
  Widget build(BuildContext context) {
    MediaQueryData screenSize = MediaQuery.of(context);

    return Container(
        width: screenSize.size.width / 5 * 4.2,
        height: screenSize.size.width / 5 * 0.7,
        decoration: BoxDecoration(
            border: Border.all(width: 0.7, color: Colors.white),
            borderRadius: BorderRadius.circular(25),
            color: Colors.white70),
        padding: EdgeInsets.zero,
        child: Stack(
          fit: StackFit.loose,
          children: [
            Container(
              width: screenSize.size.width / 5 * 4.2,
              height: screenSize.size.width / 5 * 0.7,
              child: TextField(
                maxLines: 1,
                controller: widget.controller,
                obscureText: widget.isObscured,
                style: TextStyle(color: Colors.black),
                textAlignVertical: TextAlignVertical.center,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.only(
                      left: screenSize.size.width / 5 * 0.75,
                      right: widget.eyeButton ? screenSize.size.width / 5 * 0.75 : 0),
                  border: new OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: const BorderRadius.all(
                      const Radius.circular(25),
                    ),
                  ),
                  hintStyle: new TextStyle(color: Colors.grey[800]),
                  hintText: widget.hint,
                ),
              ),
            ),
            Container(
              width: screenSize.size.width / 5 * 0.7,
              height: screenSize.size.width / 5 * 0.7,
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(50000)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(widget.icon, size: screenSize.size.width / 5 * 0.5, color: Color(0xff22256A)),
                ],
              ),
            ),
            if (widget.eyeButton)
              Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      widget.isObscured = !widget.isObscured;
                    });
                  },
                  child: Container(
                    width: screenSize.size.width / 5 * 0.7,
                    height: screenSize.size.width / 5 * 0.7,
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(50000)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(MdiIcons.eye, size: screenSize.size.width / 5 * 0.5, color: Color(0xff22256A)),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ));
  }
}
