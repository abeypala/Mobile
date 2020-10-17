import 'package:flutter/material.dart';
import 'package:kaladasava/static/staticadd.dart';

class TabPancanga extends StatelessWidget {
  final String data;//rout
  TabPancanga({ Key key, @required this.data, }) : super(key: key);//rout

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(

      body:SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(15),
            decoration: BoxDecoration(
                          image: DecorationImage(
                          fit: BoxFit.fill,
                          image: AssetImage('assets/drawer/nightsky.jpg'))),          
            child: Column(
                  children: <Widget>[
                    Container(
                      width:150,
                      height:150,
                      decoration: BoxDecoration(
                        shape:BoxShape.circle,
                        image:DecorationImage(
                          image: AssetImage('assets/drawer/moon6.png'),
                          fit:BoxFit.fill,),
                        ),
                    ),
                  ],
            ),
          ),


Container(
  padding: EdgeInsets.all(15),
  child: RichText(   
          text: TextSpan(    
    			text: 'Pancanga For\n',    
    			style: rtdB,    
    			children: <TextSpan>[   
    				TextSpan(text: 'Melbourne, Victoria, Australia \n',style: rtdA),    
    				TextSpan(text: 'Wednesday, September 2, 2020 \n',style: rtdA),    
    				TextSpan(text: 'Sunrise:\t',style: rtdB),    
    				TextSpan(text: '6:32am\t\t',style: rtdA),    
    				TextSpan(text: 'Sunset:\t',style: rtdB),    
    				TextSpan(text: '6:55pm\n',style: rtdA),    
    				TextSpan(text: 'Moonrise:\t',style: rtdB),    
    				TextSpan(text: '10:32am\t\t',style: rtdA),    
    				TextSpan(text: 'Moonset:\t',style: rtdB),    
    				TextSpan(text: '2:32pm\n',style: rtdA),    
    				TextSpan(text: 'Tithi:\t\t',style: rtdB),    
    				TextSpan(text: 'Purnima upto 03:21 PM \n',style: rtdA),    
    				TextSpan(text: 'Nakshatra:\t\t',style: rtdB),    
    				TextSpan(text: 'Shatabhisha upto 11:04 PM \n',style: rtdA),    
    				TextSpan(text: 'Yoga:\t\t',style: rtdB),    
    				TextSpan(text: 'Sukarman upto 05:34 PM \n',style: rtdA),    
    				TextSpan(text: 'Karana:\t\t',style: rtdB),    
    				TextSpan(text: 'Bava upto 03:21 PM \n',style: rtdA),    
    				TextSpan(text: 'Paksha:\t\t',style: rtdB),    
    				TextSpan(text: 'Shukla/Pura Paksha \n',style: rtdA),    
    				TextSpan(text: 'Weekday:\t\t',style: rtdB),    
    				TextSpan(text: 'Budhawara \n',style: rtdA),    
          ]
    
        ),
    
      ),
),



          ],
        ),

      ),

     // ),



    );
  }
}