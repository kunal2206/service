import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/constants/palette.dart';
import '../../data/controllers/auth_controller.dart';
import 'components.dart';
import 'side_menu_list.dart';

class SideNav extends StatefulWidget {
  const SideNav({
    Key? key,
    required this.scaffoldKey,
  }) : super(key: key);

  final GlobalKey<ScaffoldState> scaffoldKey;

  @override
  // ignore: library_private_types_in_public_api
  _SideNavState createState() => _SideNavState();
}

class _SideNavState extends State<SideNav> {
  bool _deliveryShow = false;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: LayoutBuilder(
        builder: (context, constraints) {
          var onLoginMessageTap = const Text(
            "If a serviceman is alloted and the serviceman doesn't arrive in an hr, you can contact us for refund.",
            textScaleFactor: 0.8,
          );
          return SizedBox(
            height: constraints.maxHeight,
            width: constraints.maxWidth,
            child: Column(
              children: [
                SizedBox(
                  height: !_deliveryShow
                      ? constraints.maxHeight * 0.0705 * 2 +
                          MediaQuery.of(context).padding.top
                      : constraints.maxHeight * 0.0705 * 2 +
                          MediaQuery.of(context).padding.top +
                          constraints.maxHeight * 0.08,
                  width: constraints.maxWidth,
                  child: Column(
                    children: [
                      //Main Menu
                      Container(
                        height: MediaQuery.of(context).padding.top,
                        width: constraints.maxWidth,
                        color: lightOrange,
                      ),
                      authenticationOrWelcomeBar(constraints),

                      loginMessage(constraints),

                      _deliveryShow
                          ? Container(
                              height: constraints.maxHeight * 0.08,
                              width: constraints.minWidth,
                              padding: EdgeInsets.symmetric(
                                horizontal: constraints.minWidth * 0.15,
                                vertical: constraints.minHeight * 0.005,
                              ),
                              child: onLoginMessageTap,
                            )
                          : Container(),
                    ],
                  ),
                ),
                Container(
                  height: constraints.maxHeight * 0.0025 * 2,
                  width: constraints.maxWidth,
                  color: Colors.black26,
                ),
                Container(
                  height: !_deliveryShow
                      ? constraints.maxHeight * (1 - 0.073 * 2) -
                          MediaQuery.of(context).padding.top
                      : constraints.maxHeight * (1 - 0.073 * 2 - 0.08) -
                          MediaQuery.of(context).padding.top,
                  width: constraints.maxWidth,
                  color: Colors.white,
                  child: SingleChildScrollView(
                    child: SideMenuList(
                      height: constraints.maxHeight * 0.07,
                      width: constraints.maxWidth,
                      scaffoldKey: widget.scaffoldKey,
                    ),
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }

  InkWell loginMessage(BoxConstraints constraints) {
    return InkWell(
      onTap: () {
        setState(() {
          _deliveryShow = !_deliveryShow;
        });
      },
      child: SizedBox(
        height: constraints.maxHeight * 0.07,
        width: constraints.maxWidth,
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(constraints.maxHeight * 0.015),
              width: constraints.maxWidth * 0.15,
              child: const FittedBox(
                child: Icon(
                  Icons.account_box,
                  color: cafeAuLait,
                ),
              ),
            ),
            Container(
              width: constraints.maxWidth * 0.7,
              padding: EdgeInsets.all(constraints.maxHeight * 0.015),
              child: const Text(
                "Services will arrive within hr*",
                softWrap: true,
                style: TextStyle(color: dark),
              ),
            ),
            Container(
              padding: EdgeInsets.all(constraints.maxHeight * 0.015),
              width: constraints.maxWidth * 0.15,
              child: FittedBox(
                child: !_deliveryShow
                    ? const Icon(
                        Icons.arrow_downward,
                        color: dark,
                      )
                    : const Icon(
                        Icons.arrow_upward,
                        color: dark,
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget authenticationOrWelcomeBar(BoxConstraints constraints) {
    return Container(
      color: lightOrange,
      height: constraints.maxHeight * 0.07,
      width: constraints.maxWidth,
      padding: EdgeInsets.symmetric(horizontal: constraints.maxWidth * 0.12),
      child: GetX<AuthController>(
          builder: (controller) => controller.isAuth.value
              ? AuthenticationButton(
                  constraints: constraints,
                  displayText: "Log out ",
                  logout: true,
                )
              : FutureBuilder(
                  builder: (ctx, resultSnapshot) {
                    return resultSnapshot.data == false
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              AuthenticationButton(
                                constraints: constraints,
                                displayText: "Login",
                              ),
                            ],
                          )
                        : AuthenticationButton(
                            constraints: constraints,
                            displayText: "Log out ",
                            logout: true,
                          );
                  },
                  future: controller.tryAutoLogging(),
                )),
    );
  }
}
