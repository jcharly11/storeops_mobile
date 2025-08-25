import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:storeops_mobile/config/theme/app_theme.dart';
import 'package:storeops_mobile/data/models/events_firebase_model.dart';
import 'package:storeops_mobile/presentation/global_widgets/custom_bottom_appbar.dart';
import 'package:storeops_mobile/presentation/global_widgets/custom_loader_screen.dart';
import 'package:storeops_mobile/presentation/screens/events/widgets/custom_event_item.dart';
import 'package:storeops_mobile/presentation/screens/events/widgets/custom_expand_event.dart';
import 'package:storeops_mobile/services/firebase_service.dart';
import 'package:storeops_mobile/services/shared_preferences_service.dart';

class EventsScreen extends StatefulWidget {
  static const name='events_screen';

  const EventsScreen({super.key});

  @override
  State<EventsScreen> createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
  bool isLoadingEvents=false;
  String? accountId;
  String? storeId;
  String? storeName;
  List<EventsFirebaseModel>? eventsList;
  final dbFirebase= FirebaseService.instance;
  final Set<String> knownIds = {};
  final Set<String> flashIds = {};
  bool isFirstLoad = true;

  void _markNewDocs(List<QueryDocumentSnapshot> docs) {
    if (isFirstLoad) {
      for (final doc in docs) {
        knownIds.add(doc.id);
      }
      isFirstLoad = false;
      return;
    }

    for (final doc in docs) {
      final id = doc.id;
      if (!knownIds.contains(id)) {
        knownIds.add(id);
        flashIds.add(id);

        Future.delayed(const Duration(seconds: 2), () {
          if (!mounted) return;
          if (flashIds.remove(id)) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) setState(() {});
            });
          }
        });
      }
    }
  }

  
  @override
  void initState() {
    super.initState();
    _getCustomerInfo();
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   _getCustomerInfo();
    // });
  }

  Future<void> _getCustomerInfo() async {
    setState(() => isLoadingEvents = true);
    final accountCode= await SharedPreferencesService.getSharedPreference(SharedPreferencesService.customerCodeSelected);
    final store= await SharedPreferencesService.getSharedPreference(SharedPreferencesService.storeIdSelected);
    final storeN= await SharedPreferencesService.getSharedPreference(SharedPreferencesService.storeSelected);
    setState(() {
      accountId= accountCode;
      storeId= store;
      storeName= storeN;

      // _loadEvents('today', null, null);
      isLoadingEvents = false;

    });
  }

  Future<List<EventsFirebaseModel>> _loadEvents(String filter, DateTime? startDate, DateTime? endDate) async {
    setState(() => isLoadingEvents = true);
    QuerySnapshot<Map<String, dynamic>>? snapshot;
    
    
    if(filter == 'today'){
      DateTime now = DateTime.now();
      DateTime startOfDay = DateTime(now.year, now.month, now.day);
      DateTime endOfDay = startOfDay.add(const Duration(days: 1));

      snapshot = await FirebaseFirestore.instance
      .collection('events')
      .doc(accountId)
      .collection(storeId!)
      .where('timestamp', isGreaterThanOrEqualTo: startOfDay)
      .where('timestamp', isLessThan: endOfDay)
      // .limit(500)
      .get();
    }
    

    else if(filter == 'dates'){
      DateTime endOfDay = endDate!.add(const Duration(days: 1));
      snapshot = await FirebaseFirestore.instance
      .collection('events')
      .doc(accountId)
      .collection(storeId!)
      .where('timestamp', isGreaterThanOrEqualTo: startDate)
      .where('timestamp', isLessThan: endOfDay)
      .limit(500)
      .get();
    }

    final items = snapshot!.docs
    .map((doc) => EventsFirebaseModel.fromMap(doc.data()))
    .toList();
    
    final eventsFiltered = items
      .where((e) => e.eventId == "rfid_alarm")
    .toList()..sort((a, b) => b.timestamp.compareTo(a.timestamp));

    
    setState(() {
      eventsList= eventsFiltered;
      isLoadingEvents = false;
    });

    return items;
  }




  @override
  Widget build(BuildContext context){
    
    DateTime startOfDay = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    DateTime endOfDay = startOfDay.add(const Duration(days: 1));

    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: CustomBottomAppbar(),      
      // floatingActionButton: CustomFabButton(icon: Icons.filter_list, onPressed: () => 
      //   showModalBottomSheet(
      //     context: context,
      //     isScrollControlled: true, 
      //     useSafeArea: true,
      //     builder: (BuildContext context) {
      //       return Container(
      //         alignment: Alignment.topLeft,
      //         height: 250,
      //         padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 30),
      //         child: Column(
      //           crossAxisAlignment: CrossAxisAlignment.start,
      //           children: [
      //             const Text(
      //               'Filter Events',
      //               style: TextStyle(
      //                 fontSize: 16,
      //                 fontWeight: FontWeight.w500,
      //               ),
      //             ),
      //             const Divider(),
      //             Row(
      //               mainAxisAlignment: MainAxisAlignment.center,
      //               children: [
      //                 ElevatedButton.icon(
      //                   style: ElevatedButton.styleFrom(
      //                     padding: const EdgeInsets.symmetric(
      //                         vertical: 10, horizontal: 15),
      //                     backgroundColor: AppTheme.secondaryColor,
      //                     iconColor: Colors.white,
      //                   ),
      //                   onPressed: () {
      //                     Navigator.pop(context);
      //                     _loadEvents('today', null, null);
      //                   },
      //                   icon: const Icon(Icons.today_outlined, size: 22),
      //                   label: const Text(
      //                     'Today',
      //                     style: TextStyle(
      //                       color: Colors.white,
      //                       fontWeight: FontWeight.w400,
      //                     ),
      //                   ),
      //                 ),
      //               ],
      //             ),
      //             Padding(
      //               padding: const EdgeInsets.symmetric(vertical: 15),
      //               child: Center(
      //                 child: ElevatedButton.icon(
      //                   style: ElevatedButton.styleFrom(
      //                     padding: const EdgeInsets.symmetric(
      //                         vertical: 10, horizontal: 15),
      //                     backgroundColor: AppTheme.secondaryColor,
      //                     iconColor: Colors.white,
      //                   ),
      //                   onPressed: () {
      //                     Navigator.pop(context);
      //                     showDateRangePicker(
      //                       context: context,
      //                       firstDate: DateTime(DateTime.now().year - 1),
      //                       lastDate: DateTime(DateTime.now().year + 1),
      //                     ).then((DateTimeRange? value) {
      //                       if (value != null) {
      //                         final startDate = value.start;
      //                         final endDate = value.end;
      //                         _loadEvents('dates', startDate, endDate);
      //                       }
      //                     });
      //                   },
      //                   icon: const Icon(Icons.calendar_month_outlined, size: 22),
      //                   label: const Text(
      //                     'Date Range',
      //                     style: TextStyle(
      //                       color: Colors.white,
      //                       fontWeight: FontWeight.w400,
      //                     ),
      //                   ),
      //                 ),
      //               ),
      //             ),
      //           ],
      //         ),
      //       );
      //     },
      //   )
      // ),
      
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Image.asset(
          'assets/images/storeops_logo2.png',
          height: 35,
          fit: BoxFit.contain,
        ),
        centerTitle: true,
      ),
      body:
      isLoadingEvents ? Center(
        child: CustomLoaderScreen(message: 'Loading Events from $storeName'),
      ):
      StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
        .collection('events')
        .doc(accountId)
        .collection(storeId!)
        .where('timestamp', isGreaterThanOrEqualTo: startOfDay)
        .where('timestamp', isLessThan: endOfDay)
        .limit(500)
        .snapshots(),
                        
        builder: (context, snapshot) {                  
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CustomLoaderScreen(
                message: 'Loading Events from $storeName'
              )
            );
          }
          final docs = snapshot.data!.docs
          .where((e) => e["eventId"] == "rfid_alarm")
          .toList()..sort((a, b) => b["timestamp"].compareTo(a["timestamp"]));

          _markNewDocs(docs);

          return Column(
        children:[ 
          Expanded(
            flex: 1,
              child: Padding(
                padding: EdgeInsetsGeometry.symmetric(vertical: 0, horizontal: 5),
                child: Center(
                  child: Column(
                    children: [
                      Expanded(
                        flex: 5,
                        child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            flex: 3,
                            child: Row(
                              spacing: 2,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children:[
                                Icon(
                                  Icons.my_library_books_outlined,
                                  size: 25, 
                                  color: AppTheme.buttonsColor
                                ),
                                Text(
                                  'Total',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 16,color: AppTheme.primaryColor, 
                                    fontWeight: FontWeight.w400
                                  )
                                )
                              ]
                            )
                          ),
                          Expanded(
                            flex: 4,
                            child: Row(
                              spacing: 2,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children:[
                                Icon(
                                  Icons.store_mall_directory_outlined,
                                  size: 25, 
                                  color: AppTheme.buttonsColor
                                ),
                                Text(
                                  'Site',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                  fontSize: 16,color: AppTheme.primaryColor, 
                                  fontWeight: FontWeight.w400)
                                )
                              ]
                            )
                          ),
                          Expanded(
                            flex: 3,
                            child: Row(
                              spacing: 2,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children:[
                                Icon(
                                  Icons.settings_backup_restore_rounded,
                                  size: 25, 
                                  color: AppTheme.buttonsColor
                                ),
                                Text(
                                  'Group',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 16,color: AppTheme.primaryColor, 
                                    fontWeight: FontWeight.w400)
                                ),
                              ]
                            )
                          )
                        ],
                      )
                    ),
                    Expanded(
                      flex: 5,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            flex: 3,
                            child: 
                            Text(docs.length.toString(), style: TextStyle(fontSize: 16,color: AppTheme.buttonsColor, fontWeight: FontWeight.w700),textAlign: TextAlign.center)
                          ),
                          Expanded(
                            flex: 4,
                            child: storeName == null ? Text('') :
                            Text('$storeId-$storeName',style: TextStyle(fontSize: 14,color: AppTheme.buttonsColor, fontWeight: FontWeight.w400, overflow: TextOverflow.ellipsis),textAlign: TextAlign.center,)
                          ),
                          Expanded(
                            flex: 3,
                            child: Text('All',style: TextStyle(fontSize: 16,color: AppTheme.buttonsColor, fontWeight: FontWeight.w700),textAlign: TextAlign.center,)
                          )
                        ],
                      ),
                    ),
                  ]
                )
              )
            ),
          ),
             
          SizedBox(
            height: 1, 
            child: Padding(
              padding: EdgeInsetsGeometry.symmetric(vertical: 0, horizontal: 30),
              child: Container(
                color: AppTheme.buttonsColor
              ),
            )
          ),    


          //////////////////////list events
          Expanded(
            flex: 9,
            child: Padding(
              padding: EdgeInsetsGeometry.symmetric(vertical: 35, horizontal: 10),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10)
                ),
                child: Padding(
                  padding: EdgeInsetsGeometry.symmetric(vertical: 0,horizontal: 0),
                  child: 
                  // isLoadingEvents? CircularProgressIndicator():
                  // eventsList== null? CircularProgressIndicator():
                  
                  ListView.builder(
                            itemCount: docs.length,
                            itemBuilder: (context, index) {
                            final doc = docs[index];
                            final data = doc.data() as Map<String, dynamic>;
                            final event = EventsFirebaseModel.fromMap(data);
                            final epcsData= event.enrich;

                             final id = doc.id;

                            final shouldFlash = flashIds.contains(id);


                             
                            return TweenAnimationBuilder<Color?>(
                               key: ValueKey('$id-$shouldFlash'),
                              tween: ColorTween(
                                begin: shouldFlash  ? AppTheme.primaryColor : Colors.transparent,
                                end: Colors.transparent,
                              ),
                              duration: const Duration(seconds: 2),
                              builder: (context, color, child) {
                                return Container(
                                  color: color,
                                  child: child,
                                );
                              },
                              child: 
                            epcsData.length == 1
                          ? CustomEventItem(
                              timestamp: event.timestamp.toDate().toLocal().toString(),
                              article: epcsData[0].description,
                              epc: epcsData[0].epc,
                              groupId: event.groupId,
                              urlImage: epcsData[0].imageUrl,
                              silent: event.silent,
                              storeSelected: storeId.toString(),
                              storeName: storeName!
                            )
                          : 
                          epcsData.length>1 ?
                          CustomExpandEvent(
                              timestamp: event.timestamp.toDate().toLocal().toString(),
                              groupId: event.groupId,
                              enrich: epcsData,
                              silent: event.silent,
                              storeSelected: storeId.toString(),
                              storeName: storeName!
                          )
                          : Text('data')
                          );
                        },
                      )

                       
                ),
              ),
            ),
          ),
        ]
      );
        }
      )          
    );
  }
}








































































// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:storeops_mobile/config/theme/app_theme.dart';
// import 'package:storeops_mobile/data/models/events_firebase_model.dart';
// import 'package:storeops_mobile/db/db_sqlite_helper.dart';
// import 'package:storeops_mobile/presentation/global_widgets/custom_bottom_appbar.dart';
// import 'package:storeops_mobile/presentation/global_widgets/custom_fab_button.dart';
// import 'package:storeops_mobile/presentation/global_widgets/custom_loader_screen.dart';
// import 'package:storeops_mobile/presentation/screens/events/widgets/custom_event_item.dart';
// import 'package:storeops_mobile/presentation/screens/events/widgets/custom_expand_event.dart';
// import 'package:storeops_mobile/services/shared_preferences_service.dart';

// class EventsScreen extends StatefulWidget {
//   static const name='events_screen';

//   const EventsScreen({super.key});

//   @override
//   State<EventsScreen> createState() => _EventsScreenState();
// }

// class _EventsScreenState extends State<EventsScreen> {
//   bool isLoadingEvents=false;
//   String? accountId;
//   String? storeId;
//   String? storeName;
//   // List<EventsFirebaseModel>? eventsList;
//   List<Map<String, dynamic>>? eventsDb;
  
//   final db = DbSqliteHelper.instance;


//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       _getCustomerInfo();
//     });
//   }

//   Future<void> _getCustomerInfo() async {
//     final accountCode= await SharedPreferencesService.getSharedPreference(SharedPreferencesService.customerCodeSelected);
//     final store= await SharedPreferencesService.getSharedPreference(SharedPreferencesService.storeIdSelected);
//     final storeN= await SharedPreferencesService.getSharedPreference(SharedPreferencesService.storeSelected);
//     setState(() {
//       accountId= accountCode;
//       storeId= store;
//       storeName= storeN;

//       // accountId= '39100';
//       // storeId= '7329';
//       // storeName= 'upim';

      

//       _loadEvents('today', null, null);

//     });
//   }

//   Future<void> _loadEvents(String filter, Timestamp? startDate, Timestamp? endDate) async {
//     setState(() => isLoadingEvents = true);
//     QuerySnapshot<Map<String, dynamic>>? snapshot;
//     final startOfWeek =  DateTime.now().subtract(const Duration(days: 7));
//     DateTime now = DateTime.now();
//     DateTime startOfDay = DateTime(now.year, now.month, now.day);
//     DateTime endOfDay = startOfDay.add(const Duration(days: 1));
    
//     if(filter == 'today'){
//       snapshot = await FirebaseFirestore.instance
//       .collection('events')
//       .doc(accountId)
//       .collection(storeId!)
//       // .where('eventId', isEqualTo: 'rfid_alarm')
//       .where('timestamp', isGreaterThanOrEqualTo: startOfDay)
//       .where('timestamp', isLessThan: endOfDay)
//       // .orderBy('timestamp', descending: true)
//       // .where('uuid', whereIn: ['f509870a-3e88-44e5-bbea-27e72b9eb808','f981ae62-10ed-4bc0-ad12-bb758d7ebf47'])
//       .get();
//     }
//     else if(filter == 'week'){
//       snapshot = await FirebaseFirestore.instance
//       .collection('events')
//       .doc(accountId)
//       .collection(storeId!)
//       .where('eventId', isEqualTo: 'rfid_alarm')
//       .where('timestamp', isGreaterThanOrEqualTo: startOfWeek)
//       .where('timestamp', isLessThanOrEqualTo: DateTime.now())
//       .get();

//     }
//     else if(filter == 'all'){
//       snapshot = await FirebaseFirestore.instance
//       .collection('events')
//       .doc(accountId)
//       .collection(storeId!)
//       .where('eventId', isEqualTo: 'rfid_alarm')
//       .get();
//     }

//     else if(filter == 'dates'){
//       snapshot = await FirebaseFirestore.instance
//       .collection('events')
//       .doc(accountId)
//       .collection(storeId!)
//       .where('eventId', isEqualTo: 'rfid_alarm')
//       .where('timestamp', isGreaterThanOrEqualTo: startDate)
//       .where('timestamp', isLessThanOrEqualTo: endDate)
//       .get();
//     }

//     final items = snapshot!.docs
//     .map((doc) => EventsFirebaseModel.fromMap(doc.id, doc.data()))
//     .toList();
    
//     await db.deleteEvents();
//     await db.deleteEnrich();


//     for(var item in items){
//       await db.saveEvents(
//         {
//           "uuid": item.uuid,
//           "accountNumber": accountId,
//           "storeId": storeId,
//           "eventType": item.eventId,
//           "silent": item.silent ? 1 : 0,
//           "groupId": item.groupId,
//           "timestamp": item.timestamp.toDate().millisecondsSinceEpoch,
//         },
//         item.enrich
//       );
//     }

//     final itemsDb= await db.getEventsToday();
    
//     setState(() {
//       // eventsList= items;
//       eventsDb= itemsDb;
//       isLoadingEvents = false;
//     });
//   }




//   @override
//   Widget build(BuildContext context){
//     return Scaffold(
//       // backgroundColor: Color(0xffededed),
//       backgroundColor: Colors.white,
//       bottomNavigationBar: CustomBottomAppbar(),
      
//       floatingActionButton: CustomFabButton(icon: Icons.filter_list, onPressed: () => 
//         showModalBottomSheet(context: context, builder: (BuildContext context) => Container(
//           alignment: Alignment.topLeft,
//           height: 250,
//           child: 
//             Expanded(
//               child: 
//                 Padding(
//                   padding: EdgeInsetsGeometry.symmetric(vertical: 30, horizontal: 30),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     children: [
//                       Text('Filter Events', 
//                         style: TextStyle(
//                           fontSize: 16,
//                           fontWeight: FontWeight.w500, 
//                         )
//                       ),
//                       Divider(),

//                       Row(
//                         spacing: 15,
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           ElevatedButton.icon(
//                             style: ElevatedButton.styleFrom(
//                               padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
//                               backgroundColor: AppTheme.secondaryColor,iconColor: Colors.white
//                             ),
//                             onPressed: (){
//                               _loadEvents('today', null, null);
//                             },
//                             icon: Icon(Icons.today_outlined, size: 22,),
//                             label: Text('Today',style: TextStyle(color: Colors.white, fontWeight: FontWeight.w400))
//                           ),

//                           ElevatedButton.icon(
//                             style: ElevatedButton.styleFrom(
//                               padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
//                               backgroundColor: AppTheme.secondaryColor,iconColor: Colors.white
//                             ),
//                             onPressed: (){
//                               _loadEvents('week', null, null);
//                             },
//                             icon: Icon(Icons.calendar_view_week_rounded, size: 22,),
//                             label: Text('Week',style: TextStyle(color: Colors.white, fontWeight: FontWeight.w400))
//                           ),
//                           ElevatedButton.icon(
//                             style: ElevatedButton.styleFrom(
//                               padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
//                               backgroundColor: AppTheme.secondaryColor,iconColor: Colors.white
//                             ),
//                             onPressed: (){
//                               _loadEvents('all', null, null);
//                             },
//                             icon: Icon(Icons.calendar_month_outlined, size: 22,),
//                             label: Text('All',style: TextStyle(color: Colors.white, fontWeight: FontWeight.w400))
//                           )
//                         ],
//                       ),

//                       Padding(
//                         padding: EdgeInsetsGeometry.symmetric(vertical: 15, horizontal: 0),
//                         child: Center(
//                           child: ElevatedButton.icon(
                            
//                             style: ElevatedButton.styleFrom(
//                             padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
//                             backgroundColor: AppTheme.secondaryColor,iconColor: Colors.white
//                             ),
//                                 onPressed: (){
//                                   showDateRangePicker(
//                                     context: context, 
//                                     firstDate: DateTime(DateTime.now().year-1), 
//                                     lastDate: DateTime(DateTime.now().year+1),
//                                     fieldStartHintText: 'sdafdsaf',
                          
//                                   ).then((DateTimeRange? value){
//                                     if(value!=null){
//                                       DateTimeRange _fromRange = DateTimeRange(
//                                         start: DateTime.now(), 
//                                         end: DateTime.now()
//                                       );
//                                       _fromRange= value;
                                      
//                                         final Timestamp startDate= Timestamp.fromDate(_fromRange.start);
//                                         final Timestamp endDate= Timestamp.fromDate(_fromRange.end);
                                        
//                                         _loadEvents('dates', startDate, endDate);
//                                     }
//                                   });
//                                 },
//                                 icon: Icon(Icons.calendar_month_outlined, size: 22,),
//                                 label: Text('Date Range',style: TextStyle(color: Colors.white, fontWeight: FontWeight.w400))
//                               ),
//                         ),
//                       )
                      

//                     ]
//                   ),
//                 )
//             ),
//           )
//         )
//       ),
      
//       floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         title: Image.asset(
//           'assets/images/storeops_logo2.png',
//           height: 35,
//           fit: BoxFit.contain,
//         ),
//         centerTitle: true,
//       ),
//       body: isLoadingEvents ? Center(
//         child: CustomLoaderScreen(message: 'Loading Events from $storeName')
//       ): 
//       Column(
//         children:[ 
//           Expanded(
//             flex: 1,
//               child: Padding(
//                 padding: EdgeInsetsGeometry.symmetric(vertical: 0, horizontal: 5),
//                 child: 
//                   // Card(
//                   //   shape: RoundedRectangleBorder(
//                   //   // side: BorderSide(color: AppTheme.buttonsColor, width: 1),
//                   //     borderRadius: BorderRadius.circular(10),
//                   //   ),
//                   //   color: AppTheme.extraColor,
//                   //   elevation: 2,
//                   //   shadowColor: AppTheme.colorGeneral,
//                   //   child:
//                       Center(child: 
//                         Column(
//                           children: [
//                             Expanded(
//                               flex: 5,
//                               child: Row(
//                                 crossAxisAlignment: CrossAxisAlignment.end,
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 children: [
//                                   Expanded(
//                                     flex: 3,
//                                     child: Row(
//                                       spacing: 2,
//                                       mainAxisAlignment: MainAxisAlignment.center,
//                                       children:[
//                                         Icon(
//                                           Icons.my_library_books_outlined,
//                                           size: 25, 
//                                           color: AppTheme.buttonsColor
//                                         ),
//                                         Text(
//                                           textAlign: TextAlign.center,
//                                           'Total',
//                                           style: TextStyle(
//                                             fontSize: 16,color: AppTheme.primaryColor, 
//                                             fontWeight: FontWeight.w400)
//                                         ),
//                                       ]
//                                     )
//                                   ),
//                                   Expanded(
//                                     flex: 4,
//                                     child: Row(
//                                       spacing: 2,
//                                       mainAxisAlignment: MainAxisAlignment.center,
//                                       children:[
//                                         Icon(
//                                           Icons.store_mall_directory_outlined,
//                                           size: 25, 
//                                           color: AppTheme.buttonsColor
//                                         ),
//                                         Text(
//                                           textAlign: TextAlign.center,
//                                           'Site',
//                                           style: TextStyle(
//                                             fontSize: 16,color: AppTheme.primaryColor, 
//                                             fontWeight: FontWeight.w400)
//                                         ),
//                                       ]
//                                     )
//                                   ),
//                                   Expanded(
//                                     flex: 3,
//                                     child: Row(
//                                       spacing: 2,
//                                       mainAxisAlignment: MainAxisAlignment.center,
//                                       children:[
//                                         Icon(
//                                           Icons.settings_backup_restore_rounded,
//                                           size: 25, 
//                                           color: AppTheme.buttonsColor
//                                         ),
//                                         Text(
//                                           textAlign: TextAlign.center,
//                                           'Group',
//                                           style: TextStyle(
//                                             fontSize: 16,color: AppTheme.primaryColor, 
//                                             fontWeight: FontWeight.w400)
//                                         ),
//                                       ]
//                                     )
//                                   )
//                                 ],
//                               ),
//                             ),
//                             Expanded(
//                               flex: 5,
//                               child: Row(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 children: [
//                                   Expanded(
//                                     flex: 3,
//                                     child:
//                                     // child: eventsDb == null ? CircularProgressIndicator() : 
//                                     // Text(eventsDb!.length.toString(), style: TextStyle(fontSize: 16,color: AppTheme.buttonsColor, fontWeight: FontWeight.w700),textAlign: TextAlign.center,)
//                                     Text('0', style: TextStyle(fontSize: 16,color: AppTheme.buttonsColor, fontWeight: FontWeight.w700),textAlign: TextAlign.center,)
//                                   ),
//                                   Expanded(
//                                     flex: 4,
//                                     child: storeName == null ? Text('') :
//                                     Text(storeName!,style: TextStyle(fontSize: 14,color: AppTheme.buttonsColor, fontWeight: FontWeight.w400, overflow: TextOverflow.ellipsis),textAlign: TextAlign.center,)
//                                   ),
//                                   Expanded(
//                                     flex: 3,
//                                     child: Text('All',style: TextStyle(fontSize: 16,color: AppTheme.buttonsColor, fontWeight: FontWeight.w700),textAlign: TextAlign.center,)
//                                   )
//                                 ],
//                               ),
//                             ),
//                           ]
//                         )
//                       )
//                   // ),
//                 ),
//           ),
             
//           SizedBox(
//             height: 1, 
//             child: Padding(
//               padding: EdgeInsetsGeometry.symmetric(vertical: 0, horizontal: 30),
//               child: Container(
//                 color: AppTheme.buttonsColor
//               ),
//             )
//           ),    


//           //////////////////////list events
//           Expanded(
//             flex: 9,
//             child: Padding(
//               padding: EdgeInsetsGeometry.symmetric(vertical: 35, horizontal: 10),
//               child: Container(
//                 decoration: BoxDecoration(
//                   //color: AppTheme.backColor,
//                   // color: Color(0xfff8fbff),
//                   borderRadius: BorderRadius.circular(10)
//                 ),
//                 child: Padding(
//                   padding: EdgeInsetsGeometry.symmetric(vertical: 0,horizontal: 0),
//                   child: 
//                   //  isLoadingEvents? CircularProgressIndicator():
//                   //  eventsDb== null? CircularProgressIndicator():
//                    FutureBuilder<Map<String, dynamic>>(
//                     future: db.getEventsWithEnrich(),
//                     builder: (context, snapshot) {
//                       if (snapshot.connectionState == ConnectionState.waiting) {
//                         return const Center(child: CircularProgressIndicator());
//                       }
//                       if (snapshot.hasError) {
//                         return Center(child: Text("Error: ${snapshot.error}"));
//                       }

//                       final grouped = snapshot.data!;
//                       final events = grouped.values.toList();

//                       return ListView.builder(
//                         itemCount: events.length,
//                         itemBuilder: (context, index) {
//                           final event = events[index]["event"];
//                           final epcsData = events[index]["epcs"] as List<Map<String, dynamic>>;

//                           return epcsData.length == 1
//                               ? CustomEventItem(
//                                   timestamp: event["timestamp"],
//                                   article: epcsData[0]["description"],
//                                   epc: epcsData[0]["epc"],
//                                   groupId: event["groupId"],
//                                   urlImage: epcsData[0]["imageUrl"],
//                                   silent: event["silent"],
//                                 )
//                               : 
//                               epcsData.length>1 ?
//                               CustomExpandEvent(
//                                   timestamp: event["timestamp"],
//                                   groupId: event["groupId"],
//                                   enrich: epcsData,
//                                   silent: event["silent"],
//                               )
//                               : Text('data');
//                         },
//                       );
//                     },
//                   )
                  
                  
                  
                  
                  
                  
//                 ),
//               ),
//             ),
//           ),
//         ]
//       ),
//     );
//   }
// }