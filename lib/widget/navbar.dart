import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:secureshare/services/auth_services.dart';
import 'package:secureshare/services/database_service.dart';
import 'package:secureshare/widget/custom_button.dart';

class Navbar extends StatelessWidget {
  const Navbar({super.key});

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    return Drawer(
      child: Container(
        color: Colors.deepPurple[100],
        child: StreamBuilder(
            stream: DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
                .gettinguserData(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: SpinKitCircle(
                    color: Theme.of(context).primaryColor,
                    size: 50,
                  ),
                );
              }
              if (snapshot.hasError) {
                return const Text("Failed to load Data");
              }
              return ListView(
                padding: EdgeInsets.zero,
                children: [
                  UserAccountsDrawerHeader(
                    accountName: Text(
                      'Aziz khan',
                      //snapshot.data!['name'] ?? '',
                      style: GoogleFonts.poppins(
                        textStyle: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    accountEmail: Text(
                      'axixkhanii46@gmail.com',
                      //snapshot.data!['email'] ?? '',
                      style: GoogleFonts.poppins(
                        textStyle: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ),
                    currentAccountPicture: CircleAvatar(
                      child: ClipOval(
                        child: Image.network(
                          'https://images.unsplash.com/photo-1529626455594-4ff0802cfb7e?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8Mnx8ZmVtYWxlJTIwbW9kZWx8ZW58MHx8MHx8&w=1000&q=80',
                          width: 90,
                          height: 90,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    decoration: const BoxDecoration(
                      color: Colors.blue,
                      image: DecorationImage(
                        image: NetworkImage(
                            'https://oflutter.com/wp-content/uploads/2021/02/profile-bg3.jpg'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  ListTile(
                    leading: const Icon(
                      Icons.person,
                      color: Colors.black,
                      size: 25,
                    ),
                    title: Text(
                      'Update profile',
                      style: GoogleFonts.poppins(
                        textStyle: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    onTap: (() => print("Tap fav")),
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.notifications,
                      color: Colors.black,
                      size: 25,
                    ),
                    title: Text(
                      'Notifications',
                      style: GoogleFonts.poppins(
                        textStyle: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    onTap: (() => print("Tap fav")),
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.settings,
                      color: Colors.black,
                      size: 25,
                    ),
                    title: Text(
                      'Settings',
                      style: GoogleFonts.poppins(
                        textStyle: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    onTap: (() => print("Tap fav")),
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.star,
                      color: Colors.black,
                      size: 25,
                    ),
                    title: Text(
                      'Rate us',
                      style: GoogleFonts.poppins(
                        textStyle: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    onTap: (() => print("Tap fav")),
                  ),
                  SizedBox(
                    height: height * 0.15,
                  ),
                  Custom_button(
                      width: width,
                      height: height * 0.8,
                      onpressed: () {
                        AuthService().singOut(context);
                      },
                      title: "Logout")
                ],
              );
            }),
      ),
    );
  }
}
