import 'package:flutter/material.dart';
import 'package:storeops_mobile/config/theme/app_theme.dart';
import 'package:storeops_mobile/presentation/global_widgets/custom_appbar.dart';
import 'package:storeops_mobile/presentation/global_widgets/custom_bottom_appbar.dart';

class ReportsScreen extends StatelessWidget {
  static const name='reports_screen';
  
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final tabs= [
      Tab(icon: Icon(Icons.qr_code_scanner_sharp, size: 20,), text: 'RFID'),
      Tab(icon: Icon(Icons.rss_feed, size: 20,), text: 'RF'),
      Tab(icon: Icon(Icons.directions_walk_outlined, size: 20,), text: 'People Count'),
    ];

    final tabPages= [
      Center(
        child: Column(
          children: [
            Expanded(
              flex: 2,
              child: Padding(
                padding: EdgeInsetsGeometry.symmetric(vertical: 5, horizontal: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text('Daily Report', 
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 17,
                        color: AppTheme.primaryColor
                      ),
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          flex: 5,
                          child: Column(
                            children:[ 
                              Text('Site', 
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 18
                                ),
                              ),
                              Text('1- Showroom', 
                                textAlign: TextAlign.center
                              ),
                            ]
                          )
                        ),
                        Expanded(
                          flex: 5,
                          child: Column(
                            children:[ 
                              Text('Group', 
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 18
                                ),
                              ),
                              Text('All', textAlign: TextAlign.center),
                            ]
                          )
                        )
                      ],
                    )
                  ],
                ),
              )
            ),
            Expanded(
              flex: 2,
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 100,
                      width: 100,
                      child: Card(
                        elevation: 5,
                        shadowColor: AppTheme.primaryColor,
                        child: 
                          Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children:[ 
                                Text('Total Alarms', 
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500 
                                  )
                                ),
                                Text('400', 
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w700,
                                  )
                                ),
                              ]
                            ),
                          ),
                      ),
                    ),

                    SizedBox(
                      height: 100,
                      width: 100,
                      child: Card(
                        elevation: 5,
                        shadowColor: AppTheme.primaryColor,
                        child: 
                          Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children:[ 
                                Text('Total Audible Alarms',
                                  textAlign: TextAlign.center , 
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    overflow: TextOverflow.clip
                                  )
                                ),
                                Text('160', 
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w700,
                                  )
                                ),
                              ]
                            ),
                          ),
                      ),
                    ),
                    
                    SizedBox(
                      height: 100,
                      width: 100,
                      child: Card(
                        elevation: 5,
                        shadowColor: AppTheme.primaryColor,
                        child: 
                          Center(
                            child: 
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children:[ 
                                Text('AVG Daily Audible Alarms',
                                  textAlign: TextAlign.center , 
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    overflow: TextOverflow.clip
                                  )
                                ),
                                Text('85', 
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w700,
                                  )
                                ),
                              ]
                            ),
                          ),
                      ),
                    ),
                  ],
                ),
              )
            ),
            Expanded(
              flex: 6,
              child: Padding(
                padding: EdgeInsetsGeometry.symmetric(vertical: 10, horizontal: 15),
                child: Card(
                  elevation: 5,
                  shadowColor: AppTheme.primaryColor,
                  child: Expanded(
                    child: SizedBox(
                      width: double.infinity,
                      child: Center(
                        child: 

                        GridView.builder(
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3, 
                            mainAxisSpacing: 3, 
                            crossAxisSpacing: 3,
                          ),
                          padding: EdgeInsets.all(8.0), 
                          itemCount: 9, 
                          itemBuilder: (context, index) {
                            return Card(
                              elevation: 1,
                              shadowColor: AppTheme.primaryColor,
                              child: 
                                Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children:[ 
                                      Text('Total Alarms',
                                        textAlign: TextAlign.center , 
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                          overflow: TextOverflow.clip
                                        )
                                      ),
                                      Text('160', 
                                        style: TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.w700,
                                        )
                                      ),
                                    ]
                                  ),
                                ),
                            );
                          },
                        )

                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        )
      ),
      Center(
        child: Icon(Icons.add),
      ),
      Center(
        child: Icon(Icons.disc_full_sharp),
      )


    ];

    return 
      DefaultTabController(
        length: tabs.length,      
        child: Scaffold(
        appBar: CustomAppbar(includeBottomBar: true, tabs: tabs),
        bottomNavigationBar: CustomBottomAppbar(),
        body: TabBarView(
          children: 

           tabPages
          
        )
        )
      );
    
  }
}