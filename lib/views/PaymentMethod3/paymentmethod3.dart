import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PaymentMethod3Page extends StatefulWidget {
  final int total;
  final Map payment_method;
  final String ref_id;

  PaymentMethod3Page({required this.total, required this.payment_method, required this.ref_id,});

  @override
  _PaymentMethod3PageState createState() => _PaymentMethod3PageState();
}

class _PaymentMethod3PageState extends State<PaymentMethod3Page> {
  final NumberFormat _numberFormat = NumberFormat("#,###");

  String formatNumber(int number) =>
      _numberFormat.format(number).replaceAll(",", ".");

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (pop) {
        Navigator.of(context).pushReplacementNamed("/home");
      },
      child: Scaffold(
          body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFFFFFFF),
              Color(0xFFFAF4FF),
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Payment Successful',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8.0),
              Text(
                'Payment has been successfully processed',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
              SizedBox(height: 16.0),
              Image.asset(
                'assets/image/succespayment.png',
                width: 200,
                height: 200,
              ),
              SizedBox(height: 8.0),
              Text(
                'IDR ${formatNumber(widget.total)}',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 24.0),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Successfully paid to Nahwa Tour',
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16.0),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                      color: Colors.grey.withOpacity(0.5), width: 1.0),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Reference ID)'),
                      Text(widget.ref_id),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 8.0),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                      color: Colors.grey.withOpacity(0.5), width: 1.0),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Payment Method'),
                      Text(widget.payment_method["name"]),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 130.0),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        // Navigate to the home page
                        Navigator.pushReplacementNamed(
                          context,
                          '/home',
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFFFB907),
                        minimumSize: Size.fromHeight(48),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      child: Text('Back To Homepage'),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      )),
    );
  }
}
