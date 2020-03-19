class PlanetSystemPlanetary{

  String id;
  String planetId;
  String systemId;

  PlanetSystemPlanetary({this.id, this.planetId, this.systemId});

  PlanetSystemPlanetary.fromMap(var document){
    id = document.documentID;
    this.planetId = document.data["planetId"];
    this.systemId = document.data["systemId"];
  }

   toMap(){
    return {
      "planetId":this.planetId,
      "systemId":this.systemId,
    };
   }
   
  }