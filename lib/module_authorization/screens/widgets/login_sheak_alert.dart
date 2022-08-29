import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_kom_dist_dashboard/consts/colors.dart';
import 'package:my_kom_dist_dashboard/module_authorization/authorization_routes.dart';
import 'package:my_kom_dist_dashboard/utils/size_configration/size_config.dart';


loginCheakAlertWidget(context){
  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    clipBehavior: Clip.antiAlias,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20)
    ),
    content: Container(
      height: SizeConfig.screenHeight * 0.5,
      width: SizeConfig.screenWidth * 0.8,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20)
      ),
      child: Column(
       crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey.shade100
            ),
            child: IconButton(onPressed: (){
              Navigator.pop(context);
            }, icon: Icon(Icons.clear,color: Colors.black,)),
          ),
          SizedBox(height: 10,),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            height: SizeConfig.screenHeight * 0.25,
            width: double.infinity,

            child: Image.asset('assets/not_login.png',fit: BoxFit.fill,),
          ),
          Center(child: Text('You are not subscribed to May Kom',style: GoogleFonts.lato(
              fontSize: SizeConfig.titleSize * 2.5,fontWeight: FontWeight.bold,color: Colors.black54
          ),)),
          Spacer(),
          Container(
            width: double.infinity,
            height: 40,
            margin: EdgeInsets.symmetric(horizontal: 20),
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
                color: ColorsConst.mainColor,
                borderRadius: BorderRadius.circular(10)
            ),
            child: MaterialButton(
              onPressed: (){
                Navigator.pushNamed(context, AuthorizationRoutes.LOGIN_SCREEN);
              },
              child:Text('Login',style: TextStyle(color: Colors.white,fontSize: SizeConfig.titleSize * 2.7),),

            ),
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

