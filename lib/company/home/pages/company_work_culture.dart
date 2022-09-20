// ignore_for_file: prefer_final_fields

import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hindustan_job/candidate/model/company_image_model.dart';
import 'package:hindustan_job/candidate/theme_modeule/theme.dart';
import 'package:hindustan_job/company/home/homepage.dart';
import 'package:hindustan_job/config/responsive.dart';
import 'package:hindustan_job/config/size_config.dart';
import 'package:hindustan_job/constants/colors.dart';
import 'package:hindustan_job/constants/mystring_text.dart';
import 'package:hindustan_job/utility/function_utility.dart';
import 'package:hindustan_job/widget/buttons/submit_elevated_button.dart';
import 'package:hindustan_job/widget/certificate_viewer.dart';
import 'package:hindustan_job/widget/landing_page_widget/footer.dart';
import 'package:hindustan_job/widget/register_page_widget/text_field.dart';
import 'package:hindustan_job/widget/select_file.dart';
import 'package:hindustan_job/widget/text_form_field_widget.dart';

class CompanyWorkCulture extends ConsumerStatefulWidget {
  const CompanyWorkCulture({Key? key}) : super(key: key);

  @override
  _CompanyWorkCulture createState() => _CompanyWorkCulture();
}

class _CompanyWorkCulture extends ConsumerState<CompanyWorkCulture> {
  @override
  var _formKey = GlobalKey<FormState>();
  TextEditingController imageTitle = TextEditingController();
  TextEditingController uploadImage = TextEditingController();
  var uploadFile;

  // ignore: annotate_overrides
  Widget build(BuildContext context) {
    final styles = Mytheme.lightTheme(context).textTheme.headline1!;
    return ListView(
      children: [
        if (!Responsive.isDesktop(context))
          titleEditHead(title: "Add a new Work-Culture Image"),
        if (!Responsive.isDesktop(context)) workCultureUpload(context),
        if (!Responsive.isDesktop(context))
          SizedBox(
            height: Sizeconfig.screenHeight! / 20,
          ),
        !Responsive.isDesktop(context)
            ? Consumer(builder: (context, ref, child) {
                List<CompanyImage> companyImageList =
                    ref.watch(companyProfile).companyImageList;
                return Column(
                    children: List.generate(
                        companyImageList.length,
                        (index) => mainOffice(styles,
                            object: companyImageList[index])));
              })
            : Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    const SizedBox(
                      width: 40,
                    ),
                    Flexible(
                      flex: 1,
                      child: Container(
                        alignment: Alignment.topRight,
                        color: MyAppColor.greynormal,
                        child: Column(
                          children: [
                            Container(
                              alignment: Alignment.center,
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              color: MyAppColor.grayplane,
                              child: const Text('Add a new Work-culture Image'),
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            Form(
                              key: _formKey,
                              child: Column(children: [
                                Container(
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 20),
                                    child: TextFormFieldWidget(
                                      text: 'Upload Image',
                                      control: uploadImage,
                                      isRequired: false,
                                      type: TextInputType.none,
                                      onTap: () async {
                                        FilePickerResult? file =
                                            await selectFile(
                                                allow: ['jpg', 'png']);
                                        if (file == null) return;
                                        setState(() {
                                          uploadFile = kIsWeb
                                              ? file.files.first
                                              : File(file.paths.first!);
                                          uploadImage.text = kIsWeb
                                              ? file.files.first.name
                                              : file.names.first!;
                                          FocusScope.of(context).unfocus();
                                        });
                                      },
                                    )),
                                const SizedBox(
                                  height: 30,
                                ),
                                Container(
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 20),
                                  child: TextFormFieldWidget(
                                    text: 'Image Title',
                                    control: imageTitle,
                                    isRequired: true,
                                    type: TextInputType.multiline,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 12.0),
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        primary: MyAppColor.orangelight),
                                    onPressed: () async {
                                      if (!isFormValid(_formKey)) {
                                        return;
                                      }
                                      FocusScope.of(context).unfocus();
                                      await ref
                                          .read(companyProfile)
                                          .addCompanyImage(context,
                                              imageTitle:
                                                  imageTitle.text.toString(),
                                              uploadImage: uploadFile);
                                      imageTitle.clear();
                                      uploadFile = null;
                                      uploadImage.clear();
                                    },
                                    child: const Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Text('ADD IMAGE'),
                                    ),
                                  ),
                                )
                              ]),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 40,
                    ),
                    Flexible(
                      flex: 3,
                      child: Center(
                          child: Consumer(builder: (context, ref, child) {
                        List<CompanyImage> companyImageList =
                            ref.watch(companyProfile).companyImageList;
                        return Wrap(
                            children: List.generate(
                                companyImageList.length,
                                (index) => mainOffice(styles,
                                    object: companyImageList[index])));
                      })),
                    ),
                  ],
                ),
              ),
        SizedBox(
          height: Sizeconfig.screenHeight! / 20,
        ),
        Footer(),
        Container(
          alignment: Alignment.center,
          color: MyAppColor.normalblack,
          height: 30,
          width: double.infinity,
          child: Text(Mystring.hackerkernel,
              style: Mytheme.lightTheme(context)
                  .textTheme
                  .headline1!
                  .copyWith(color: MyAppColor.white)),
        ),
      ],
    );
  }

  workCultureUpload(context) {
    return Container(
      padding: const EdgeInsets.all(20),
      width: MediaQuery.of(context).size.width * 0.75,
      child: SingleChildScrollView(
          child: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormFieldWidget(
              text: 'Upload Image',
              control: uploadImage,
              isRequired: false,
              type: TextInputType.none,
              onTap: () async {
                FilePickerResult? file = await selectFile();
                if (file == null) return;
                setState(() {
                  uploadFile = File(file.paths.first!);
                  uploadImage.text = file.names.first!;
                  FocusScope.of(context).unfocus();
                });
              },
            ),
            TextFormFieldWidget(
              text: 'Image Title',
              control: imageTitle,
              isRequired: true,
              type: TextInputType.multiline,
            ),
            SubmitElevatedButton(
              label: "Save",
              onSubmit: () async {
                if (!isFormValid(_formKey)) {
                  return;
                }
                FocusScope.of(context).unfocus();
                await ref.read(companyProfile).addCompanyImage(context,
                    imageTitle: imageTitle.text.toString(),
                    uploadImage: uploadFile);
                imageTitle.clear();
                uploadFile = null;
                uploadImage.clear();
              },
            )
          ],
        ),
      )),
    );
  }

  titleEditHead({title}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      width: Responsive.isDesktop(context) ? Sizeconfig.screenWidth! / 2 : null,
      alignment: Alignment.center,
      padding: const EdgeInsets.all(15),
      color: MyAppColor.greynormal,
      child: Text('$title'),
    );
  }

  Padding mainOffice(TextStyle styles, {CompanyImage? object}) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        child: InkWell(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ImageDialog(
                          url: currentUrl(object!.image),
                        )));
          },
          child: Container(
            alignment: Alignment.bottomLeft,
            height: Sizeconfig.screenHeight! / 2.5,
            width: !Responsive.isDesktop(context)
                ? Sizeconfig.screenWidth
                : Sizeconfig.screenWidth! / 5,
            decoration: BoxDecoration(
              color: MyAppColor.blacklight,
              image: DecorationImage(
                  image: NetworkImage('${currentUrl(object!.image)}'),
                  fit: BoxFit.fitHeight),
            ),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      InkWell(
                          onTap: () {
                            ref.read(companyProfile).deleteCompanyImage(context,
                                id: object.id, object: object);
                          },
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(5)),
                                color: MyAppColor.floatButtonColor),
                            child: const Icon(
                              Icons.delete,
                              color: Colors.white,
                              size: 25,
                            ),
                          ))
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Text('${object.title}',
                        style:
                            styles.copyWith(color: MyAppColor.backgroundColor)),
                  ),
                ]),
          ),
        ));
  }
}

// import 'dart:io';
// import 'dart:typed_data';

// import 'package:file_picker/file_picker.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:hindustan_job/candidate/model/company_image_model.dart';
// import 'package:hindustan_job/candidate/theme_modeule/desktop_style.dart';
// import 'package:hindustan_job/candidate/theme_modeule/text_style.dart';
// import 'package:hindustan_job/candidate/theme_modeule/theme.dart';
// import 'package:hindustan_job/company/home/homepage.dart';
// import 'package:hindustan_job/config/responsive.dart';
// import 'package:hindustan_job/config/size_config.dart';
// import 'package:hindustan_job/constants/colors.dart';
// import 'package:hindustan_job/constants/mystring_text.dart';
// import 'package:hindustan_job/utility/function_utility.dart';
// import 'package:hindustan_job/widget/buttons/submit_elevated_button.dart';
// import 'package:hindustan_job/widget/certificate_viewer.dart';
// import 'package:hindustan_job/widget/landing_page_widget/footer.dart';
// import 'package:hindustan_job/widget/register_page_widget/text_field.dart';
// import 'package:hindustan_job/widget/select_file.dart';
// import 'package:hindustan_job/widget/text_form_field_widget.dart';

// class CompanyWorkCulture extends ConsumerStatefulWidget {
//   const CompanyWorkCulture({Key? key}) : super(key: key);

//   @override
//   _CompanyWorkCulture createState() => _CompanyWorkCulture();
// }

// class _CompanyWorkCulture extends ConsumerState<CompanyWorkCulture> {
//   @override
//   var _formKey = GlobalKey<FormState>();
//   TextEditingController imageTitle = TextEditingController();
//   TextEditingController uploadImage = TextEditingController();
//   File? uploadFile;

//   Uint8List? bytesFromPicker;

//   PlatformFile? logo;

//   // ignore: annotate_overrides
//   Widget build(BuildContext context) {
//     final styles = Mytheme.lightTheme(context).textTheme.headline1!;
//     return ListView(
//       children: [
//         if (!Responsive.isDesktop(context))
//           titleEditHead(title: "Add a new Work-Culture Image"),
//         workCultureUpload(context),
//         if (!Responsive.isDesktop(context))
//           SizedBox(
//             height: Sizeconfig.screenHeight! / 20,
//           ),
//         !Responsive.isDesktop(context)
//             ? Consumer(
//                 builder: (context, ref, child) {
//                   List<CompanyImage> companyImageList =
//                       ref.watch(companyProfile).companyImageList;
//                   return Column(
//                     children: List.generate(
//                       companyImageList.length,
//                       (index) =>
//                           mainOffice(styles, object: companyImageList[index]),
//                     ),
//                   );
//                 },
//               )
//             : Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 50),
//                 child: Row(
//                   children: [
//                     const SizedBox(
//                       width: 40,
//                     ),
//                     Expanded(
//                       flex: 1,
//                       child: Container(
//                         // alignment: Alignment.topRight,
//                         color: MyAppColor.greynormal,
//                         child: Column(
//                           mainAxisAlignment: MainAxisAlignment.start,
//                           children: [
//                             titleEditHead(
//                                 title: "Add a new Work-Culture Image"),
//                             workCultureUpload(context),
//                             // Container(
//                             //   alignment: Alignment.center,
//                             //   padding: const EdgeInsets.symmetric(vertical: 10),
//                             //   color: MyAppColor.grayplane,
//                             //   child: const Text('Add a new Work-culture Image'),
//                             // ),
//                             // const SizedBox(
//                             //   height: 30,
//                             // ),
//                             // Container(
//                             //   margin: const EdgeInsets.symmetric(horizontal: 20),
//                             //   color: MyAppColor.white,
//                             //   padding: const EdgeInsets.symmetric(
//                             //       horizontal: 10, vertical: 5),
//                             //   child: Row(
//                             //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             //     children: [
//                             //       const Text('Upload Image'),
//                             //       const Icon(Icons.image)
//                             //     ],
//                             //   ),
//                             // ),
//                             // const SizedBox(
//                             //   height: 30,
//                             // ),
//                             // Container(
//                             //   margin: const EdgeInsets.symmetric(horizontal: 20),
//                             //   child: TextfieldWidget(
//                             //     text: 'Image Title ',
//                             //   ),
//                             // ),
//                             // Padding(
//                             //   padding: const EdgeInsets.symmetric(vertical: 12.0),
//                             //   child: ElevatedButton(
//                             //     style: ElevatedButton.styleFrom(
//                             //         primary: MyAppColor.orangelight),
//                             //     onPressed: () {},
//                             //     child: const Padding(
//                             //       padding: EdgeInsets.all(8.0),
//                             //       child: Text('ADD IMAGE'),
//                             //     ),
//                             //   ),
//                             // )
//                           ],
//                         ),
//                       ),
//                     ),
//                     const SizedBox(
//                       width: 40,
//                     ),
//                     Flexible(
//                       flex: 3,
//                       child: Padding(
//                         padding: const EdgeInsets.only(left: 00.0),
//                         child: Center(
//                           child: Consumer(builder: (context, ref, child) {
//                             List<CompanyImage> companyImageList =
//                                 ref.watch(companyProfile).companyImageList;

//                             return Wrap(
//                                 runSpacing: 10,
//                                 children: List.generate(
//                                     companyImageList.length,
//                                     (index) => mainOffice(styles,
//                                         object: companyImageList[index])));
//                           }),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//         SizedBox(
//           height: Sizeconfig.screenHeight! / 20,
//         ),
//         Footer(),
//         Container(
//           alignment: Alignment.center,
//           color: MyAppColor.normalblack,
//           height: 30,
//           width: double.infinity,
//           child: Text(Mystring.hackerkernel,
//               style: Mytheme.lightTheme(context)
//                   .textTheme
//                   .headline1!
//                   .copyWith(color: MyAppColor.white)),
//         ),
//       ],
//     );
//   }

//   workCultureUpload(context) {
//     return Container(
//       padding: const EdgeInsets.all(20),
//       width: MediaQuery.of(context).size.width * 0.75,
//       child: SingleChildScrollView(
//           child: Form(
//         key: _formKey,
//         child: Column(
//           children: [
//             TextFormFieldWidget(
//               text: 'Upload Image',
//               control: uploadImage,
//               isRequired: false,
//               type: TextInputType.none,
//               onTap: kIsWeb
//                   ? () async {
//                       var result = await FilePicker.platform.pickFiles();
//                       setState(() {
//                         if (result != null) {
//                           logo = result.files.single;
//                           uploadImage.text = result.names.first!;

//                           // bytesFromPicker = result.files.single as Uint8List?;
//                         } else {}
//                       }); // FilePickerResult? file =
//                     }
//                   : () async {
//                       FilePickerResult? file = await selectFile();
//                       if (file == null) return;
//                       setState(() {
//                         uploadFile = File(file.paths.first!);
//                         uploadImage.text = file.names.first!;
//                         FocusScope.of(context).unfocus();
//                       });
//                     },
//             ),
//             if (Responsive.isDesktop(context))
//               SizedBox(
//                 height: 10,
//               ),
//             TextFormFieldWidget(
//               text: 'Image Title',
//               control: imageTitle,
//               isRequired: true,
//               type: TextInputType.multiline,
//             ),
//             if (Responsive.isDesktop(context))
//               SizedBox(
//                 height: 15,
//               ),
//             Container(
//               color: MyAppColor.orangelight,
//               width: 150,
//               height: 30,
//               child: SubmitElevatedButton(
//                 label: !Responsive.isDesktop(context) ? "Save" : "ADD IMAGE",
//                 onSubmit: () async {
//                   if (!isFormValid(_formKey)) {
//                     return;
//                   }
//                   FocusScope.of(context).unfocus();
//                   await ref.read(companyProfile).addCompanyImage(context,
//                       imageTitle: imageTitle.text.toString(),
//                       uploadImage: kIsWeb ? logo! : uploadFile);
//                   imageTitle.clear();
//                   uploadFile = null;
//                   uploadImage.clear();
//                 },
//               ),
//             )
//           ],
//         ),
//       )),
//     );
//   }

//   titleEditHead({title}) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 20),
//       width: Responsive.isDesktop(context) ? Sizeconfig.screenWidth! / 2 : null,
//       alignment: Alignment.center,
//       padding: const EdgeInsets.all(15),
//       color: MyAppColor.simplegrey,
//       child: Text(
//         '$title',
//         style: blackDarkR12(),
//       ),
//     );
//   }

//   Padding mainOffice(TextStyle styles, {CompanyImage? object}) {
//     return Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
//         child: InkWell(
//           onTap: () {
//             Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                     builder: (context) => ImageDialog(
//                           url: currentUrl(object!.image),
//                         )));
//           },
//           child: Container(
//             alignment: Alignment.bottomLeft,
//             height: Sizeconfig.screenHeight! / 2.5,
//             width: !Responsive.isDesktop(context)
//                 ? Sizeconfig.screenWidth
//                 : Sizeconfig.screenWidth! / 5,
//             decoration: BoxDecoration(
//               color: MyAppColor.blacklight,
//               image: DecorationImage(
//                   image: NetworkImage('${currentUrl(object!.image)}'),
//                   fit: BoxFit.fitHeight),
//             ),
//             child: Column(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.end,
//                     children: [
//                       InkWell(
//                           onTap: () {
//                             ref.read(companyProfile).deleteCompanyImage(context,
//                                 id: object.id, object: object);
//                           },
//                           child: Container(
//                             padding: const EdgeInsets.all(6),
//                             decoration: BoxDecoration(
//                                 borderRadius:
//                                     const BorderRadius.all(Radius.circular(5)),
//                                 color: MyAppColor.floatButtonColor),
//                             child: const Icon(
//                               Icons.delete,
//                               color: Colors.white,
//                               size: 25,
//                             ),
//                           ))
//                     ],
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.all(15.0),
//                     child: Text('${object.title}',
//                         style:
//                             styles.copyWith(color: MyAppColor.backgroundColor)),
//                   ),
//                 ]),
//           ),
//         ));
//   }
// }
