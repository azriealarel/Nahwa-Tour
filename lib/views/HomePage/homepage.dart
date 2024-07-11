import 'package:flutter/material.dart';
import 'package:travelappui/components/featuredcard.dart';
import 'package:travelappui/components/travelplacedart.dart';
import 'package:travelappui/constants/colors.dart';
import 'package:travelappui/models/placesModel.dart';
import 'package:travelappui/theme.dart';
import 'package:travelappui/utils/firebase.dart';
import 'package:travelappui/utils/restAPI.dart';
import 'package:travelappui/views/HomePage/components/featurelist.dart';
import 'package:travelappui/views/HomePage/state/homepageScrollListner.dart';
import 'package:travelappui/views/ViewDetails/viewDetails.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ScrollController _mainScrollController = ScrollController();
  late HomepageSrollListner _model;
  Color _buttonColor = kAppTheme.colorScheme.secondary;
  final RESTAPI api = RESTAPI();

  @override
  void initState() {
    super.initState();
    _model = HomepageSrollListner.initialise(_mainScrollController);
  }

  Future<List<PlaceModel>> getToursByLocation() async {
    try {
      final List<PlaceModel> tours = await retrieveTourByLocation();
      return tours;
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
      return [];
    }
  }

  Future<List<PlaceModel>> getToursByRate() async {
    try {
      final List<PlaceModel> tours = await retrieveTourByRate();
      return tours;
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
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: kPrimaryColor,
        body: Stack(
          children: [
            SingleChildScrollView(
              controller: _mainScrollController,
              child: Column(
                children: [
                  // Header section
                  Container(
                    height: 300, // Adjust the height as needed
                    width: double.infinity,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(
                            'assets/image/welcome.png'), // Replace with the path to your header image
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(30),
                        bottomRight: Radius.circular(30),
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Welcome to Nahwa Tour',
                          style: kAppTheme.textTheme.displayLarge!.copyWith(
                            // Use displayLarge instead of headlineLarge
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Explore the best destinations with us',
                          style: kAppTheme.textTheme.titleLarge!.copyWith(
                            // Use titleLarge instead of bodyLarge
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 2),
                  TopFeaturedList(),
                  Container(
                    width: size.width,
                    height: size.height * 0.33,
                    child: FutureBuilder<List<PlaceModel>>(
                        future: getToursByLocation(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return Container(
                              alignment: Alignment.center,
                              width: 50,
                              height: 50,
                              child: CircularProgressIndicator(
                                color: Colors.amber.shade700,
                              ),
                            );
                          }
                          return ListView.builder(
                              scrollDirection: Axis.horizontal,
                              shrinkWrap: true,
                              itemCount: snapshot.data!.length,
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => ViewDetails(
                                              placeModel:
                                                  snapshot.data![index]),
                                        ),
                                      );
                                    },
                                    child: FeaturedCard(
                                      placeModel: snapshot.data![index],
                                    ));
                              });
                        }),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 12, right: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "   Recommended",
                          style: kAppTheme.textTheme.headlineSmall,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.all(16),
                    child: FutureBuilder<List<PlaceModel>>(
                        future: getToursByRate(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return Container(
                                alignment: Alignment.center,
                                width: 50,
                                height: 50,
                                child: CircularProgressIndicator());
                          }

                          return GridView.builder(
                              itemCount: snapshot.data!.length,
                              shrinkWrap: true,
                              primary: false,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                      mainAxisSpacing: 16,
                                      crossAxisSpacing: 16,
                                      crossAxisCount: 2),
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => ViewDetails(
                                              placeModel:
                                                  snapshot.data![index]),
                                        ),
                                      );
                                    },
                                    child: TravelCard(placeModel: snapshot.data![index]));
                              });
                        }),
                  ),
                  SizedBox(
                      height:
                          8), // Add some spacing between recommended and travel blog
                  Container(
                    margin: EdgeInsets.only(left: 12, right: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Guidance",
                          style: kAppTheme.textTheme.headlineSmall,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 4),
                  SizedBox(
                    height: 160,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8),
                          child: Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.asset(
                                  'assets/image/guidance1.png',
                                  width: 300,
                                  height: 150,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              SizedBox(height: 16),
                              Text(
                                'How To Make Reservation',
                                style:
                                    kAppTheme.textTheme.titleMedium!.copyWith(
                                  // Use titleLarge instead of bodyLarge
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8),
                          child: Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.asset(
                                  'assets/image/guidance2.png',
                                  width: 300,
                                  height: 150,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              SizedBox(height: 16),
                              Text(
                                'How To Use This Apps',
                                style:
                                    kAppTheme.textTheme.titleMedium!.copyWith(
                                  // Use titleLarge instead of bodyLarge
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                      height:
                          8), // Add some spacing between recommended and travel blog
                  Container(
                    margin: EdgeInsets.only(left: 12, right: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Travel Blog",
                          style: kAppTheme.textTheme.headlineSmall,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 4),
                  SizedBox(
                    height: 160,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8),
                          child: GestureDetector(
                            onTap: () {
                              // Implement navigation to the URL
                              launch(
                                  'https://nahwatour.com/paket-arung-jeram-pekalen');
                            },
                            child: Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.asset(
                                    'assets/image/travelblog1.png',
                                    width: 300,
                                    height: 150,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                SizedBox(height: 16),
                                Text(
                                  'Arung Jeram Pekalen Package',
                                  style:
                                      kAppTheme.textTheme.titleMedium!.copyWith(
                                    // Use titleLarge instead of bodyLarge
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8),
                          child: GestureDetector(
                            onTap: () {
                              // Implement navigation to the URL
                              launch(
                                  'https://nahwatour.com/seruni-point-bromo');
                            },
                            child: Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.asset(
                                    'assets/image/travelblog2.png',
                                    width: 300,
                                    height: 150,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                SizedBox(height: 16),
                                Text(
                                  'Seruni Point Bromo',
                                  style:
                                      kAppTheme.textTheme.titleMedium!.copyWith(
                                    // Use titleLarge instead of bodyLarge
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            AnimatedBuilder(
                animation: _model,
                builder: (context, child) {
                  return Positioned(
                      bottom: _model.bottom,
                      right: 22,
                      left: 22,
                      child: Container(
                        padding: EdgeInsets.only(left: 12, right: 12),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                  blurRadius: 15,
                                  color: Colors.black.withOpacity(0.4))
                            ],
                            borderRadius: BorderRadius.circular(45)),
                        height: 75,
                        alignment: Alignment.center,
                        child: Material(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              IconButton(
                                  icon: Icon(Icons.home_rounded,
                                      size: 36, color: _buttonColor),
                                  onPressed: () {
                                    setState(() {
                                      _buttonColor =
                                          Colors.black.withOpacity(0.4);
                                    });
                                    Navigator.pushNamed(context, "/home");
                                  }),
                              IconButton(
                                  icon: Icon(Icons.calendar_today_rounded,
                                      size: 36, color: _buttonColor),
                                  onPressed: () {
                                    setState(() {
                                      _buttonColor =
                                          Colors.black.withOpacity(0.4);
                                    });
                                    Navigator.pushNamed(context, "/yourorder");
                                  }),
                              IconButton(
                                  icon: Icon(Icons.support,
                                      size: 36,
                                      color: kAppTheme.colorScheme.secondary),
                                  onPressed: () {
                                    setState(() {
                                      _buttonColor =
                                          Colors.black.withOpacity(0.4);
                                    });
                                    Navigator.pushNamed(context, "/support");
                                  }),
                              IconButton(
                                  icon: Icon(Icons.person,
                                      size: 36,
                                      color: kAppTheme.colorScheme.secondary),
                                  onPressed: () {
                                    setState(() {
                                      _buttonColor =
                                          Colors.black.withOpacity(0.4);
                                    });
                                    Navigator.pushNamed(context, "/profile");
                                  })
                            ],
                          ),
                        ),
                      ));
                })
          ],
        ));
  }
}
