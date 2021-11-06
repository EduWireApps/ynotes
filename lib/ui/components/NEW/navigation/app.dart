import 'package:flutter/material.dart';
import 'package:ynotes/ui/components/NEW/navigation/connection_status.dart';
import 'package:ynotes/ui/components/y_drawer/y_drawer.dart';
import 'package:ynotes_packages/components.dart';
import 'package:ynotes_packages/theme.dart';

class ZApp extends StatelessWidget {
  final YPage page;

  const ZApp({Key? key, required this.page}) : super(key: key);

  bool get _showDrawer => responsive<bool>(def: false, md: true);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: theme.colors.backgroundColor,
      child: Row(
        children: [
          if (_showDrawer)
            SizedBox(
              height: 100.vh,
              width: 310,
              child: const YDrawer(),
            ),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                const ZConnectionStatus(),
                Expanded(
                  child: YPage(
                    key: page.key,
                    drawer: const YDrawer(),
                    appBar: Builder(builder: (context) {
                      if (_showDrawer && Scaffold.of(context).isDrawerOpen) {
                        Future.delayed(const Duration(seconds: 0), () {
                          Scaffold.of(context).openEndDrawer();
                        });
                      }
                      final YAppBar appBar = page.appBar as YAppBar;
                      return YAppBar(
                        title: appBar.title,
                        actions: appBar.actions,
                        bottom: appBar.bottom,
                        leading: YIconButton(
                            icon: Icons.menu_rounded,
                            onPressed: () {
                              Scaffold.of(context).openDrawer();
                            }),
                        removeLeading: _showDrawer,
                      );
                    }),
                    body: page.body,
                    floatingButtons: page.floatingButtons,
                    bottomNavigationElements: page.bottomNavigationElements,
                    bottomNavigationInitialIndex: page.bottomNavigationInitialIndex,
                    scrollable: page.scrollable,
                    showScrollbar: page.showScrollbar,
                    onRefresh: page.onRefresh,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
