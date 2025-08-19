import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:storeops_mobile/config/menu/menu_items.dart';
import 'package:storeops_mobile/config/theme/app_theme.dart';
import 'package:storeops_mobile/services/shared_preferences_service.dart';

class SideMenu extends StatefulWidget {

  final GlobalKey<ScaffoldState> scaffoldKey;
  final VoidCallback onReturnFromSettings;

  const SideMenu({super.key, required this.scaffoldKey, required this.onReturnFromSettings});

  @override
  State<SideMenu> createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {

  int navDrawerIndex=0;
  String? userAuth;
  String? selectedClient;
  bool isCheckingData = false;

  @override
  void initState() {
    super.initState();
    setState(() {
      isCheckingData=true;
    });
    _getUserAuth();
  }

  Future<void> _getUserAuth() async {
    final user= await SharedPreferencesService.getSharedPreference(SharedPreferencesService.userAuthenticated);
    final client= await SharedPreferencesService.getSharedPreference(SharedPreferencesService.customerSelected);
    setState(() {
      userAuth= user;
      selectedClient= client;
      isCheckingData= false;
    });
  }
  

  @override
  Widget build(BuildContext context) {
    // validate if notch exists
    final hasNotch= MediaQuery.of(context).viewPadding.top > 26;
    
    return Drawer(
    child:Column(
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(20, hasNotch ? 50 : 10, 10, 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Image.asset('assets/images/storeops_logo2.png', height: 35, fit: BoxFit.contain),
              ),
              SizedBox(height: 40),
              Row(
                children: [
                  CircleAvatar(
                    radius: 35,
                    backgroundColor: AppTheme.primaryColor,
                    child: Image.asset('assets/images/checkpoint_logo_bco.png', height: 30, fit: BoxFit.contain),
                  ),
                  SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      isCheckingData ? CircularProgressIndicator():
                      userAuth==null ? CircularProgressIndicator() 
                      : Text(userAuth!, style: TextStyle(fontWeight: FontWeight.w700)),

                      isCheckingData ? CircularProgressIndicator():
                      selectedClient == null ? Text('Waiting Info Client', style: TextStyle(fontWeight: FontWeight.w400, color: Colors.red)):
                      Text(selectedClient!, style: TextStyle(fontWeight: FontWeight.w400)),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 5),
              Divider(),
              SizedBox(height: 10),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 5),
                child: Row(
                  children: [
                    Icon(Icons.arrow_circle_right_outlined),
                    SizedBox(width: 10),
                    Text('Principal Menu', style: TextStyle(fontWeight: FontWeight.w400, fontSize: 13)),
                  ],
                ),
              ),
            ],
          ),
        ),

        Expanded(
          child: NavigationDrawer(

            selectedIndex: null,
            onDestinationSelected: (value) {
              setState(() { 
                navDrawerIndex = value;
              }
              );

              final menuItem= appMenuItems[value];
              // context.push(menuItem.link);
              
              context.push(menuItem.link).then((_) {
                widget.onReturnFromSettings();
              });

              widget.scaffoldKey.currentState?.closeDrawer();
              
            },
            children: appMenuItems.map((item) {
              return NavigationDrawerDestination(
                enabled: selectedClient == null ? item.title == "Settings" ? true : false : true,
                icon: Icon(item.icon, size: 28),
                label: Text(item.title, style: TextStyle(fontWeight: FontWeight.w300, fontSize: 18)),
              );
            }).toList(),
          ),
        ),

        Padding(
          padding: EdgeInsets.symmetric(vertical: 30, horizontal: 30),
          child: Image.asset('assets/images/checkpoint_logo.png', height: 25, fit: BoxFit.contain),
        ),
      ],
    ),
    
    );


  }
}














//     return NavigationDrawer(
//       selectedIndex: navDrawerIndex,
//       onDestinationSelected: (value) {
//         setState(() {
//           navDrawerIndex= value;
//         });
//       },
//       children: [
//         Padding(
//             // padding: EdgeInsets.fromLTRB(28, hasNotch ? 10 : 20, 16, 10),
//           padding: EdgeInsetsGeometry.fromLTRB(20, 20, 10, 10),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Center(
//                 child: Image.asset(
//                   'assets/images/storeops_logo2.png',
//                   height: 35,
//                   fit: BoxFit.contain,
//                 ),
//               ),
              
//               SizedBox(height: 40),


//               Row(
//                 spacing: 10,
//                 children: [
//                   CircleAvatar(
//                     radius: 35,
//                     backgroundColor: AppTheme.primaryColor,
//                     child: Image.asset(
//                   'assets/images/checkpoint_logo_bco.png',
//                   height: 30,
//                   fit: BoxFit.contain,
//                 ),
                    
//                   ),
                
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children:[ 
//                     Text("MULTI_USERID05749",
//                       style: TextStyle(fontWeight: FontWeight.w700, ),
//                     ),
//                     Text("Checkpoint Mexico",
//                       style: TextStyle(fontWeight: FontWeight.w400, ),
//                     ),
//                   ]
//                 )
//                ],
//                ),
//                SizedBox(height: 5,),
//                Divider(),              
//             ],
//           ),
//         ),
        
//         Padding(
//           padding: EdgeInsetsGeometry.symmetric(horizontal: 25, vertical: 1),
//           child: Column(
//             children:[ 
//               Row(
//                 spacing: 10,
//                 children: [
//                   Icon(Icons.arrow_circle_right_outlined),
                  
//                   Text('Principal Menu', 
//                     style: TextStyle(
//                       fontWeight: FontWeight.w400,
//                       fontSize: 13
//                     ),
//                   ),
//                 ],
//               ),
//               SizedBox(height: 30,)
//             ]
//           ),
//         ),

//         ... appMenuItems.map((item) => NavigationDrawerDestination(
            
//             icon: Icon(item.icon, size: 35,), 
           
//             label: Text(
//               item.title, 
//               style: TextStyle(
//                 fontWeight: FontWeight.w300,
//                 fontSize: 20
//               ))
//           ),
          
//         ),
        
//       ],
//     );
//   }
// }