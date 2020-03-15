class Gas{

  String id;
  String name;

  Gas({this.id, this.name});

  Gas.fromMap(var document){
    id = document.documentID;
    this.name = document.data["name"];
  }

   toMap(){
    return {
      "name":this.name};
   }

    bool operator == (m) => m is Gas && id == m.id;

}