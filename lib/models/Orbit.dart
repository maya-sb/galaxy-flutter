class Orbit{

  String id;
  String satelliteId;
  String planetId;
  String starId;
  int orbitColor;

  Orbit({this.id, this.satelliteId, this.planetId, this.starId, this.orbitColor});

  Orbit.fromMap(var document){
    id = document.documentID;
    this.satelliteId = document.data["satelliteId"];
    this.planetId = document.data["planetId"];
    this.starId = document.data["starId"];
    this.orbitColor = document.data["orbitColor"];
  }

  toMap(){
    return {
      "satelliteId":this.satelliteId,
      "planetId":this.planetId,
      "starId":this.starId,
      "orbitColor":this.orbitColor,
    };
  }
}