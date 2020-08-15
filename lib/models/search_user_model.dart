import 'user_model.dart';

class SearchUser {
  bool success;
  List<User> userSearch;

  SearchUser({this.success, this.userSearch});

  //gets data from backend in json format and check success
  SearchUser.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['user'] != null) {
      userSearch = new List<User>();
      json['user'].forEach((v) {
        userSearch.add(new User.fromJson(v));
      });
    }
  }

  //sends data to backend in json format and check success
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.userSearch != null) {
      data['user'] = this.userSearch.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
