class PlaceModel {
  String uid;
  String placeTitle;
  String locationShort;
  double rating;
  String description;
  int duration;
  int rateperpackage;
  String iterasiDetail;
  String imgUrl;

  PlaceModel({
      this.uid = "",
      required this.iterasiDetail,
      required this.placeTitle,
      required this.locationShort,
      required this.rateperpackage,
      required this.rating,
      required this.description,
      required this.duration,
      required this.imgUrl});
}
