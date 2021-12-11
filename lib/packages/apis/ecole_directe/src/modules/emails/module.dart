part of ecole_directe;

class _EmailsModule extends EmailsModule<_EmailsRepository> {
  _EmailsModule(SchoolApi api, {required bool isSupported, required bool isAvailable})
      : super(isSupported: isSupported, isAvailable: isAvailable, repository: _EmailsRepository(api), api: api);

  @override
  Future<Response<void>> fetch({bool online = false}) async {
    fetching = true;
    notifyListeners();
    if (online) {
      final res = await repository.get();
      if (res.error != null) return res;
      final List<Email> _emailsReceived = res.data!["emailsReceived"];
      if (_emailsReceived.length > emailsReceived.length) {
        final List<Email> newEmails = _emailsReceived.toSet().difference(emailsReceived.toSet()).toList();
        // TODO: foreach: trigger notifications
        emailsReceived.addAll(newEmails);
        await offline.setEmailsReceived(emailsReceived);
      }
      final List<Email> _emailsSent = res.data!["emailsSent"];
      if (_emailsSent.length > emailsSent.length) {
        final List<Email> newEmails = _emailsSent.toSet().difference(emailsSent.toSet()).toList();
        emailsSent.addAll(newEmails);
        await offline.setEmailsSent(emailsSent);
      }
      final List<Recipient> _recipients = res.data!["recipients"];
      if (_recipients.length > recipients.length) {
        final List<Recipient> newRecipients = _recipients.toSet().difference(recipients.toSet()).toList();
        recipients.addAll(newRecipients);
        await offline.setRecipients(recipients);
      }
    } else {
      emailsReceived = await offline.getEmailsReceived();
      emailsSent = await offline.getEmailsSent();
      recipients = await offline.getRecipients();
    }
    final List<String> favoriteEmailsIds = await offline.getFavoriteEmailsIds();
    fetching = false;
    notifyListeners();
    return const Response();
  }

  @override
  Future<Response<String>> send(Email email) async {
    return const Response(error: "Not implemented");
  }
  // https://api.ecoledirecte.com/v3/eleves/id/messages.awp?verbe=post
  // example body
  /* 
    data={
    "message": {
        "groupesDestinataires": [
            {
                "destinataires": [
                    {
                        "prenom": "J.",
                        "particule": "",
                        "nom": "DURAND",
                        "sexe": "",
                        "id": 69,
                        "type": "P",
                        "matiere": "",
                        "photo": "",
                        "telephone": "",
                        "email": "",
                        "estBlackList": false,
                        "isPP": false,
                        "etablissements": [],
                        "classes": [
                            {
                                "id": 20,
                                "code": "",
                                "libelle": "Seconde D",
                                "isPP": false,
                                "matiere": "FRANCAIS"
                            },
                            {
                                "id": 21,
                                "code": "",
                                "libelle": "Seconde D",
                                "isPP": false,
                                "matiere": "LATIN"
                            }
                        ],
                        "classe": {
                            "id": 1,
                            "code": "",
                            "libelle": ""
                        },
                        "responsable": {
                            "id": 5,
                            "versQui": "",
                            "typeResp": "",
                            "contacts": []
                        },
                        "fonction": {
                            "id": 3,
                            "libelle": ""
                        },
                        "isSelected": true,
                        "to_cc_cci": "to"
                    }
                ],
                "selection": {
                    "classes": [
                        {
                            "id": 0,
                            "code": "2D",
                            "libelle": "Seconde D",
                            "estNote": 1
                        }
                    ],
                    "classe": {
                        "id": 0,
                        "code": "2D",
                        "libelle": "Seconde D",
                        "estNote": 1
                    },
                    "isPP": false,
                    "type": "P"
                }
            }
        ],
        "content": "PHA%2BQm9uam91ciwgaiYjMzk7ZW52b2llIGp1c3RlIGRlcyBlbWFpbHMgZGUgdGVzdCBwb3VyIGFuYWx5c2VyIGxlcyByZXF1JmVjaXJjO3RlcyBkZSBsJiMzOTthcGkgZCYjMzk7RWNvbGVEaXJlY3RlLjwvcD4KCjxwPkomIzM5O2VuIGVudmVycmFpIHMmdWNpcmM7cmVtZW50IGQmIzM5O2F1dHJlcywgcXVlIGomIzM5O2FwcGVsbGVyYWkgYXVzc2kgJnF1b3Q7VGVzdCZxdW90OyBwb3VyIHF1ZSB2b3VzIG4mIzM5O2F5ZXogcGFzICZhZ3JhdmU7IHZvdXMgZW4gc291Y2llci48L3A%2BCgo8cD4mbmJzcDs8L3A%2BCgo8cD5Cb24gYXByJmVncmF2ZTtzLW1pZGksPC9wPgoKPHA%2BRmxvcmlhbjwvcD4K",
        "subject": "Test",
        "brouillon": false,
        "files": []
    },
    "anneeMessages": "",
    "token": "62484130626b684c516e567a616d5172616c5244526b4a48624668554f5546356232464d546b526c6331557a515774564c7a4e314c336435566d4630566b35716248526f516a424d65485a595954564a0d0a557a56456545567852466c4d63466c3153576f7a5a6974435432734e436e56744f43396e535452694d5556694f46423464315a79516c4a344d474d7256577372625652714e6a4e30616c4254596a55780d0a64473536644564796457744a646b5a454e6e526c4d6d316b61577470593359326256646863484d335555785163456435563246335a3263304451707a62455a77544456794e32307956565977615442740d0a615756595a6d597662544a4563555656574568435647684f4d6d6f3356335272627974504e6a64344d6b524c61476f3159585532525863794f47704c634768704e6a5a78565564434b304a4964306b330d0a4d6a49325977304b4e7a466d556b68485a6b7432526b3435596c4e53525767325a5764686245466b4d574e69626a46434d6a6849516c4669526b5656626b74554e475a4762577876655535755245706b0d0a4e304e73565574505a556c4a65564a6b6558704d536e4932526c467a52475677596d734e436e4e7462566b72566e526b5a57356d62564e59547a646e643278535645645a5569733351575a6e565374760d0a635464484d554530593346684b3168766545356d4c3068515357684951316470547a497a646d744d5130786f6456686c6555744765554e49566e4e355a54686144516f3254456779556a5132646d74440d0a4e6b52786458706955465a6c5230524862554a474d565931576a4a595a57524a62586b7963335236546a5a614e5849765a7a4a435930314e51567077576b6c5956586b795131424d5456424e64566b300d0a59544d334e31525a555842316267304b596a4e464d314a78596e687265545a444d335a5164576f72654852554b327855536a527452464e7a4d6c497a616d6c7556336734656c46776157526a576c5a550d0a56314a585a56527553326c4b65574a355232783362586433646b6732556a6849576c4d78535864685a54554e436e7049596e4d795656524c64564648595531435a6d646d5343737a4e7a46424e564a550d0a524668734b324e365a327842566b395462305a794b335578576e46684e316c514e45746f6355565362336c324d6d704a625552326353395655565650516a646c523349355a554a5644517070534555760d0a55316c5951586c4e626a64315530316f576c525853466459596b4a365a574e756132787a4d6b6c5a546d387257444a4d63314a58516d6c326131527a61575a7963585a72656e4e7161555a6e556e68680d0a5a7a46775a464a6b646a5a51566c6c3356474e716351304b6379394c645735544d3170754e57783356556c6e636b4e4562336730566e424f4c316c36656e42735345685956566372636e5a6f564534780d0a515778464e6c5a51575734766253737653444a4f646b396c63576f33613256575332387664304e484d45784b647a64316433494e436b4633526e424d5a474652636974776547706b536a4130623068680d0a4d554d7a4e32707157456330656c6c685a316850616d6c72616b7732626a686d52544e4d5679737754486c6a595663334e4764735a5778424d6b6f3364456730596a4a42553268594e55465163476c4b0d0a4451707861554e69576c64494c32463264485a70566b45335230566d51334531525552335a44527a56556454656b64356145773161576c334c33466a63544e556132744752337049634870585a7a52430d0a596e41334b33424f616e6c724f57314d546b315863325179556c4a7a5451304b5748673053566c61546b6c5a4e6d786e5a454a5a63574d765157647a4f46497a4f576c365957785853556f31625738340d0a626c4e7454476c584b30316961334e4251306831656c526a555538775a6a4e6852554e47633252474e3039744d4373316431523461553173536a634e436d78594d6c705a566c6454656a6430516a45300d0a4e4664715a30527756304e304e31563152584259647a4a5153324534596d3955565738315648704b647a564865553556566e567465456731626a46526457314554314a56614339705548644e537a5a430d0a55466c3265564e4844516f3554486b304d6c45"
}
    */

  @override
  Future<Response<void>> read(Email email) async {
    final bool received = emailsReceived.contains(email);
    final res = await repository.getEmailContent(email, received);
    if (res.error != null) return res;
    if (received) {
      emailsReceived.firstWhere((e) => e.id == email.id).read = true;
      emailsReceived.firstWhere((e) => e.id == email.id).content = res.data!;
      offline.setEmailsReceived(emailsReceived);
    } else {
      emailsSent.firstWhere((e) => e.id == email.id).read = true;
      emailsSent.firstWhere((e) => e.id == email.id).content = res.data!;
      offline.setEmailsSent(emailsSent);
    }
    notifyListeners();
    return const Response();
  }
}
