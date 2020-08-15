import './user_model.dart';

class Message {
  bool success;
  List<Messages> messages;

  Message({this.success, this.messages});

  //gets data from backend in json format and check success
  Message.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['chats'] != null) {
      messages = new List<Messages>();
      json['chats'].forEach((v) {
        messages.add(new Messages.fromJson(v));
      });
    }
  }

  //sends data to backend in json format and check success
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.messages != null) {
      data['chats'] = this.messages.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Messages {
  int id;
  int senderId;
  int recieverId;
  User sender;
  String message;
  bool isLiked;
  bool unread;
  String type;
  String image;
  String location;
  String latitude;
  String longitude;
  String createdAt;
  String updatedAt;

  Messages(
      {this.id,
      this.senderId,
      this.recieverId,
      this.sender,
      this.message,
      this.isLiked,
      this.unread,
      this.type,
      this.image,
      this.location,
      this.latitude,
      this.longitude,
      this.createdAt,
      this.updatedAt});

  //Models the data that comes from backend in json format
  Messages.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    senderId = json['sender_id'];
    recieverId = json['reciever_id'];
    message = json['message'];
    isLiked = json['isLiked'] == 'false' ? false : true;
    unread = json['unread'] == 'false' ? false : true;
    type = json['type'];
    image = json['image'];
    location = json['location'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    sender = json['user'] != null ? new User.fromJson(json['user']) : null;
  }

  //Models the data that goes to backend to json format
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['sender_id'] = this.senderId;
    data['reciever_id'] = this.recieverId;
    data['image'] = this.image;
    data['isLiked'] = this.isLiked;
    data['unread'] = this.unread;
    data['type'] = this.type;
    data['location'] = this.location;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.sender != null) {
      data['user'] = this.sender.toJson();
    }
    return data;
  }
}

// EXAMPLE CHATS ON HOME SCREEN
/*List<Message> chats = [
  Message(
    sender: james,
    time: '5:30 PM',
    text: 'Hey, how\'s it going? What did you do today?',
    isLiked: false,
    unread: true,
  ),
  Message(
    sender: olivia,
    time: '4:30 PM',
    text: 'Hey, how\'s it going? What did you do today?',
    isLiked: false,
    unread: true,
  ),
  Message(
    sender: john,
    time: '3:30 PM',
    text: 'Hey, how\'s it going? What did you do today?',
    isLiked: false,
    unread: false,
  ),
  Message(
    sender: sophia,
    time: '2:30 PM',
    text: 'Hey, how\'s it going? What did you do today?',
    isLiked: false,
    unread: true,
  ),
  Message(
    sender: steven,
    time: '1:30 PM',
    text: 'Hey, how\'s it going? What did you do today?',
    isLiked: false,
    unread: false,
  ),
  Message(
    sender: sam,
    time: '12:30 PM',
    text: 'Hey, how\'s it going? What did you do today?',
    isLiked: false,
    unread: false,
  ),
  Message(
    sender: greg,
    time: '11:30 AM',
    text: 'Hey, how\'s it going? What did you do today?',
    isLiked: false,
    unread: false,
  ),
];

// EXAMPLE MESSAGES IN CHAT SCREEN
List<Message> messages = [
  Message(
    sender: james,
    time: '5:30 PM',
    text: 'Hey, how\'s it going? What did you do today?',
    isLiked: true,
    unread: true,
  ),
  Message(
    sender: currentUser,
    time: '4:30 PM',
    text: 'Just walked my doge. She was super duper cute. The best pupper!!',
    isLiked: false,
    unread: true,
  ),
  Message(
    sender: james,
    time: '3:45 PM',
    text: 'How\'s the doggo?',
    isLiked: false,
    unread: true,
  ),
  Message(
    sender: james,
    time: '3:15 PM',
    text: 'All the food',
    isLiked: true,
    unread: true,
  ),
  Message(
    sender: currentUser,
    time: '2:30 PM',
    text: 'Nice! What kind of food did you eat?',
    isLiked: false,
    unread: true,
  ),
  Message(
    sender: james,
    time: '2:00 PM',
    text: 'I ate so much food today.',
    isLiked: false,
    unread: true,
  ),
];*/
