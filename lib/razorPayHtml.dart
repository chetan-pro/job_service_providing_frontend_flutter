// import 'dart:collection';
// import 'dart:html';
// import 'package:flutter/material.dart';
// import 'UiFake.dart' if (dart.library.html) 'dart:ui' as ui;

// class Webpayment extends StatelessWidget {
//   final String? name;
//   final String? email;
//   final String? contact;
//   final String? image;
//   final String? razorPayKey;
//   final String? orderId;
//   final int? price;
//   Webpayment(
//       {this.name,
//       this.price,
//       this.image,
//       this.orderId,
//       this.email,
//       this.contact,
//       this.razorPayKey});
//   @override
//   Widget build(BuildContext context) {
//     ui.platformViewRegistry.registerViewFactory("rzp-html", (int viewId) {
//       IFrameElement element = IFrameElement();
//       window.onMessage.forEach((element) {
//         if (element.data == 'MODAL_CLOSED') {
//           Navigator.pop(context, false);
//         } else if (element.data.runtimeType != String &&
//             element.data['flag'] == 'SUCCESS') {
//           Navigator.pop(context, element.data);
//         }
//       });
//       element.src =
//           'assets/assets/payments.html?email=$email&name=$name&price=$price&image=$image&order_id=$orderId&contact=$contact&razor_pay_key=$razorPayKey';

//       element.style.border = 'none';

//       return element;
//     });
//     return Scaffold(body: Builder(builder: (BuildContext context) {
//       return Container(
//         child: HtmlElementView(viewType: 'rzp-html'),
//       );
//     }));
//   }
// }
