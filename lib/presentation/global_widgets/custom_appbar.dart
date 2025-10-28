import 'package:flutter/material.dart';
import 'package:storeops_mobile/config/router/router.dart';
import 'package:storeops_mobile/config/theme/app_theme.dart';
import 'package:storeops_mobile/l10n/app_localizations.dart';
import 'package:storeops_mobile/services/firebase_service.dart';
import 'package:storeops_mobile/services/shared_preferences_service.dart';

class CustomAppbar extends StatelessWidget implements PreferredSizeWidget{
  final bool includeBottomBar;
  final List<Tab>? tabs;
  final String tokenMob;
  final bool rememberCredentials;
  final String userRemembered;
  final String passRemembered;
  

  const CustomAppbar({super.key, required this.includeBottomBar, this.tabs, required this.tokenMob, required this.rememberCredentials, required this.userRemembered, required this.passRemembered});
  


  @override
  Widget build(BuildContext context) {
    List<Map<String,dynamic>> valuesToSave=[];

    return AppBar(
        backgroundColor: Colors.white,
        title: Image.asset(
          'assets/images/store_operations.png',
          height: 23,
          fit: BoxFit.contain,
        ),
        centerTitle: true,
        actions: [
          IconButton( onPressed: () async {
            showDialog(
              barrierDismissible: false,
              context: context, 
              builder: (BuildContext context) => AlertDialog(
                
                actionsAlignment: MainAxisAlignment.center,
                icon: Icon(Icons.logout_outlined),
                title: Text(AppLocalizations.of(context)!.log_out,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w500
                  )
                ),
                content: Text(AppLocalizations.of(context)!.log_out_question, 
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15
                  ),
                ),
                actions: [
                  ElevatedButton.icon(
                    label: Text(AppLocalizations.of(context)!.confirm, style: TextStyle(color: Colors.white),),
                    icon: Icon(Icons.check_circle_outline_outlined),
                    onPressed: ()async {
                      
                      await SharedPreferencesService.clearAllSharedPreference();
                      
                      valuesToSave.add({SharedPreferencesService.tokenMobile :tokenMob});
                      valuesToSave.add({SharedPreferencesService.rememberCredentials :rememberCredentials});
                      valuesToSave.add({SharedPreferencesService.userRemembered :userRemembered});
                      valuesToSave.add({SharedPreferencesService.passRemembered :passRemembered});

                      var docId= await FirebaseService.tokenMobileExists(tokenMob);
                      await FirebaseService.updateNotificationsLogout(docId.toString());

                      await SharedPreferencesService.saveMultipleSharedPreference(valuesToSave);

                      appRouter.go('/login');
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                      backgroundColor: AppTheme.primaryColor,
                      iconColor: Colors.white
                    )
                  ),

                  ElevatedButton.icon(
                    label: Text(AppLocalizations.of(context)!.cancel, style: TextStyle(color: Colors.white),),
                    icon: Icon(Icons.cancel_outlined),
                    onPressed: (){
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                      backgroundColor: AppTheme.secondaryColor,
                      iconColor: Colors.white
                    )
                  )
                ],

              )
            );
          }, icon: Icon(Icons.logout_outlined))
        ],
      );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}