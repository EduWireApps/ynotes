import 'package:flutter/material.dart';
import 'package:ynotes/globals.dart';
import 'package:ynotes/ui/components/y_page/mixins.dart';
import 'package:ynotes/ui/components/y_page/y_page_local.dart';
import 'package:ynotes/ui/screens/settings/sub_pages/account.dart';
import 'package:ynotes_packages/theme.dart';
import 'package:ynotes_packages/utilities.dart';

class AccountHeader extends StatefulWidget {
  const AccountHeader({Key? key}) : super(key: key);

  @override
  _AccountHeaderState createState() => _AccountHeaderState();
}

class _AccountHeaderState extends State<AccountHeader> with YPageMixin {
  final account = appSys.currentSchoolAccount;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => openLocalPage(const YPageLocal(child: AccountPage(), title: "Compte")),
      child: Container(
          padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 15),
          color: theme.colors.primary.backgroundColor,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${account?.name ?? ''} ${account?.surname ?? ''}",
                    style: TextStyle(
                        color: theme.colors.primary.foregroundColor, fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                  Text(
                    "${account?.schoolName ?? ''} · ${account?.studentClass ?? ''}",
                    style: TextStyle(
                        color: theme.colors.primary.foregroundColor, fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
              Icon(Icons.chevron_right_rounded, size: YScale.s6, color: theme.colors.primary.foregroundColor)
            ],
          )),
    );
  }
}
