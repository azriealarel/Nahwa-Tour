import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

void _launchWhatsApp() async {
  final url = 'https://wa.me/6281222431414';
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

class SupportPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SUPPORT CENTER'),
        backgroundColor: Color(0xFFFFB907),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 16.0),
            TextField(
              decoration: InputDecoration(
                hintText: 'Hi Arel, how can we help?',
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.search),
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              'Select help topic',
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16.0),
            Expanded(
              child: GridView.count(
                crossAxisCount: 3,
                crossAxisSpacing: 16.0,
                mainAxisSpacing: 16.0,
                children: [
                  SupportOption(
                    icon: Icons.call,
                    title: 'Contact',
                    onTap: () {
                      _launchWhatsApp();
                      // Add your contact support logic here
                    },
                  ),
                  SupportOption(
                    icon: Icons.account_circle,
                    title: 'Account',
                    onTap: () {
                      // Navigate to the profile page
                      Navigator.pushNamed(context, '/profile');
                    },
                  ),
                  SupportOption(
                    icon: Icons.person,
                    title: 'General',
                    onTap: () {
                      // Add your general support logic here
                    },
                  ),
                  SupportOption(
                    icon: Icons.book,
                    title: 'Book',
                    onTap: () {
                      // Add your book support logic here
                    },
                  ),
                  SupportOption(
                    icon: Icons.payment,
                    title: 'Payment',
                    onTap: () {
                      // Add your payment support logic here
                    },
                  ),
                  SupportOption(
                    icon: Icons.cancel,
                    title: 'Canceled',
                    onTap: () {
                      // Add your canceled support logic here
                    },
                  ),
                  SupportOption(
                    icon: Icons.change_circle,
                    title: 'Change',
                    onTap: () {
                      // Add your change support logic here
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SupportOption extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  SupportOption({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.grey.withOpacity(0.5),
            width: 1.0,
          ),
          borderRadius: BorderRadius.circular(8.0),
        ),
        padding: EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 32.0),
            SizedBox(height: 8.0),
            Text(
              title,
              style: TextStyle(
                fontSize: 12.0,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}