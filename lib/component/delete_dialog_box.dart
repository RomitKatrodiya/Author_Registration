import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../helpers/cloud_firestore_helper.dart';

deleteAlertBox(context, id) {
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        scrollable: true,
        backgroundColor: Colors.white.withOpacity(0.9),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        icon: const Icon(
          Icons.delete_sweep_outlined,
          size: 50,
          color: Colors.red,
        ),
        title: Text(
          "Are You Sure want to Delete ?",
          style: GoogleFonts.poppins(
            fontSize: 22,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              CloudFirestoreHelper.cloudFirestoreHelper
                  .deleteRecords(id: id)
                  .then(
                    (value) => Navigator.of(context)
                        .pushNamedAndRemoveUntil("/", (route) => false),
                  );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              padding: const EdgeInsets.all(7),
              shape: const StadiumBorder(),
            ),
            child: Text(
              "Yes",
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
          ),
          OutlinedButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.all(7),
              shape: const StadiumBorder(),
              foregroundColor: Colors.red,
            ),
            child: Text(
              "No",
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
          ),
        ],
      );
    },
  );
}
