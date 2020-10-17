import 'package:flutter/material.dart';
import 'package:kaladasava/bloc/drawer/textboxer.dart';
import 'package:kaladasava/models/chartdata.dart';
class ChartDrawer extends CustomPainter {

  final ChartData cd;
  ChartDrawer({@required this.cd});
    ChartData cdx = ChartData(phouses:[4,2,3,5,6,7,8,4,9,10,11,3],pnames:['ර','ච','කු','බු','ගු','ශු','ශ','රා','කේ','යු','නැ','ප්'],tatkala:true);

  @override
  void paint(Canvas canvas, Size size) {
    // Define a paint object
     final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0
      ..color = Colors.brown[200];
     final d0 = size.width;
     final d1 = 0.33333 * size.width;
     final d2 = 0.66666 * size.width;
     final o1 = size.width/77;
     final o2 = size.width/22;
     final o3 = size.width/13;



List<TextAlign> texAlign = List(12);
texAlign[0] = TextAlign.center;
texAlign[1] = TextAlign.right;
texAlign[2] = TextAlign.left;
texAlign[3] = TextAlign.center;
texAlign[4] = TextAlign.left;
texAlign[5] = TextAlign.right;
texAlign[6] = TextAlign.center;
texAlign[7] = TextAlign.left;
texAlign[8] = TextAlign.right;
texAlign[9] = TextAlign.center;
texAlign[10] = TextAlign.right;
texAlign[11] = TextAlign.left;


      //vertical lines
      final vla1 = Offset(d1,0);
      final vla2 = Offset(d1,d0);
      final vlb1 = Offset(d2,0);
      final vlb2 = Offset(d2,d0);
      //horizontal lines
      final hla1 = Offset(0,d1);
      final hla2 = Offset(d0,d1);
      final hlb1 = Offset(0,d2);
      final hlb2 = Offset(d0,d2);
      //diagonal lines
      final dla1 = Offset(0,0);
      final dla2 = Offset(d1,d1);
      final dlb1 = Offset(d0,0);
      final dlb2 = Offset(d2,d1);
      final dlc1 = Offset(d0,d0);
      final dlc2 = Offset(d2,d2);
      final dld1 = Offset(0,d0);
      final dld2 = Offset(d1,d2);      
      //Draw Chart
      canvas.drawLine(vla1, vla2, paint);
      canvas.drawLine(vlb1, vlb2, paint);
      canvas.drawLine(hla1, hla2, paint);
      canvas.drawLine(hlb1, hlb2, paint);
      canvas.drawLine(dla1, dla2, paint);
      canvas.drawLine(dlb1, dlb2, paint);
      canvas.drawLine(dlc1, dlc2, paint);
      canvas.drawLine(dld1, dld2, paint);

   //   print('Sun ${cd.sun}  Moon ${cd.moon} '); 
   //   print('Width $d0  Height ${size.height}'); 
      final List<String> tl = TextBoxer(cd: this.cd).textLine();
     // print('doube trouble $tl '); 
List<Offset> texOffset = List(12);
texOffset[0] = Offset(d1+o2, 0+o2);
texOffset[1] = Offset(o3, 0);
texOffset[2] = Offset(0, o1);
texOffset[3] = Offset(o2, d1+o2);
texOffset[4] = Offset(o1, d2);
texOffset[5] = Offset(o3, d2);
texOffset[6] = Offset(d1+o2, d2+o2);
texOffset[7] = Offset(d2 ,d2);
texOffset[8] = Offset(d2 + o3, d2);
texOffset[9] = Offset(d2+o2, d1+o2);
texOffset[10] = Offset(d2 + o3, 0);
texOffset[11] = Offset(d2, 0);


for (var i = 0; i <= 11; i++) { 
    //  print("Textloop: $i text ${tl[i]}"); 
    final textStyle = TextStyle(
      color: this.cd.tatkala==true? Colors.red[200]:Colors.brown[900],
      fontSize: 20,
      letterSpacing: 3,
    );
    //In here get text depend on angles
    final textSpan = TextSpan(
      text: tl[i],
      style: textStyle,
    );
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
      textAlign: texAlign[i],
    );
    textPainter.layout(
      minWidth: 0,
      maxWidth: d1 * 0.8 ,
    );

// final textPainter = new ChartTextPainter(cd: new ChartData(1.02,2.022)).tp();
      final offset = texOffset[i];
      textPainter.paint(canvas, offset);
  }


      final List<String> tl2 = TextBoxer(cd: this.cdx).textLine();
for (var i = 0; i <= 11; i++) { 
    //  print("Textloop: $i text ${tl[i]}"); 
    final textStyle = TextStyle(
      color: this.cdx.tatkala==true? Colors.red[200]:Colors.brown[900],
      fontSize: 20,
      letterSpacing: 3,
    );
    //In here get text depend on angles
    final textSpan = TextSpan(
      text: tl2[i],
      style: textStyle,
    );
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
      textAlign: texAlign[i],
    );
    textPainter.layout(
      minWidth: 0,
      maxWidth: d1 * 0.8 ,
    );

// final textPainter = new ChartTextPainter(cd: new ChartData(1.02,2.022)).tp();
      final offset = texOffset[i];
      textPainter.paint(canvas, offset);
  }
  




}
  @override
  bool shouldRepaint(ChartDrawer oldDelegate) => false;
}