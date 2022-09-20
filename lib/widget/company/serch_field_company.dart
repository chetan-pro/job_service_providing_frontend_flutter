


// import 'package:flutter/material.dart';

// class CompanysearchDesktop extends StatelessWidget {
//   const CompanysearchDesktop({ Key? key }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       child: Padding(
//       padding: const EdgeInsets.only(top: 8.0),
//       child: Row(
//         children: [
//           SizedBox(
//             width: Sizeconfig.screenWidth! / 6,
//             height: Sizeconfig.screenHeight! / 20,
//             child: TextfieldWidget(
//               styles: desktopstyle,
//               text: 'Search by job title',
//             ),
//           ),
//           SizedBox(
//             width: 5,
//           ),
//           customDropdown(
//             selectingValue: DropdownString.selectIndustry,
//             setdata: (newValue) {
//               setState(
//                 () {
//                   DropdownString.selectIndustry = newValue!;
//                 },
//               );
//             },
//             context: context,
//             label: "Select job role",
//             listDropdown: ListDropdown.selectIndustries,
//           ),
//           SizedBox(
//             width: 5,
//           ),
//           customDropdown(
//             selectingValue: DropdownString.sector,
//             setdata: (newValue) {
//               setState(
//                 () {
//                   DropdownString.sector = newValue!;
//                 },
//               );
//             },
//             context: context,
//             label: "Select Sector",
//             listDropdown: ListDropdown.sectors,
//           ),
//           SizedBox(
//             width: 5,
//           ),
//           customDropdown(
//             selectingValue: DropdownString.location,
//             setdata: (newValue) {
//               setState(
//                 () {
//                   DropdownString.location = newValue!;
//                 },
//               );
//             },
//             context: context,
//             label: "Select Location",
//             listDropdown: ListDropdown.locations,
//           ),
//           SizedBox(
//             width: 5,
//           ),
//           customDropdown(
//             selectingValue: DropdownString.experience,
//             setdata: (newValue) {
//               setState(
//                 () {
//                   DropdownString.experience = newValue!;
//                 },
//               );
//             },
//             context: context,
//             label: "Select Expeience",
//             listDropdown: ListDropdown.experiences,
//           ),,
      
//     );
//   }
//   Widget customDropdown({
//     BuildContext? context,
//     List<String>? listDropdown,
//     String? label,
//     String? selectingValue,
//     Function? setdata,
//   }) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 00.0, vertical: 9),
//       child: Container(
//         height: Sizeconfig.screenHeight! / 20,
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(4),
//           border: Border.all(color: MyAppColor.white),
//         ),
//         child: DropdownButtonHideUnderline(
//           child: DropdownButton2(
//             autofocus: false,

//             iconDisabledColor: MyAppColor.white,
//             focusColor: MyAppColor.white,
//             buttonElevation: 00,
//             icon: IconFile.arrow,
//             iconSize: 17,
//             isExpanded: true,
//             hint: Text(
//               // ,
//               label!,
//               style: blackDarkOpacityR9(),
//             ),
//             items: _addDividersAfterItems(listDropdown!),
//             customItemsIndexes: _getDividersIndexes(),
//             customItemsHeight: 4,
//             value: selectingValue, style: blackDarkOpacityR9(),
//             onChanged: (value) => setdata!(value),
//             buttonWidth: !Responsive.isDesktop(context!)
//                 ? Sizeconfig.screenWidth! / 1.2
//                 : Sizeconfig.screenWidth! / 9.1,
//             buttonPadding: EdgeInsets.symmetric(horizontal: 0),

//             buttonHeight: 40,
//             // dropdownDecoration:
//             //     BoxDecoration(borderRadius: BorderRadius.circular(50)),            // buttonWidth: 140,
//             itemHeight: 40,
//             // itemWidth: Sizeconfig.screenWidth,
//             //  // itemPadding:
//             //       const EdgeInsets.(vertical: 8.0),
//           ),
//         ),
//       ),
//     );
//   }
// }