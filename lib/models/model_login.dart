class ModelLoginResponse {
  bool? status;
  dynamic message;
  Data? data;

  ModelLoginResponse({this.status, this.message, this.data});

  ModelLoginResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  dynamic cookie;
  dynamic cookieAdmin;
  dynamic cookieName;
  User? user;

  Data({this.cookie, this.cookieAdmin, this.cookieName, this.user});

  Data.fromJson(Map<String, dynamic> json) {
    cookie = json['cookie'];
    cookieAdmin = json['cookie_admin'];
    cookieName = json['cookie_name'];
    user = json['user'] != null ? User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['cookie'] = cookie;
    data['cookie_admin'] = cookieAdmin;
    data['cookie_name'] = cookieName;
    if (user != null) {
      data['user'] = user!.toJson();
    }
    return data;
  }
}

class User {
  dynamic id;
  dynamic username;
  dynamic nicename;
  dynamic email;
  dynamic url;
  dynamic registered;
  dynamic displayname;
  dynamic firstname;
  dynamic lastname;
  dynamic nickname;
  dynamic description;
  Capabilities? capabilities;
  dynamic avatar;

  User(
      {this.id,
        this.username,
        this.nicename,
        this.email,
        this.url,
        this.registered,
        this.displayname,
        this.firstname,
        this.lastname,
        this.nickname,
        this.description,
        this.capabilities,
        this.avatar});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    username = json['username'];
    nicename = json['nicename'];
    email = json['email'];
    url = json['url'];
    registered = json['registered'];
    displayname = json['displayname'];
    firstname = json['firstname'];
    lastname = json['lastname'];
    nickname = json['nickname'];
    description = json['description'];
    capabilities = json['capabilities'] != null
        ? Capabilities.fromJson(json['capabilities'])
        : null;
    avatar = json['avatar'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['username'] = username;
    data['nicename'] = nicename;
    data['email'] = email;
    data['url'] = url;
    data['registered'] = registered;
    data['displayname'] = displayname;
    data['firstname'] = firstname;
    data['lastname'] = lastname;
    data['nickname'] = nickname;
    data['description'] = description;
    if (capabilities != null) {
      data['capabilities'] = capabilities!.toJson();
    }
    data['avatar'] = avatar;
    return data;
  }
}

class Capabilities {
  bool? customer;

  Capabilities({this.customer});

  Capabilities.fromJson(Map<String, dynamic> json) {
    customer = json['customer'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['customer'] = customer;
    return data;
  }
}
