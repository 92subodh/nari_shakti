import 'dart:convert';

class UserRegistrationSchema {
  String? name;
  String? number;

  UserRegistrationSchema({this.name, this.number});

  String toJson() {
    var mapped = {'name': name, 'number': number};
    return jsonEncode(mapped);
  }
}


