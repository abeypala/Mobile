import 'package:flutter/material.dart';
import 'package:kaladasava/models/chartdata.dart';
class TextBoxer{
  final ChartData cd;
  TextBoxer({@required this.cd});

List textLine(){
//INPUT
//var planetposition = [8,8,8,8,8,8,1,4,1,1,1,1];
//INPUT

//var planetletters = ['ර','ච','කු','බු','ගු','ශු','ශ','රා','කේ','යු','නැ','ප්'];
var chartboxpopulation =[0,0,0,0,0,0,0,0,0,0,0,0];//hold number of planets in a box

var letterpos = List.generate(12, (i) => List(12), growable: false);
//array with all the positions in a text string which goes to a box
letterpos[0] =[5,7,10,0,8,2,4,6,1,3,9,11];
letterpos[3] =[5,7,10,0,8,2,4,6,1,3,9,11];
letterpos[6] =[5,7,10,0,8,2,4,6,1,3,9,11];
letterpos[9] =[5,7,10,0,8,2,4,6,1,3,9,11];

letterpos[1] =[4,6,7,2,0,1,3,5,8];
letterpos[4] =[4,6,7,2,0,1,3,5,8];
letterpos[8] =[4,6,7,2,0,1,3,5,8];
letterpos[11] =[4,6,7,2,0,1,3,5,8];

letterpos[2] =[2,4,7,5,1,3,6,8,0];
letterpos[5] =[2,4,7,5,1,3,6,8,0];
letterpos[7] =[2,4,7,5,1,3,6,8,0];
letterpos[10] =[2,4,7,5,1,3,6,8,0];

var letterbreak = List.generate(12, (i) => List(2), growable: false);
//aray with where break point \n should insertet in text string
letterbreak[0] =[4,9];
letterbreak[3] =[4,9];
letterbreak[6] =[4,9];
letterbreak[9] =[4,9];

letterbreak[1] =[4,8];
letterbreak[4] =[4,8];
letterbreak[8] =[4,8];
letterbreak[11] =[4,8];

letterpos[2] =[0,3,7];
letterpos[5] =[0,3,7];
letterpos[7] =[0,3,7];
letterpos[10] =[0,3,7];


var planetinbox = List.generate(12, (i) => List(), growable: true);
//growable array holds plants char as an array for each box
    for (int i=0;i<12;i++){
      int pbox = 	this.cd.phouses[i];
      int pbpos = letterpos[pbox][chartboxpopulation[pbox]]; //planet in box, position
      chartboxpopulation[pbox]++;
      int pboxlength = planetinbox[pbox].length;
        if (pbpos>=pboxlength){
          for (int i=pboxlength;i<=pbpos;i++){
            planetinbox[pbox].add('');
          }
        }
      planetinbox[pbox][pbpos]=this.cd.pnames[i];
    }

List<String> textarr = List(12);

    for(int i=0;i<12;i++){
      for (int j=0;j<=planetinbox[i].length;j++){
        var z = [2,5,7,10];
        if(z.contains(i) && j==0){
          planetinbox[i].insert(j, '\n');
        }
        if(j==letterbreak[i][0]||j==letterbreak[i][1]){
          planetinbox[i].insert(j, '\n');
        }
      }

      textarr[i] =planetinbox[i].join(' ');
    }
    return textarr;
  }//method textLine
}//class TextBoxer