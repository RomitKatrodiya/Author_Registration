import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import '../global.dart';
import '../helpers/cloud_firestore_helper.dart';

class EditAddAuthorPage extends StatefulWidget {
  const EditAddAuthorPage({Key? key}) : super(key: key);

  @override
  State<EditAddAuthorPage> createState() => _EditAddAuthorPageState();
}

class _EditAddAuthorPageState extends State<EditAddAuthorPage> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final TextEditingController authorController = TextEditingController();
  final TextEditingController bookController = TextEditingController();

  String? author;
  String? book;

  Uint8List? image;
  Uint8List? decodedImage;
  String imageString = "";
  bool isNew = false;

  @override
  void initState() {
    super.initState();
    clearControllersAndVar();
  }

  @override
  Widget build(BuildContext context) {
    QueryDocumentSnapshot? res;
    if (Global.isUpdate) {
      res = ModalRoute.of(context)!.settings.arguments as QueryDocumentSnapshot;

      authorController.text = "${res["name"]}";
      bookController.text = "${res["book"]}";

      isNew == false ? image = base64Decode(res["image"]) : null;
    }
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        actions: [
          TextButton(
            onPressed: () async {
              if (image != null) {
                if (formKey.currentState!.validate()) {
                  formKey.currentState!.save();
                  imageString = base64Encode(image!);

                  Map<String, dynamic> data = {
                    "name": author,
                    "book": book,
                    "image": imageString
                  };

                  if (Global.isUpdate) {
                    await CloudFirestoreHelper.cloudFirestoreHelper
                        .updateRecords(data: data, id: res!.id);
                  } else {
                    await CloudFirestoreHelper.cloudFirestoreHelper
                        .insertData(data: data);
                  }

                  Navigator.of(context).pop();
                }
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    behavior: SnackBarBehavior.floating,
                    backgroundColor: Colors.red,
                    content: Text(
                      "Add image First..",
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                );
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
                Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: Container(
                        height: 220,
                        width: 150,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(13),
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: image != null
                                ? MemoryImage(
                                    image!,
                                  )
                                : const NetworkImage(
                                    "https://media.istockphoto.com/id/1189849703/vector/01-open-book-and-creative-paper-airplanes-teamwork-paper-art-style.jpg?s=612x612&w=0&k=20&c=xeXSZaFfGv5CoNgWhZRJzlCWSMijXWrqVjEzfNlbpKE=",
                                  ) as ImageProvider,
                          ),
                        ),
                      ),
                    ),
                    FloatingActionButton(
                      mini: true,
                      shape: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      backgroundColor: Colors.white.withOpacity(0.9),
                      onPressed: () async {
                        final ImagePicker picker = ImagePicker();

                        XFile? pickImage =
                            await picker.pickImage(source: ImageSource.gallery);

                        if (pickImage != null) {
                          File compressedImage =
                              await FlutterNativeImage.compressImage(
                                  pickImage.path);
                          image = await compressedImage.readAsBytes();
                          isNew = true;
                          imageString = base64Encode(image!);
                        }
                        setState(() {});
                      },
                      child: Icon(
                        (Global.isUpdate) ? Icons.edit : Icons.add,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 25),
                Text(
                  "Author",
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                  controller: authorController,
                  decoration: textFieldDecoration("Author name"),
                  onSaved: (val) {
                    author = val;
                  },
                  validator: (val) =>
                      (val!.isEmpty) ? "Enter Author Name First..." : null,
                ),
                const SizedBox(height: 20),
                Text(
                  "Book",
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                  controller: bookController,
                  decoration: textFieldDecoration("Book name"),
                  onSaved: (val) {
                    book = val;
                  },
                  validator: (val) =>
                      (val!.isEmpty) ? "Enter Book Name First..." : null,
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
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
      hintText: hint,
      fillColor: ([...Colors.primaries]..shuffle()).first.shade100,
      filled: true,
    );
  }

  clearControllersAndVar() {
    authorController.clear();
    bookController.clear();

    author = null;
    image = null;
    book = null;
  }
}
