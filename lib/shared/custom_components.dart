import 'package:vaccine_dist/shared/custom_style.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class CustomSpinner extends StatelessWidget {
  final bool toggleSpinner;
  const CustomSpinner({Key key, this.toggleSpinner}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(child: toggleSpinner ? CircularProgressIndicator() : null);
  }
}

class CustomMessage extends StatelessWidget {
  final bool toggleMessage;
  final toggleMessageType;
  final String toggleMessageTxt;
  const CustomMessage(
      {Key key,
      this.toggleMessage,
      this.toggleMessageType,
      this.toggleMessageTxt})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: toggleMessage
            ? Text(toggleMessageTxt,
                style: toggleMessageType == cMessageType.error.toString()
                    ? cErrorText
                    : cSuccessText)
            : null);
  }
}

class CustomDrawer extends StatelessWidget {
  //final bool toggleSpinner;
  const CustomDrawer({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      semanticLabel: cLabel,
// Add a ListView to the drawer. This ensures the user can scroll
// through the options in the drawer if there isn't enough vertical
// space to fit everything.
      child: ListView(
// Important: Remove any padding from the ListView.
        padding: EdgeInsets.all(4.0),
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(cAppTitle),
            accountEmail: Text(cEmailID),
            currentAccountPicture: CircleAvatar(
              backgroundImage: NetworkImage(cSampleImage),
            ),
          ),
          SizedBox(height: 10),
          ListTile(
            leading: Icon(Icons.book),
            title: Text(
              "AddressBook",
              style: cNavText,
            ),
            onTap: () => {
              Navigator.pushReplacementNamed(
                context,
                '/addressbook',
              )
            },
          ),
          ListTile(
            leading: Icon(Icons.business),
            title: Text(
              "Marketing",
              style: cNavText,
            ),
            onTap: null,
            subtitle: Text('Manage Campaigns, Leads & Opportunities.'),
            trailing: Icon(Icons.more_vert),
            isThreeLine: true,
          ),
          ListTile(
            leading: Icon(Icons.call),
            title: Text(
              "Call Register",
              style: cNavText,
            ),
            onTap: null,
            subtitle: Text('Manage Calls, eMails, enquiry, & visits'),
            trailing: Icon(Icons.more_vert),
            isThreeLine: true,
          ),
          ListTile(
            leading: Icon(Icons.dashboard),
            title: Text(
              "Customer",
              style: cNavText,
            ),
            onTap: null,
            subtitle: Text('Bills, Invoices & Sales register'),
            trailing: Icon(Icons.more_vert),
            isThreeLine: true,
          ),
          ListTile(
            leading: Icon(Icons.sms),
            title: Text(
              "HelpDesk",
              style: cNavText,
            ),
            onTap: null,
            subtitle: Text('Service Tickets, Workorder'),
            trailing: Icon(Icons.more_vert),
            isThreeLine: true,
          ),
          ListTile(
            leading: Icon(Icons.satellite),
            title: Text(
              "Vendors",
              style: cNavText,
            ),
            onTap: null,
            subtitle: Text('Vouchers, Bills, Invoices'),
            trailing: Icon(Icons.more_vert),
            isThreeLine: true,
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text(
              "Admin",
              style: cNavText,
            ),
            onTap: null,
          ),
          RaisedButton(
            child: Text('Logout'),
            color: Colors.blue,
            onPressed: () {
              Navigator.pushReplacementNamed(
                context,
                '/',
              );
            },
          ),
        ],
      ),
    );
  }
}

class CustomAdminNav extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            IconButton(
              icon:
                  Icon(Icons.calendar_today_rounded, color: Colors.deepPurple),
              onPressed: () {
                Navigator.pushReplacementNamed(
                  context,
                  '/appointments',
                );
              },
            ),
            Text(
              "Appointments",
              style: cBodyText,
            ),
          ],
        ),
        SizedBox(
          width: 7,
          height: 7,
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.dashboard, color: Colors.deepOrange),
              onPressed: () {
                Navigator.pushReplacementNamed(
                  context,
                  '/purchase',
                );
              },
            ),
            Text(
              "SupplyChain",
              style: cBodyText,
            ),
          ],
        ),
        SizedBox(
          width: 7,
          height: 7,
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.receipt, color: Colors.grey),
              onPressed: () {
                Navigator.pushReplacementNamed(
                  context,
                  '/reports',
                );
              },
            ),
            Text(
              "Reports",
              style: cBodyText,
            ),
          ],
        ),
        SizedBox(
          width: 40,
          height: 40,
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.settings, color: Colors.blue),
              onPressed: () {
                Navigator.pushReplacementNamed(
                  context,
                  '/login',
                );
              },
            ),
            Text(
              "Sign Out",
              style: cBodyText,
            ),
          ],
        ),
      ],
    );
  }
}

class CustomGuestNav extends StatelessWidget {
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
    return Row(
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            IconButton(
              icon:
                  Icon(Icons.calendar_today_rounded, color: Colors.greenAccent),
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
        SizedBox(
          width: 7,
          height: 7,
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.person, color: Colors.pink),
              onPressed: () {
                Navigator.pushReplacementNamed(
                  context,
                  '/person',
                );
              },
            ),
            Text(
              "Personal Data",
              style: cBodyText,
            ),
          ],
        ),
        SizedBox(
          width: 7,
          height: 7,
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.receipt, color: Colors.orange),
              onPressed: () {
                Navigator.pushReplacementNamed(
                  context,
                  '/records',
                );
              },
            ),
            Text(
              "Records",
              style: cBodyText,
            ),
          ],
        ),
        SizedBox(
          width: 7,
          height: 7,
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            IconButton(
                icon: Icon(Icons.wallet_travel, color: Colors.greenAccent),
                onPressed: () => _launched = _launchInBrowser(
                    'https://www.youtube.com/watch?v=MkV413X2Kmw&list=PLp0TENYyY8lHL-G7jGbhpJBhVb2UdTOhQ&index=1&t=698s')),
            Text(
              "ContactTracing",
              style: cBodyText,
            ),
          ],
        ),
        SizedBox(
          width: 40,
          height: 40,
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.settings, color: Colors.blue),
              onPressed: () {
                Navigator.pushReplacementNamed(
                  context,
                  '/login',
                );
              },
            ),
            Text(
              "Sign Out",
              style: cBodyText,
            ),
          ],
        ),
      ],
    );
  }
}

class CustomSCMNav extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.receipt, color: Colors.orange),
              onPressed: () {
                Navigator.pushReplacementNamed(
                  context,
                  '/purchase',
                );
              },
            ),
            Text(
              "PO",
              style: cBodyText,
            ),
          ],
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.outlet_rounded, color: Colors.blueGrey),
              onPressed: () {
                Navigator.pushReplacementNamed(
                  context,
                  '/msr',
                );
              },
            ),
            Text(
              "MSR",
              style: cBodyText,
            ),
          ],
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.shopping_bag_rounded, color: Colors.blueAccent),
              onPressed: () {
                Navigator.pushReplacementNamed(
                  context,
                  '/vendor',
                );
              },
            ),
            Text(
              "Vendor",
              style: cBodyText,
            ),
          ],
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.wallet_travel, color: Colors.red),
              onPressed: () {
                Navigator.pushReplacementNamed(
                  context,
                  '/warehouse',
                );
              },
            ),
            Text(
              "Warehouse",
              style: cBodyText,
            ),
          ],
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.cached, color: Colors.purple),
              onPressed: () {
                Navigator.pushReplacementNamed(
                  context,
                  '/centre',
                );
              },
            ),
            Text(
              "Center",
              style: cBodyText,
            ),
          ],
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.thermostat_outlined, color: Colors.deepOrange),
              onPressed: () {
                Navigator.pushReplacementNamed(
                  context,
                  '/item',
                );
              },
            ),
            Text(
              "Items",
              style: cBodyText,
            ),
          ],
        )
      ],
    );
  }
}
