class Star{

  String id;
  String name;
  String idade;
  String size;
  String distance;
  String type;
  bool death = false;
  int colorId;

  Star({this.id, this.name, this.idade, this.size, this.distance, this.type, this.colorId});

  Star.fromMap(var document){
    id = document.documentID;
    this.name = document.data["name"];
    this.idade = document.data["idade"];
    this.size = document.data["size"];
    this.distance = document.data["distance"];
    this.type = document.data["type"];
    this.death = document.data["death"];
    this.colorId = document.data["colorId"];

  }

   toMap(){
    return {
      "name":this.name,
      "idade":this.idade,
      "size": this.size,
      "distance": this.distance,
      "type": this.type,
      "death": this.death,
      "colorId": this.colorId};
  }

    bool operator == (m) => m is Star && id == m.id;

}