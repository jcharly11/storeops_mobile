
import 'package:flutter/material.dart';
import 'package:storeops_mobile/config/theme/app_theme.dart';
import 'package:storeops_mobile/l10n/app_localizations.dart';
import 'package:storeops_mobile/presentation/screens/events/widgets/custom_epc_row.dart';

class CustomEventItem extends StatelessWidget {
  final String timestamp;
  final String groupId;
  final String article;
  final String epc;
  final String urlImage;
  final bool silent;
  final String storeSelected;
  final String storeName;
  final String gtin;
  final String eventId;

  const CustomEventItem({super.key, required this.timestamp, required this.groupId, required this.article, required this.epc, required this.urlImage, required this.silent, required this.storeSelected, required this.storeName, required this.gtin, required this.eventId});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 180,
      child: Card(
        shape: RoundedRectangleBorder(
    side: BorderSide(color: AppTheme.buttonsColor, width: 1),
    borderRadius: BorderRadius.circular(5),
  ),
        color: Colors.white,
        elevation: 1,
        shadowColor: AppTheme.primaryColor,
        child: Column(
          children: [
            Expanded(
              flex: 3,
              child: Row(
                children: [
                  Expanded(
                    flex:7, 
                    child: Padding(
                      padding: EdgeInsetsGeometry.fromLTRB(15, 6, 0, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 6,
                            child: Text(
                              timestamp.substring(0,timestamp.length-4),
                              style: TextStyle(
                                fontSize: 16,
                                color: AppTheme.primaryColor,
                                fontWeight: FontWeight.w500,
                                overflow: TextOverflow.ellipsis
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 4,
                            child: Text(
                              '$storeSelected ($storeName) - $groupId',
                              style: TextStyle(
                                fontSize: 12,
                                color: AppTheme.primaryColor,
                                fontWeight: FontWeight.w300
                              ),
                            ),
                          )
                        ]
                      ),
                    )
                  ),
                  Expanded(
                    flex:3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          flex: 6, 
                          child: Center(
                            child: Padding(
                              padding: EdgeInsetsGeometry.fromLTRB(0,5,0,0),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: eventId == "rfid_alarm" ? AppTheme.buttonsColor : Colors.blue,
                                ),
                                child: Padding(
                                  padding: EdgeInsetsGeometry.symmetric(vertical: 0, horizontal: 8),
                                  child: Text(eventId == "rfid_alarm" ? 'RFID' : AppLocalizations.of(context)!.sold_uppercase, 
                                    style: TextStyle(color: Colors.white, fontSize: 14)
                                  )
                                ),
                              )
                            )
                          )
                        ),
                        Expanded(
                          flex: 4,
                          child: eventId == "rfid_alarm" ? 
                          !silent ? Icon(
                            Icons.volume_up_outlined,
                            color: AppTheme.buttonsColor
                          ) : Icon(Icons.volume_off_outlined, color: AppTheme.buttonsColor) 
                          : SizedBox()
                        )
                      ]
                    )
                  )
                ]
              )
            ),
            Expanded(
              flex: 7,
              child: Column(
                children: [
                  Divider(),
                  Padding(
                    padding: EdgeInsetsGeometry.fromLTRB(10,15,0,0),
                    child: CustomEpcRow(
                      article: article, 
                      epc: epc, 
                      urlImage: urlImage,
                      gtin: gtin,
                    )
                  )
                  
                ]
              )
            )
          ]
        )
      )
    );
  }                      
}

