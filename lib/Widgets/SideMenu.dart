import 'package:flutter/material.dart';

class SideMenu extends StatelessWidget {
  SideMenu({
    super.key,
    required this.setState,
  });

  Function setState;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.green,
            ),
            child: Text('Crumbs', style: TextStyle(color: Colors.white, fontSize: 24)),
          ),
          ListTile(
            title: const Text('Home'),
            onTap: () {
              setState(0);
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text('Profile'),
            onTap: () {
              setState(1);
              Navigator.pop(context);
            },
          ),
          // ListTile(
          //   title: const Text('Reviews'),
          //   onTap: () {
          //     setState(2);
          //     Navigator.pop(context);
          //   },
          // ),
          ListTile(
            title: const Text('Add Item'),
            onTap: () {
              setState(2);
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text('Map'),
            onTap: () {
              setState(3);
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
