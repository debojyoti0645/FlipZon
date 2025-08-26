import 'package:flipzon/components/my_listtile.dart';
import 'package:flutter/material.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
        backgroundColor: Theme.of(context).colorScheme.surface,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  //HEADER: LOGO
                  DrawerHeader(
                    child: Center(
                        child:
                            Image(image: AssetImage('assets/brand-logo.jpg'))),
                  ),
                  SizedBox(height: 50),

                  //SHOP TITLE
                  MyListTile(
                      text: "SHOP",
                      icon: Icons.home,
                      onTap: () => Navigator.pop(context)),
                  SizedBox(height: 10),

                  //CART TITLE
                  MyListTile(
                      text: "WISHLIST",
                      icon: Icons.favorite_outline,
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.pushNamed(context, '/wishlist_page');
                      }),
                  SizedBox(height: 10),

                  MyListTile(
                      text: "COMPARE",
                      icon: Icons.favorite_outline,
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.pushNamed(context, '/compare_page');
                      }),
                  SizedBox(height: 10),
                ],
              ),
              // EXIT TIME
              MyListTile(
                text: "EXIT",
                icon: Icons.logout,
                onTap: () {
                  // Show a SnackBar with a simple text message
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Hit the back button to close the app"),
                      duration: Duration(seconds: 2), // Display for 2 seconds
                    ),
                  );

                  // Navigate to the home page and clear navigation stack
                  Navigator.pushNamedAndRemoveUntil(
                      context, '/home_page', (route) => false);
                },
              ),
            ],
          ),
        ));
  }
}
