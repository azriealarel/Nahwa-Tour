import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:travelappui/models/placesModel.dart';
import 'package:travelappui/utils/firebase.dart';
import 'package:travelappui/views/PaymentMethod3/paymentmethod3.dart';

class PaymentMethod2Page extends StatefulWidget {
  final PlaceModel destination;
  final Map order_info;
  final Map payment_method;

  PaymentMethod2Page({
    required this.destination,
    required this.order_info,
    required this.payment_method,
  });

  @override
  _PaymentMethod2PageState createState() => _PaymentMethod2PageState();
}

class _PaymentMethod2PageState extends State<PaymentMethod2Page> {
  final NumberFormat _numberFormat = NumberFormat("#,###");

  String formatNumber(int number) =>
      _numberFormat.format(number).replaceAll(",", ".");

  Future<void> handleNewTransaction() async {
    try {
      showDialog(
        // ?Loading Dialog
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          content: SizedBox(
            width: 64,
            height: 64,
            child: Center(
                child: CircularProgressIndicator(
              color: Colors.amber[700],
            )),
          ),
        ),
      );
      String uid = await newTransaction(
        widget.destination,
        widget.order_info,
        widget.payment_method,
      );
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => PaymentMethod3Page(
            total: widget.order_info["number_package"] *
                widget.destination.rateperpackage,
            payment_method: widget.payment_method,
            ref_id: uid,
          ),
        ),
        (route) => false,
      );
    } catch (error) {
      Navigator.of(context).pop(); // ?Close Loading Dialog
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Something Happened!"),
          content: Text("$error"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Okay!"),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Continue Payment'),
        backgroundColor: Color(0xFFFFB907),
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          SizedBox(height: 12.0),
          Text(
            'Destination',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16.0),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      widget.destination.placeTitle,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 40.0),
          Text(
            'Transfer To',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8.0),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: ListTile(
              leading: Image.asset(
                  "assets/image/${widget.payment_method["image"]}",
                  width: 70,
                  height: 70),
              title: Text(widget.payment_method["name"]),
              subtitle: Text("(009-223-5295)"),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            ),
          ),
          SizedBox(height: 10.0),
          Text(
            "Payment Total",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8.0),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: ListTile(
              title: Text(
                  'Rp ${formatNumber(widget.order_info["number_package"] * widget.destination.rateperpackage)}'),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            ),
          ),
          SizedBox(height: 16.0),
          Row(
            children: [
              Icon(Icons.money_off, color: const Color.fromARGB(255, 0, 0, 0)),
              SizedBox(height: 8.0),
              Expanded(
                child: Text('cannot be refunded'),
              ),
            ],
          ),
          SizedBox(height: 8.0),
          Row(children: [
            Icon(Icons.calendar_today,
                color: const Color.fromARGB(255, 0, 0, 0)),
            SizedBox(height: 8.0),
            Expanded(
              child: Text('Make reservations no later than 5 days in advance'),
            )
          ]),
          SizedBox(height: 150.0),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    handleNewTransaction();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFFFB907),
                    minimumSize: Size.fromHeight(48),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child: Text('Pay Now'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
