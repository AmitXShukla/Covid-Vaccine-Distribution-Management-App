import 'package:vaccine_dist/blocs/auth/auth.bloc.dart';
import 'package:vaccine_dist/shared/custom_components.dart';
import 'package:vaccine_dist/shared/custom_style.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vaccine_dist/models/datamodel.dart';

class Appointments extends StatefulWidget {
  static const routeName = '/appointments';
  @override
  AppointmentsState createState() => AppointmentsState();
}

class AppointmentsState extends State<Appointments> {
  bool spinnerVisible = false;
  bool messageVisible = false;
  String messageTxt = "";
  String messageType = "";
  CollectionReference appointments =
      FirebaseFirestore.instance.collection('appointments');

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    authBloc.dispose();
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
        Center(
          child: Column(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(top: 25.0),
              ),
              Container(margin: EdgeInsets.all(20.0), child: CustomAdminNav()),
              // : guestNav(context, authBloc)),
              Container(
                margin: EdgeInsets.only(top: 25.0),
              ),
              Text("Appointments", style: cHeaderDarkText),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  IconButton(
                    icon:
                        Icon(Icons.calendar_today_outlined, color: Colors.pink),
                    onPressed: () {
                      Navigator.pushReplacementNamed(
                        context,
                        '/appointments',
                      );
                    },
                  ),
                  Text(
                    "Schedule",
                    style: cBodyText,
                  ),
                ],
              ),
              Container(
                  width: 400,
                  height: 600,
                  child: showAppointments(context, authBloc)),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10.0),
              ),
              CustomSpinner(toggleSpinner: spinnerVisible),
              CustomMessage(
                  toggleMessage: messageVisible,
                  toggleMessageType: messageType,
                  toggleMessageTxt: messageTxt),
            ],
          ),
        ),
      ],
    );
  }

  Widget showAppointments(BuildContext context, AuthBloc authBloc) {
    return StreamBuilder<QuerySnapshot>(
        stream: appointments.snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            // return Text('Something went wrong');
            return showMessage(true, "error", "An un-known error has occured.");
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Text("Loading");
          }

          return new ListView(
            children: snapshot.data.docs.map((DocumentSnapshot document) {
              return new ListTile(
                title: new Text(document.data()['appointmentDate']),
                subtitle: Column(
                  children: [
                    Row(
                      children: [
                        new Text("Name: "),
                        new Text(document.data()['name']),
                        new Text(" Phone: "),
                        new Text(document.data()['phone']),
                      ],
                    ),
                    Row(
                      children: [
                        Row(
                          children: [
                            new Text(" Comments: "),
                            new Text(document.data()['comments']),
                          ],
                        )
                      ],
                    )
                  ],
                ),
                onTap: () {
                  Navigator.pushReplacementNamed(context, '/vaccine',
                      arguments: ScreenArguments(document.data()['author']));
                },
              );
            }).toList(),
          );
        });
  }
}
