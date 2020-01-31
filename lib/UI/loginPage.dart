import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:vector_math/vector_math.dart' as math;
import 'package:ynotes/main.dart';
Color myColor = Color(0xff00bfa5);

class ConditionsDialog extends StatelessWidget {
  @override

  Widget build(BuildContext context) {
    MediaQueryData screenSize;
    screenSize = MediaQuery.of(context);
    openAlertBox() {
      return showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(32.0))),
              contentPadding: EdgeInsets.only(top: 10.0),
              content: Container(
                width: screenSize.size.width,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text(
                          "Conditions d’utilisation",
                          style: TextStyle(fontSize: 24.0, fontFamily: "Asap"),
                        ),

                      ],
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                    Divider(
                      color: Colors.grey,
                      height: 4.0,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 10, bottom: 10),

                      child: SingleChildScrollView(child:Container(height: 500, child: Text(
                      "En utilisant cette application ainsi que les services tiers vous acceptez et comprenez les conditions suivantes :\n\n  - Mon identifant ainsi que mon mot de passe ne sont pas enregistrés sur des serveurs, seulement sur votre appareil. Mais vous vous portez responsables en cas de perte de ces derniers.\n\n - YNote ne se porte pas responsable en cas de suppression ou altération de la qualité de votre compte EcoleDirecte par une entité externe.\n\n - YNote est un client libre et gratuit et non officiel\n\n - YNote n’est en aucun cas affilié ou relié à une quelconque entité\n\n - EcoleDirecte est un produit de la société STATIM",
                        style: TextStyle(fontFamily: "Asap",), textAlign: TextAlign.justify,
                      ),) )
                    ),


                RaisedButton(
                    padding: EdgeInsets.only(
                        left: 60, right: 60, top: 15, bottom: 18),
                    color: Color(0xff27AE60),
                    shape: RoundedRectangleBorder(
                        borderRadius:  BorderRadius.only(bottomLeft: Radius.circular(32.0), bottomRight: Radius.circular(32.0)),

                    ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SecondRoute()),
                    );
                  },
                    child:
                    Text(
                          "J'accepte",
                          style: TextStyle(color: Colors.white),
                          textAlign: TextAlign.center,

                      ),

                    ),

                  ],
                ),
              ),
            );
          });
    }


    return  Container(
        height: screenSize.size.height,
        decoration: BoxDecoration(

          gradient: LinearGradient(
            begin: Alignment.topLeft,

            end: Alignment(1, 1), // 10% of the width, so there are ten blinds.
            colors: [
              const Color(0xFF000000),
              const Color(0xFF0500FF).withOpacity(0)
            ], // whitish to gray
            tileMode: TileMode.repeated, // repeats the gradient over the canvas
          ),
        ),
        child: SingleChildScrollView(child:Container(
            height: screenSize.size.height,
            width: screenSize.size.width,
            decoration: BoxDecoration(
              color: Color(0xff252228).withOpacity(0.8),
            ),
            child: Stack(
              children: <Widget>[
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: 90),
                      Container(
                        child: Text(
                          "Trouvez votre espace",
                          style: TextStyle(
                              fontFamily: 'Asap',
                              fontSize: 48,
                              color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(
                        height: screenSize.size.height / 28,
                      ),


                      Container(
                        width: 400,
                        margin: EdgeInsets.only(
                            left: screenSize.size.width / 11, top: 20, bottom: 5),
                        child: Text(
                          "Nom d'utilisateur",
                          style:
                          TextStyle(fontFamily: 'Asap', color: Colors.white),
                          textAlign: TextAlign.left,
                        ),
                      ),


                      Container(
                        margin: EdgeInsets.only(
                            left: screenSize.size.width / 12,
                            right: screenSize.size.width / 12),
                        height: 45,
                        child: TextFormField(

                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.all(18),
                            filled: true,
                            fillColor: Colors.white,
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  width: 0, color: Colors.lightBlue.shade50),
                              borderRadius: BorderRadius.circular(25.0),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  width: 0, color: Colors.lightBlue.shade50),
                              borderRadius: BorderRadius.circular(25.0),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: screenSize.size.width,
                        margin: EdgeInsets.only(
                            left: screenSize.size.width / 11, top: 20, bottom: 5),
                        child: Text(
                          "Mot de passe",
                          style:
                          TextStyle(fontFamily: 'Asap', color: Colors.white),
                          textAlign: TextAlign.left,
                        ),
                      ),
                      Container(
                        height: 45,
                        margin: EdgeInsets.only(
                            left: screenSize.size.width / 12,
                            right: screenSize.size.width / 12),
                        child: TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          obscureText: true,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.all(18),
                            filled: true,
                            fillColor: Colors.white,
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  width: 0, color: Colors.lightBlue.shade50),
                              borderRadius: BorderRadius.circular(25.0),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  width: 0, color: Colors.lightBlue.shade50),
                              borderRadius: BorderRadius.circular(25.0),
                            ),
                          ),
                        ),
                      ),
                      Container(
                          margin: const EdgeInsets.only(top: 20),
                          child: RaisedButton(
                            padding: EdgeInsets.only(
                                left: 60, right: 60, top: 15, bottom: 15),
                            color: Color(0xffBDE1C9),
                            shape: StadiumBorder(),
                            onPressed: () {openAlertBox();},
                            child: Text(
                              "Se connecter",
                              style: TextStyle(fontSize: 24),
                            ),
                          )),

                      SizedBox(height: 90),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Tooltip(message: "EcoleDirecte" , preferBelow: false, child: Container(
                              height: 37,
                              width: 37,
                              decoration: new BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                      width: 4.0,
                                      color: const Color(0xFFFFFFFF))),
                              child: SvgPicture.asset("assets/images/logoED.svg",
                                  color: Colors.lightBlueAccent)),
                          ),
                          SizedBox(width: screenSize.size.width / 30),
                          Container(
                              height: 41,
                              width: 41,
                              decoration: new BoxDecoration(
                                shape: BoxShape.circle,
                              ),
                              child: Image(
                                image:
                                AssetImage('assets/images/space/space.png'),
                                fit: BoxFit.fill,
                              )),
                        ],
                      )
                    ],
                  ),
                ),

                Container(child:  Planet(),)

              ],
            )),
        ));
  }
}


//Planet widget
class Planet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    MediaQueryData screenSize;
    screenSize = MediaQuery.of(context);
    return Stack( children: <Widget>[ Positioned.fill(

      left: 70,
      top: screenSize.size.height / 1.6,
      child: Stack(children: <Widget>[
        Container(
          transform:
          Matrix4.translationValues(screenSize.size.width / 2, 150, 0),
          child: Material(
            borderRadius: BorderRadius.all(Radius.circular(500.0)),
            color: Color(0xffE1BAA3),
            child: Container(
              width: 326,
              height: 318,
            ),
          ),
        ),
        Container(
          transform:
          Matrix4.translationValues(screenSize.size.width / 1.7, 270, 0),
          child: Material(
            borderRadius: BorderRadius.all(Radius.circular(500.0)),
            color: Color(0xffEBCDBC),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(width: 8.0, color: const Color(0xFFC5A492)),
                borderRadius: BorderRadius.all(Radius.circular(500.0)),
              ),
              width: 74,
              height: 71,
            ),
          ),
        ),
        Container(
          transform:
          Matrix4.translationValues(screenSize.size.width / 1.45, 170, 0),
          child: Material(
            borderRadius: BorderRadius.all(Radius.circular(500.0)),
            color: Color(0xffEBCDBC),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(width: 8.0, color: const Color(0xFFC5A492)),
                borderRadius: BorderRadius.all(Radius.circular(500.0)),
              ),
              width: 74,
              height: 71,
            ),
          ),
        ),
      ]),
    )
    ]);

  }
}

