class User {
  int id;
  String username;
  String fullname;
  String phoneNumber;
  String email;
  String emailVerifiedAt;
  String sPassword;
  String createdAt;
  String updatedAt;
  Profile profile;
  List<Following> following;
  ProfilePix profilePix;

  User(
      {this.id,
      this.username,
      this.fullname,
      this.phoneNumber,
      this.email,
      this.emailVerifiedAt,
      this.sPassword,
      this.createdAt,
      this.updatedAt,
      this.profile,
      this.following,
      this.profilePix});

  //Models the data that comes from backend in json format
  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    username = json['username'];
    fullname = json['fullname'];
    phoneNumber = json['phone_number'];
    email = json['email'];
    emailVerifiedAt = json['email_verified_at'];
    sPassword = json['s_password'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    profile =
        json['profile'] != null ? new Profile.fromJson(json['profile']) : null;

    if (json['following'] != null) {
      following = new List<Following>();
      json['following'].forEach((v) {
        following.add(new Following.fromJson(v));
      });
    }

    profilePix = json['profile_pix'] != null
        ? new ProfilePix.fromJson(json['profile_pix'])
        : null;
  }

  //Models the data that goes to backend to json format
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['username'] = this.username;
    data['fullname'] = this.fullname;
    data['phone_number'] = this.phoneNumber;
    data['email'] = this.email;
    data['email_verified_at'] = this.emailVerifiedAt;
    data['s_password'] = this.sPassword;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.profile != null) {
      data['profile'] = this.profile.toJson();
    }
    if (this.following != null) {
      data['following'] = this.following.map((v) => v.toJson()).toList();
    }

    if (this.profilePix != null) {
      data['profile_pix'] = this.profilePix.toJson();
    }

    return data;
  }
}

class ProfilePix {
  String profileThumbnail;
  String profileImage;

  ProfilePix({this.profileThumbnail, this.profileImage});

  //gets data from backend in json format
  ProfilePix.fromJson(Map<String, dynamic> json) {
    profileThumbnail = json['profile_thumbnail'];
    profileImage = json['profile_image'];
  }

  //sends data to backend in json format
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['profile_thumbnail'] = this.profileThumbnail;
    data['profile_image'] = this.profileImage;
    return data;
  }
}

class Profile {
  int id;
  int userId;
  String title;
  String description;
  String url;
  String image;
  String profileThumbnail;
  String location;
  String latitude;
  String longitude;
  String createdAt;
  String updatedAt;
  int followersCount;
  int followingCount;
  bool isFollowing;
  bool isBlocked;
  bool isBlockedMe;
  List<Followers> followers;
  User user;

  Profile(
      {this.id,
      this.userId,
      this.title,
      this.description,
      this.url,
      this.image,
      this.profileThumbnail,
      this.location,
      this.latitude,
      this.longitude,
      this.createdAt,
      this.updatedAt,
      this.followersCount,
      this.followingCount,
      this.isFollowing,
      this.isBlocked,
      this.isBlockedMe,
      this.followers,
      this.user});

  //Models the data that comes from backend in json format
  Profile.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    title = json['title'];
    description = json['description'];
    url = json['url'];
    image = json['profile_image'];
    profileThumbnail = json['profile_image_thumbnail'];
    location = json['location'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    followersCount = json['followers_count'];
    followingCount = json['following_count'];
    isFollowing = json['is_following'];
    isBlocked = json['is_blocked'];
    isBlockedMe = json['is_blocked_me'];
    if (json['followers'] != null) {
      followers = new List<Followers>();
      json['followers'].forEach((v) {
        followers.add(new Followers.fromJson(v));
      });
    }
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
  }

  //Models the data that goes to backend to json format
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['title'] = this.title;
    data['description'] = this.description;
    data['url'] = this.url;
    data['profile_image'] = this.image;
    data['profile_image_thumbnail'] = this.profileThumbnail;
    data['location'] = this.location;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['followers_count'] = this.followersCount;
    data['following_count'] = this.followingCount;
    data['is_following'] = this.isFollowing;
    data['is_blocked'] = this.isBlocked;
    data['is_blocked_me'] = this.isBlockedMe;
    if (this.followers != null) {
      data['followers'] = this.followers.map((v) => v.toJson()).toList();
    }
    if (this.user != null) {
      data['user'] = this.user.toJson();
    }
    return data;
  }
}

class Following {
  int id;
  int userId;
  String title;
  String description;
  String url;
  String image;
  String createdAt;
  String updatedAt;
  int followersCount;
  int followingCount;
  int postCount;
  bool isFollowing;
  Pivot pivot;
  List<Followers> followers;
  User user;

  Following(
      {this.id,
      this.userId,
      this.title,
      this.description,
      this.url,
      this.image,
      this.createdAt,
      this.updatedAt,
      this.followersCount,
      this.followingCount,
      this.postCount,
      this.isFollowing,
      this.pivot,
      this.followers,
      this.user});

  //Models the data that comes from backend in json format
  Following.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    title = json['title'];
    description = json['description'];
    url = json['url'];
    image = json['image'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    followersCount = json['followers_count'];
    followingCount = json['following_count'];
    postCount = json['post_count'];
    isFollowing = json['is_following'];
    pivot = json['pivot'] != null ? new Pivot.fromJson(json['pivot']) : null;
    if (json['followers'] != null) {
      followers = new List<Followers>();
      json['followers'].forEach((v) {
        followers.add(new Followers.fromJson(v));
      });
    }
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
  }

  //Models the data that goes to backend to json format
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['title'] = this.title;
    data['description'] = this.description;
    data['url'] = this.url;
    data['image'] = this.image;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['followers_count'] = this.followersCount;
    data['following_count'] = this.followingCount;
    data['post_count'] = this.postCount;
    data['is_following'] = this.isFollowing;
    if (this.pivot != null) {
      data['pivot'] = this.pivot.toJson();
    }
    if (this.followers != null) {
      data['followers'] = this.followers.map((v) => v.toJson()).toList();
    }
    if (this.user != null) {
      data['user'] = this.user.toJson();
    }
    return data;
  }
}

class Pivot {
  int userId;
  int profileId;

  Pivot({this.userId, this.profileId});

  //Models the data that comes from backend in json format
  Pivot.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    profileId = json['profile_id'];
  }

  //Models the data that goes to backend to json format
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['profile_id'] = this.profileId;
    return data;
  }
}

class Followers {
  int id;
  String username;
  String fullname;
  String phoneNumber;
  String email;
  String emailVerifiedAt;
  String sPassword;
  String createdAt;
  String updatedAt;
  Pivot pivot;

  Followers(
      {this.id,
      this.username,
      this.fullname,
      this.phoneNumber,
      this.email,
      this.emailVerifiedAt,
      this.sPassword,
      this.createdAt,
      this.updatedAt,
      this.pivot});

  //Models the data that comes from backend in json format
  Followers.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    username = json['username'];
    fullname = json['fullname'];
    phoneNumber = json['phone_number'];
    email = json['email'];
    emailVerifiedAt = json['email_verified_at'];
    sPassword = json['s_password'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    pivot = json['pivot'] != null ? new Pivot.fromJson(json['pivot']) : null;
  }

  //Models the data that goes to backend to json format
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['username'] = this.username;
    data['fullname'] = this.fullname;
    data['phone_number'] = this.phoneNumber;
    data['email'] = this.email;
    data['email_verified_at'] = this.emailVerifiedAt;
    data['s_password'] = this.sPassword;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.pivot != null) {
      data['pivot'] = this.pivot.toJson();
    }
    return data;
  }
}

User currentUser;

// get current user
User get getCurrentUser {
  return currentUser;
}

// setting current user
setCurrentUser(Map<String, dynamic> json) async {
  currentUser = User.fromJson(json);
}
