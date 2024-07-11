import 'dart:math';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:travelappui/components/rating.dart';
import 'package:travelappui/models/placesModel.dart';
import 'package:travelappui/routes/routes.dart';
import 'package:travelappui/views/date_picker/date_picker.dart';

class ViewDetails extends StatefulWidget {
  final PlaceModel placeModel;

  ViewDetails({required this.placeModel});

  @override
  _ViewDetailsState createState() => _ViewDetailsState();
}

class _ViewDetailsState extends State<ViewDetails> {
  int numberPackage = 1;
  NumberFormat currencyFormat =
      NumberFormat.currency(locale: 'id_ID', symbol: 'Rp');
  DateTime? selectedDate;
  late String currentDescription;
  late String currentLabel;
  late String buttonText;

  @override
  void initState() {
    super.initState();
    currentDescription = widget.placeModel.description;
    currentLabel = "Description";
    buttonText = "You Can See Full Itinerary";
  }

  void removePackage() {
    setState(() {
      numberPackage--;
      numberPackage = max(numberPackage, 0);
    });
  }

  void addPackage() {
    setState(() {
      numberPackage++;
      numberPackage = min(numberPackage, 5);
    });
  }

  void toggleDescription() {
    setState(() {
      if (currentLabel == "Description") {
        currentDescription = widget.placeModel.iterasiDetail;
        currentLabel = "Itinerari";
        buttonText = "Back To Description";
      } else {
        currentDescription = widget.placeModel.description;
        currentLabel = "Description";
        buttonText = "You Can See Full Itinerary";
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    ThemeData appTheme = Theme.of(context);
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
      body: Stack(
        children: [
          Positioned(
            left: 0,
            right: 0,
            top: 0,
            child: Container(
              height: size.height * 0.7,
              color: Colors.grey,
              child: Image(
                image: NetworkImage(widget.placeModel.imgUrl),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: EdgeInsets.only(top: 10, left: 20, right: 20),
              height: size.height * 0.75,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(32),
                color: Colors.white,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.placeModel.placeTitle,
                    style: appTheme.textTheme.displayMedium,
                  ),
                  SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        Icons.location_pin,
                        size: 14,
                      ),
                      SizedBox(width: 12),
                      Text(
                        widget.placeModel.locationShort,
                        style: appTheme.textTheme.bodySmall,
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Rating(rating: widget.placeModel.rating, color: Colors.black),
                  SizedBox(height: 18),
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.remove,
                          color: appTheme.colorScheme.secondary,
                        ),
                        splashColor: appTheme.colorScheme.secondary,
                        onPressed: removePackage,
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 8, right: 8),
                        child: Text(
                          numberPackage.toString(),
                          style: appTheme.textTheme.bodySmall,
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.add),
                        onPressed: addPackage,
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: MyTextFieldDatePicker(
                          labelText: "Kalender",
                          prefixIcon: Icon(Icons.date_range),
                          suffixIcon: Icon(Icons.arrow_drop_down),
                          lastDate: DateTime.now().add(Duration(days: 366)),
                          firstDate: DateTime.now(),
                          initialDate: DateTime.now().add(Duration(days: 1)),
                          onDateChanged: (selectedDate) {
                            setState(() {
                              this.selectedDate = selectedDate;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Text(
                    currentLabel,
                    style: appTheme.textTheme.displaySmall!
                        .merge(TextStyle(color: Colors.black)),
                  ),
                  SizedBox(height: 8),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Text(
                            currentDescription,
                            style: appTheme.textTheme.bodyLarge,
                            textAlign: TextAlign.justify,
                          ),
                          ElevatedButton(
                            onPressed: toggleDescription,
                            child: Text(buttonText),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: size.height * 0.02),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text:
                                  " ${currencyFormat.format(widget.placeModel.rateperpackage)} ",
                              style: TextStyle(
                                color: appTheme.colorScheme.secondary,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(
                              text: "/Paket",
                              style: TextStyle(
                                color: appTheme.colorScheme.secondary,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Flexible(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.amber[700],
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            elevation: 0,
                            textStyle: TextStyle(
                              fontSize: 16,
                              fontFamily: 'PlayFair',
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          onPressed: () {
                            if (numberPackage < 1) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text("Jumlah Paket Mohon Diisi!")),
                              );
                              return;
                            }
                            Navigator.pushNamed(
                              context,
                              AppRoutes.Route_PaymentMethod,
                              arguments: {
                                "destination": widget.placeModel,
                                "order_info": {
                                  "date": selectedDate,
                                  "number_package": numberPackage,
                                },
                              },
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 4.0,
                              vertical: 2.0,
                            ),
                            child: Text(
                              "Booking",
                              style: appTheme.textTheme.displaySmall,
                            ),
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
