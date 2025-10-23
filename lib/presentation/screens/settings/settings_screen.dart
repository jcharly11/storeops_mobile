import 'dart:async';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:storeops_mobile/config/router/router.dart';
import 'package:storeops_mobile/config/theme/app_theme.dart';
import 'package:storeops_mobile/db/db_sqlite_helper.dart';
import 'package:storeops_mobile/domain/entities/customer_response_entity.dart';
import 'package:storeops_mobile/domain/entities/stores_response_entity.dart';
import 'package:storeops_mobile/domain/repositories/customers_repository.dart';
import 'package:storeops_mobile/domain/repositories/stores_repository.dart';
import 'package:storeops_mobile/l10n/app_localizations.dart';
import 'package:storeops_mobile/presentation/global_widgets/custom_appbar.dart';
import 'package:storeops_mobile/presentation/global_widgets/custom_bottom_appbar.dart';
import 'package:storeops_mobile/presentation/global_widgets/custom_fab_button.dart';
import 'package:storeops_mobile/presentation/global_widgets/custom_loader_screen.dart';
import 'package:storeops_mobile/presentation/global_widgets/custom_snackbar_message.dart';
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
  Map<String, dynamic>? selectedGroup;
  bool isLoadingStores = false;
  bool isLoadingGroups = false;
  String? userAuth;

  List<Map<String,dynamic>> valuesToSave = [];
  bool isCheckedSold = false;
  bool isCheckedRFID = true;
  bool isCheckedRF = false;
  bool isCheckedPush = true;
  bool isSavingConfig = false;
  bool storeValidated = false;
  bool isLoadingInfo = false;
  List<Map<String,dynamic>> groupList = [];
  final db = DbSqliteHelper.instance;
  String? tokenMobile;

  @override
  void initState() {
    super.initState();
    getUserAuth();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadCustomers();
      loadTechnologies();
    });
  }

  Future<void> getUserAuth() async {
    setState(() {
      isLoadingInfo = true;
    });
    final user = await SharedPreferencesService.getSharedPreference(SharedPreferencesService.userAuthenticated);
    final tokenM = await SharedPreferencesService.getSharedPreference(SharedPreferencesService.tokenMobile);
    setState(() {
      userAuth = user;
      tokenMobile = tokenM;
    });
  }

  Future<void> loadCustomers() async {
    setState(() => isLoadingCustomers = true);
    final repo = context.read<CustomerRepository>();
    final customers = await repo.customer();
    final customerSelectedJson = await SharedPreferencesService.getSharedPreference(SharedPreferencesService.customerSelectedJson);
    setState(() {
      customerList = customers;
      if (customerSelectedJson != null) {
        final customer = CustomerResponseEntity.fromJson(customerSelectedJson);
        selectedCustomer = customer;
        if (customer.customerToken != null) {
          loadStores(customer.customerToken);
        }
      }
      isLoadingCustomers = false;
      isLoadingInfo = false;
    });
  }

  Future<void> loadStores(String customerToken) async {
    setState(() => isLoadingStores = true);
    final repo = context.read<StoresRepository>();
    final stores = await repo.stores(customerToken);
    final storeSelectedJson = await SharedPreferencesService.getSharedPreference(SharedPreferencesService.storeSelectedJson);

    setState(() {
      storeList = stores;
      selectedStore = null;
      if (storeSelectedJson != null && !storeValidated) {
        final store = StoresResponseEntity.fromJson(storeSelectedJson);
        selectedStore = store;
        storeValidated = true;
        if (store.groups != null) loadGroups(store.groups);
      }
      isLoadingStores = false;
    });
  }

  Future<void> loadGroups(List<dynamic> groups) async {
    setState(() => isLoadingGroups = true);
    final groupSelected = await SharedPreferencesService.getSharedPreference(SharedPreferencesService.groupSelected);
    final groupIdSelected = await SharedPreferencesService.getSharedPreference(SharedPreferencesService.groupIdSelected);

    setState(() {
      groupList.clear();
      groupList.add({'groupId': '0', 'groupName': AppLocalizations.of(context)?.all ?? 'Todos'});
      for (var itemGroup in groups) {
        groupList.add(itemGroup);
      }
      selectedGroup = null;
      if (groupSelected != null) {
        final group = groupList.firstWhere(
          (g) => g['groupId'].toString() == (groupIdSelected ?? ''),
          orElse: () => groupList.first,
        );
        selectedGroup = group;
      }
      isLoadingGroups = false;
    });
  }

  Future<void> loadTechnologies() async {
    final soldValue = await SharedPreferencesService.getSharedPreferenceBool(SharedPreferencesService.soldSelected);
    final rfValue = await SharedPreferencesService.getSharedPreferenceBool(SharedPreferencesService.rfSelected);
    final rfidValue = await SharedPreferencesService.getSharedPreferenceBool(SharedPreferencesService.rfidSelected);
    final pushValue = await SharedPreferencesService.getSharedPreferenceBool(SharedPreferencesService.pushSelected);

    setState(() {
      isCheckedSold = soldValue ?? isCheckedSold;
      isCheckedRF = rfValue ?? isCheckedRF;
      isCheckedRFID = rfidValue ?? isCheckedRFID;
      isCheckedPush = pushValue ?? isCheckedPush;
    });
  }

  Future<void> saveConfig() async {
    setState(() => isSavingConfig = true);
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final messageSaved = AppLocalizations.of(context)?.config_saved ?? 'Configuración guardada';

    if (selectedCustomer == null) {
      scaffoldMessenger.showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)?.select_client ?? 'Seleccione un cliente'),
          backgroundColor: AppTheme.secondaryColor,
          duration: const Duration(seconds: 2),
        ),
      );
      setState(() => isSavingConfig = false);
      return;
    }

    if (selectedStore == null) {
      scaffoldMessenger.showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)?.select_store ?? 'Seleccione una tienda'),
          backgroundColor: AppTheme.secondaryColor,
          duration: const Duration(seconds: 2),
        ),
      );
      setState(() => isSavingConfig = false);
      return;
    }

    if (selectedGroup == null) {
      scaffoldMessenger.showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)?.select_group ?? 'Seleccione un grupo'),
          backgroundColor: AppTheme.secondaryColor,
          duration: const Duration(seconds: 2),
        ),
      );
      setState(() => isSavingConfig = false);
      return;
    }

    if (!isCheckedSold && !isCheckedRFID && !isCheckedRF) {
      scaffoldMessenger.showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)?.select_technology ?? 'Seleccione al menos una tecnología'),
          backgroundColor: AppTheme.secondaryColor,
          duration: const Duration(seconds: 2),
        ),
      );
      setState(() => isSavingConfig = false);
      return;
    }

    final docId = tokenMobile != null ? await FirebaseService.tokenMobileExists(tokenMobile!) : '';
    valuesToSave.clear();
    valuesToSave.add({SharedPreferencesService.customerSelected: selectedCustomer?.description ?? ''});
    valuesToSave.add({SharedPreferencesService.customerCodeSelected: selectedCustomer?.accountCode ?? ''});
    valuesToSave.add({SharedPreferencesService.storeIdSelected: selectedStore?.storeId ?? ''});
    valuesToSave.add({SharedPreferencesService.storeSelected: selectedStore?.storeName ?? ''});
    valuesToSave.add({SharedPreferencesService.soldSelected: isCheckedSold});
    valuesToSave.add({SharedPreferencesService.rfidSelected: isCheckedRFID});
    valuesToSave.add({SharedPreferencesService.rfSelected: isCheckedRF});
    valuesToSave.add({SharedPreferencesService.pushSelected: isCheckedPush});
    valuesToSave.add({SharedPreferencesService.customerSelectedJson: selectedCustomer?.toJson() ?? {}});
    valuesToSave.add({SharedPreferencesService.storeSelectedJson: selectedStore?.toJson() ?? {}});
    valuesToSave.add({SharedPreferencesService.groupSelected: selectedGroup?["groupName"] ?? ''});
    valuesToSave.add({SharedPreferencesService.groupIdSelected: selectedGroup?["groupId"] ?? ''});

    await SharedPreferencesService.saveMultipleSharedPreference(valuesToSave);

    if (docId == '') {
      if (selectedCustomer?.accountCode != null && selectedStore?.storeId != null && tokenMobile != null) {
        await FirebaseService.insertTokenMobile(selectedCustomer!.accountCode, selectedStore!.storeId, tokenMobile!, isCheckedPush, isCheckedSold);
      }
    } else {
      if (selectedCustomer?.accountCode != null && selectedStore?.storeId != null && docId != null) {
        await FirebaseService.updateInfoTokenMobile(selectedCustomer!.accountCode, selectedStore!.storeId, docId, isCheckedPush, isCheckedSold);
      }
    }

    await db.deleteEvents();
    await db.deleteEnrich();

    setState(() => isSavingConfig = false);
    Fluttertoast.showToast(msg: messageSaved);
    appRouter.go("/events");
  }

  @override
  Widget build(BuildContext context) {
    final scaffoldKey = GlobalKey<ScaffoldState>();
    final isTesting = const bool.fromEnvironment('INTEGRATION_TEST', defaultValue: false);
    final token = tokenMobile ?? (isTesting ? 'test_token_123' : null);

    if (token == null) {
      return const Scaffold(
        body: Center(child: Text('Token no disponible')),
      );
    }

    return Scaffold(
      key: Key(SettingsScreen.name),
      backgroundColor: Colors.white,
      bottomNavigationBar: CustomBottomAppbar(),
      floatingActionButton: (isSavingConfig || isLoadingInfo)
          ? null
          : CustomFabButton(onPressed: saveConfig, icon: Icons.check),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      appBar: tokenMobile != null ? CustomAppbar(includeBottomBar: false, tokenMob: tokenMobile!) : null,
      drawer: SideMenu(scaffoldKey: scaffoldKey),
      body: isSavingConfig
          ? CustomLoaderScreen(message: AppLocalizations.of(context)?.saving_configuration ?? 'Guardando configuración...')
          : isLoadingInfo
              ? CustomLoaderScreen(message: AppLocalizations.of(context)?.loading_customers_info ?? 'Cargando información...')
              : SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 50),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TitleText(textShow: AppLocalizations.of(context)?.user ?? 'Usuario', icon: Icons.person_pin_outlined),
                        userAuth == null
                            ? const CircularProgressIndicator()
                            : Text(userAuth ?? '', style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 15)),
                        const SizedBox(height: 15),

                        TitleText(textShow: AppLocalizations.of(context)?.customer ?? 'Cliente', icon: Icons.contact_page_outlined),
                        isLoadingCustomers
                            ? const Center(child: CircularProgressIndicator())
                            : DropdownSearch<CustomerResponseEntity>(
                                items: (String filter, LoadProps? loadProps) {
                                  if (filter.isEmpty) return customerList;
                                  return customerList.where((c) => '${c.accountCode} - ${c.description}'.toLowerCase().contains(filter.toLowerCase())).toList();
                                },
                                itemAsString: (CustomerResponseEntity c) => '${c.accountCode} - ${c.description}',
                                selectedItem: selectedCustomer,
                                compareFn: (a, b) => a.customerToken == b.customerToken,
                                onChanged: (customer) {
                                  if (customer != null) {
                                    setState(() => selectedCustomer = customer);
                                    if (customer.customerToken != null) loadStores(customer.customerToken);
                                  }
                                },
                                popupProps: PopupProps.menu(
                                  showSearchBox: true,
                                  searchFieldProps: TextFieldProps(
                                    decoration: InputDecoration(
                                      hintText: AppLocalizations.of(context)?.search ?? 'Buscar',
                                      border: const OutlineInputBorder(),
                                    ),
                                  ),
                                ),
                                decoratorProps: const DropDownDecoratorProps(
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                              ),

                        const SizedBox(height: 20),
 // Tienda
                      TitleText(
                        textShow: AppLocalizations.of(context)?.site ?? 'Tienda',
                        icon: Icons.store_outlined,
                      ),
                      isLoadingStores
                          ? const Center(child: CircularProgressIndicator())
                          : DropdownSearch<StoresResponseEntity>(
                              items: (String filter, LoadProps? loadProps) {
                                if (filter.isEmpty) return storeList;
                                return storeList
                                    .where((s) =>
                                        '${s.storeId} - ${s.storeName}'
                                            .toLowerCase()
                                            .contains(filter.toLowerCase()))
                                    .toList();
                              },
                              itemAsString: (StoresResponseEntity s) =>
                                  '${s.storeId} - ${s.storeName}',
                              selectedItem: selectedStore,
                              compareFn: (a, b) => a.storeId == b.storeId,
                              onChanged: (store) {
                                if (store != null) {
                                  setState(() => selectedStore = store);
                                  loadGroups(store.groups);
                                }
                              },
                              popupProps: PopupProps.menu(
                                showSearchBox: true,
                                searchFieldProps: TextFieldProps(
                                  decoration: InputDecoration(
                                    hintText: AppLocalizations.of(context)
                                            ?.search_site ??
                                        'Buscar tienda',
                                    border: const OutlineInputBorder(),
                                  ),
                                ),
                              ),
                              decoratorProps: const DropDownDecoratorProps(
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ),

                      const SizedBox(height: 20),

                      // Grupo
                      TitleText(
                        textShow:
                            AppLocalizations.of(context)?.group ?? 'Grupo',
                        icon: Icons.door_sliding_outlined,
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: isLoadingGroups
                            ? const Center(child: CircularProgressIndicator())
                            : DropdownSearch<Map<String, dynamic>>(
                                items: (String filter, LoadProps? loadProps) {
                                  if (filter.isEmpty) return groupList;
                                  return groupList
                                      .where((g) => g["groupName"]
                                          .toString()
                                          .toLowerCase()
                                          .contains(filter.toLowerCase()))
                                      .toList();
                                },
                                itemAsString: (Map<String, dynamic> g) =>
                                    g["groupName"].toString(),
                                selectedItem: selectedGroup,
                                compareFn: (a, b) => a["groupId"] == b["groupId"],
                                onChanged: (value) {
                                  if (value != null) {
                                    setState(() => selectedGroup = value);
                                  }
                                },
                                popupProps: PopupProps.menu(
                                  showSearchBox: true,
                                  searchFieldProps: TextFieldProps(
                                    decoration: InputDecoration(
                                      hintText: AppLocalizations.of(context)
                                              ?.search_group ??
                                          'Buscar grupo',
                                      border: const OutlineInputBorder(),
                                    ),
                                  ),
                                ),
                                decoratorProps: const DropDownDecoratorProps(
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                              ),
                      ),

                      const SizedBox(height: 20),

                      // Tecnologías
                      TitleText(
                        textShow:
                            AppLocalizations.of(context)?.technologies ??
                                'Tecnologías',
                        icon: Icons.wifi_tethering,
                      ),
                      const SizedBox(height: 10),
                      GridView.count(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 8,
                        crossAxisCount: 2,
                        childAspectRatio: 4,
                        children: [
                          TechCheckbox(
                            label: 'RFID',
                            value: isCheckedRFID,
                            onChanged: (bool? value) {
                              setState(() {
                                isCheckedRFID = value ?? false;
                              });
                            },
                          ),
                          TechCheckbox(
                            label: 'RF',
                            value: isCheckedRF,
                            onChanged: (bool? value) {
                              setState(() {
                                isCheckedRF = value ?? false;
                              });
                            },
                          ),
                          TechCheckbox(
                            label: AppLocalizations.of(context)?.sold ?? 'Sold',
                            value: isCheckedSold,
                            onChanged: (bool? value) {
                              setState(() {
                                isCheckedSold = value ?? false;
                              });
                            },
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      // Notificaciones
                      TitleText(
                        textShow: AppLocalizations.of(context)
                                ?.notifications ??
                            'Notificaciones',
                        icon: Icons.notifications_active_outlined,
                      ),
                      TechCheckbox(
                        label: AppLocalizations.of(context)?.push_notifications ??
                            'Push Notifications',
                        value: isCheckedPush,
                        onChanged: (bool? value) {
                          setState(() {
                            isCheckedPush = value ?? false;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
  );
}
}