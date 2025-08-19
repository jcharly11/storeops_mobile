import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:storeops_mobile/config/router/router.dart';
import 'package:storeops_mobile/presentation/global_widgets/custom_bottom_appbar.dart';
import 'package:storeops_mobile/presentation/global_widgets/custom_fab_button.dart';
import 'package:storeops_mobile/presentation/screens/home/widgets/side_menu.dart';
import 'package:storeops_mobile/services/shared_preferences_service.dart';

class HomeScreen extends StatefulWidget {

  static const name= 'home_screen';
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? clientSelected;
  String? storeSelected;
  bool isCheckingClient = false;
  bool isCheckingStore = false;

  @override
  void initState() {
    super.initState();
    
    setState(() {
      isCheckingClient=true;
      isCheckingStore=true;  
    });
    _getInfoClient();
    
  }

  Future<void> _getInfoClient() async {
    
    final client= await SharedPreferencesService.getSharedPreference(SharedPreferencesService.customerSelected);
    final store= await SharedPreferencesService.getSharedPreference(SharedPreferencesService.storeSelected);
    setState(() {
      clientSelected= client;
      storeSelected= store;
      isCheckingClient= false;
      isCheckingStore= false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final scaffoldKey= GlobalKey<ScaffoldState>();

    void navigateConfig(){
      context.push('/settings').then((_) {
        _getInfoClient(); 
      });
    }


    return Scaffold(
      key: scaffoldKey,
      bottomNavigationBar: CustomBottomAppbar(),
      appBar: AppBar(
        
        title: Image.asset(
          'assets/images/storeops_logo2.png',
          height: 35,
          fit: BoxFit.contain,
        ),
        centerTitle: true,
        actions: [
          IconButton( onPressed: () async {
            showDialog(
              context: context, 
              builder: (BuildContext context) => AlertDialog(
                title: Text('¿Do you want to log out?'),
                content: Text('¿Do you want to log out?'),
                actions: [
                  TextButton(onPressed: (){}, child: Text('data'))
                ],

              )
            );
            await SharedPreferencesService.clearAllSharedPreference();
            appRouter.go('/login');
          }, icon: Icon(Icons.logout_outlined))
        ],
      ),
      floatingActionButton: CustomFabButton(onPressed: navigateConfig, icon: Icons.settings_outlined),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      drawer: SideMenu(scaffoldKey: scaffoldKey, onReturnFromSettings: _getInfoClient),
      body: Center(
        child: Column(
          children: [
            Expanded(
              flex: 5, 
              child: Padding(
                padding: EdgeInsetsGeometry.fromLTRB(10, 40, 10, 0),
                child: Center(child: 
                    Column(
                      children: [
                          isCheckingClient ? Text('loading') 
                          : clientSelected == null ? Text('Waiting client selection', style: TextStyle(
                            color: Colors.red,
                            fontSize: 20,
                            fontWeight: FontWeight.w600
                          ),) :
                          Text(clientSelected!, style: 
                            TextStyle(
                              fontWeight: FontWeight.w700, fontSize: 25
                            )
                          ),
                          
                        isCheckingStore ? Text('loading')
                        : storeSelected == null ? Text('  '): 
                        Text(storeSelected!, style: 
                          TextStyle(
                            fontWeight: FontWeight.w400, fontSize: 18
                          )
                        ),
                      ]
                    )
                ),
              ),
            ),
            Expanded(
              flex: 5,
              child: Column(
                children:[ 
                  Image.asset(
                    'assets/images/checkpoint_logo1.png',
                    width: 80,
                    fit: BoxFit.contain,
                  ),
                ]
              ),
              
            ),
           
          ],
        ),
      )
      // body: Center(
      //   child: 
      //   Column(
      //     children: [
      //       Image.asset(
      //         'assets/images/checkpoint_logo1.png',
      //         width: 100,
      //         fit: BoxFit.contain,
      //       ),
      //     ]
      //   ),
      // ),
    );
  }
}