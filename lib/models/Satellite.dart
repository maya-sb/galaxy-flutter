class Satellite{

  String id;
  String name;
  String size;
  String mass;
  int colorId;

  Satellite({this.id, this.name, this.size, this.mass, this.colorId});

  Satellite.fromMap(var document){
    id = document.documentID;
    this.name = document.data["name"];
    this.size = document.data["size"];
    this.mass = document.data["mass"];
    this.colorId = document.data["colorId"];

  }

   toMap(){
    return {
      "name":this.name,
      "size":this.size,
      "mass": this.mass,
      "colorId": this.colorId};
  }

    bool operator == (m) => m is Satellite && id == m.id;

}