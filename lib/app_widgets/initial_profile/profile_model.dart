import 'package:prasso_app/app_widgets/initial_profile/create_profile_input_model.dart';

class ProfileModel {
  int? id;
  int? fkUserId;
  String? userName;
  String? firstName;
  String? lastName;
  String? address1;
  String? address2;
  String? city;
  String? zip;
  String? state;
  String? phone;
  String? email;

  String? createdDate;
  bool? isNewUser;
  int? statusCode;
  String? message;
  String? photoURL;
  String? displayName;

  ProfileModel(
      {this.id,
      this.fkUserId,
      this.userName,
      this.firstName,
      this.lastName,
      this.address1,
      this.address2,
      this.city,
      this.zip,
      this.state,
      this.phone,
      this.email,
      this.createdDate,
      this.isNewUser,
      this.statusCode,
      this.message});

  ProfileModel.fromCreatePim(CreateProfileInputModel cp) {
    try {
      id = 0;
      fkUserId = cp.fkUserId != null ? int.parse(cp.fkUserId!) : 0;
      userName = cp.userName;
      firstName = cp.firstName;
      lastName = cp.lastName;
      address1 = cp.address1;
      address2 = cp.address2;
      city = cp.city;
      zip = cp.zip;
      state = cp.state;
      phone = cp.phone;
      email = cp.email;

      createdDate = cp.createdDate;
      if (cp.isNewUser is bool) {
        isNewUser = bool.fromEnvironment(cp.isNewUser!);
      } else {
        isNewUser = null;
      }
    } catch (ex) {
      //default to the authorized user from Firebase.? nothing yet
      print(ex.toString());
    }
  }
  ProfileModel.fromJson(Map<String, dynamic> json) {
    id = json['Id'] is int ? int.parse(json['Id']) : null;
    fkUserId = json['fkUserId'] is int ? int.parse(json['fkUserId']) : null;
    userName = json['UserName'] is String ? json['UserName'].toString() : null;
    firstName =
        json['FirstName'] is String ? json['FirstName'].toString() : null;
    lastName = json['LastName'] is String ? json['LastName'].toString() : null;
    address1 = json['Address1'] is String ? json['Address1'].toString() : null;
    address2 = json['Address2'] is String ? json['Address2'].toString() : null;
    city = json['City'] is String ? json['City'].toString() : null;
    zip = json['Zip'] is String ? json['Zip'].toString() : null;
    state = json['State'] is String ? json['State'].toString() : null;
    phone = json['Phone'] is String ? json['Phone'].toString() : null;
    email = json['Email'] is String ? json['Email'].toString() : null;

    createdDate =
        json['CreatedDate'] is String ? json['CreatedDate'].toString() : null;
    isNewUser = json['isNewUser'] is bool
        ? bool.fromEnvironment(json['isNewUser'])
        : null;
    message = json['Message'] is String ? json['Message'].toString() : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Id'] = id;
    data['fkUserId'] = fkUserId;
    data['UserName'] = userName;
    data['FirstName'] = firstName;
    data['LastName'] = lastName;
    data['Address1'] = address1;
    data['Address2'] = address2;
    data['City'] = city;
    data['Zip'] = zip;
    data['State'] = state;
    data['Phone'] = phone;
    data['Email'] = email;

    data['CreatedDate'] = createdDate;
    data['isNewUser'] = isNewUser;
    data['Message'] = message;
    return data;
  }
}
