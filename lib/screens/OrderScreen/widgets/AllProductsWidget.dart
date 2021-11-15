import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ItemTile extends StatelessWidget {
  final int itemNo;

  ItemTile(
      this.itemNo,
      );

  int _ammount = 0;

  ///CONTAINER DECORATION BORDER
  BoxDecoration myBoxDecoration() {
    return BoxDecoration(
      border: Border.all(),
    );
  }


  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.all(10),
      child: Container(
        height: 200,
        width: 200,
        child: Column(
          children: <Widget>[
            GestureDetector(
              onTap: () {

              },
              child: Container(
                height: 200,
                width: 200,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    image: DecorationImage(
                        image: AssetImage(
                            'assets/images/logo.png',
                        ),
                        fit: BoxFit.fill )
                ),
              ),
            ),
            SizedBox(height: 5,),
            Text("Product ${itemNo}",
              style: GoogleFonts.roboto(
                  fontSize: 14,
                  color: Colors.black,

              ),),
            Container(
              width: 200,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  IconButton(onPressed: (){

                  }, icon: Icon(Icons.remove)),
                  Container(
                      width: 50,
                      alignment: Alignment.center,
                      decoration: myBoxDecoration(),
                      child: Text('\$${5 + _ammount}')
                  ),
                  IconButton(onPressed: (){

                  }, icon: Icon(Icons.add)),
                  Icon(Icons.check_box)
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}