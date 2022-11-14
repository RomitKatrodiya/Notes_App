import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import '../global.dart';
import '../helpers/cloud_firestore_helper.dart';
import 'package:google_fonts/google_fonts.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(
          "Notes",
          style: GoogleFonts.poppins(
            color: Colors.white.withOpacity(0.9),
            fontSize: 25,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Colors.black,
        elevation: 0,
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.settings)),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        onPressed: () {
          Global.isUpdate = false;
          Navigator.of(context).pushNamed("edit_add_notes_page");
        },
        child: const Icon(
          Icons.add,
          size: 30,
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: CloudFirestoreHelper.cloudFirestoreHelper.selectRecords(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          } else if (snapshot.hasData) {
            List<QueryDocumentSnapshot> data = snapshot.data!.docs;

            return ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, i) {
                return Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  child: InkWell(
                    onTap: () {
                      Global.isUpdate = true;
                      Navigator.of(context)
                          .pushNamed("edit_add_notes_page", arguments: data[i]);
                    },
                    splashColor: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    child: Ink(
                      decoration: BoxDecoration(
                        color:
                            ([...Colors.primaries]..shuffle()).first.shade100,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Container(
                        padding: const EdgeInsets.only(
                            right: 20, left: 20, top: 15, bottom: 5),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${data[i]["title"]}",
                              style: GoogleFonts.poppins(
                                fontSize: 22,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              "${data[i]["description"]}",
                              style: GoogleFonts.poppins(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                const Spacer(),
                                IconButton(
                                  onPressed: () async {
                                    await Share.share(
                                        "Title : ${data[i]["title"]}\nDescription : ${data[i]["description"]}");
                                  },
                                  icon: const Icon(Icons.share_rounded),
                                ),
                                IconButton(
                                  onPressed: () async {
                                    await Clipboard.setData(
                                      ClipboardData(
                                        text:
                                            "Title : ${data[i]["title"]}\nDescription : ${data[i]["description"]}",
                                      ),
                                    );
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        behavior: SnackBarBehavior.floating,
                                        backgroundColor: Colors.black,
                                        content: Text(
                                          "Copied Note Successfully..",
                                          style: GoogleFonts.poppins(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                  icon: const Icon(Icons.content_copy_rounded),
                                ),
                                IconButton(
                                  onPressed: () {
                                    CloudFirestoreHelper.cloudFirestoreHelper
                                        .deleteRecords(id: data[i].id);
                                  },
                                  icon: const Icon(Icons.delete_outline),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
