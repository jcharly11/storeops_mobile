import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:storeops_mobile/config/router/router.dart';
import 'package:storeops_mobile/config/theme/app_theme.dart';
import 'package:storeops_mobile/domain/repositories/auth_repository.dart';
import 'package:storeops_mobile/l10n/app_localizations.dart';
import 'package:storeops_mobile/presentation/global_widgets/custom_field_box.dart';
import 'package:storeops_mobile/presentation/global_widgets/custom_snackbar_message.dart';
import 'package:storeops_mobile/presentation/screens/login/widgets/custom_button_submit.dart';
import 'package:storeops_mobile/presentation/screens/settings/widgets/tech_checkbox.dart';
import 'package:storeops_mobile/services/shared_preferences_service.dart';

class LoginScreen extends StatefulWidget {
  static const name='login_screen';
  

  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final userController= TextEditingController(text: '');
  final passwordController= TextEditingController(text: '');
  bool isCheckedRemeber= false;
  List<Map<String,dynamic>> valuesToSave=[];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadRememberData();
    }); 
  }

  Future<void> loadRememberData() async {
    final checkRemember= await SharedPreferencesService.getSharedPreferenceBool(SharedPreferencesService.rememberCredentials);
    final userRemember= await SharedPreferencesService.getSharedPreference(SharedPreferencesService.userRemembered) ?? "";
    final passRemember= await SharedPreferencesService.getSharedPreference(SharedPreferencesService.passRemembered) ?? "";
    
    setState(() {
      
      if(checkRemember != null) {
        isCheckedRemeber= checkRemember;
        userController.text= userRemember;
        passwordController.text= passRemember;
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final messageAccessSuccess= AppLocalizations.of(context)?.access_success;
    final messageUnauthorized= AppLocalizations.of(context)?.unauthorized;
    final messageUserRequired= AppLocalizations.of(context)?.no_user;
    final messageUserPass= AppLocalizations.of(context)?.no_password;
    final messageUserWrong= AppLocalizations.of(context)?.incorrect;
    final messageButton= AppLocalizations.of(context)?.send;

    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.35,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // Image.asset(
                    //   'assets/images/storeops_fold.png',
                    //   width: 100,
                    //   fit: BoxFit.contain,
                    // ),
                    Padding(
                      padding: EdgeInsetsGeometry.fromLTRB(0,0,0,20),
                      child: Image.asset(
                        'assets/images/ckp_store_operations.png',
                        width: MediaQuery.of(context).size.width * 0.8,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.50,
                child: Container(
                  constraints: BoxConstraints.expand(),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 60),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(AppLocalizations.of(context)!.user),
                        CustomFieldBox(
                          hintText: AppLocalizations.of(context)!.user, 
                          selectedIcon: Icon(Icons.account_circle_outlined),
                          obscureText: false,
                          fieldController: userController
                        
                        ),
                        SizedBox(height: 10),
                        Text(AppLocalizations.of(context)!.password),
                        CustomFieldBox(
                          hintText: AppLocalizations.of(context)!.password, 
                          selectedIcon: Icon(Icons.lock_outline),
                          obscureText: true,
                          fieldController: passwordController
                        ),

                        
                        SizedBox(height: 10,),

                        Container(
                          alignment: Alignment.center,
                          child: TechCheckbox(label: AppLocalizations.of(context)!.remember,
                            value: isCheckedRemeber,onChanged: (bool? value) {
                              setState(() {
                                isCheckedRemeber = value!;
                              });
                            },
                          ),
                        ),

                        SizedBox(height: 30,),
                        
                        Center(
                          child: 
                          CustomButtonSubmit(
                            onSubmit: () async {
                              if(userController.value.text != "" && passwordController.value.text != ""){
                                final repo = context.read<AuthRepository>();
                                final loginResponse = await repo.login(userController.value.text, passwordController.value.text);

                                if(loginResponse.message=="" && loginResponse.accessToken!=""){
                                  if(loginResponse.mobileAccess){
                                    
                                    String passRemembered= "";
                                    String userRemembered= "";

                                    if(isCheckedRemeber){
                                      userRemembered= userController.value.text;
                                      passRemembered= passwordController.value.text;
                                    }

                                    valuesToSave.add({SharedPreferencesService.userAuthenticated :userController.value.text});
                                    valuesToSave.add({SharedPreferencesService.tokenKey :loginResponse.accessToken});
                                    valuesToSave.add({SharedPreferencesService.rememberCredentials :isCheckedRemeber});
                                    valuesToSave.add({SharedPreferencesService.passRemembered :passRemembered});
                                    valuesToSave.add({SharedPreferencesService.userRemembered :userRemembered});
                                    valuesToSave.add({SharedPreferencesService.soldSelected :false});
                                    valuesToSave.add({SharedPreferencesService.rfidSelected :true});
                                    valuesToSave.add({SharedPreferencesService.rfSelected :true});
                                    valuesToSave.add({SharedPreferencesService.inputSelected :false});
                                    valuesToSave.add({SharedPreferencesService.pushSelected :true});
                                    
                                    await SharedPreferencesService.saveMultipleSharedPreference(valuesToSave);
                                    
                                    Fluttertoast.showToast(msg: messageAccessSuccess!);

                                    appRouter.go('/settings');
                                  }
                                  else{
                                    if (!mounted) return;
                                    scaffoldMessenger.showSnackBar(
                                      CustomSnackbarMessage(
                                        message: messageUnauthorized!, 
                                        color: AppTheme.secondaryColor, 
                                        paddingVertical: 30) as SnackBar
                                    );
                                  }
                                }
                                else{
                                  if (!mounted) return;
                                  scaffoldMessenger.showSnackBar(
                                    CustomSnackbarMessage(
                                      message: messageUserWrong!, 
                                      color: AppTheme.secondaryColor, 
                                      paddingVertical: 30) as SnackBar
                                  );
                                }
                                
                              }
                              else if(userController.value.text == ""){
                                scaffoldMessenger.showSnackBar(
                                  CustomSnackbarMessage(
                                    message: messageUserRequired!, 
                                    color: AppTheme.secondaryColor, 
                                    paddingVertical: 30)
                                );
                              }
                              else if(passwordController.value.text == ""){
                                scaffoldMessenger.showSnackBar(
                                  CustomSnackbarMessage(
                                    message: messageUserPass!, 
                                    color: AppTheme.secondaryColor, 
                                    paddingVertical: 30)
                                );
                              }              
                            },
                            buttonText: messageButton!,
                          ),
                        ),
                   
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.05,
                // child: Image.asset(
                //   'assets/images/checkpoint_logo.png',
                //   width: 150,
                //   fit: BoxFit.contain,
                // ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.10,
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                  child: Text(AppLocalizations.of(context)!.copyright,
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