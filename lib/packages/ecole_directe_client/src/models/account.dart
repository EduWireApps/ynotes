part of ecole_directe_client;

class Account {
  final int id;
  final int loginId;
  final String uuid;
  final String username;
  final String type;
  final bool main;
  final DateTime lastLogin;
  final String civility;
  final String firstName;
  final String lastName;
  final String nameParticle;
  String get name => "$firstName $nameParticle $lastName";
  final String email;
  final String currentSchoolYear;
  final School school;
  final List<Module> modules;
  final Profile profile;

  const Account(
      {required this.id,
      required this.loginId,
      required this.uuid,
      required this.username,
      required this.type,
      required this.main,
      required this.lastLogin,
      required this.civility,
      required this.firstName,
      required this.lastName,
      required this.nameParticle,
      required this.email,
      required this.currentSchoolYear,
      required this.school,
      required this.modules,
      required this.profile});

  factory Account.fromMap(Map<String, dynamic> map) => Account(
      id: map["id"],
      loginId: map["idLogin"],
      uuid: map["uid"],
      username: map["identifiant"],
      type: map["typeCompte"],
      main: map["main"],
      lastLogin: DateTime.parse(map["lastConnexion"]),
      civility: map["civilite"],
      firstName: map["prenom"],
      lastName: map["nom"],
      nameParticle: map["particule"],
      email: map["email"],
      currentSchoolYear: map["anneeScolaireCourante"],
      school: School(
          name: map["nomEtablissement"],
          logo: map["logoEtablissement"],
          id: int.parse(map["profile"]["idEtablissement"]),
          rne: map["profile"]["rneEtablissement"],
          phone: map["profile"]["telPortable"],
          realId: int.parse(map["profile"]["idReelEtab"])),
      modules: map["modules"].map<Module>((m) => Module.fromMap(m)).toList(),
      profile: Profile.fromMap(map["profile"]));
}

class School {
  final String name;
  final String? logo;
  final int id;
  final String? rne;
  final String? phone;
  final int realId;

  const School({
    required this.name,
    this.logo,
    required this.id,
    this.rne,
    this.phone,
    required this.realId,
  });
}

class Module {
  final String code;
  final bool enabled;
  final int order;
  final int badge;
  final Map<String, dynamic> parameters;

  const Module(
      {required this.code, required this.enabled, required this.order, required this.badge, required this.parameters});

  factory Module.fromMap(Map<String, dynamic> map) => Module(
      code: map["code"], enabled: map["enable"], order: map["ordre"], badge: map["badge"], parameters: map["params"]);
}

class Profile {
  final String gender;
  final String agendaInfo;
  final String photo;
  final Classroom classroom;
  final List<SubAccount> accounts;

  const Profile(
      {required this.gender,
      required this.agendaInfo,
      required this.photo,
      required this.classroom,
      required this.accounts});

  factory Profile.fromMap(Map<String, dynamic> map) => Profile(
      gender: map["sexe"],
      agendaInfo: map["infoEDT"],
      photo: map["photo"],
      classroom: Classroom.fromMap(map["classe"]),
      accounts: map["eleves"] == null ? [] : map["eleves"].map((e) => SubAccount.fromMap(e)).toList());
}

class Classroom {
  final int id;
  final String code;
  final String name;
  final bool graded;

  const Classroom({required this.id, required this.code, required this.name, required this.graded});

  factory Classroom.fromMap(Map<String, dynamic> map) =>
      Classroom(id: map["id"], code: map["code"], name: map["libelle"], graded: map["estNote"] == 1);
}

class SubAccount {
  final int id;
  final String firstName;
  final String lastName;
  String get name => "$firstName $lastName";
  final String gender;
  final String agendaInfo;
  final String photoUrl;
  final School school;

  const SubAccount(
      {required this.id,
      required this.firstName,
      required this.lastName,
      required this.gender,
      required this.agendaInfo,
      required this.photoUrl,
      required this.school});

  factory SubAccount.fromMap(Map<String, dynamic> map) => SubAccount(
      id: map["id"],
      firstName: map["prenom"],
      lastName: map["nom"],
      gender: map["sexe"],
      agendaInfo: map["infoEDT"],
      photoUrl: map["photo"],
      school: School(
          name: map["nomEtablissement"], id: int.parse(map["idEtablissement"]), realId: int.parse(map["idReelEtab"])));
}
