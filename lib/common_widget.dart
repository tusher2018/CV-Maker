import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';

Widget commonText(String text,
    {double size = 12.0,
    Color color = Colors.black,
    bool isBold = false,
    overflow,
    maxline = 10,
    alignment}) {
  return Text(
    text,
    overflow: TextOverflow.ellipsis,
    maxLines: maxline,
    textAlign: alignment,

    style: TextStyle(
        overflow: overflow,
        fontSize: size,
        color: color,
        fontWeight: isBold ? FontWeight.bold : FontWeight.w500),
    // style: GoogleFonts.poppins(
    //   fontSize: size,
    //   color: color,
    //   fontWeight: isBold ? FontWeight.w600 : FontWeight.normal,
    // ),
  );
}

// pw.Widget commonTextpdf(String text,
//     {double size = 12.0,
//     PdfColor color = PdfColors.black,
//     bool isBold = true}) {
//   return pw.Text(
//     text,
//     maxLines: 10,
//     style: pw.TextStyle(
//       fontSize: size,
//       color: color,
//     ),
//   );
// }

Widget commonTextField(
    {required BuildContext context,
    String text = "",
    dynamic maxLine = 1,
    borderColor = Colors.black,
    TextEditingController? controller,
    validatorFunction,
    bool enabled = true,
    keyboardType = TextInputType.text,
    borderRadius = 5.0,
    double? height}) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: TextField(
        keyboardType: keyboardType,
        controller: controller,
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          labelText: text,
        )),
  );
  //  SizedBox(
  //   width: MediaQuery.sizeOf(context).width * 0.9,
  //   height: height,
  //   child: Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       Padding(
  //         padding: const EdgeInsets.symmetric(vertical: 8.0),
  //         child: commonText(text),
  //       ),
  //       TextField(
  //         maxLines: maxLine,
  //         controller: controller,
  //         keyboardType: keyboardType,
  //         enabled: enabled,
  //         obscureText: obscureText,
  //         minLines: maxLine,
  //         onChanged: onchanged,
  //         decoration: InputDecoration(
  //             prefixIcon: prefixIcon,
  //             suffixIcon: suffixIcon,
  //             filled: true,
  //             fillColor: Colors.white70,
  //             border: OutlineInputBorder(
  //               borderSide: BorderSide(color: borderColor),
  //               borderRadius: BorderRadius.circular(borderRadius),
  //             ),
  //             disabledBorder: OutlineInputBorder(
  //               borderSide: BorderSide(color: borderColor),
  //               borderRadius: BorderRadius.circular(borderRadius),
  //             ),
  //             enabledBorder: OutlineInputBorder(
  //               borderSide: BorderSide(color: borderColor),
  //               borderRadius: BorderRadius.circular(borderRadius),
  //             ),
  //             focusedBorder: OutlineInputBorder(
  //               borderSide: BorderSide(color: borderColor),
  //               borderRadius: BorderRadius.circular(borderRadius),
  //             ),
  //             errorBorder: OutlineInputBorder(
  //               borderSide: BorderSide(color: borderColor),
  //               borderRadius: BorderRadius.circular(borderRadius),
  //             ),
  //             focusedErrorBorder: OutlineInputBorder(
  //               borderSide: BorderSide(color: borderColor),
  //               borderRadius: BorderRadius.circular(borderRadius),
  //             )),
  //       ),
  //     ],
  //   ),
  // );
}

dynamic commonsnakbar(context, {massage}) {
  return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(massage),
    duration: const Duration(
        seconds: 2), // Duration for which the SnackBar is displayed
  ));
}

Widget commonTitleText(String title) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 16.0),
    child: Text(
      title,
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
  );
}
