class MSG {
  String? messnger;
  MSG({this.messnger});


factory MSG.fromMap(map) {
    return MSG(
      messnger: map['messnger'],
     
    );
  }

Map<String, dynamic> toMap() {
    return {
'messnger' :messnger    
    };
  }

}
