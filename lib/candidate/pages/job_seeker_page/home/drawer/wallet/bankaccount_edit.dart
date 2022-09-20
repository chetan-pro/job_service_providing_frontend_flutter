// ignore_for_file: unused_import, must_be_immutable, unused_element, prefer_const_constructors, avoid_unnecessary_containers, avoid_print

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hindustan_job/candidate/dropdown/dropdown_list.dart';
import 'package:hindustan_job/candidate/dropdown/dropdown_string.dart';
import 'package:hindustan_job/candidate/header/app_bar.dart';
import 'package:hindustan_job/candidate/icons/icon.dart';
import 'package:hindustan_job/candidate/model/addbank/getbank.dart';
import 'package:hindustan_job/candidate/model/ifsc_model.dart';
import 'package:hindustan_job/candidate/pages/job_seeker_page/home/drawer/mywallet_bank_details.dart';
import 'package:hindustan_job/candidate/pages/job_seeker_page/home/homeappbar.dart';
import 'package:hindustan_job/candidate/theme_modeule/desktop_style.dart';
import 'package:hindustan_job/candidate/theme_modeule/new_text_style.dart';
import 'package:hindustan_job/candidate/theme_modeule/specing.dart';
import 'package:hindustan_job/candidate/theme_modeule/text_style.dart';
import 'package:hindustan_job/candidate/theme_modeule/theme.dart';
import 'package:hindustan_job/config/responsive.dart';
import 'package:hindustan_job/config/size_config.dart';
import 'package:hindustan_job/constants/colors.dart';
import 'package:hindustan_job/services/api_services/panel_services.dart';
import 'package:hindustan_job/services/api_services/user_services.dart';
import 'package:hindustan_job/services/auth/auth.dart';
import 'package:hindustan_job/services/services_constant/response_model.dart';
import 'package:hindustan_job/utility/function_utility.dart';
import 'package:hindustan_job/widget/buttons/outline_buttons.dart';
import 'package:hindustan_job/widget/drop_down_widget/drop_down_dynamic_widget.dart';
import 'package:hindustan_job/widget/landing_page_widget/footer.dart';
import 'package:hindustan_job/widget/text_form_field_widget.dart';

class BankAccountEdit extends ConsumerStatefulWidget {
  Data? getAdd;
  BankAccountEdit({
    this.getAdd,
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState<BankAccountEdit> createState() => _BankAccountEditState();
}

class _BankAccountEditState extends ConsumerState<BankAccountEdit> {
  final _formkey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    accountType.text = DropdownString.accountType;
    if (widget.getAdd != null) {
      setData(widget.getAdd!);
    }
    // ref.read(editProfileData).getBankDetails(context);
  }

  List? select;

  TextEditingController fulname = TextEditingController();
  TextEditingController accountNumber = TextEditingController();
  TextEditingController accountConfirmNumber = TextEditingController();
  TextEditingController bankName = TextEditingController();
  TextEditingController bankBranch = TextEditingController();
  TextEditingController ifscCode = TextEditingController();
  TextEditingController accountType = TextEditingController();

  getIFSCDetails(ifsc) async {
    var response = await fetchIFSCDetail(context, ifsc);
    if (response != null) {
      response = IFSCModel.fromJson(response.data);
      bankName.text = response.bANK;
      bankBranch.text = response.bRANCH;
      setState(() {});
    }
  }

  setData(Data getAdd) {
    fulname.text = getAdd.fullRegisteredName.toString();
    accountNumber.text = getAdd.bankAccountNumber.toString();
    accountConfirmNumber.text = getAdd.bankAccountNumber.toString();
    bankName.text = getAdd.bankName.toString();
    bankBranch.text = getAdd.branchName.toString();
    ifscCode.text = getAdd.ifscCode.toString();
    accountType.text = getAdd.bankAccountType.toString();
    DropdownString.accountType = accountType.text;
    setState(() {});
  }

  final GlobalKey<ScaffoldState> _drawerKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    Sizeconfig().init(context);
    final styles = Mytheme.lightTheme(context).textTheme.headline1!;
    return Scaffold(
      backgroundColor: MyAppColor.backgroundColor,
      appBar: CustomAppBar(
        context: context,
        drawerKey: _drawerKey,
        back: "HOME (JOB-SEEKER) / Edit Bank Details  ",
      ),
      body: Responsive(
        mobile: SingleChildScrollView(
          child: _myWalletBank(styles),
        ),
        desktop: Center(
          child: _myWalletBank(styles),
        ),
        tablet: SingleChildScrollView(
          child: Center(
            child: SizedBox(
              width: Sizeconfig.screenWidth! / 2,
              child: _myWalletBank(styles),
            ),
          ),
        ),
        smallMobile: SingleChildScrollView(child: _myWalletBank(styles)),
      ),
    );
  }

  Widget _myWalletBank(TextStyle styles) {
    return Container(
      child: SingleChildScrollView(
        child: Form(
          key: _formkey,
          child: Column(
            children: [
              SizedBox(
                height: 40,
              ),
              Stack(
                children: [
                  Container(
                    alignment: Alignment.center,
                    color: MyAppColor.greylight,
                    height: Sizeconfig.screenHeight! / 10,
                    width: !Responsive.isDesktop(context)
                        ? double.infinity
                        : Sizeconfig.screenWidth! / 1.9,
                    child: Text(
                      'My Bank Details',
                      style: whiteSb14(),
                    ),
                  ),
                  Positioned(
                    top: 00,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Image.asset('assets/contact-image.png', height: 18),
                        Image.asset(
                          'assets/contact-image-down.png',
                          height: 18,
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    top: 00,
                    right: 00,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Image.asset(
                          'assets/contact-image-down.png',
                          height: 18,
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    bottom: 00,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Image.asset('assets/contact-page-downs.png',
                            height: 18),
                      ],
                    ),
                  ),
                  Positioned(
                    bottom: 00,
                    right: 00,
                    child: Image.asset('assets/contact-image-left.png',
                        height: 18),
                  ),
                ],
              ),
              Container(
                width: Responsive.isDesktop(context)
                    ? Sizeconfig.screenWidth! / 1.9
                    : Sizeconfig.screenWidth!,
                color: MyAppColor.greynormal,
                child: Column(
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Image.asset(
                      "assets/bankdetailimg.png",
                      height: 90,
                      width: 90,
                    ),
                    !Responsive.isDesktop(context)
                        ? Padding(
                            padding: const EdgeInsets.only(
                                left: 15, right: 15, top: 8),
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 20,
                                ),
                                fullname(),
                                SizedBox(
                                  height: 10,
                                ),
                                accountTpe(context),
                                SizedBox(
                                  height: 10,
                                ),
                                bankaccount(),
                                SizedBox(
                                  height: 10,
                                ),
                                bankconfirmaccount(),
                                SizedBox(
                                  height: 10,
                                ),
                                ifsc(),
                                SizedBox(
                                  height: 10,
                                ),
                                bankname(),
                                SizedBox(
                                  height: 10,
                                ),
                                branchname(),
                                SizedBox(
                                  height: 30,
                                ),
                              ],
                            ),
                          )
                        : Center(
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 40,
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 50.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      fullname(),
                                      Expanded(child: accountTpe(context)),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 50.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      bankaccount(),
                                      bankconfirmaccount(),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 50.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      bankname(),
                                      branchname(),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 50.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      ifsc(),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 40,
                                ),
                              ],
                            ),
                          ),
                  ],
                ),
              ),
              Padding(
                padding: paddingvertical30,
                child: ElevatedButton(
                  onPressed: () async {
                    await bankAdd();
                  },
                  child: widget.getAdd == null
                      ? Text(
                          'Submit',
                          style: whiteSb12(),
                        )
                      : Text(
                          'Update',
                          style: whiteSb12(),
                        ),
                  style: ElevatedButton.styleFrom(
                    primary: MyAppColor.orangedark,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    minimumSize: Size(150, 45),
                  ),
                ),
              ),
              Footer(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _branchName() {
    return Consumer(builder: (context, watch, child) {
      return Container(
        width: !Responsive.isDesktop(context)
            ? Sizeconfig.screenWidth!
            : Sizeconfig.screenWidth! / 4.6,
        padding: EdgeInsets.all(10),
        color: MyAppColor.grayplane,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Bank Branch",
                  style: appleColorsb10,
                ),
                SizedBox(
                  height: 4,
                ),
                Text("ABG Bank", style: blackdarkM12)
              ],
            ),
          ],
        ),
      );
    });
  }

  Widget _bankName() {
    return Container(
      width: !Responsive.isDesktop(context)
          ? Sizeconfig.screenWidth!
          : Sizeconfig.screenWidth! / 4.6,
      padding: EdgeInsets.all(10),
      color: MyAppColor.grayplane,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Bank Name",
                style: appleColorsb10,
              ),
              SizedBox(
                height: 4,
              ),
              Text("ABG Bank", style: blackdarkM12)
            ],
          ),
        ],
      ),
    );
  }

  Widget _ifscCode() {
    return Container(
      width: !Responsive.isDesktop(context)
          ? Sizeconfig.screenWidth!
          : Sizeconfig.screenWidth! / 4.6,
      padding: EdgeInsets.all(10),
      color: MyAppColor.grayplane,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "IFSC Code",
                style: appleColorsb10,
              ),
              SizedBox(
                height: 4,
              ),
              Text("ABG145872001", style: blackdarkM12)
            ],
          ),
        ],
      ),
    );
  }

  Widget _bankAccount() {
    return Container(
      width: !Responsive.isDesktop(context)
          ? Sizeconfig.screenWidth!
          : Sizeconfig.screenWidth! / 4.6,
      padding: EdgeInsets.all(10),
      color: MyAppColor.grayplane,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Bank Account Number",
                style: appleColorsb10,
              ),
              SizedBox(
                height: 4,
              ),
              Text("1117 8914 5871 11", style: blackdarkM12)
            ],
          ),
        ],
      ),
    );
  }

  Widget _bankConfirmAccount() {
    return Container(
      width: !Responsive.isDesktop(context)
          ? Sizeconfig.screenWidth!
          : Sizeconfig.screenWidth! / 4.6,
      padding: EdgeInsets.all(10),
      color: MyAppColor.grayplane,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Confirm Bank Account Number",
                style: appleColorsb10,
              ),
              SizedBox(
                height: 4,
              ),
              Text("1117 8914 5871 11", style: blackdarkM12)
            ],
          ),
        ],
      ),
    );
  }

  fullname() {
    return SizedBox(
      width: 300,
      height: 60,
      child: TextFormFieldWidget(
          text: 'Enter Yor Name',
          isRequired: false,
          control: fulname,
          //..text = widget.getAdd!.fullRegisteredName.toString(),
          styles: blackDark12,
          type: TextInputType.name),
    );
  }

  Widget accountTpe(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: Responsive.isDesktop(context) ? 10 : 00,
        left: Responsive.isMobile(context) ? 15 : 20,
        right: Responsive.isMobile(context) ? 15 : 00,
        bottom: Responsive.isDesktop(context) ? 22 : 00,
      ),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 15),
        height: Responsive.isMobile(context) ? 46 : 48,
        width: Responsive.isMobile(context)
            ? double.infinity
            : Sizeconfig.screenWidth! / 4.6,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(3),
          border: Border.all(color: MyAppColor.white),
        ),
        child: Padding(
          padding: const EdgeInsets.only(right: 8),
          child: DropdownButtonHideUnderline(
            child: ButtonTheme(
              child: DropdownButton<String>(
                value: DropdownString.accountType,
                icon: IconFile.arrow,
                iconSize: Responsive.isMobile(context) ? 25 : 15,
                elevation: 16,
                style: blackDark12,
                onChanged: (String? newValue) {
                  setState(() {
                    accountType.text = newValue.toString();
                    DropdownString.accountType = newValue.toString();
                  });
                },
                items: ListDropdown.accountTypes
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      value,
                      style: blackDark12,
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ),
      ),
    );
  }

  type() {
    return SizedBox(
      width: 300,
      height: 60,
      child: TextFormFieldWidget(
          text: 'Enter Your Account type',
          isRequired: true,
          control: accountType,
          // ..text = widget.getAdd!.bankAccountType.toString(),
          styles: blackDark12,
          type: TextInputType.name),
    );
  }

  ifsc() {
    return SizedBox(
      width: 300,
      height: 60,
      child: TextFormFieldWidget(
        text: 'Enter Ifsc code',
        isRequired: true,
        control: ifscCode,
        onChanged: (val) async {
          await getIFSCDetails(val);
        },
        styles: blackDark12,
        type: TextInputType.multiline,
      ),
    );
  }

  branchname() {
    return SizedBox(
      width: 300,
      height: 60,
      child: TextFormFieldWidget(
          text: 'Enter Branch Name',
          isRequired: false,
          control: bankBranch,
          // .text = widget.getAdd!.branchName.toString(),
          styles: blackDark12,
          type: TextInputType.none),
    );
  }

  bankname() {
    return SizedBox(
      width: 300,
      height: 60,
      child: TextFormFieldWidget(
          text: 'Enter Bank Name',
          isRequired: false,
          control: bankName,
          // ..text = widget.getAdd!.bankName.toString(),
          styles: blackDark12,
          type: TextInputType.none),
    );
  }

  bankaccount() {
    return SizedBox(
      width: 300,
      height: 60,
      child: TextFormFieldWidget(
          text: 'Enter Account No ',
          isRequired: false,
          control: accountNumber,
          // ..text = widget.getAdd!.bankAccountNumber.toString(),
          styles: blackDark12,
          type: TextInputType.number),
    );
  }

  bankconfirmaccount() {
    return SizedBox(
      width: 300,
      height: 60,
      child: TextFormFieldWidget(
          text: 'Re-Enter Account No ',
          isRequired: false,
          control: accountConfirmNumber,
          // ..text = widget.getAdd!.bankAccountNumber.toString(),
          styles: blackDark12,
          type: TextInputType.number),
    );
  }

  Widget _fullNameRegistered() {
    return Container(
      padding: EdgeInsets.all(10),
      color: MyAppColor.grayplane,
      width: !Responsive.isDesktop(context)
          ? Sizeconfig.screenWidth!
          : Sizeconfig.screenWidth! / 4.6,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Full Name registered with Bank",

                // widget.getAdd!.bankAccountNumber.toString(),
                style: appleColorsb10,
              ),
              SizedBox(
                height: 4,
              ),
              Text("John Kumar Cena", style: blackdarkM12)
            ],
          ),
        ],
      ),
    );
  }

  bankAdd() async {
    if (accountConfirmNumber.text != accountNumber.text) {
      return showSnack(
          context: context,
          msg: "Your account number not matched",
          type: 'error');
    }
    final addBankData = {
      "bank_name": bankName.text,
      "branch_name": bankBranch.text,
      "full_registered_name": fulname.text,
      "ifsc_code": ifscCode.text,
      "bank_account_number": accountNumber.text.toString(),
      "bank_account_type": accountType.text.toString()
    };
    ApiResponse response;
    if (widget.getAdd != null) {
      addBankData['id'] = widget.getAdd!.id.toString();
      response = await editBankDetails(addBankData);
    } else {
      response = await bankPostDetails(addBankData);
    }

    if (response.status == 200) {
      ref.watch(editProfileData).getBankDetails(context);
      return Navigator.pop(context, true);
    } else {
      showSnack(context: context, msg: response.body!.message, type: 'error');
    }
  }
}
