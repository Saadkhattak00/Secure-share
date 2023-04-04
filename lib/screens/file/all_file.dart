// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:secureshare/constant.dart';
import 'package:secureshare/screens/file/photo_view.dart';
import 'package:secureshare/screens/file/viewPdf.dart';
import 'package:secureshare/screens/file/viewWorrd.dart';
import 'package:secureshare/services/database_service.dart';
import 'package:secureshare/widget/custom_button.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

import '../../widget/dialog_box.dart';

class All extends StatefulWidget {
  static const String routeName = 'All';

  @override
  State<All> createState() => _AllState();
}

class _AllState extends State<All> {
  TextEditingController namecontroller = TextEditingController();
  final stt.SpeechToText _speech = stt.SpeechToText();
  String _searchText = '';

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
        title: Text(
          'ALLFILE',
          style: GoogleFonts.poppins(
            textStyle: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              letterSpacing: 5,
            ),
          ),
        ),
        centerTitle: true,
      ),
      body: StreamBuilder(
          stream: DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
              .gettingfile(),
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
              return const Center(
                child: Text('Faild to loadData'),
              );
            }
            final filedata = snapshot.data?.docs;
            return Column(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10),
                  child: TextFormField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      contentPadding: EdgeInsets.zero,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: const BorderSide(
                          width: 1.5,
                          color: Colors.black,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: const BorderSide(
                          width: 1.5,
                          color: Colors.black,
                        ),
                      ),
                      hintText: "Search here...",
                      suffixIcon: IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.mic,
                          size: 30,
                          color: Constant().kprimaryColor,
                        ),
                      ),
                    ),
                  ),
                ),
                ListView.builder(
                  itemCount: filedata.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    String imageurl = filedata[index]['url'];
                    String filename = filedata[index]['filename'];
                    final file = filedata[index];
                    return GestureDetector(
                      onTap: () {
                        if (filename.endsWith('.pdf')) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      ViewPdf(Url: imageurl)));
                        } else if (filename.endsWith('.jpg')) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ViewPhoto(image: imageurl),
                            ),
                          );
                        } else if (filename.endsWith('.jpeg')) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ViewPhoto(image: imageurl),
                            ),
                          );
                        } else if (filename.endsWith('.jpng')) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ViewPhoto(image: imageurl),
                            ),
                          );
                        } else if (filename.endsWith('.doc') ||
                            filename.endsWith('.docx')) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ViewWord(url: imageurl),
                            ),
                          );
                        }
                      },
                      child: Container(
                        height: height * 0.15,
                        margin: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(color: Colors.black),
                        ),
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10.0, horizontal: 5),
                              child: Container(
                                height: height * 0.2,
                                width: width * 0.3,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  border: Border.all(color: Colors.black),
                                  image: filename.endsWith('.pdf')
                                      ? const DecorationImage(
                                          image:
                                              AssetImage('assets/pdf_log.png'),
                                        )
                                      : filename.endsWith('.doc') ||
                                              filename.endsWith('.docx')
                                          ? const DecorationImage(
                                              image: AssetImage(
                                                  'assets/word_logo.png'),
                                            )
                                          : DecorationImage(
                                              image: NetworkImage(imageurl),
                                              fit: BoxFit.cover,
                                            ),
                                ),
                              ),
                            ),
                            Flexible(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Flexible(
                                        child: Container(
                                          padding: const EdgeInsets.all(12.0),
                                          child: Text(
                                            filedata[index]['filename'],
                                            textAlign: TextAlign.left,
                                            overflow: TextOverflow.ellipsis,
                                            style: GoogleFonts.poppins(
                                              textStyle: const TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      ShowDialog(
                                        menulist: [
                                          PopupMenuItem(
                                            child: ListTile(
                                              leading: const Icon(
                                                Icons.share,
                                                color: Colors.black,
                                              ),
                                              title: Text("Share"),
                                              onTap: () {},
                                            ),
                                          ),
                                          PopupMenuItem(
                                            child: ListTile(
                                              leading: const Icon(
                                                Icons.update,
                                                color: Colors.black,
                                              ),
                                              title: const Text("Update"),
                                              onTap: () {
                                                showModalBottomSheet(
                                                  context: context,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                  ),
                                                  builder: (context) {
                                                    return Container(
                                                      height: 200,
                                                      child: Column(
                                                        children: [
                                                          SizedBox(
                                                            height: 100,
                                                            child: Center(
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .all(
                                                                        15.0),
                                                                child:
                                                                    TextField(
                                                                  controller:
                                                                      namecontroller,
                                                                  decoration:
                                                                      InputDecoration(
                                                                    labelText:
                                                                        "Update Name",
                                                                    enabledBorder:
                                                                        OutlineInputBorder(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              15),
                                                                      borderSide:
                                                                          const BorderSide(
                                                                        width:
                                                                            1.5,
                                                                        color: Colors
                                                                            .black,
                                                                      ),
                                                                    ),
                                                                    focusedBorder:
                                                                        OutlineInputBorder(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              15),
                                                                      borderSide:
                                                                          const BorderSide(
                                                                        width:
                                                                            1.5,
                                                                        color: Colors
                                                                            .black,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          Custom_button(
                                                            width: width,
                                                            height: height,
                                                            onpressed:
                                                                () async {
                                                              String id =
                                                                  FirebaseAuth
                                                                      .instance
                                                                      .currentUser!
                                                                      .uid;
                                                              String docid =
                                                                  snapshot
                                                                      .data
                                                                      .docs[
                                                                          index]
                                                                      .id;
                                                              await DatabaseService(
                                                                      uid: id)
                                                                  .updateName(
                                                                      docid,
                                                                      namecontroller
                                                                          .text);
                                                              namecontroller
                                                                  .clear();
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                            },
                                                            title: "Update",
                                                          ),
                                                        ],
                                                      ),
                                                    );
                                                  },
                                                );
                                              },
                                            ),
                                          ),
                                          PopupMenuItem(
                                            child: ListTile(
                                              leading: const Icon(
                                                Icons.delete,
                                                color: Colors.black,
                                              ),
                                              title: const Text("Delete"),
                                              onTap: () async {
                                                String id = FirebaseAuth
                                                    .instance.currentUser!.uid;
                                                DatabaseService(uid: id)
                                                    .deleteFile(snapshot
                                                        .data.docs[index].id);
                                              },
                                            ),
                                          ),
                                        ],
                                        icon: const Icon(Icons.menu),
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 12.0, right: 12.0),
                                    child: Text(
                                      "27-12-2022",
                                      style: GoogleFonts.poppins(
                                        textStyle: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 12,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            );
          }),
    );
  }
}
