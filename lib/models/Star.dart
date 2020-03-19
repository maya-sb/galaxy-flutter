class Star{

  String id;
  String name;
  String idade;
  String size;
  String distancia;
  String tipo;
  int colorId;

  Star({this.id, this.name, this.idade, this.size, this.distancia, this.tipo, this.colorId});

  Star.fromMap(var document){
    id = document.documentID;
    this.name = document.data["name"];
    this.idade = document.data["idade"];
    this.size = document.data["size"];
    this.distancia = document.data["distancia"];
    this.tipo = document.data["tipo"];
    this.colorId = document.data["colorId"];

  }

   toMap(){
    return {
      "name":this.name,
      "idade":this.idade,
      "size": this.size,
      "distancia": this.distancia,
      "tipo": this.tipo,
      "colorId": this.colorId};
  }

    bool operator == (m) => m is Star && id == m.id;

}