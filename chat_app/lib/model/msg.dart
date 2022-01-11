class MSG {
  String? messnger;
  String? username;
  MSG({this.messnger, this.username});

  factory MSG.fromMap(map) {
    return MSG(messnger: map['messnger'], username: map['username']);
  }

  Map<String, dynamic> toMap() {
    return {'messnger': messnger, 'username': username};
  }
}
