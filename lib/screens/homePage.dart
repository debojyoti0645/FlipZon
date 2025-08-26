import 'package:flipzon/components/my_button.dart';
import 'package:flipzon/screens/main_shop_home_page.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //LOGO
              Image(image: AssetImage('assets/label.jpg')),
              SizedBox(height: 1),

              //TITLE
              Text("F L I P Z O N",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                  )),

              //SUBTITLE
              Text("Your one-stop shop for all your Apple electronics",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.inversePrimary)),

              SizedBox(height: 40),

              //BUTTON
              MyButton(
                  onTap: () => Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const MainShopHomePage()),
                        (route) => false,
                      ),
                  child: Icon(Icons.arrow_forward))
            ],
          ),
        ),
      ),
    );
  }
}
