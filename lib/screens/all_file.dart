import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:secureshare/constant.dart';
import 'package:secureshare/services/database_service.dart';

class All extends StatelessWidget {
  static const String routeName = 'All';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
        title: Text(
          'ALL',
          style: GoogleFonts.poppins(
            textStyle: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              letterSpacing: 2,
            ),
          ),
        ),
        centerTitle: true,
      ),
      body: StreamBuilder(
        stream: DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
            .gettingmyupload(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: SpinKitCircle(
                color: Theme.of(context).primaryColor,
                size: 50,
              ),
            );
          }
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(snapshot.data['name']),
                  leading: const CircleAvatar(
                    child: Icon(Icons.file_download),
                  ),
                  trailing: const Text("5:40 pm"),
                );
              },
            );
          }
          return const Text("No file");
        },
      ),
    );
  }
}
