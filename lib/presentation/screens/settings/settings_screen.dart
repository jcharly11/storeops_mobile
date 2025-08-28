import 'dart:async';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:storeops_mobile/config/router/router.dart';
import 'package:storeops_mobile/config/theme/app_theme.dart';
import 'package:storeops_mobile/domain/entities/customer_response_entity.dart';
import 'package:storeops_mobile/domain/entities/stores_response_entity.dart';
import 'package:storeops_mobile/domain/repositories/customers_repository.dart';
import 'package:storeops_mobile/domain/repositories/stores_repository.dart';
import 'package:storeops_mobile/main.dart';
import 'package:storeops_mobile/presentation/global_widgets/custom_appbar.dart';
import 'package:storeops_mobile/presentation/global_widgets/custom_bottom_appbar.dart';
import 'package:storeops_mobile/presentation/global_widgets/custom_fab_button.dart';
import 'package:storeops_mobile/presentation/global_widgets/custom_loader_screen.dart';
import 'package:storeops_mobile/presentation/global_widgets/snackbar_message.dart';
import 'package:storeops_mobile/presentation/screens/home/widgets/side_menu.dart';
import 'package:storeops_mobile/presentation/screens/settings/widgets/tech_checkbox.dart';
import 'package:storeops_mobile/presentation/screens/settings/widgets/title_text.dart';
import 'package:storeops_mobile/services/firebase_service.dart';
import 'package:storeops_mobile/services/shared_preferences_service.dart';

class SettingsScreen extends StatefulWidget {
  static const name = 'settings_screen';
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {

  List<CustomerResponseEntity> customerList = [];
  CustomerResponseEntity? selectedCustomer;
  bool isLoadingCustomers = false;

  List<StoresResponseEntity> storeList = [];
  StoresResponseEntity? selectedStore;
  bool isLoadingStores = false;
  String? userAuth;

  List<Map<String,dynamic>> valuesToSave=[];
  bool isCheckedPeople = false;
  bool isCheckedRFID = true;
  bool isCheckedRF = false;
  bool isCheckedPush = true;
  bool isSavingConfig = false;
  bool storeValidated= false;
  bool isLoadingInfo= false;
  List<String> list_groups = <String>['All'];

  


  @override
  void initState() {
    super.initState();
    _getUserAuth();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadCustomers();
      loadTechnologies();
    });
    
  }

   Future<void> _getUserAuth() async {
    setState(() {
      isLoadingInfo= true;
    });
    final user= await SharedPreferencesService.getSharedPreference(SharedPreferencesService.userAuthenticated);
    setState(() {
      userAuth= user;
    });
  }

  Future<void> loadCustomers() async {
    setState(() => isLoadingCustomers = true);
    final repo = context.read<CustomerRepository>();
    final customers = await repo.customer();
    final customerSelectedJson= await SharedPreferencesService.getSharedPreference(SharedPreferencesService.customerSelectedJson);
    setState(() {
      customerList = customers;
      if (customerSelectedJson != null) {
        final customer = CustomerResponseEntity.fromJson(customerSelectedJson);
        selectedCustomer= customer;
        loadStores(customer.customerToken);
      }
      isLoadingCustomers = false;
      isLoadingInfo= false;
      
    });
  }

  Future<void> loadStores(String customerToken) async {
    setState(() => isLoadingStores = true);
    final repo = context.read<StoresRepository>();
    final stores = await repo.stores(customerToken);
    final storeSelectedJson= await SharedPreferencesService.getSharedPreference(SharedPreferencesService.storeSelectedJson);
    setState(() {
      storeList = stores;
      selectedStore = null;
      if (storeSelectedJson != null && !storeValidated) {
        final store = StoresResponseEntity.fromJson(storeSelectedJson);
        selectedStore= store;
        storeValidated= true;
      }
      isLoadingStores = false;
    });
  }

  Future<void> loadTechnologies() async {
    final peopleValue= await SharedPreferencesService.getSharedPreferenceBool(SharedPreferencesService.peopleSelected);
    final rfValue= await SharedPreferencesService.getSharedPreferenceBool(SharedPreferencesService.rfSelected);
    final rfidValue= await SharedPreferencesService.getSharedPreferenceBool(SharedPreferencesService.rfidSelected);
    final pushValue= await SharedPreferencesService.getSharedPreferenceBool(SharedPreferencesService.pushSelected);
    
    setState(() {
      
      if (peopleValue != null && rfValue != null && rfidValue != null && pushValue != null) {
        isCheckedPeople= peopleValue;
        isCheckedRF= rfValue;
        isCheckedRFID= rfidValue;
        isCheckedPush= pushValue;
      }
      
    });
  }

  Future<void> saveConfig() async {
    setState(() => isSavingConfig = true);
    
    final tokenMobile= await SharedPreferencesService.getSharedPreference(SharedPreferencesService.tokenMobile);
    
    if(selectedCustomer==null){
      snackbarMessage(context, 'You must select a client', AppTheme.secondaryColor, 10);
      isSavingConfig = false;
      await Future.delayed(const Duration(seconds: 2));
      return;
    }
    else{
      if(selectedStore==null){
        snackbarMessage(context, 'You must select a store', AppTheme.secondaryColor, 10);
        isSavingConfig = false;
        await Future.delayed(const Duration(seconds: 2));
        return;
      }
      else{
        if(!isCheckedPeople && !isCheckedRFID && !isCheckedRF){
          snackbarMessage(context, 'You must select at least one technology', AppTheme.secondaryColor, 10);
          isSavingConfig = false;
          await Future.delayed(const Duration(seconds: 2));
          return;
        }
        else{
          var docId= await FirebaseService.tokenMobileExists(tokenMobile!);
    
          valuesToSave.add({SharedPreferencesService.customerSelected :selectedCustomer?.description});
          valuesToSave.add({SharedPreferencesService.customerCodeSelected :selectedCustomer?.accountCode});
          valuesToSave.add({SharedPreferencesService.storeIdSelected :selectedStore?.storeId});
          valuesToSave.add({SharedPreferencesService.storeSelected :selectedStore?.storeName});
          valuesToSave.add({SharedPreferencesService.peopleSelected :isCheckedPeople});
          valuesToSave.add({SharedPreferencesService.rfidSelected :isCheckedRFID});
          valuesToSave.add({SharedPreferencesService.rfSelected :isCheckedRF});
          valuesToSave.add({SharedPreferencesService.pushSelected :isCheckedPush});
          valuesToSave.add({SharedPreferencesService.customerSelectedJson :selectedCustomer?.toJson()});
          valuesToSave.add({SharedPreferencesService.storeSelectedJson :selectedStore?.toJson()});

          await SharedPreferencesService.saveMultipleSharedPreference(valuesToSave);
          
          if(docId == ''){
            await FirebaseService.insertTokenMobile(selectedCustomer!.accountCode,selectedStore!.storeId, tokenMobile, isCheckedPush);
          }
          else{
            await FirebaseService.updateInfoTokenMobile(selectedCustomer!.accountCode, selectedStore!.storeId, docId.toString(), isCheckedPush);
          }

          setState(() {
            isSavingConfig = false;
          });

          Fluttertoast.showToast(msg: 'Config Saved');

          appRouter.go("/events");
        }
      } 
    }
  }


  @override
  Widget build(BuildContext context) {
    final scaffoldKey= GlobalKey<ScaffoldState>();
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: CustomBottomAppbar(),
      floatingActionButton: isSavingConfig || isLoadingInfo ? Text('') : 
      CustomFabButton(onPressed: saveConfig, icon: Icons.check),
      
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,

      appBar: CustomAppbar(includeBottomBar: false),
      drawer: SideMenu(scaffoldKey: scaffoldKey),
      body: isSavingConfig ? CustomLoaderScreen(message: 'Saving Configuration'): isLoadingInfo ? CustomLoaderScreen(message: 'Loading Customers Info',): SingleChildScrollView(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                  padding: EdgeInsetsGeometry.symmetric(vertical: 30, horizontal: 50),
                  child: Container(
                    alignment: Alignment.topLeft,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      
                      children:[
                        TitleText(textShow: 'User', icon: Icons.person_pin_outlined),
                        userAuth == null ? CircularProgressIndicator()
                        : Text(userAuth!, style: 
                          TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 15
                          ),              
                        ),
                        SizedBox(height: 15),
          
                        TitleText(textShow: 'Customer', icon: Icons.contact_page_outlined),
          
                        isLoadingCustomers ? Center(child: CircularProgressIndicator()) : 
                        DropdownSearch<CustomerResponseEntity>(
                          items: (String filter, LoadProps? loadProps) {
                            if (filter.isEmpty) return customerList;
                            return customerList
                                .where((c) => '${c.accountCode} - ${c.description}'
                                    .toLowerCase()
                                    .contains(filter.toLowerCase())
                                )
                                .toList();
                          },
                          itemAsString: (CustomerResponseEntity c) => '${c.accountCode} - ${c.description}',
                          selectedItem: selectedCustomer,
                          compareFn: (a, b) => a.customerToken == b.customerToken,
                          onChanged: (customer) {
                            if (customer != null) {
                              setState(() {
                                selectedCustomer = customer;
                              });
                              loadStores(customer.customerToken);
                            }
                          },
                          popupProps: PopupProps.menu(
                            showSearchBox: true,
                            searchFieldProps: TextFieldProps(
                              decoration: InputDecoration(
                                hintText: 'Search Customer',
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                          decoratorProps: DropDownDecoratorProps(
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
          
                        TitleText(textShow: 'Site', icon: Icons.store_outlined),
          
                        isLoadingStores ? Center(child: CircularProgressIndicator()) : 
                          DropdownSearch<StoresResponseEntity>(
                            items: (String filter, LoadProps? loadProps) {
                              if (filter.isEmpty) return storeList;
                              
                              return storeList
                                .where((s) => '${s.storeId} - ${s.storeName}'
                                .toLowerCase()
                                .contains(filter.toLowerCase()))
                                .toList();
                            },
                            itemAsString: (StoresResponseEntity s) => '${s.storeId} -  ${s.storeName}',
                            selectedItem: selectedStore,
                            compareFn: (a, b) => a.storeId == b.storeId,
                            onChanged: (store) {
                              if (store != null) {
                                setState(() {
                                  selectedStore = store;
                                });
                              }
                            },
                            popupProps: PopupProps.menu(
                              showSearchBox: true,
                              searchFieldProps: TextFieldProps(
                                decoration: InputDecoration(
                                  hintText: 'Search Site',
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ),
                            decoratorProps: DropDownDecoratorProps(
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
          
                          SizedBox(height: 20),

                          TitleText(textShow: 'Group', icon: Icons.door_sliding_outlined),
                          
                          SizedBox(
                            width: double.infinity,
                            child: 
                              DropdownButton<String>(
                              value: 'All',
                              elevation: 16,
                              style: TextStyle(color: AppTheme.primaryColor),
                              
                              underline: Container(height: 1, color: AppTheme.primaryColor),
                              onChanged: (String? value) {
                                setState(() {
                                //dropdownValue = value!;
                                });
                              },
                              items: list_groups.map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(value: value, child: Text(value));
                              }).toList()
                            ),
                          ),

                          
                          SizedBox(height: 20),

                          TitleText(textShow: 'Technologies', icon: Icons.wifi_tethering),
                          SizedBox(height: 10),
                          GridView.count(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            crossAxisSpacing: 8,
                            mainAxisSpacing: 8,
                            crossAxisCount: 2, 
                            childAspectRatio: 4,
                            children: [
                              TechCheckbox(label: 'People Counting',
                                value: isCheckedPeople,onChanged: (bool? value) {
                                  setState(() {
                                    isCheckedPeople = value!;
                                  });
                                },
                              ),
          
                              TechCheckbox(label: 'RFID',
                                value: isCheckedRFID,onChanged: (bool? value) {
                                  setState(() {
                                    isCheckedRFID = value!;
                                  });
                                },
                              ),
          
                              TechCheckbox(label: 'RF',
                                value: isCheckedRF,onChanged: (bool? value) {
                                  setState(() {
                                    isCheckedRF = value!;
                                  });
                                },
                              ),
                              
                            ],
                          ),
          
                          SizedBox(height: 20),
          
                          TitleText(textShow: 'Notifications', icon: Icons.notifications_active_outlined),
          
                          TechCheckbox(label: 'Push Notifications',
                            value: isCheckedPush,onChanged: (bool? value) {
                              setState(() {
                                isCheckedPush = value!;
                              });
                            },
                          ),
                      ]
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


