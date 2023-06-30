import 'package:delegate_app/models/api_user.dart';

class CreateProfileInputModel {
  String? fkUserId;
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
  String? gender;
  String? fem;
  String? birthDay;
  String? isFemale;
  String? pregnentorBreastfeeding;
  String? currentWeight;
  String? goalWeight;
  String? heightFeet;
  String? heightInches;
  String? currentActivityLevel;
  String? goalActivityLevel;
  String? bMI;
  String? bMR;
  String? caloriesAllowed;
  String? image;
  String? fatAllowed;
  String? carbsAllowed;
  String? proteinAllowed;
  String? userTimeZone;
  String? createdDate;
  String? isNewUser;

  CreateProfileInputModel(
      {this.fkUserId,
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
      this.gender,
      this.fem,
      this.birthDay,
      this.isFemale,
      this.pregnentorBreastfeeding,
      this.currentWeight,
      this.goalWeight,
      this.heightFeet,
      this.heightInches,
      this.currentActivityLevel,
      this.goalActivityLevel,
      this.bMI,
      this.bMR,
      this.caloriesAllowed,
      this.image,
      this.fatAllowed,
      this.carbsAllowed,
      this.proteinAllowed,
      this.userTimeZone,
      this.createdDate,
      this.isNewUser});

  Map<String, dynamic> getProfileModelJson() {
    return {
      'fkUserId': fkUserId,
      'userName': userName,
      'firstName': firstName,
      'lastName': lastName,
      'address1': address1,
      'address2': address2,
      'city': city,
      'zip': zip,
      'state': state,
      'phone': phone,
      'email': email,
      'gender': gender,
      'fem': fem,
      'birthDay': birthDay,
      'isFemale': isFemale,
      'pregnentorBreastfeeding': pregnentorBreastfeeding,
      'currentWeight': currentWeight,
      'goalWeight': goalWeight,
      'heightFeet': heightFeet,
      'heightInches': heightInches,
      'currentActivityLevel': currentActivityLevel,
      'goalActivityLevel': goalActivityLevel,
      'bMI': bMI,
      'bMR': bMR,
      'caloriesAllowed': caloriesAllowed,
      'image': image,
      'fatAllowed': fatAllowed,
      'carbsAllowed': carbsAllowed,
      'proteinAllowed': proteinAllowed,
      'userTimeZone': userTimeZone,
      'createdDate': createdDate,
      'isNewUser': isNewUser
    };
  }

  CreateProfileInputModel.fromJson(Map<String, dynamic> json) {
    fkUserId = json['fkUserId'] is String ? json['fkUserId'].toString() : null;
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
    gender = json['Gender'] is String ? json['Gender'].toString() : null;
    fem = json['Fem'] is String ? json['Fem'].toString() : null;
    birthDay = json['BirthDay'] is String ? json['BirthDay'].toString() : null;
    isFemale = json['IsFemale'] is String ? json['IsFemale'].toString() : null;
    pregnentorBreastfeeding = json['PregnentorBreastfeeding'] is String
        ? json['PregnentorBreastfeeding'].toString()
        : null;
    currentWeight = json['CurrentWeight'] is String
        ? json['CurrentWeight'].toString()
        : null;
    goalWeight =
        json['GoalWeight'] is String ? json['GoalWeight'].toString() : null;
    heightFeet =
        json['HeightFeet'] is String ? json['HeightFeet'].toString() : null;
    heightInches =
        json['HeightInches'] is String ? json['HeightInches'].toString() : null;
    currentActivityLevel = json['CurrentActivityLevel'] is String
        ? json['CurrentActivityLevel'].toString()
        : null;
    goalActivityLevel = json['GoalActivityLevel'] is String
        ? json['GoalActivityLevel'].toString()
        : null;
    bMI = json['BMI'] is String ? json['BMI'].toString() : null;
    bMR = json['BMR'] is String ? json['BMR'].toString() : null;
    caloriesAllowed = json['CaloriesAllowed'] is String
        ? json['CaloriesAllowed'].toString()
        : null;
    image = json['Image'] is String ? json['Image'].toString() : null;
    fatAllowed =
        json['FatAllowed'] is String ? json['FatAllowed'].toString() : null;
    carbsAllowed =
        json['CarbsAllowed'] is String ? json['CarbsAllowed'].toString() : null;
    proteinAllowed = json['ProteinAllowed'] is String
        ? json['ProteinAllowed'].toString()
        : null;
    userTimeZone =
        json['UserTimeZone'] is String ? json['UserTimeZone'].toString() : null;
    createdDate =
        json['CreatedDate'] is String ? json['CreatedDate'].toString() : null;
    isNewUser =
        json['isNewUser'] is String ? json['isNewUser'].toString() : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
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
    data['Gender'] = gender;
    data['Fem'] = fem;
    data['BirthDay'] = birthDay;
    data['IsFemale'] = isFemale;
    data['PregnentorBreastfeeding'] = pregnentorBreastfeeding;
    data['CurrentWeight'] = currentWeight;
    data['GoalWeight'] = goalWeight;
    data['HeightFeet'] = heightFeet;
    data['HeightInches'] = heightInches;
    data['CurrentActivityLevel'] = currentActivityLevel;
    data['GoalActivityLevel'] = goalActivityLevel;
    data['BMI'] = bMI;
    data['BMR'] = bMR;
    data['CaloriesAllowed'] = caloriesAllowed;
    data['Image'] = image;
    data['FatAllowed'] = fatAllowed;
    data['CarbsAllowed'] = carbsAllowed;
    data['ProteinAllowed'] = proteinAllowed;
    data['UserTimeZone'] = userTimeZone;
    data['CreatedDate'] = createdDate;
    data['isNewUser'] = isNewUser;
    return data;
  }

  void setReasonableDefaults(ApiUser? user) {
    fkUserId = '0';
    isFemale = gender == 'female' ? 'true' : 'false';
    pregnentorBreastfeeding = 'false';
    currentWeight = '150';
    goalWeight = '150';
    bMI = '10';
    bMR = '1625';
    fatAllowed = '19';
    isNewUser = 'true';
    userName = user?.email;
    zip = '12345';
    birthDay = '01/01/2000';
    caloriesAllowed = '2000';
  }
}
