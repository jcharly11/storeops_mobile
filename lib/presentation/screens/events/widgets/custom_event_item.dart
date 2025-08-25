



import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:storeops_mobile/config/theme/app_theme.dart';
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

  const CustomEventItem({super.key, required this.timestamp, required this.groupId, required this.article, required this.epc, required this.urlImage, required this.silent, required this.storeSelected, required this.storeName});

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
            //TOP HEADER EVENT 
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
                              // timestamp,
                              timestamp.substring(0,timestamp.length-4),
                              // '${timestamp.toDate().day}/${timestamp.toDate().month}/${timestamp.toDate().year}, ${timestamp.toDate().hour}:${timestamp.toDate().minute}:${timestamp.toDate().second}',
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
                                  color: AppTheme.buttonsColor,
                                ),
                                child: Padding(
                                  padding: EdgeInsetsGeometry.symmetric(vertical: 0, horizontal: 8),
                                  child: Text('RFID', 
                                    style: TextStyle(color: Colors.white, fontSize: 14)
                                  )
                                ),
                              )
                            )
                          )
                        ),
                        Expanded(
                          flex: 4,
                          child: !silent ? Icon(
                            Icons.volume_up_outlined,
                            color: AppTheme.buttonsColor
                          ) : Icon(Icons.volume_off_outlined) 
                        )
                      ]
                    )
                  )
                ]
              )
            ),
             //bottom
            Expanded(
              flex: 7,
              child: Column(
                children: [
                  Divider(),
                  Padding(
                    padding: EdgeInsetsGeometry.fromLTRB(10,15,0,0),
                    child: CustomEpcRow(article: article, epc: epc, urlImage: urlImage)
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

