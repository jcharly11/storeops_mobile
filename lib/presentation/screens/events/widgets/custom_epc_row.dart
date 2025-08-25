import 'package:flutter/material.dart';
import 'package:storeops_mobile/config/theme/app_theme.dart';

class CustomEpcRow extends StatelessWidget {
  final String article;
  final String epc;
  final String urlImage;

  const CustomEpcRow({super.key, required this.article, required this.epc, required this.urlImage});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 7,
          child: 
            Padding(
              padding: EdgeInsetsGeometry.symmetric(vertical: 2, horizontal: 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  article != "" ?
                  Text(article,
                  style: TextStyle(
                    fontSize: 12,
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
              )
            )
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
                      size: 40             
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
                      size: 40             
                    ),
                    Text('Image unavailable', 
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppTheme.buttonsColor,
                        fontSize: 12,
                        overflow: TextOverflow.clip
                      )
                    )
                  ]
                )
            )
          )
        ]
      );
    }
  }