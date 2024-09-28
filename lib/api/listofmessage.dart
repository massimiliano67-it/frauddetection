class Author {
  String? firstName;
  String? id;
  String? lastName;

  Author({this.firstName, this.id, this.lastName});

  Author.fromJson(Map<String, dynamic> json) {
    firstName = json['firstName'];
    id = json['id'];
    lastName = json['lastName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['firstName'] = firstName;
    data['id'] = id;
    data['lastName'] = lastName;
    return data;
  }
}

class Message {
  Author? author;
  double? createdAt;
  String? id;
  String? status;
  String? text;
  String? type;

  Message({this.author, this.createdAt, this.id, this.status, this.text, this.type});

  Message.fromJson(Map<String, dynamic> json) {
    author = json['author'] != null ? Author?.fromJson(json['author']) : null;
    createdAt = json['createdAt'];
    id = json['id'];
    status = json['status'];
    text = json['text'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['author'] = author!.toJson();
    data['createdAt'] = createdAt;
    data['id'] = id;
    data['status'] = status;
    data['text'] = text;
    data['type'] = type;
    return data;
  }
}














