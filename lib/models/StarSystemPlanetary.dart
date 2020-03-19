class StarSystemPlanetary{

  String id;
  String starId;
  String systemId;

  StarSystemPlanetary({this.id, this.starId, this.systemId});

  StarSystemPlanetary.fromMap(var document){
    id = document.documentID;
    this.starId = document.data["starId"];
    this.systemId = document.data["systemId"];
  }

   toMap(){
    return {
      "starId":this.starId,
      "systemId":this.systemId,
    };
   }
   
  }