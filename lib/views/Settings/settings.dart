import 'package:flutter/material.dart';
import 'package:travelappui/utils/firebase.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  Future<void> handleLogout() async {
    await logout();
    Navigator.of(context).pushNamedAndRemoveUntil("/login", (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
        backgroundColor: Color(0xFFFFB907),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: ListView(
          children: [
            SettingsOption(
              icon: Icons.person,
              title: 'Account Information',
              onTap: () {
                // Navigate to account information page
                Navigator.pushNamed(context, '/profile');
              },
            ),
            SettingsOption(
              icon: Icons.lock,
              title: 'Password',
              onTap: () {
                // Navigate to password settings page
              },
            ),
            SettingsOption(
              icon: Icons.security,
              title: 'Security',
              onTap: () {
                // Navigate to security settings page
              },
            ),
            SettingsOption(
              icon: Icons.flag,
              title: 'Country',
              onTap: () {
                // Navigate to country settings page
              },
            ),
            SettingsOption(
              icon: Icons.language,
              title: 'Language',
              onTap: () {
                // Navigate to language settings page
              },
            ),
            SettingsOption(
              icon: Icons.attach_money,
              title: 'Currency',
              onTap: () {
                // Navigate to currency settings page
              },
            ),
            SettingsOption(
              icon: Icons.notifications,
              title: 'Notifications',
              onTap: () {
                // Navigate to notification settings page
              },
            ),
            SettingsOption(
              icon: Icons.location_on,
              title: 'Location',
              onTap: () {
                // Navigate to location settings page
              },
            ),
            SettingsOption(
              icon: Icons.logout,
              title: 'Sign Out',
              onTap: () {
                handleLogout();
              },
            ),
          ],
        ),
      ),
    );
  }
}

class SettingsOption extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  SettingsOption({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade400),
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Row(
            children: [
              Icon(icon, size: 24),
              SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Icon(Icons.arrow_forward_ios, size: 18),
            ],
          ),
        ),
      ),
    );
  }
}
