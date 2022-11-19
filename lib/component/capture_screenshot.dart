import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import '../global.dart';

captureScreenShort({required var res}) async {
  Uint8List image = base64Decode(res["image"]);
  await Global.screenshotController
      .captureFromWidget(
    Container(
      width: double.infinity,
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: ([...Colors.primaries]..shuffle()).first.shade100,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          const Spacer(),
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.memory(
              image,
              height: 300,
            ),
          ),
          // const SizedBox(height: 20),
          const Spacer(),
          Text(
            "Author",
            style: GoogleFonts.poppins(
              fontSize: 26,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            "${res["name"]}",
            style: GoogleFonts.poppins(
              fontSize: 23,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
          const Spacer(),
          // const SizedBox(height: 15),
          Text(
            "Book",
            style: GoogleFonts.poppins(
              fontSize: 26,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            "${res["book"]}",
            style: GoogleFonts.poppins(
              fontSize: 23,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
          const Spacer(),
        ],
      ),
    ),
  )
      .then(
    (Uint8List? image) async {
      if (image != null) {
        final directory = await getApplicationDocumentsDirectory();
        final imagePath = await File('${directory.path}/image.png').create();
        await imagePath.writeAsBytes(image);
        await Share.shareFiles([imagePath.path]);
      }
    },
  );
}
