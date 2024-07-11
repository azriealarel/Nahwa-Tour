// ignore_for_file: must_be_immutable

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:travelappui/components/rating.dart';
import 'package:travelappui/models/placesModel.dart';
import 'package:travelappui/theme.dart';
import 'package:travelappui/utils/firebase.dart';

class FeaturedCard extends StatefulWidget {
  PlaceModel placeModel;

  FeaturedCard({required this.placeModel});

  @override
  _FeaturedCardState createState() => _FeaturedCardState();
}

class _FeaturedCardState extends State<FeaturedCard> {
  List favourites = [];

  @override
  void initState() {
    super.initState();
  }

  Future<void> addFav() async {
    try {
      await newFav(widget.placeModel);
    } catch (error) {
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

  Future<void> deleteFav(String uid) async {
    try {
      await removeFav(uid);
    } catch (error) {
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
    Size size = MediaQuery.of(context).size;
    // ThemeData appTheme = Theme.of(context);
    return Container(
        width: size.width * 0.85,
        height: max(200, size.height * 0.32),
        margin: EdgeInsets.all(8),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            color: Colors.grey.withAlpha(90)),
        child: Stack(
          children: [
            Container(
              height: double.maxFinite,
              width: double.maxFinite,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: Image(
                  image: NetworkImage(widget.placeModel.imgUrl),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: EdgeInsets.only(left: 20, right: 8, top: 8),
                height: 90,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18),
                    color: Colors.black.withAlpha(95)),
                child: Column(
                  children: [
                    Container(
                      height: 28,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            widget.placeModel.placeTitle,
                            style: kAppTheme.textTheme.displaySmall,
                          ),
                          StreamBuilder(
                            stream: database
                                .ref(favouritesRef)
                                .orderByChild("user")
                                .equalTo(user_data!.uid)
                                .onValue,
                            builder: (context, event) {
                              Map value = {};
                              if (event.connectionState == ConnectionState.waiting) {
                                return SizedBox();
                              } else if (event.data!.snapshot.value != null) {
                                value = event.data!.snapshot.value as Map;
                                final List listValue = [];
                                value.forEach((key, value) {
                                  listValue.add({
                                    "uid": key,
                                    "tour": value["tour"],
                                  });
                                });
                                bool isFavourite = listValue.any((fav) =>
                                    fav["tour"] == widget.placeModel.uid);
                                return IconButton(
                                  icon: Icon(
                                    isFavourite
                                        ? Icons.favorite_rounded
                                        : Icons.favorite_outline,
                                    color:
                                        isFavourite ? Colors.red : Colors.grey,
                                  ),
                                  onPressed: () {
                                    if (isFavourite) {
                                      final Map fav = listValue.firstWhere(
                                          (fav) =>
                                              fav["tour"] ==
                                              widget.placeModel.uid);
                                      removeFav(fav["uid"]);
                                    } else {
                                      addFav();
                                    }
                                  },
                                );
                              }
                              return IconButton(
                                icon: Icon(
                                  Icons.favorite_outline,
                                  color: Colors.grey,
                                ),
                                onPressed: () {
                                  addFav();
                                },
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    Container(
                      child: Row(
                        children: [Rating(rating: widget.placeModel.rating)],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ));
  }
}
