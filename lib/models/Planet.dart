class Planet{

  String id;
  String name;
  String size;
  String mass;
  String rotationSpeed;
  int colorId;

  Planet({this.id, this.name, this.size, this.mass, this.rotationSpeed, this.colorId});

  Planet.fromMap(var document){
    id = document.documentID;
    this.name = document.data["name"];
    this.size = document.data["size"];
    this.mass = document.data["mass"];
    this.rotationSpeed = document.data["rotationSpeed"];
    this.colorId = document.data["colorId"];
  }

   toMap(){
    return {
      "name":this.name,
      "size":this.size,
      "mass": this.mass,
      "rotationSpeed": this.rotationSpeed,
      "colorId": this.colorId};
  }

  bool operator == (m) => m is Planet && id == m.id;

}