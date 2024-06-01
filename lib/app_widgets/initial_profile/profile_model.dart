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
  id = json['Id'] as int?;
  fkUserId = json['fkUserId'] as int?;
  userName = json['UserName'] as String?;
  firstName = json['FirstName'] as String?;
  lastName = json['LastName'] as String?;
  address1 = json['Address1'] as String?;
  address2 = json['Address2'] as String?;
  city = json['City'] as String?;
  zip = json['Zip'] as String?;
  state = json['State'] as String?;
  phone = json['Phone'] as String?;
  email = json['Email'] as String?;
  
  createdDate = json['CreatedDate'] as String?;
  isNewUser = json['isNewUser'] as bool?;
  message = json['Message'] as String?;
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
