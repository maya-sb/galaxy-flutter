class Star{

  String id;
  String name;
  String age;
  String size;
  String mass;
  String distance;
  String type;
  String death = "false";
  int colorId;

  Star({this.id, this.name, this.age, this.size, this.mass, this.distance, this.type, this.death, this.colorId});

  Star.fromMap(var document){
    id = document.documentID;
    this.name = document.data["name"];
    this.age = document.data["age"];
    this.size = document.data["size"];
    this.mass = document.data["mass"];
    this.distance = document.data["distance"];
    this.type = document.data["type"];
    this.death = document.data["death"];
    this.colorId = document.data["colorId"];

  }

   toMap(){
    return {
      "name":this.name,
      "age":this.age,
      "size": this.size,
      "mass": this.mass,
      "distance": this.distance,
      "type": this.type,
      "death": this.death,
      "colorId": this.colorId};
  }

    bool operator == (m) => m is Star && id == m.id;

}