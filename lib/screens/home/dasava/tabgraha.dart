import 'package:flutter/material.dart';
import 'package:kaladasava/static/staticadd.dart';

class TabGraha extends StatefulWidget {
  final String pid;//rout
  TabGraha({ Key key, @required this.pid, }) : super(key: key);//rout
  @override
  _TabGraha createState() => _TabGraha(pid);
}
class _TabGraha extends State<TabGraha> {
 //String _name = StaticAdd().listfullBioData.where((e) => e.pid==StaticAdd().selectedPid).first.name;
 String _pid;
  _TabGraha(pid){
    _pid=pid;
  }
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child:Container(
  padding: EdgeInsets.all(15),
  child: RichText(   
          text: TextSpan(    
    			text: 'Wednesday, September 2, 2020\nMelbourne, Victoria, Australia \n\n',    
    			style: rtdB,    
    			children: <TextSpan>[   
    				TextSpan(text: 'Surya ${StaticAdd().selectedPid} doekaam dnekatha, 4 pada, \n\n',style: rtdA), 
            	TextSpan(text: 'Moon $_pid Makara Rasi mula trikona, doekaam dnekatha, 4 pada, \n\n',style: rtdA), 
              	TextSpan(text: 'Kuja 123.23123* 23*12\'45\"  Makara Rasi mula trikona, doekaam dnekatha, 4 pada, \n\n',style: rtdA), 
                      ]
    
        ),
    
      ),
),
    );
  }
}