import 'package:flutter/material.dart';
import 'package:kaladasava/static/staticadd.dart';

class TabRahu extends StatelessWidget {
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
            TextSpan(text: 'Maru  East\n\n',style: rtdA), 

    				TextSpan(text: 'Rahu Kalaya\n',style: rtdA), 
    				TextSpan(text: 'From:\t',style: rtdB),    
    				TextSpan(text: '6:32am\t\t',style: rtdA),    
    				TextSpan(text: 'to:\t',style: rtdB),    
    				TextSpan(text: '6:55pm [day]\n',style: rtdA), 
    				TextSpan(text: 'From:\t',style: rtdB),    
    				TextSpan(text: '6:32am\t\t',style: rtdA),    
    				TextSpan(text: 'to:\t',style: rtdB),    
    				TextSpan(text: '6:55pm [night]\n\n',style: rtdA),    

     				TextSpan(text: 'Abhijit muhurtha\n',style: rtdA), 
    				TextSpan(text: 'From:\t',style: rtdB),    
    				TextSpan(text: '6:32am\t\t',style: rtdA),    
    				TextSpan(text: 'to:\t',style: rtdB),    
    				TextSpan(text: '6:55pm [day]\n',style: rtdA), 
    				TextSpan(text: 'From:\t',style: rtdB),    
    				TextSpan(text: '6:32am\t\t',style: rtdA),    
    				TextSpan(text: 'to:\t',style: rtdB),    
    				TextSpan(text: '6:55pm [night]\n\n',style: rtdA),   

     				TextSpan(text: 'Gulika Kalaya\n',style: rtdA), 
    				TextSpan(text: 'From:\t',style: rtdB),    
    				TextSpan(text: '6:32am\t\t',style: rtdA),    
    				TextSpan(text: 'to:\t',style: rtdB),    
    				TextSpan(text: '6:55pm [day]\n',style: rtdA), 
    				TextSpan(text: 'From:\t',style: rtdB),    
    				TextSpan(text: '6:32am\t\t',style: rtdA),    
    				TextSpan(text: 'to:\t',style: rtdB),    
    				TextSpan(text: '6:55pm [night]\n\n',style: rtdA), 


     				TextSpan(text: 'Yama Kalaya\n',style: rtdA), 
    				TextSpan(text: 'From:\t',style: rtdB),    
    				TextSpan(text: '6:32am\t\t',style: rtdA),    
    				TextSpan(text: 'to:\t',style: rtdB),    
    				TextSpan(text: '6:55pm [day]\n',style: rtdA), 
    				TextSpan(text: 'From:\t',style: rtdB),    
    				TextSpan(text: '6:32am\t\t',style: rtdA),    
    				TextSpan(text: 'to:\t',style: rtdB),    
    				TextSpan(text: '6:55pm [night]\n\n',style: rtdA), 

                              
            
            
            
            
                      ]
    
        ),
    
      ),
),
    );
  }
}