import 'package:flutter/material.dart';

void main() {
  runApp(
    MaterialApp(
      home: Logger(),

    ),
  );
}

class Logger extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body:
      Container(

        decoration: BoxDecoration(
          color: Color(0xff252228).withOpacity(1),




        ),
        child:

      Container(

        margin: const EdgeInsets.only(left: 30.0, right: 30.0),

        child:

        Column(

          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              transform: Matrix4.translationValues(0.0, -80.0, 0.0),
              child:  Text("Trouvez votre espace",
                style: TextStyle(fontFamily: 'Asap', fontSize: 48, color: Colors.white), textAlign: TextAlign.center,),
            ),
            Container(
              width: 400,
              margin: const EdgeInsets.only(left: 20.0, right: 20.0, top: 20),
              child:  Text("Adresse mail",
                style: TextStyle(fontFamily: 'Asap', color: Colors.white), textAlign: TextAlign.left,),
            ),
            Container(

              height: 45,
              child:   TextFormField(



                  decoration: InputDecoration(

                  contentPadding: EdgeInsets.all(18),
                  filled: true,
                  fillColor: Colors.white,
                  focusedBorder:OutlineInputBorder(
                    borderSide: BorderSide(width: 0, color: Colors.lightBlue.shade50),
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                  enabledBorder:OutlineInputBorder(
                    borderSide: BorderSide(width: 0, color: Colors.lightBlue.shade50),
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                ),
              ),
            ),
            Container(
              width: 400,
              margin: const EdgeInsets.only(left: 20.0, right: 20.0, top: 20),
              child:  Text("Mot de passe",
                style: TextStyle(fontFamily: 'Asap', color: Colors.white), textAlign: TextAlign.left,),
            ),
            Container(
              height: 45,
              child:   TextFormField(


                obscureText: true,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(18),
                  filled: true,
                  fillColor: Colors.white,
                  focusedBorder:OutlineInputBorder(
                    borderSide: BorderSide(width: 0, color: Colors.lightBlue.shade50),
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                  enabledBorder:OutlineInputBorder(
                    borderSide: BorderSide(width: 0, color: Colors.lightBlue.shade50),
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                ),
              ),

            ),
        Container(
          margin: const EdgeInsets.only( top: 20),
          child: RaisedButton(
            padding: EdgeInsets.only(left: 60, right: 60, top: 15, bottom: 15),
            color: Color(0xff767593),
            shape: StadiumBorder(),
            onPressed: () {},
            child: Text("Se connecter", style: TextStyle(fontSize: 24),),
          )
        )

          ],
        ),

      ),
    ),
    );
  }
}