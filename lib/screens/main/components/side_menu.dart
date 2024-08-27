import 'package:flutter/material.dart';

class SideMenu extends StatelessWidget {
  final int index;
  final void Function(int i) onTapDrawer;
  const SideMenu({Key? key, this.index = 0, required this.onTapDrawer})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            // child: Image.asset("assets/images/logo.png"),
            child: Center(
              child: Text(
                "E commerce",
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
          ),
          DrawerListTile(
            title: "Produk",
            svgSrc: Icons.bookmark,
            press: () {
              onTapDrawer(0);
            },
            selected: index == 0,
          ),
          DrawerListTile(
            title: "Customers",
            svgSrc: Icons.location_on,
            press: () {
              onTapDrawer(1);
            },
            selected: index == 1,
          ),
          DrawerListTile(
            title: "Logout",
            svgSrc: Icons.logout,
            press: () {
              onTapDrawer(2);
            },
            selected: index == 2,
          ),
        ],
      ),
    );
  }
}

class DrawerListTile extends StatelessWidget {
  final String title;
  final IconData svgSrc;
  final bool selected;
  final VoidCallback press;

  const DrawerListTile({
    Key? key,
    // For selecting those three line once press "Command+D"
    required this.title,
    required this.svgSrc,
    required this.press,
    this.selected = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTileTheme(
      selectedColor: Colors.green,
      child: ListTile(
        onTap: press,
        horizontalTitleGap: 0.0,
        leading: Icon(
          svgSrc,
          color: Colors.grey,
        ),
        title: Row(
          children: [
            SizedBox(width: 16), // H(16) bisa diganti dengan SizedBox
            Text(
              title,
              style: TextStyle(color: Colors.white54),
            ),
          ],
        ),
        selected: selected,
      ),
    );
  }
}
