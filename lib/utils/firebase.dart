import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:travelappui/models/placesModel.dart';

FirebaseDatabase database = FirebaseDatabase.instance;
FirebaseAuth auth = FirebaseAuth.instance;
String usersRef = "users/";
String toursRef = "tours/";
String transactionsRef = "transactions/";
String favouritesRef = "favourites/";
User? user_data;

Future<void> logout() async {
  await auth.signOut();
}

Future<User?> checkExistingUser() async {
  auth.authStateChanges().listen((User? user) {
    user_data = user;
  });
  await Future.delayed(const Duration(seconds: 1));
  return user_data;
}

Future<Map> retrieveUser() async {
  try {
    User? user_data;
    auth.authStateChanges().listen((User? user) {
      user_data = user;
    });
    await Future.delayed(const Duration(seconds: 1));
    if (user_data == null) {
      throw "User not found!!!";
    }
    final DatabaseEvent usersEvent =
        await database.ref(usersRef + user_data!.uid).once();
    return {
      "uid": user_data!.uid,
      "name": usersEvent.snapshot.child("name").value,
      "email": usersEvent.snapshot.child("email").value,
    };
  } catch (error) {
    return Future.error(error);
  }
}

Future<void> register(
  String name,
  String email,
  String password,
) async {
  try {
    final UserCredential userCredential =
        await auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    await database.ref(usersRef + userCredential.user!.uid).set({
      "name": name,
      "email": email,
    });
  } catch (error) {
    Future.error(error);
  }
}

Future<void> login(
  String email,
  String password,
) async {
  try {
    await auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  } catch (error) {
    Future.error(error);
  }
}

Future<List<PlaceModel>> retrieveTourByLocation([String location = ""]) async {
  try {
    final List<PlaceModel> tours = [];
    final DataSnapshot snapshot = await database.ref(toursRef).get();
    if (!snapshot.exists) {
      return tours;
    }
    final Map toursSnapshot = snapshot.value as Map;
    toursSnapshot.forEach((key, value) {
      tours.add(PlaceModel(
        uid: key,
        iterasiDetail: value["iterasiDetail"],
        placeTitle: value["placeTitle"],
        locationShort: value["locationShort"],
        rateperpackage: value["rateperpackage"],
        rating: value["rating"],
        description: value["description"],
        duration: value["duration"],
        imgUrl: value["imgUrl"],
      ));
    });
    return tours;
  } catch (error) {
    return Future.error(error);
  }
}

Future<List<PlaceModel>> retrieveTourByRate() async {
  try {
    final List<PlaceModel> tours = [];
    final DataSnapshot snapshot = await database
        .ref(toursRef)
        .orderByChild("rating")
        .limitToLast(4)
        .get();
    if (!snapshot.exists) {
      return tours;
    }
    final Map toursSnapshot = snapshot.value as Map;
    toursSnapshot.forEach((key, value) {
      tours.add(PlaceModel(
        uid: key,
        iterasiDetail: value["iterasiDetail"],
        placeTitle: value["placeTitle"],
        locationShort: value["locationShort"],
        rateperpackage: value["rateperpackage"],
        rating: value["rating"],
        description: value["description"],
        duration: value["duration"],
        imgUrl: value["imgUrl"],
      ));
    });
    return tours;
  } catch (error) {
    return Future.error(error);
  }
}

Future<String> newTransaction(
  PlaceModel place,
  Map order_info,
  Map payment_method,
) async {
  try {
    final List transactions = [];
    final int now = DateTime.now().millisecondsSinceEpoch;
    User? user_data;
    auth.authStateChanges().listen((User? user) {
      user_data = user;
    });
    await Future.delayed(const Duration(seconds: 1));
    final Map detail_place = {
      "description": place.description,
      "duration": place.duration,
      "uid": place.uid,
      "placeTitle": place.placeTitle,
      "locationShort": place.locationShort,
      "rating": place.rating,
      "rateperpackage": place.rateperpackage,
      "iterasiDetail": place.iterasiDetail,
      "imgUrl": place.imgUrl,
    };
    await database.ref(transactionsRef).push().set({
      "user": user_data!.uid,
      "tour": place.uid,
      "tour_detail": detail_place,
      "qty": order_info["number_package"],
      "date": order_info["date"].millisecondsSinceEpoch,
      "total": order_info["number_package"] * place.rateperpackage,
      "payment_method": payment_method["name"],
      "created_at": now,
    });
    final DataSnapshot dataSnapshot = await database
        .ref(transactionsRef)
        .orderByChild("user")
        .equalTo(user_data!.uid)
        .get();
    final Map transactionsData = dataSnapshot.value as Map;
    transactionsData.forEach((key, value) {
      final Map order = {
        "uid": key,
        "created_at": value["created_at"],
        "date": value["date"],
        "payment_method": value["payment_method"],
        "qty": value["qty"],
        "total": value["total"],
        "tour": value["tour"],
        "tour_detail": value["tour_detail"],
        "user": value["user"],
      };
      transactions.add(order);
    });
    final Map current_transaction =
        transactions.firstWhere((item) => item["created_at"] == now);
    return current_transaction["uid"];
  } catch (error) {
    return Future.error(error);
  }
}

Future<List> retrieveTransaction() async {
  try {
    final List transactions = [];
    User? user_data;
    auth.authStateChanges().listen((User? user) {
      user_data = user;
    });
    await Future.delayed(const Duration(seconds: 1));
    final DataSnapshot dataSnapshot = await database
        .ref(transactionsRef)
        .orderByChild("user")
        .equalTo(user_data!.uid)
        .get();
    if (!dataSnapshot.exists) {
      return transactions;
    }
    final Map transactionsData = dataSnapshot.value as Map;
    transactionsData.forEach((key, value) {
      final Map order = {
        "uid": key,
        "created_at": value["created_at"],
        "date": value["date"],
        "payment_method": value["payment_method"],
        "qty": value["qty"],
        "total": value["total"],
        "tour": value["tour"],
        "tour_detail": value["tour_detail"],
        "user": value["user"],
      };
      transactions.add(order);
    });
    transactions.sort((a, b) => b["date"].compareTo(a["date"]));
    return transactions;
  } catch (error) {
    return Future.error(error);
  }
}

Stream<List> retrieveFavourites() async* {
  try {
    auth.authStateChanges().listen((User? user) {
      user_data = user;
      database
          .ref(favouritesRef)
          .orderByChild("user")
          .equalTo(user_data!.uid)
          .onValue
          .listen((event) {
        final Map toursSnapshot = event.snapshot.value as Map;
        toursSnapshot.forEach((key, value) {
          final List favourites = [];
          favourites.add({
            "uid": key,
            "tour": value["tour"],
          });
        });
      });
    });
  } catch (error) {
    Future.error(error);
  }
}

Future<void> newFav(PlaceModel placeModel) async {
  try {
    User? user_data;
    auth.authStateChanges().listen((User? user) {
      user_data = user;
    });
    await Future.delayed(const Duration(milliseconds: 50));
    await database.ref(favouritesRef).push().set({
      "tour": placeModel.uid,
      "user": user_data!.uid,
    });
  } catch (error) {
    return Future.error(error);
  }
}

Future<void> removeFav(String uid) async {
  try {
    await database.ref(favouritesRef + uid).remove();
  } catch (error) {
    return Future.error(error);
  }
}
