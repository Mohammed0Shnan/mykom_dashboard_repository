import 'package:flutter/material.dart';
import 'package:my_kom_dist_dashboard/utils/size_configration/size_config.dart';

class IconWidget  extends StatelessWidget {

  final IconData icon;
  final Function() onPress;
  IconWidget  ({required this.icon , required this.onPress,Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double size = SizeConfig.heightMulti *7;
           return   Container(
               alignment: Alignment.center,
               width: size,
               height: size,
               decoration: BoxDecoration(
                 shape: BoxShape.circle,
                 color: Colors.white.withOpacity(0.8)
               ),
               child: IconButton(
                   onPressed:onPress,
                   icon:Icon(icon,color: Colors.black,size: 20,)),
             );
  }

}
