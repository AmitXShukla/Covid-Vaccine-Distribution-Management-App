import 'package:vaccine_dist/shared/custom_components.dart';
import 'package:vaccine_dist/shared/custom_style.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Reports extends StatefulWidget {
  static const routeName = '/reports';
  @override
  ReportsState createState() => ReportsState();
}

class ReportsState extends State<Reports> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
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

  @override
  Widget build(BuildContext context) {
    return Material(
        child: Container(margin: EdgeInsets.all(20.0), child: settings()));
  }

  Widget settings() {
    return Center(
      child: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 25.0),
          ),
          Container(margin: EdgeInsets.all(20.0), child: CustomAdminNav()),
          Container(
            margin: EdgeInsets.only(top: 25.0),
          ),
          Text("Admin Reports", style: cHeaderDarkText),
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Icon(Icons.receipt, color: Colors.grey),
              Text(
                "Reports",
                style: cNavText,
              ),
              SizedBox(
                width: 10,
                height: 10,
              ),
              Text(
                "Appointments by date",
                style: cBodyText,
              ),
              SizedBox(
                width: 10,
                height: 10,
              ),
              Text(
                "Doses by date",
                style: cBodyText,
              ),
              SizedBox(
                width: 10,
                height: 10,
              ),
              Text(
                "On Hand Inventory Qty by warehouse",
                style: cBodyText,
              ),
              SizedBox(
                width: 10,
                height: 10,
              ),
              Text(
                "On Hand Inventory Qty by distribution center",
                style: cBodyText,
              ),
              SizedBox(
                width: 10,
                height: 10,
              ),
              Text(
                "Vendor PO status by date",
                style: cBodyText,
              ),
              SizedBox(
                width: 10,
                height: 10,
              ),
              Text(
                "MSR (Material Service Request) status by date",
                style: cBodyText,
              ),
              SizedBox(
                width: 10,
                height: 10,
              ),
              Text(
                "Received inventory by date",
                style: cBodyText,
              ),
              SizedBox(
                width: 10,
                height: 10,
              ),
              Text(
                "Returned inventory by date",
                style: cBodyText,
              ),
              SizedBox(
                width: 10,
                height: 10,
              ),
              Text(
                "Discarded inventory by date",
                style: cBodyText,
              ),
              SizedBox(
                width: 10,
                height: 10,
              )
            ],
          )
        ],
      ),
    );
  }
}
