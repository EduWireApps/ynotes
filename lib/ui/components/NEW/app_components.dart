import 'package:flutter/material.dart';
import 'package:ynotes/ui/components/y_drawer/y_drawer.dart';
import 'package:ynotes_packages/components.dart';
import 'package:ynotes_packages/theme.dart';

class AppComponents {
  AppComponents._();

  static bool get _showDrawer => responsive<bool>(def: false, md: true);

  static YAppBar _appBar({required YAppBar appBar, required BuildContext context}) => YAppBar(
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

  static Widget page({required BuildContext context, required YPage page}) => Row(
        children: [
          if (_showDrawer)
            SizedBox(
              height: 100.vh,
              width: 310,
              child: const YDrawer(),
            ),
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
                return _appBar(context: context, appBar: page.appBar as YAppBar);
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
      );
}
