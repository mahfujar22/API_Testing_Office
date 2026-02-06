class LoginResponse {
    bool status;
    String message;
    Data data;

    LoginResponse({
        required this.status,
        required this.message,
        required this.data,
    });

    factory LoginResponse.fromJson(Map<String, dynamic> json) => LoginResponse(
        status: json['status'],
        message: json['message'],
        data: Data.fromJson(json['data']),
    );

}

class Data {
    String token;
    User user;

    Data({
        required this.token,
        required this.user,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        token: json['token'],
        user: User.fromJson(json['user']),
    );

}

class User {
    int id;
    String profileImage;
    String name;
    String email;
    String phone;
    dynamic dob;
    dynamic nationalInsuranceNumber;
    dynamic nationality;
    dynamic flarHouseNo;
    dynamic street;
    dynamic city;
    dynamic postCode;

    User({
        required this.id,
        required this.profileImage,
        required this.name,
        required this.email,
        required this.phone,
        required this.dob,
        required this.nationalInsuranceNumber,
        required this.nationality,
        required this.flarHouseNo,
        required this.street,
        required this.city,
        required this.postCode,
    });

    factory User.fromJson(Map<String, dynamic> json) => User(
        id: json['id'],
        profileImage: json['profile_image'],
        name: json['name'],
        email: json['email'],
        phone: json['phone'],
        dob: json['dob'],
        nationalInsuranceNumber: json['national_insurance_number'],
        nationality: json['nationality'],
        flarHouseNo: json['flar_house_no'],
        street: json['street'],
        city: json['city'],
        postCode: json['post_code'],
    );
}
