// // ignore_for_file: unnecessary_brace_in_string_interps

// import 'package:dropdown_button2/dropdown_button2.dart';
// import 'package:flutter/material.dart';
// import 'package:hindustan_job/candidate/dropdown/dropdown_list.dart';
// import 'package:hindustan_job/candidate/dropdown/dropdown_string.dart';
// import 'package:hindustan_job/candidate/icons/icon.dart';
// import 'package:hindustan_job/candidate/theme_modeule/text_style.dart';
// import 'package:hindustan_job/candidate/theme_modeule/theme.dart';
// import 'package:hindustan_job/config/responsive.dart';
// import 'package:hindustan_job/config/size_config.dart';
// import 'package:hindustan_job/constants/colors.dart';
// import 'package:hindustan_job/constants/mystring_text.dart';
// import 'package:hindustan_job/utility/function_utility.dart';

// class DynamicDropDownListOfFields extends StatelessWidget {
//   String? label;
//   List<String>? dropDownList;
//   dynamic selectingValue;
//   Function? setValue;
//   bool isValidDrop;
//   String? alertMsg;
//   DynamicDropDownListOfFields(
//       {Key? key,
//       required this.label,
//       required this.dropDownList,
//       required this.selectingValue,
//       required this.setValue,
//       this.isValidDrop = true,
//       this.alertMsg})
//       : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     List<DropdownMenuItem<String>> _addDividersAfterItems(
//         List<String> dropDownList) {
//       List<DropdownMenuItem<String>> _menuItems = [];
//       for (var item in dropDownList) {
//         _menuItems.addAll(
//           [
//             DropdownMenuItem(
//               value: label,
//               child: Text(
//                 "${label}",
//                 style: !Responsive.isDesktop(context)
//                     ? blackDarkOpacityM14()
//                     : blackDarkOpacityM12(),
//               ),
//             ),
//             ...dropDownList.map(
//               (value) {
//                 return DropdownMenuItem(
//                   value: value.toString(),
//                   child: Text(
//                     "${value}",
//                     style: !Responsive.isDesktop(context)
//                         ? blackDarkOpacityM14()
//                         : blackDarkOpacityM12(),
//                   ),
//                 );
//               },
//             ),
//             //If it's last item, we will not add Divider after it.
//             // if (item != states.last)
//             //   const DropdownMenuItem<String>(
//             //     enabled: true,
//             //     child: SizedBox(),
//             //   ),
//           ],
//         );
//       }
//       return _menuItems;
//     }

//     List<int> _getDividersIndexes() {
//       List<int> _dividersIndexes = [];
//       for (var i = 0; i < (ListDropdown.salutations.length * 2) - 1; i++) {
//         //Dividers indexes will be the odd indexes
//         if (i.isOdd) {
//           _dividersIndexes.add(i);
//         }
//       }
//       return _dividersIndexes;
//     }

//     Sizeconfig().init(context);
//     return Container(
//       // margin: EdgeInsets.only(bottom: 7),
//       // height: Responsive.isMobile(context) ? 46 : 35,
//       // padding: const EdgeInsets.only(
//       //   left: 15,
//       //   right: 15,
//       //   bottom: 0,
//       // ),
//       width: !Responsive.isDesktop(context)
//           ? double.infinity
//           : Sizeconfig.screenWidth! / 9,
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(3),
//         border: Border.all(color: MyAppColor.white),
//       ),
//       child: DropdownButtonHideUnderline(
//         child: DropdownButton2(
//           onTap: () {
//             FocusScope.of(context).requestFocus(new FocusNode());
//             if (!isValidDrop) {
//               return showSnack(
//                   context: context, msg: "$alertMsg", type: 'error');
//             }
//             if (!dropDownList!.isNotEmpty &&
//                 label == DropdownString.selectCity) {
//               showSnack(
//                   context: context,
//                   msg: AlertString.selectState,
//                   type: 'error');
//             }
//           },
//           buttonElevation: 00,
//           icon: IconFile.arrow,
//           iconSize: Responsive.isDesktop(context) ? 20 : 24,
//           isExpanded: true,
//           hint: Text(
//             // ,
//             label!,
//             style: blackDarkOpacityM14(),
//           ),
//           items: _addDividersAfterItems(dropDownList!),
//           customItemsIndexes: _getDividersIndexes(),
//           customItemsHeight: 4,
//           value: selectingValue != null ? selectingValue.name : label,
//           style: blackDarkOpacityM14(),
//           onChanged: (value) => setValue!(value.toString()),
//           buttonWidth: Sizeconfig.screenWidth! / 1.2,
//           buttonPadding: EdgeInsets.symmetric(horizontal: 8),
//           itemPadding: EdgeInsets.all(5),
//           dropdownPadding: EdgeInsets.all(20),
//           buttonHeight: 40,
//           // dropdownDecoration:
//           //     BoxDecoration(borderRadius: BorderRadius.circular(50)),            // buttonWidth: 140,
//           itemHeight: 40,
//           // itemWidth: Sizeconfig.screenWidth,
//           //  // itemPadding:
//           //       const EdgeInsets.(vertical: 8.0),
//         ),
//       ),
//     );
//   }
// }
