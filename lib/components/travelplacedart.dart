import 'package:flutter/material.dart';
import 'package:travelappui/components/rating.dart';
import 'package:travelappui/models/placesModel.dart';
import 'package:travelappui/theme.dart';
import 'package:travelappui/utils/firebase.dart';

class TravelCard extends StatefulWidget {
  const TravelCard({super.key, required this.placeModel});

  final PlaceModel placeModel;

  @override
  State<TravelCard> createState() => _TravelCardState();
}

class _TravelCardState extends State<TravelCard> {
  List favourites = [];

  @override
  void initState() {
    super.initState();
  }

  // Future<void> getFavs() async {
  //   try {
  //     final List favs = await retrieveFavourites();
  //     setState(() {
  //       favourites.clear();
  //       favourites.addAll(favs);
  //     });
  //   } catch (error) {
  //     print(error);
  //   }
  // }

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
    return Container(
      child: Stack(
        children: [
          Container(
            height: double.maxFinite,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image(
                image: NetworkImage(widget.placeModel.imgUrl),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            right: 0,
            top: 0,
            child: StreamBuilder(
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
                  bool isFavourite = listValue
                      .any((fav) => fav["tour"] == widget.placeModel.uid);
                  return IconButton(
                    icon: Icon(
                      isFavourite
                          ? Icons.favorite_rounded
                          : Icons.favorite_outline,
                      color: isFavourite ? Colors.red : Colors.grey,
                    ),
                    onPressed: () {
                      if (isFavourite) {
                        final Map fav = listValue.firstWhere(
                            (fav) => fav["tour"] == widget.placeModel.uid);
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
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.only(left: 8, right: 8, top: 4),
              height: 60,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.black.withAlpha(90)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.placeModel.placeTitle,
                    style: kAppTheme.textTheme.titleMedium,
                  ),
                  Row(
                    children: [Rating(rating: widget.placeModel.rating)],
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
