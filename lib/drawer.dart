import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:meditation_app/MyProviders/darkmode.dart';
import 'package:meditation_app/splash.dart';
import 'package:provider/provider.dart';

class MainDrawer extends StatefulWidget {
  const MainDrawer({super.key});

  @override
  State<MainDrawer> createState() => _MainDrawerState();
}

class _MainDrawerState extends State<MainDrawer> {
  User? user = FirebaseAuth.instance.currentUser;

  Future<void> deleteAccount() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        await user.delete();
        //print('Account deleted successfully.');
      }
    } catch (e) {
      //print('Error deleting account: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      elevation: 8.0,
      width: 240.0,
      //backgroundColor: Colors.deepPurple[50],
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.deepPurple.shade200,
                  Colors.deepPurple.shade100,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            accountName: Text(
              "💊",
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey[700],
              ),
            ),
            accountEmail: Text(
              "${user?.email}",
              style: TextStyle(
                fontSize: 11.5,
                color: Colors.grey[700],
              ),
            ),
            currentAccountPicture: GestureDetector(
              child: Hero(
                transitionOnUserGestures: true,
                tag: "My Profile Picture",
                child: CircleAvatar(
                  radius: 25.0,
                  backgroundColor: Colors.grey[700],
                  child: Icon(
                    Icons.account_circle_rounded,
                    size: 70,
                    color: Colors.deepPurple.shade200,
                  ),
                ),
              ),
            ),
          ),
          ListTile(
            visualDensity: const VisualDensity(
              horizontal: 0,
              vertical: -1.8,
            ),
            leading: const Icon(
              Icons.info_outline_rounded,
            ),
            title: Text(
              style: TextStyle(
                color: Colors.grey[700],
                fontSize: 10,
                fontWeight: FontWeight.w600,
              ),
              'About',
              selectionColor: Colors.blueGrey,
            ),
          ),
          const Divider(
            indent: 7.0,
            endIndent: 7.0,
          ),
          ListTile(
            visualDensity: const VisualDensity(
              horizontal: 0,
              vertical: -1.8,
            ),
            leading: const Icon(
              Icons.dark_mode_rounded,
            ),
            title: Text(
              'Dark Mode',
              style: TextStyle(
                color: Colors.grey[700],
                fontSize: 10,
                fontWeight: FontWeight.w600,
              ),
              selectionColor: Colors.blueGrey,
            ),
            onTap: () {
              Provider.of<ThemeProvider>(context, listen: false)
                  .toggleDarkMode();
              Navigator.pop(context);
            },
          ),
          /* ListTile(
            visualDensity: const VisualDensity(
              horizontal: 0,
              vertical: -1.8,
            ),
            leading: const Icon(
              Icons.dark_mode_rounded,
            ),
            title: Text(
              style: TextStyle(
                color: Colors.grey[700],
                fontSize: 10,
                fontWeight: FontWeight.w600,
              ),
              'Dark Mode',
              selectionColor: Colors.blueGrey,
            ),
            onTap: () {},
          ),*/
          const Divider(
            indent: 7.0,
            endIndent: 7.0,
          ),
          ListTile(
              visualDensity: const VisualDensity(
                horizontal: 0,
                vertical: -1.8,
              ),
              leading: const Icon(
                Icons.delete_rounded,
              ),
              title: Text(
                style: TextStyle(
                  color: Colors.grey[700],
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                ),
                'Delete Account',
                selectionColor: Colors.blueGrey,
              ),
              onTap: () {
                const Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 2.0,
                  ),
                );
              }),
          const Divider(
            indent: 7.0,
            endIndent: 7.0,
          ),
          ListTile(
            visualDensity: const VisualDensity(
              horizontal: 0,
              vertical: -1.8,
            ),
            leading: const Icon(
              Icons.login_outlined,
            ),
            title: Text(
              style: TextStyle(
                color: Colors.grey[700],
                fontSize: 10,
                fontWeight: FontWeight.w600,
              ),
              'Log Out',
              selectionColor: Colors.blueGrey,
            ),
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return const Center(
                    child: CircularProgressIndicator(strokeWidth: 2.0),
                  );
                },
              );
              FirebaseAuth.instance.signOut();
              //Navigator.pop(context);
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (BuildContext context) => const SplashScreen(),
                ),
              );
              //Navigator.pop(context);
            },
          ),
          const Divider(
            indent: 7.0,
            endIndent: 7.0,
          ),
        ],
      ),
    );
  }
}
