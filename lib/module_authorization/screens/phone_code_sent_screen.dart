
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:my_kom_dist_dashboard/consts/colors.dart';
import 'package:my_kom_dist_dashboard/module_authorization/bloc/phone_verification_bloc.dart';
import 'package:my_kom_dist_dashboard/module_authorization/screens/login_automatically.dart';
import 'package:my_kom_dist_dashboard/module_dashbord/dashboard_routes.dart';
class PhoneCodeSentScreen extends StatefulWidget {
  final String phoneNumber ;
  final String email;
  final String password;
   PhoneCodeSentScreen({required this.phoneNumber,required this.email,required this.password,Key? key}) : super(key: key);

  @override
  State<PhoneCodeSentScreen> createState() => _PhoneCodeSentScreenState();
}

class _PhoneCodeSentScreenState extends State<PhoneCodeSentScreen> {
   final _confirmationController = TextEditingController();
   final PhoneVerificationBloc _phoneVerificationBloc = PhoneVerificationBloc();

   bool retryEnabled = false;
   bool loading = false;

   @override
  void initState() {
     _phoneVerificationBloc.registerPhoneNumber(widget.phoneNumber);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:  Form(
    child: Flex(
    direction: Axis.vertical,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(height: 30,),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextFormField(
              controller: _confirmationController,
              decoration: InputDecoration(
                labelText:'Confirm Code',
                hintText: 'OTP',
              ),
              keyboardType: TextInputType.number,
              validator: (v) {
                if (v!.isEmpty) {
                  return 'Please Input Phone Number';
                }
                return null;
              }),
        ),
        SizedBox(height: 10,),
        OutlinedButton(
          onPressed: (){
            _phoneVerificationBloc.registerPhoneNumber(widget.phoneNumber);
          },
          child: Text('Resend Code'),
        ),
       Spacer(),
        BlocConsumer<PhoneVerificationBloc, PhoneVerificationStates>(
          bloc: _phoneVerificationBloc,
          listener: (context,state){
           if(state is PhoneVerificationCurrentState )
             {
               if(state.message == 'CODE SENT'){
                 Scaffold.of(context).showBottomSheet((context) => Container(
                   child: Text('Code sent by text message'),
                 ));
               }else if (state.message == 'CODE TIMEOUT'){
                 Scaffold.of(context).showBottomSheet((context) => Container(
                   child: Text('If the code is not received, redial the code'),
                 ));
               }else if(state.message == 'UNAUTHORIZED'){
                 EasyLoading.showError('Error !!!');
                 Scaffold.of(context).showBottomSheet((context) => Container(
                   child: Text('There was an error !!!'),
                 ));
               }
             }
           else if(state is PhoneVerificationSuccessState){
             EasyLoading.showSuccess('Success !!!');
             Navigator.pushNamedAndRemoveUntil(context, DashboardRoutes.DASHBOARD_SCREEN,(route)=>false);
           }

          }
          ,
            builder:(context,state){

            if(state is PhoneVerificationLoadingState)
              return Text('Loading ...');
            else
            return Container(
              decoration: BoxDecoration(color:ColorsConst.mainColor),
              margin: EdgeInsets.symmetric(horizontal: 20),
              child: GestureDetector(
                onTap: () {
                  loading = true;
                  Future.delayed(Duration(seconds: 10), () {
                    loading = false;
                  });

                  setState((){});
                  _phoneVerificationBloc.confirmCaptainCode(_confirmationController.text);

                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        'Confirm',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
            }
        ),
        SizedBox(height: 30,),

      ],
    ),
    ),
    );
  }
}


