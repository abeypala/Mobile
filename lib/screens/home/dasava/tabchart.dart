import 'package:flutter/material.dart';
import 'package:kaladasava/bloc/drawer/chartdrawer.dart';
import 'package:kaladasava/models/chartdata.dart';

class TabChart extends StatefulWidget {
  @override
  _TabChart createState() => _TabChart();
}
class _TabChart extends State<TabChart> {
  String _currentlySelected = '';
    final List<String> _dropdownValues = [
'D-00\tRasi-Tatkala',
'D-01\tRasi',
'D-02\tHora',
'D-03\tDrekkana',
'D-04\tChaturthamsa',
'D-05\tPanchamsa',
'D-06\tShasthamsa',
'D-07\tSaptamsa',
'D-08\tAshtamsa',
'D-09\tNavamsa',
'D-10\tDasamsa',
'D-11\tEkaDasamsa',
'D-12\tDvadasamsa',
'D-16\tShodasamsa',
'D-20\tVimsamsa',
'D-24\tChaturVimsamsa',
'D-27\tSaptaVimsamsa',
'D-30\tTrimsamsa',
'D-40\tKhaVedamsa',
'D-45\tAkshaVedamsa',
'D-60\tShastiamsa',
'D-81\tNavNavamsa',
'D-108\tAstottaramsa',
'D-144\tDvadasamsa2'
  ];
_TabChart(){
  _currentlySelected=_dropdownValues[0];
}
  @override
  Widget build(BuildContext context) {
    
    ChartData cd = ChartData(phouses:[8,8,8,8,8,8,1,7,1,1,1,1],pnames:['ර','ච','කු','බු','ගු','ශු','ශ','රා','කේ','යු','නැ','ප්'],tatkala:false);
    return Scaffold(
floatingActionButton: FloatingActionButton(
      elevation: 1.0,
      child: Icon(Icons.swap_calls),
      onPressed: () {
                print('tatkala');
              },
    ),
    body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[

          DropdownButton(               
                icon: Icon(Icons.apps,),
                items: _dropdownValues.map((value) => DropdownMenuItem(child: Text(value),value: value,)).toList(),          
                onChanged: (String value) {setState(() { _currentlySelected = value;});},
                isExpanded: false,//this wont make dropdown expanded and fill the horizontal space     
                value: _currentlySelected,//make default value of dropdown the first value of our list
              ),
          LayoutBuilder(
            // Inner yellow container
            builder: (_, constraints) => Container(
              width: constraints.widthConstraints().maxWidth,
              height: constraints.widthConstraints().maxWidth,              
              //height: constraints.heightConstraints().maxHeight,
              color: Colors.yellow[10],
              child: CustomPaint(painter: ChartDrawer(cd:cd),),
            ),
          ),

          ],
        ),
    ),
        );
  }
}