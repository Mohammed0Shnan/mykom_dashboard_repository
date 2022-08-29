import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_kom_dist_dashboard/consts/colors.dart';
import 'package:my_kom_dist_dashboard/module_dashbord/models/product_model.dart';
import 'package:my_kom_dist_dashboard/module_dashbord/widgets/expanded_text_widget.dart';
import 'package:my_kom_dist_dashboard/module_dashbord/widgets/icon_widget.dart';
import 'package:my_kom_dist_dashboard/utils/size_configration/size_config.dart';

class ProductStatisticsDetail extends StatefulWidget {
  final ProductModel productModel;
  ProductStatisticsDetail(
      {required this.productModel, Key? key});


  @override
  State<ProductStatisticsDetail> createState() => _ProductStatisticsDetailState();
}

class _ProductStatisticsDetailState extends State<ProductStatisticsDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Material(

        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              automaticallyImplyLeading: false,
              toolbarHeight: 11.9 * SizeConfig.heightMulti,
              pinned: true
              ,
              backgroundColor: ColorsConst.mainColor,
              expandedHeight: SizeConfig.screenHeight * 0.35,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconWidget(icon:Icons.arrow_back, onPress: (){
                    Navigator.pop(context);
                  }),
                ],
              ),
              flexibleSpace: FlexibleSpaceBar(
                background:     Container(
                  width: double.infinity,
                  child: CachedNetworkImage(
                    imageUrl: widget.productModel.imageUrl,
                    progressIndicatorBuilder: (context, l, ll) =>
                        CircularProgressIndicator(
                          value: ll.progress,
                        ),
                    errorWidget: (context, s, l) => Icon(Icons.error),
                    fit: BoxFit.cover,
                  ),)



              ),
              bottom: PreferredSize(
                preferredSize: Size.fromHeight(20),
                child: Container(
                    padding: EdgeInsets.only(bottom: 10,top: 10),
                    decoration: BoxDecoration(
                        color: Colors.white
                        ,borderRadius: BorderRadius.only(

                        topLeft:Radius.circular(20),
                        topRight: Radius.circular(20)
                    ))
                    ,child: Center(child: Text(widget.productModel.title,style: GoogleFonts.lato(
                    fontWeight: FontWeight.bold,
                    fontSize: SizeConfig.titleSize * 3.5,
                    color: Colors.black87

                )
                ))) ,
              ),
            ),
            SliverToBoxAdapter(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 20,),
                    Text('Description',style: TextStyle(
                        fontSize: 20,
                        color: Colors.black54,
                        fontWeight: FontWeight.w600),),
                    SizedBox(height: 10,),
                    ExpadedTextWidget(text: widget.productModel.description),
                    SizedBox(
                      height: 10,
                    ),



                  ],
                ),
              ),
            )

          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(8),
        height: 120,
        decoration: BoxDecoration(
            color: Colors.grey.shade200
            ,borderRadius: BorderRadius.only(topLeft: Radius.circular(20),topRight: Radius.circular(20))),
        child:               Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text('${widget.productModel.price}  AED',
                  style: GoogleFonts.lato(
                      color: ColorsConst.mainColor,
                      fontSize: SizeConfig.titleSize * 2.8,
                      fontWeight: FontWeight.bold
                  ),
                ),


              ]),
        ),
      ),
    );
  }
}
