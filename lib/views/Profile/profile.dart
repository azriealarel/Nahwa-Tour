import 'package:flutter/material.dart';
import 'package:travelappui/models/placesModel.dart';
import 'package:travelappui/utils/firebase.dart';
import 'package:travelappui/views/PaymentMethod/paymentmethod.dart';
import 'package:travelappui/views/Settings/settings.dart';
import 'package:travelappui/views/Support/support.dart';
import 'package:travelappui/views/Voucher/voucher.dart';
import 'package:travelappui/views/YourOrder/yourorder.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Future<Map> getUser() async {
    try {
      final Map user = await retrieveUser();
      return user;
    } catch (error) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Something Happened!"),
          content: Text("$error"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context)
                    .pushNamedAndRemoveUntil("/login", (route) => false);
              },
              child: const Text("Okay!"),
            ),
          ],
        ),
      );
      return {};
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Account'),
        backgroundColor: Color(0xFFFFB907),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade400, width: 2),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundImage:
                          AssetImage('assets/image/ellipse_66.jpeg'),
                    ),
                    SizedBox(width: 16.0),
                    FutureBuilder(
                        future: getUser(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(
                              child: CircularProgressIndicator(
                                color: Colors.amber.shade700,
                              ),
                            );
                          }
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                snapshot.data!["name"],
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 8.0),
                              Text(
                                snapshot.data!["email"],
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          );
                        }),
                  ],
                ),
              ),
            ),
            SizedBox(height: 24.0),
            ProfileOption(
              title: 'Your Order',
              onTap: () {
                // Navigate to order history page
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => YourOrderPage()),
                );
              },
            ),
            ProfileOption(
              title: 'Payment Method',
              onTap: () {
                // Navigate to payment method page with default parameters
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PaymentMethodPage(
                      destination: PlaceModel(
                          description: "",
                          duration: 30,
                          imgUrl: "",
                          iterasiDetail: "",
                          locationShort: "",
                          placeTitle: "",
                          rateperpackage: 0,
                          rating: 0),
                      order_info: {},// example default value
                    ),
                  ),
                );
              },
            ),
            ProfileOption(
              title: 'Voucher Discount',
              onTap: () {
                // Navigate to voucher page
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => VoucherPage()),
                );
              },
            ),
            ProfileOption(
              title: 'Support Center',
              onTap: () {
                // Navigate to support page
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SupportPage()),
                );
              },
            ),
            ProfileOption(
              title: 'Settings',
              onTap: () {
                // Navigate to settings page
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SettingsPage()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class ProfileOption extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  ProfileOption({
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade400),
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Center(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
