import 'user_model.dart';

class ProfileUser {
  bool success;
  User userDetails;

  ProfileUser({this.success, this.userDetails});

  //gets data from backend in json format and check success
  ProfileUser.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    userDetails = json['user_details'] != null
        ? new User.fromJson(json['user_details'])
        : null;
  }

  //sends data to backend in json format and check success
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.userDetails != null) {
      data['user_details'] = this.userDetails.toJson();
    }
    return data;
  }
}
