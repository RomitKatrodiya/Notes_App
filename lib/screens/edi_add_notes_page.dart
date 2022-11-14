import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../global.dart';
import '../helpers/cloud_firestore_helper.dart';

class EditAddNotesPage extends StatefulWidget {
  const EditAddNotesPage({Key? key}) : super(key: key);

  @override
  State<EditAddNotesPage> createState() => _EditAddNotesPageState();
}

class _EditAddNotesPageState extends State<EditAddNotesPage> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  String? title;
  String? description;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    clearControllersAndVar();
  }

  @override
  Widget build(BuildContext context) {
    QueryDocumentSnapshot? res;
    if (Global.isUpdate) {
      res = ModalRoute.of(context)!.settings.arguments as QueryDocumentSnapshot;

      titleController.text = "${res["title"]}";
      descriptionController.text = "${res["description"]}";
    }
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        actions: [
          TextButton(
            onPressed: () async {
              if (formKey.currentState!.validate()) {
                formKey.currentState!.save();

                Map<String, dynamic> data = {
                  "title": title,
                  "description": description,
                };

                if (Global.isUpdate) {
                  await CloudFirestoreHelper.cloudFirestoreHelper
                      .updateRecords(data: data, id: res!.id);
                } else {
                  CloudFirestoreHelper.cloudFirestoreHelper
                      .insertData(data: data);
                }

                Navigator.of(context).pop();
              }
            },
            child: Text(
              (Global.isUpdate) ? "SAVE" : "ADD",
              style: GoogleFonts.poppins(
                color: Colors.white.withOpacity(0.9),
                fontSize: 17,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: 7),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                const SizedBox(height: 15),
                TextFormField(
                  style: GoogleFonts.poppins(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                  ),
                  controller: titleController,
                  decoration: textFieldDecoration("Title"),
                  onSaved: (val) {
                    title = val;
                  },
                  validator: (val) =>
                      (val!.isEmpty) ? "Enter Title First..." : null,
                ),
                const SizedBox(height: 15),
                TextFormField(
                  style: GoogleFonts.poppins(
                    fontSize: 19,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 25,
                  controller: descriptionController,
                  decoration: textFieldDecoration("Description"),
                  onSaved: (val) {
                    description = val;
                  },
                  validator: (val) =>
                      (val!.isEmpty) ? "Enter Description First..." : null,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  textFieldDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      fillColor: ([...Colors.primaries]..shuffle()).first.shade100,
      filled: true,
    );
  }

  clearControllersAndVar() {
    titleController.clear();
    descriptionController.clear();

    title = null;
    description = null;
  }
}
