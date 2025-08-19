import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:storeops_mobile/config/theme/app_theme.dart';
import 'package:storeops_mobile/data/models/events_firebase_model.dart';
import 'package:storeops_mobile/presentation/global_widgets/custom_bottom_appbar.dart';
import 'package:storeops_mobile/presentation/global_widgets/custom_fab_button.dart';
import 'package:storeops_mobile/presentation/global_widgets/custom_loader_screen.dart';
import 'package:storeops_mobile/presentation/screens/events/widgets/custom_event_item.dart';
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


  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getCustomerInfo();
    });
  }

  Future<void> _getCustomerInfo() async {
    final accountCode= await SharedPreferencesService.getSharedPreference(SharedPreferencesService.customerCodeSelected);
    final store= await SharedPreferencesService.getSharedPreference(SharedPreferencesService.storeIdSelected);
    final storeN= await SharedPreferencesService.getSharedPreference(SharedPreferencesService.storeSelected);
    setState(() {
      accountId= accountCode;
      storeId= store;
      storeName= storeN;

      // accountId= '39100';
      // storeId= '7329';
      // storeName= 'upim';

      

      _loadEvents('today', null, null);

    });
  }

  Future<void> _loadEvents(String filter, Timestamp? startDate, Timestamp? endDate) async {
    setState(() => isLoadingEvents = true);
    QuerySnapshot<Map<String, dynamic>>? snapshot;
    final startOfWeek =  DateTime.now().subtract(const Duration(days: 7));
    
    
    if(filter == 'today'){
      snapshot = await FirebaseFirestore.instance
      .collection('events')
      .doc(accountId)
      .collection(storeId!)
      .where('eventId', isEqualTo: 'rfid_alarm')
      .orderBy('timestamp', descending: true)
      .get();
    }
    else if(filter == 'week'){
      snapshot = await FirebaseFirestore.instance
      .collection('events')
      .doc(accountId)
      .collection(storeId!)
      .where('eventId', isEqualTo: 'rfid_alarm')
      .where('timestamp', isGreaterThanOrEqualTo: startOfWeek)
      .where('timestamp', isLessThanOrEqualTo: DateTime.now())
      .get();

    }
    else if(filter == 'all'){
      snapshot = await FirebaseFirestore.instance
      .collection('events')
      .doc(accountId)
      .collection(storeId!)
      .where('eventId', isEqualTo: 'rfid_alarm')
      .get();
    }

    else if(filter == 'dates'){
      snapshot = await FirebaseFirestore.instance
      .collection('events')
      .doc(accountId)
      .collection(storeId!)
      .where('eventId', isEqualTo: 'rfid_alarm')
      .where('timestamp', isGreaterThanOrEqualTo: startDate)
      .where('timestamp', isLessThanOrEqualTo: endDate)
      .get();
    }

    final items = snapshot!.docs
    .map((doc) => EventsFirebaseModel.fromMap(doc.id, doc.data()))
    .toList();
      
    setState(() {
      eventsList= items;   
      isLoadingEvents = false;
    });
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Color(0xffededed),
      backgroundColor: Colors.white,
      bottomNavigationBar: CustomBottomAppbar(),
      
      floatingActionButton: CustomFabButton(icon: Icons.filter_list, onPressed: () => 
        showModalBottomSheet(context: context, builder: (BuildContext context) => Container(
          alignment: Alignment.topLeft,
          height: 250,
          child: 
            Expanded(
              child: 
                Padding(
                  padding: EdgeInsetsGeometry.symmetric(vertical: 30, horizontal: 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text('Filter Events', 
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500, 
                        )
                      ),
                      Divider(),

                      Row(
                        spacing: 15,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                              backgroundColor: AppTheme.secondaryColor,iconColor: Colors.white
                            ),
                            onPressed: (){
                              _loadEvents('today', null, null);
                            },
                            icon: Icon(Icons.today_outlined, size: 22,),
                            label: Text('Today',style: TextStyle(color: Colors.white, fontWeight: FontWeight.w400))
                          ),

                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                              backgroundColor: AppTheme.secondaryColor,iconColor: Colors.white
                            ),
                            onPressed: (){
                              _loadEvents('week', null, null);
                            },
                            icon: Icon(Icons.calendar_view_week_rounded, size: 22,),
                            label: Text('Week',style: TextStyle(color: Colors.white, fontWeight: FontWeight.w400))
                          ),
                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                              backgroundColor: AppTheme.secondaryColor,iconColor: Colors.white
                            ),
                            onPressed: (){
                              _loadEvents('all', null, null);
                            },
                            icon: Icon(Icons.calendar_month_outlined, size: 22,),
                            label: Text('All',style: TextStyle(color: Colors.white, fontWeight: FontWeight.w400))
                          )
                        ],
                      ),

                      Padding(
                        padding: EdgeInsetsGeometry.symmetric(vertical: 15, horizontal: 0),
                        child: Center(
                          child: ElevatedButton.icon(
                            
                            style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                            backgroundColor: AppTheme.secondaryColor,iconColor: Colors.white
                            ),
                                onPressed: (){
                                  showDateRangePicker(
                                    context: context, 
                                    firstDate: DateTime(DateTime.now().year-1), 
                                    lastDate: DateTime(DateTime.now().year+1),
                                    fieldStartHintText: 'sdafdsaf',
                          
                                  ).then((DateTimeRange? value){
                                    if(value!=null){
                                      DateTimeRange _fromRange = DateTimeRange(
                                        start: DateTime.now(), 
                                        end: DateTime.now()
                                      );
                                      _fromRange= value;
                                      
                                        final Timestamp startDate= Timestamp.fromDate(_fromRange.start);
                                        final Timestamp endDate= Timestamp.fromDate(_fromRange.end);
                                        
                                        _loadEvents('dates', startDate, endDate);
                                    }
                                  });
                                },
                                icon: Icon(Icons.calendar_month_outlined, size: 22,),
                                label: Text('Date Range',style: TextStyle(color: Colors.white, fontWeight: FontWeight.w400))
                              ),
                        ),
                      )
                      

                    ]
                  ),
                )
            ),
          )
        )
      ),
      
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
      body: isLoadingEvents ? Center(
        child: CustomLoaderScreen(message: 'Loading Events from $storeName')
      ): 
      Column(
        children:[ 
          Expanded(
            flex: 1,
              child: Padding(
                padding: EdgeInsetsGeometry.symmetric(vertical: 0, horizontal: 5),
                child: 
                  // Card(
                  //   shape: RoundedRectangleBorder(
                  //   // side: BorderSide(color: AppTheme.buttonsColor, width: 1),
                  //     borderRadius: BorderRadius.circular(10),
                  //   ),
                  //   color: AppTheme.extraColor,
                  //   elevation: 2,
                  //   shadowColor: AppTheme.colorGeneral,
                  //   child:
                      Center(child: 
                        Column(
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
                                          textAlign: TextAlign.center,
                                          'Total',
                                          style: TextStyle(
                                            fontSize: 16,color: AppTheme.primaryColor, 
                                            fontWeight: FontWeight.w400)
                                        ),
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
                                          textAlign: TextAlign.center,
                                          'Site',
                                          style: TextStyle(
                                            fontSize: 16,color: AppTheme.primaryColor, 
                                            fontWeight: FontWeight.w400)
                                        ),
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
                                          textAlign: TextAlign.center,
                                          'Group',
                                          style: TextStyle(
                                            fontSize: 16,color: AppTheme.primaryColor, 
                                            fontWeight: FontWeight.w400)
                                        ),
                                      ]
                                    )
                                  )
                                ],
                              ),
                            ),
                            Expanded(
                              flex: 5,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Expanded(
                                    flex: 3,
                                    child: eventsList == null ? CircularProgressIndicator() : 
                                    Text(eventsList!.length.toString(), style: TextStyle(fontSize: 16,color: AppTheme.buttonsColor, fontWeight: FontWeight.w700),textAlign: TextAlign.center,)
                                  ),
                                  Expanded(
                                    flex: 4,
                                    child: storeName == null ? Text('') :
                                    Text(storeName!,style: TextStyle(fontSize: 14,color: AppTheme.buttonsColor, fontWeight: FontWeight.w400, overflow: TextOverflow.ellipsis),textAlign: TextAlign.center,)
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
                  // ),
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
                  //color: AppTheme.backColor,
                  // color: Color(0xfff8fbff),
                  borderRadius: BorderRadius.circular(10)
                ),
                child: Padding(
                  padding: EdgeInsetsGeometry.symmetric(vertical: 0,horizontal: 0),
                  child: ListView.builder( 
                    itemCount: eventsList?.length,
                    itemBuilder:(context, index) {
                      final eventItem= eventsList?[index];
                      
                      return eventItem == null ? CircularProgressIndicator() : 
                      Padding(
                        padding: EdgeInsetsGeometry.fromLTRB(0, 0, 0, 10),
                        child: CustomEventItem(
                          article: eventItem.enrich[0].description,
                          epc: eventItem.enrich[0].epc,
                          groupId: eventItem.groupId,
                          silent: eventItem.silent,
                          timestamp: eventItem.timestamp,
                          urlImage: eventItem.enrich[0].imageUrl,
                        ),
                      );
                    }
                  )
                ),
              ),
            ),
              ),
            
          
        ]
      ),
    );
  }
}



