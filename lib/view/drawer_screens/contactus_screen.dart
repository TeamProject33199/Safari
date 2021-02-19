import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:project/constants_colors.dart';
import 'package:project/locale_language/localization_delegate.dart';


class ContactUsScreen extends StatefulWidget {
  @override
  _ContactUsScreenState createState() => _ContactUsScreenState();
}

class _ContactUsScreenState extends State<ContactUsScreen> {

  TextEditingController _messageController = TextEditingController();
  TextEditingController _subjectController = TextEditingController();

  var _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  OutlineInputBorder borderE = OutlineInputBorder(
    borderSide: BorderSide(
      color: primary200Color,
      width: 2,
    ),
    borderRadius: BorderRadius.circular(50),
  );

  OutlineInputBorder borderF = OutlineInputBorder(
    borderSide: BorderSide(
      width: 2,
      color: primaryColor,
    ),
    borderRadius: BorderRadius.circular(50),
  );

  @override
  void dispose() {
    _messageController.dispose();
    _subjectController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: primaryColor,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
        title: Text(
            AppLocalization.of(context).getTranslated("contact_us_title"),
            style: TextStyle(
              color: blackColor,
            )),
        backgroundColor: transparent,
        elevation: 0,
      ),
      body: ListView(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 20),
            child: Text(
              " ${AppLocalization.of(context).getTranslated("text_note1")} \n & ${AppLocalization.of(context).getTranslated("text_note2")}",
              style: TextStyle(
                  fontSize: 20,
                  color: grey500Color,
                  fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
          Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.only(left: 20, top: 30, right: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [

                  TextFormField(
                    keyboardType: TextInputType.text,
                    controller: _subjectController,
                    style: TextStyle(
                      color: blackColor,
                    ),
                    decoration: InputDecoration(
                        prefixStyle: TextStyle(
                          color: grey50Color,
                        ),
                        labelText: AppLocalization.of(context).getTranslated("text_subject"),
                        labelStyle:
                        TextStyle(inherit: true, color: blackColor),
                        hintText: AppLocalization.of(context).getTranslated("text_subject_hint"),
                        hintStyle: TextStyle( color: grey500Color),
                        prefixIcon: Icon(
                          Icons.subject,
                          color: primaryColor,
                        ),
                        fillColor: whiteColor,
                        filled: true,
                        enabledBorder: borderE,
                        focusedBorder: borderF,
                        border: borderE),
                    validator: (value) {
                      if (value.isEmpty) {
                        return AppLocalization.of(context).getTranslated("validated_field_subject");
                      } else {
                        return null;
                      }
                    },
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  TextFormField(
                    keyboardType: TextInputType.text,
                    controller: _messageController,
                    style: TextStyle(
                      color: blackColor,
                    ),
                    decoration: InputDecoration(
                        prefixStyle: TextStyle(
                          color: grey500Color,
                        ),
                        labelText: AppLocalization.of(context).getTranslated("text_message"),
                        labelStyle:
                            TextStyle(inherit: true, color: blackColor),
                        hintText: AppLocalization.of(context).getTranslated("text_message_hint"),
                        hintStyle: TextStyle( color: grey50Color),
                        prefixIcon: Icon(
                          Icons.mail,
                          color: primaryColor,
                        ),
                        fillColor: whiteColor,
                        filled: true,
                        enabledBorder: borderE,
                        focusedBorder: borderF,
                        border: borderE),
                    validator: (value) {
                      if (value.isEmpty) {
                        return AppLocalization.of(context).getTranslated("validated_field_message");
                      } else {
                        return null;
                      }
                    },
                  ),



                  SizedBox(
                    height: 40,
                  ),
                  Container(
                      width: double.infinity,
                      height: 55,
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: RaisedButton(
                        color: primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(30),
                          ),
                        ),
                        child: Text(
                          AppLocalization.of(context).getTranslated("button_send_message"),
                          style: TextStyle(
                            color: whiteColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            letterSpacing: 1.1,
                          ),
                        ),
                        onPressed: () async {

                          if (_formKey.currentState.validate()) {
                            await sendEmail();
                          }
                        },
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> sendEmail() async {
    final Email email = Email(
      body: _messageController.text,
      subject: _subjectController.text,
      recipients: ["infiniteloop20002020@gmail.com"],
      isHTML: false,
    );

    String platformResponse;

    try {
      await FlutterEmailSender.send(email);
      platformResponse = 'success';
      _subjectController.clear();
      _messageController.clear();
    } catch (error) {
      platformResponse = error.toString();
    }

    if (!mounted)
      return null;
    else
    _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(platformResponse),));
  }
}
