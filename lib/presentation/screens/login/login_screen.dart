import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:storeops_mobile/config/router/router.dart';
import 'package:storeops_mobile/config/theme/app_theme.dart';
import 'package:storeops_mobile/domain/repositories/auth_repository.dart';
import 'package:storeops_mobile/presentation/global_widgets/custom_field_box.dart';
import 'package:storeops_mobile/presentation/global_widgets/snackbar_message.dart';
import 'package:storeops_mobile/presentation/screens/login/widgets/custom_button_submit.dart';
import 'package:storeops_mobile/services/shared_preferences_service.dart';

class LoginScreen extends StatelessWidget {
  static const name='login_screen';
  
  final userController= TextEditingController(text: '');
  final passwordController= TextEditingController(text: '');
    

  LoginScreen({super.key});
  

  @override
  Widget build(BuildContext context) {  
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.40,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Image.asset(
                      'assets/images/storeops_fold.png',
                      width: 100,
                      fit: BoxFit.contain,
                    ),
                    Image.asset(
                      'assets/images/storeops_logo1.png',
                      width: 230,
                      fit: BoxFit.contain,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.40,
                child: Container(
                  // color: Colors.amberAccent,
                  constraints: BoxConstraints.expand(),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 50),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('User ID'),
                        CustomFieldBox(
                          hintText: 'User ID', 
                          selectedIcon: Icon(Icons.account_circle_outlined),
                          obscureText: false,
                          fieldController: userController
                        
                        ),
                        SizedBox(height: 10),
                        Text('Password '),
                        CustomFieldBox(
                          hintText: 'Password', 
                          selectedIcon: Icon(Icons.lock_outline),
                          obscureText: true,
                          fieldController: passwordController
                        ),

                        
                        SizedBox(height: 20,),

                        Center(
                          child: 
                          CustomButtonSubmit(
                            onSubmit: () async {
                              if(userController.value.text != "" && passwordController.value.text != ""){
                                final repo = context.read<AuthRepository>();
                                final loginResponse = await repo.login(userController.value.text, passwordController.value.text);

                                
                                
                                if(loginResponse.message=="" && loginResponse.accessToken!=""){
                                  if(!loginResponse.mobileAccess){
                                    
                                    await SharedPreferencesService.saveSharedPreference(SharedPreferencesService.userAuthenticated,userController.value.text);
                                    await SharedPreferencesService.saveSharedPreference(SharedPreferencesService.tokenKey, loginResponse.accessToken);
                                    
                                    Fluttertoast.showToast(msg: 'Access success');

                                    appRouter.go('/settings');
                                  }
                                  else{
                                    snackbarMessage(context, "Your user is not authorized", AppTheme.secondaryColor, 30);
                                  }
                                }
                                else{
                                  snackbarMessage(context, "Your user or password are wrong", AppTheme.secondaryColor, 30);
                                }
                                
                              }
                              else if(userController.value.text == ""){
                                snackbarMessage(context, "You must enter your username", AppTheme.secondaryColor, 30);
                              }
                              else if(passwordController.value.text == ""){
                                snackbarMessage(context, "You must enter your password", AppTheme.secondaryColor, 30);
                              }              
                            },
                          ),
                        ),
                   
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.10,
                child: Image.asset(
                  'assets/images/checkpoint_logo.png',
                  width: 150,
                  fit: BoxFit.contain,
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.10,
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                  child: Text(
                    'Copyright © 2025 Checkpoint Systems, Inc. All right are reserved. StoreOps is a trademark of Checkpoint Systems, Inc.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 11),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );

  }
}


