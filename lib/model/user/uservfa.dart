class UserVfa {
  String? userId;
  String? vfaEmail;
  String? vfaAvatar;
  String? vfaPhoneWork;
  String? userFullName;
  String? userBirthday;

  UserVfa(
      {this.userId,
      this.vfaEmail,
      this.vfaAvatar,
      this.vfaPhoneWork,
      this.userFullName,
      this.userBirthday});

  factory UserVfa.fromJson(Map<String, dynamic> json) => UserVfa(
        userId: json['userId'].toString(),
        vfaEmail: json['vfaEmail'].toString(),
        vfaAvatar: json['vfaAvatar'].toString(),
        vfaPhoneWork: json['vfaPhoneWork'].toString(),
        userFullName: json['userFullName'].toString(),
        userBirthday: json['userBirthday'].toString(),
      );

  Map<String, dynamic> toJson(UserVfa userVfa) => {
        'userId': userVfa.userId,
        'vfaEmail': userVfa.vfaEmail,
        'vfaAvatar': userVfa.vfaAvatar,
        'vfaPhoneWork': userVfa.vfaAvatar,
        'userFullName': userVfa.userFullName,
        'userBirthday': userVfa.userBirthday
      };
}
