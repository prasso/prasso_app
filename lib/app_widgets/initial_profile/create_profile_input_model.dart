import 'package:prasso_app/models/api_user.dart';

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
    fkUserId = json['fkUserId'] as String?;
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
    gender = json['Gender'] as String?;
    fem = json['Fem'] as String?;
    birthDay = json['BirthDay'] as String?;
    isFemale = json['IsFemale'] as String?;
    pregnentorBreastfeeding = json['PregnentorBreastfeeding'] as String?;
    currentWeight = json['CurrentWeight'] as String?;
    goalWeight = json['GoalWeight'] as String?;
    heightFeet = json['HeightFeet'] as String?;
    heightInches = json['HeightInches'] as String?;
    currentActivityLevel = json['CurrentActivityLevel'] as String?;
    goalActivityLevel = json['GoalActivityLevel'] as String?;
    bMI = json['BMI'] as String?;
    bMR = json['BMR'] as String?;
    caloriesAllowed = json['CaloriesAllowed'] as String?;
    image = json['Image'] as String?;
    fatAllowed = json['FatAllowed'] as String?;
    carbsAllowed = json['CarbsAllowed'] as String?;
    proteinAllowed = json['ProteinAllowed'] as String?;
    userTimeZone = json['UserTimeZone'] as String?;
    createdDate = json['CreatedDate'] as String?;
    isNewUser = json['isNewUser'] as String?;
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
