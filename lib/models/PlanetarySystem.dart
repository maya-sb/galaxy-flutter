class PlanetarySystem{

  String id;
  String name;
  String age;
  int numStars;
  int numPlanets;
  String galaxyId;
  int colorId;

  PlanetarySystem({this.id, this.name, this.age, this.numStars, this.numPlanets, this.galaxyId, this.colorId});

  PlanetarySystem.fromMap(var document){
    id = document.documentID;

    this.name = document.data["name"];
    this.age = document.data["age"];
    this.numStars = document.data["numStars"];
    this.numPlanets = document.data["numPlanets"];
    this.galaxyId = document.data["galaxyId"];
    this.colorId = document.data["colorId"];
  }

   toMap(){
    return {
      "name":this.name,
      "age":this.age,
      "numStars": this.numStars,
      "numPlanets": this.numPlanets,
      "colorId" : this.colorId,
      "galaxyId": this.galaxyId};
  }
 
}