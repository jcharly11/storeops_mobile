import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:storeops_mobile/config/theme/app_theme.dart';

class CustomEventItem extends StatelessWidget {
  final Timestamp timestamp;
  final String groupId;
  final String article;
  final String epc;
  final String urlImage;
  final bool silent;

  const CustomEventItem({super.key, required this.timestamp, required this.groupId, required this.article, required this.epc, required this.urlImage, required this.silent});

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
                               timestamp.toDate().toString().substring(0,timestamp.toDate().toString().length-4),
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
                              '1 - $groupId',
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
                                  padding: EdgeInsetsGeometry.symmetric(vertical: 2, horizontal: 8),
                                  child: Text('RFID', 
                                    style: TextStyle(color: Colors.white)
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
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          flex: 7,
                          child: Padding(
                                padding: EdgeInsetsGeometry.symmetric(vertical: 0, horizontal: 10),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    article != "" ?
                                    Text(article,
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500,
                                        overflow: TextOverflow.clip
                                      )
                                    ) :
                                    Text('No Description',
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500
                                      )
                                    ),
                                    Text(epc,
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w300
                                      )
                                    )
                                  ]
                                ),
                              )
                            // ),
                          // )
                        ),
                        Expanded(
                          flex: 3,
                          child: Center(
                            // child: Image.network(
                            //   'https://storeops.checkpointsystems.com/newstoreops/datamaster/T%20SHIRT%20WHITE.png')
                            child: urlImage != "" ? 
                            urlImage.substring(urlImage.length-4,urlImage.length)=='.png' || urlImage.substring(urlImage.length-5,urlImage.length)== ".jpeg" || urlImage.substring(urlImage.length-4,urlImage.length) == ".jpg"
                            ? Image.network(
                              urlImage,
                              width: 60,
                              height: 60,
                              fit: BoxFit.cover,
                              loadingBuilder: (context, child, loadingProgress) {
                                if(loadingProgress==null){
                                  return child;
                                }
                                return CircularProgressIndicator();
                              }
                            ):
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [ 
                                Icon(Icons.grid_off_sharp,
                                  color: AppTheme.extraColor,
                                  size: 40,                            
                                ),
                                Text('Image break', 
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontSize: 12,
                                    overflow: TextOverflow.clip
                                  )
                                )
                              ]
                            ):
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [ 
                                Icon(Icons.photo_size_select_actual_outlined,
                                  color: AppTheme.extraColor,
                                  size: 40,                            
                                ),
                                Text('Image unavailable', 
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontSize: 12,
                                    overflow: TextOverflow.clip
                                  )
                                )
                              ]
                            )
                          )
                        )
                      ]
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



