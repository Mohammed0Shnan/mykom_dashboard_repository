import 'package:flutter/material.dart';
import 'package:my_kom_dist_dashboard/consts/colors.dart';

 deleteCheckAlertWidget(BuildContext context, {required Function function , required String message}){
  // set up the AlertDialog
  AlertDialog alert = AlertDialog(

    clipBehavior: Clip.antiAlias,
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20)

    ),
    content: Container(

      height: 100,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(message,style: TextStyle(fontSize:20,fontWeight: FontWeight.w800,color: Colors.black54),),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                height: 35,
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                    color: ColorsConst.mainColor,
                    borderRadius: BorderRadius.circular(10)
                ),
                child: MaterialButton(
                  onPressed: (){
                    Navigator.pop(context);
                  },
                  child:Text('Cancel',style: TextStyle(color: Colors.white,fontSize: 20),),

                ),
              ),
              Container(
                clipBehavior: Clip.antiAlias,
                height: 35,
                decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(10)
                ),
                child: MaterialButton(
                  onPressed: (){

                  function();
                  Navigator.pop(context);
                  },
                  child:Text('Confirm',style: TextStyle(color: Colors.white,fontSize:20),),

                ),
              ),
            ],
          ),
        ],
      ),
    ),

  );

// show the dialog
   showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

