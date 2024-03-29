import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:ynotes/core/utils/theme_utils.dart';

// ignore: must_be_immutable
class CustomTextField extends StatefulWidget {
  final TextEditingController? controller;
  final String hint;
  bool isObscured;
  final IconData icon;
  final bool eyeButton;

  CustomTextField(
    this.controller,
    this.hint,
    this.isObscured,
    this.icon,
    this.eyeButton, {
    Key? key,
  }) : super(key: key);
  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  @override
  Widget build(BuildContext context) {
    MediaQueryData screenSize = MediaQuery.of(context);

    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 450),
      child: Container(
          width: screenSize.size.width / 5 * 4.2,
          height: 50,
          decoration: BoxDecoration(
              border: Border.all(width: 0.7, color: ThemeUtils.textColor().withOpacity(0.4)),
              borderRadius: BorderRadius.circular(10000),
              color: Theme.of(context).primaryColorDark),
          padding: EdgeInsets.zero,
          child: Stack(
            fit: StackFit.loose,
            children: [
              SizedBox(
                width: screenSize.size.width / 5 * 4.2,
                height: 50,
                child: TextField(
                  maxLines: 1,
                  controller: widget.controller,
                  obscureText: widget.isObscured,
                  style: TextStyle(color: ThemeUtils.textColor().withOpacity(0.8)),
                  textAlignVertical: TextAlignVertical.center,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.only(left: 68, right: widget.eyeButton ? 12 : 0),
                    border: const OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.all(
                        Radius.circular(25),
                      ),
                    ),
                    hintStyle: TextStyle(color: ThemeUtils.textColor().withOpacity(0.4)),
                    hintText: widget.hint,
                  ),
                ),
              ),
              Container(
                width: 50,
                height: 50,
                decoration:
                    BoxDecoration(color: Theme.of(context).primaryColor, borderRadius: BorderRadius.circular(50000)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(widget.icon, size: 30, color: ThemeUtils.textColor().withOpacity(0.8)),
                  ],
                ),
              ),
              if (widget.eyeButton)
                Align(
                    alignment: Alignment.centerRight,
                    child: IconButton(
                        onPressed: () {
                          setState(() {
                            widget.isObscured = !widget.isObscured;
                          });
                        },
                        iconSize: 50,
                        icon: const Center(child: Icon(MdiIcons.eye, size: 30, color: Color(0xff22256A))))

                    /* GestureDetector(
                    onTap: () {
                      setState(() {
                        widget.isObscured = !widget.isObscured;
                      });
                    },
                    child: Container(
                      width: screenSize.size.width / 5 * 0.7,
                      height: screenSize.size.width / 5 * 0.7,
                      decoration: BoxDecoration(
                          color: Theme.of(context).primaryColorDark, borderRadius: BorderRadius.circular(50000)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(MdiIcons.eye, size: screenSize.size.width / 5 * 0.5, color: Color(0xff22256A)),
                        ],
                      ),
                    ),
                  ), */
                    ),
            ],
          )),
    );
  }
}
