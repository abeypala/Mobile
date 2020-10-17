import 'package:flutter/material.dart';
import 'package:kaladasava/static/staticadd.dart';

class TabNaks extends StatelessWidget {
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
    				TextSpan(text: 'Denats nekatha mayura pakshi, Surya 123.23123* 23*12\'45\"  Makara Rasi mula trikona, doekaam dnekatha, 4 pada, Denats nekatha mayura pakshi, Surya 123.23123* 23*12\'45\"  Makara Rasi mula trikona, doekaam dnekatha, 4 pada, Denats nekatha mayura pakshi, Surya 123.23123* 23*12\'45\"  Makara Rasi mula trikona, doekaam dnekatha, 4 pada, Denats nekatha mayura pakshi, Surya 123.23123* 23*12\'45\"  Makara Rasi mula trikona, doekaam dnekatha, 4 pada, \n\n',style: rtdA), 
                      ]
    
        ),
    
      ),
),
    );
  }
}