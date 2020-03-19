class Orbit{

  String id;
  String satelliteId;
  String planetId;
  String starId;

  Orbit({this.id, this.satelliteId, this.planetId, this.starId});

  Orbit.fromMap(var document){
    id = document.documentID;
    this.satelliteId = document.data["satelliteId"];
    this.planetId = document.data["planetId"];
    this.starId = document.data["starId"];
  }

  toMap(){
    return {
      "satelliteId":this.satelliteId,
      "planetId":this.planetId,
      "starId":this.starId,
    };
  }
}