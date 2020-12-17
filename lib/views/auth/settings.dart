import 'dart:async';
import 'dart:convert';
import 'package:vaccine_dist/blocs/auth/auth.bloc.dart';
import 'package:vaccine_dist/shared/custom_components.dart';
import 'package:vaccine_dist/shared/custom_style.dart';
import 'package:vaccine_dist/models/datamodel.dart';
import 'package:vaccine_dist/blocs/validators.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Settings extends StatefulWidget {
  static const routeName = '/settings';
  @override
  SettingsState createState() => SettingsState();
}

class SettingsState extends State<Settings> {
  bool spinnerVisible = false;
  bool messageVisible = false;
  bool isAdmin = false;
  String messageTxt = "";
  String messageType = "";
  final _formKey = GlobalKey<FormState>();
  SettingsDataModel formData = SettingsDataModel();
  bool _btnEnabled = false;
  TextEditingController _nameController = new TextEditingController();
  TextEditingController _emailController = new TextEditingController();
  TextEditingController _phoneController = new TextEditingController();

  @override
  void initState() {
    AuthBloc authBloc = AuthBloc();
    getData(authBloc);
    super.initState();
  }

  @override
  void dispose() {
    authBloc.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _launched;
  Future<void> _launchInBrowser(String url) async {
    if (await canLaunch(url)) {
      await launch(
        url,
        forceSafariVC: false,
        forceWebView: false,
        // headers: <String, String>{'my_header_key': 'my_header_value'},
      );
    } else {
      throw 'Could not launch $url';
    }
  }

  toggleSpinner() {
    setState(() => spinnerVisible = !spinnerVisible);
  }

  showMessage(bool msgVisible, msgType, message) {
    messageVisible = msgVisible;
    setState(() {
      messageType = msgType == "error"
          ? cMessageType.error.toString()
          : cMessageType.success.toString();
      messageTxt = message;
    });
  }

  getData(AuthBloc authBloc) async {
    toggleSpinner();
    messageVisible = true;
    if (authBloc.isSignedIn()) {
      if (authBloc.isSignedIn()) {
        await authBloc
            .getData()
            .then((res) => setState(
                () => updateFormData(SettingsDataModel.fromJson(res.data()))))
            .catchError((error) => showMessage(
                true, "error", "User information is not available."));
      }
    } else {
      showMessage(true, "error", "An un-known error has occured.");
    }
    toggleSpinner();
  }

  updateFormData(data) {
    formData = data;
    if (formData.role == "admin") {
      setState(() {
        isAdmin = true;
      });
    }
    _nameController.text = formData.name;
    _phoneController.text = formData.phone;
    _emailController.text = formData.email;
  }

  Future setData(AuthBloc authBloc) async {
    toggleSpinner();
    messageVisible = true;
    await authBloc
        .setData(formData)
        .then((res) => {showMessage(true, "success", "Data is saved.")})
        .catchError((error) => {showMessage(true, "error", error.toString())});
    toggleSpinner();
  }

  @override
  Widget build(BuildContext context) {
    AuthBloc authBloc = AuthBloc();
    return Material(
        child: Container(
            margin: EdgeInsets.all(20.0),
            child: authBloc.isSignedIn()
                ? settings(authBloc)
                : loginPage(authBloc)));
  }

  Widget loginPage(AuthBloc authBloc) {
    return Column(
      children: [
        SizedBox(width: 10, height: 50),
        RaisedButton(
          child: Text('Click here to go to Login page'),
          color: Colors.blue,
          onPressed: () {
            Navigator.pushReplacementNamed(
              context,
              '/login',
            );
          },
        )
      ],
    );
  }

  Widget settings(AuthBloc authBloc) {
    return Form(
      key: _formKey,
      autovalidateMode: AutovalidateMode.always,
      onChanged: () =>
          setState(() => _btnEnabled = _formKey.currentState.validate()),
      child: Center(
        child: Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(top: 25.0),
            ),
            Container(
                margin: EdgeInsets.all(20.0),
                child: isAdmin
                    // ? adminNav(context, authBloc)
                    ? CustomAdminNav()
                    : CustomGuestNav()),
            // : guestNav(context, authBloc)),
            Container(
              margin: EdgeInsets.only(top: 25.0),
            ),
            Text("Update user settings", style: cHeaderDarkText),
            Container(
                width: 300.0,
                margin: EdgeInsets.only(top: 25.0),
                child: TextFormField(
                  controller: _nameController,
                  cursorColor: Colors.blueAccent,
                  keyboardType: TextInputType.name,
                  maxLength: 50,
                  obscureText: false,
                  onChanged: (value) => formData.name = value,
                  validator: evalName,
                  decoration: InputDecoration(
                    icon: Icon(Icons.person),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16.0)),
                    hintText: 'your name',
                    labelText: 'Name *',
                    // errorText: snapshot.error,
                  ),
                )),
            Container(
              margin: EdgeInsets.only(top: 5.0),
            ),
            Container(
                width: 300.0,
                margin: EdgeInsets.only(top: 25.0),
                child: TextFormField(
                  controller: _emailController,
                  cursorColor: Colors.blueAccent,
                  keyboardType: TextInputType.emailAddress,
                  maxLength: 50,
                  obscureText: false,
                  onChanged: (value) => formData.email = value,
                  validator: evalEmail,
                  decoration: InputDecoration(
                    icon: Icon(Icons.email),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16.0)),
                    hintText: 'name@domain.com',
                    labelText: 'emailID *',
                  ),
                )),
            Container(
              margin: EdgeInsets.only(top: 5.0),
            ),
            Container(
                width: 300.0,
                margin: EdgeInsets.only(top: 25.0),
                child: TextFormField(
                  controller: _phoneController,
                  cursorColor: Colors.blueAccent,
                  keyboardType: TextInputType.phone,
                  maxLength: 50,
                  obscureText: false,
                  onChanged: (value) => formData.phone = value,
                  validator: evalPhone,
                  decoration: InputDecoration(
                    icon: Icon(Icons.phone),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16.0)),
                    hintText: '123-000-0000',
                    labelText: 'phone *',
                  ),
                )),
            Container(
              margin: EdgeInsets.only(top: 25.0),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0),
            ),
            CustomSpinner(toggleSpinner: spinnerVisible),
            CustomMessage(
                toggleMessage: messageVisible,
                toggleMessageType: messageType,
                toggleMessageTxt: messageTxt),
            Container(
              margin: EdgeInsets.only(top: 15.0),
            ),
            signinSubmitBtn(context, authBloc)
          ],
        ),
      ),
    );
  }

  Widget signinSubmitBtn(context, authBloc) {
    return RaisedButton(
      child: Text('Save'),
      color: Colors.blue,
      onPressed: _btnEnabled == true ? () => setData(authBloc) : null,
    );
  }

  // Widget guestNav(context, AuthBloc authBloc) {
  //   return Row(
  //     children: [
  //       Column(
  //         mainAxisSize: MainAxisSize.min,
  //         children: <Widget>[
  //           IconButton(
  //             icon:
  //                 Icon(Icons.calendar_today_rounded, color: Colors.greenAccent),
  //             onPressed: () {
  //               Navigator.pushReplacementNamed(
  //                 context,
  //                 '/login',
  //               );
  //             },
  //           ),
  //           Text(
  //             "Appointment",
  //             style: cBodyText,
  //           ),
  //         ],
  //       ),
  //       SizedBox(
  //         width: 7,
  //         height: 7,
  //       ),
  //       Column(
  //         mainAxisSize: MainAxisSize.min,
  //         children: <Widget>[
  //           IconButton(
  //             icon: Icon(Icons.person, color: Colors.pink),
  //             onPressed: () {
  //               Navigator.pushReplacementNamed(
  //                 context,
  //                 '/login',
  //               );
  //             },
  //           ),
  //           Text(
  //             "Personal Data",
  //             style: cBodyText,
  //           ),
  //         ],
  //       ),
  //       SizedBox(
  //         width: 7,
  //         height: 7,
  //       ),
  //       Column(
  //         mainAxisSize: MainAxisSize.min,
  //         children: <Widget>[
  //           IconButton(
  //             icon: Icon(Icons.receipt, color: Colors.orange),
  //             onPressed: () {
  //               Navigator.pushReplacementNamed(
  //                 context,
  //                 '/login',
  //               );
  //             },
  //           ),
  //           Text(
  //             "Records",
  //             style: cBodyText,
  //           ),
  //         ],
  //       ),
  //       SizedBox(
  //         width: 7,
  //         height: 7,
  //       ),
  //       Column(
  //         mainAxisSize: MainAxisSize.min,
  //         children: <Widget>[
  //           IconButton(
  //             icon: Icon(Icons.wallet_travel, color: Colors.greenAccent),
  //             onPressed: () => setState(() {
  //               _launched = _launchInBrowser(
  //                   'https://www.youtube.com/watch?v=MkV413X2Kmw&list=PLp0TENYyY8lHL-G7jGbhpJBhVb2UdTOhQ&index=1&t=698s');
  //             }),
  //           ),
  //           Text(
  //             "ContactTracing",
  //             style: cBodyText,
  //           ),
  //         ],
  //       ),
  //       SizedBox(
  //         width: 40,
  //         height: 40,
  //       ),
  //       Column(
  //         mainAxisSize: MainAxisSize.min,
  //         children: <Widget>[
  //           IconButton(
  //             icon: Icon(Icons.settings, color: Colors.blue),
  //             onPressed: () {
  //               Navigator.pushReplacementNamed(
  //                 context,
  //                 '/login',
  //               );
  //             },
  //           ),
  //           Text(
  //             "Sign Out",
  //             style: cBodyText,
  //           ),
  //         ],
  //       ),
  //     ],
  //   );
  // }

  // Widget adminNav(context, AuthBloc authBloc) {
  //   return Row(
  //     children: [
  //       Column(
  //         mainAxisSize: MainAxisSize.min,
  //         children: <Widget>[
  //           IconButton(
  //             icon:
  //                 Icon(Icons.calendar_today_rounded, color: Colors.deepPurple),
  //             onPressed: () {
  //               Navigator.pushReplacementNamed(
  //                 context,
  //                 '/login',
  //               );
  //             },
  //           ),
  //           Text(
  //             "Appointment",
  //             style: cBodyText,
  //           ),
  //         ],
  //       ),
  //       SizedBox(
  //         width: 7,
  //         height: 7,
  //       ),
  //       Column(
  //         mainAxisSize: MainAxisSize.min,
  //         children: <Widget>[
  //           IconButton(
  //             icon: Icon(Icons.dashboard, color: Colors.deepOrange),
  //             onPressed: () {
  //               Navigator.pushReplacementNamed(
  //                 context,
  //                 '/login',
  //               );
  //             },
  //           ),
  //           Text(
  //             "SupplyChain",
  //             style: cBodyText,
  //           ),
  //         ],
  //       ),
  //       SizedBox(
  //         width: 7,
  //         height: 7,
  //       ),
  //       Column(
  //         mainAxisSize: MainAxisSize.min,
  //         children: <Widget>[
  //           IconButton(
  //             icon: Icon(Icons.receipt, color: Colors.grey),
  //             onPressed: () {
  //               Navigator.pushReplacementNamed(
  //                 context,
  //                 '/login',
  //               );
  //             },
  //           ),
  //           Text(
  //             "Reports",
  //             style: cBodyText,
  //           ),
  //         ],
  //       ),
  //       SizedBox(
  //         width: 40,
  //         height: 40,
  //       ),
  //       Column(
  //         mainAxisSize: MainAxisSize.min,
  //         children: <Widget>[
  //           IconButton(
  //             icon: Icon(Icons.settings, color: Colors.blue),
  //             onPressed: () {
  //               Navigator.pushReplacementNamed(
  //                 context,
  //                 '/login',
  //               );
  //             },
  //           ),
  //           Text(
  //             "Sign Out",
  //             style: cBodyText,
  //           ),
  //         ],
  //       ),
  //     ],
  //   );
  // }
}
