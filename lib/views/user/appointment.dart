import 'dart:async';
// import 'dart:convert';
import 'package:vaccine_dist/blocs/auth/auth.bloc.dart';
import 'package:vaccine_dist/shared/custom_components.dart';
import 'package:vaccine_dist/shared/custom_style.dart';
import 'package:vaccine_dist/models/datamodel.dart';
import 'package:vaccine_dist/blocs/validators.dart';
import 'package:flutter/material.dart';

class Appointment extends StatefulWidget {
  static const routeName = '/appointment';
  @override
  AppointmentState createState() => AppointmentState();
}

class AppointmentState extends State<Appointment> {
  bool spinnerVisible = false;
  bool messageVisible = false;
  bool isAdmin = false;
  String messageTxt = "";
  String messageType = "";
  final _formKey = GlobalKey<FormState>();
  AppointmentDataModel formData = AppointmentDataModel();
  bool _btnEnabled = false;
  TextEditingController _appointmentDate = new TextEditingController();
  TextEditingController _name = new TextEditingController();
  TextEditingController _phone = new TextEditingController();
  TextEditingController _comments = new TextEditingController();

  @override
  void initState() {
    AuthBloc authBloc = AuthBloc();
    getData(authBloc);
    super.initState();
  }

  @override
  void dispose() {
    authBloc.dispose();
    _appointmentDate.dispose();
    _name.dispose();
    _phone.dispose();
    _comments.dispose();
    super.dispose();
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
            .getUserData("appointments")
            .then((res) => setState(() =>
                updateFormData(AppointmentDataModel.fromJson(res.data()))))
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
    if (formData.appointmentDate != null)
      _appointmentDate.text = formData.appointmentDate;
    if (formData.name != null) _name.text = formData.name;
    if (formData.phone != null) _phone.text = formData.phone;
    if (formData.comments != null) _comments.text = formData.comments;
  }

  Future setData(AuthBloc authBloc) async {
    toggleSpinner();
    messageVisible = true;
    await authBloc
        .setUserData('appointments', formData)
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
    return ListView(
      children: [
        Form(
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
                    margin: EdgeInsets.all(20.0), child: CustomGuestNav()),
                // : guestNav(context, authBloc)),
                Container(
                  margin: EdgeInsets.only(top: 25.0),
                ),
                Text("Update Appointment Date", style: cHeaderDarkText),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    IconButton(
                      icon: Icon(Icons.calendar_today_outlined,
                          color: Colors.pink),
                      onPressed: () {
                        Navigator.pushReplacementNamed(
                          context,
                          '/appointment',
                        );
                      },
                    ),
                    Text(
                      "Appointment",
                      style: cBodyText,
                    ),
                  ],
                ),
                Container(
                  width: 300,
                  child: TextFormField(
                    controller: _appointmentDate,
                    decoration: InputDecoration(
                      labelText: "Appointment Date",
                      hintText: "Ex. preferred appointment datetime",
                    ),
                    validator: evalName,
                    onTap: () async {
                      DateTime date = DateTime(1900);
                      FocusScope.of(context).requestFocus(new FocusNode());

                      date = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(1900),
                          lastDate: DateTime(2100));
                      _appointmentDate.text = date.toIso8601String();
                      formData.appointmentDate = date.toIso8601String();
                    },
                  ),
                ),
                Container(
                    width: 300.0,
                    margin: EdgeInsets.only(top: 25.0),
                    child: TextFormField(
                      controller: _name,
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
                      controller: _phone,
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
                        hintText: 'your phone #',
                        labelText: 'Phone *',
                        // errorText: snapshot.error,
                      ),
                    )),
                Container(
                    width: 300.0,
                    margin: EdgeInsets.only(top: 25.0),
                    child: TextFormField(
                      controller: _comments,
                      cursorColor: Colors.blueAccent,
                      maxLength: 50,
                      obscureText: false,
                      onChanged: (value) => formData.comments = value,
                      validator: evalChar,
                      decoration: InputDecoration(
                        icon: Icon(Icons.sms),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16.0)),
                        hintText: 'comments',
                        labelText: 'comments *',
                        // errorText: snapshot.error,
                      ),
                    )),
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
        ),
      ],
    );
  }

  Widget signinSubmitBtn(context, authBloc) {
    return RaisedButton(
      child: Text('Save'),
      color: Colors.blue,
      onPressed: _btnEnabled == true ? () => setData(authBloc) : null,
    );
  }
}
