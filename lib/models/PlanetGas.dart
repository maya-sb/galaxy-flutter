class PlanetGas{

  String id;
  String gasId;
  String planetId;
  String amount;

  PlanetGas({this.id, this.gasId, this.planetId, this.amount});

  PlanetGas.fromMap(var document){
    id = document.documentID;
    this.gasId = document.data["gasId"];
    this.planetId = document.data["planetId"];
    this.amount = document.data["amount"];
  }

   toMap(){
    return {
      "gasId":this.gasId,
      "planetId":this.planetId,
      "amount": this.amount
    };
   }
   
  }