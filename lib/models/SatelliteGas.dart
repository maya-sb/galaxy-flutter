class SatelliteGas{

  String id;
  String gasId;
  String satelliteId;
  String amount;

  SatelliteGas({this.id, this.gasId, this.satelliteId, this.amount});

  SatelliteGas.fromMap(var document){
    id = document.documentID;
    this.gasId = document.data["gasId"];
    this.satelliteId = document.data["satelliteId"];
    this.amount = document.data["amount"];
  }

   toMap(){
    return {
      "gasId":this.gasId,
      "satelliteId":this.satelliteId,
      "amount": this.amount
    };
   }
   
  }