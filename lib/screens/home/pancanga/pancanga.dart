import 'package:flutter/material.dart';
import 'package:kaladasava/menudrawer.dart';
import 'package:kaladasava/screens/home/pancanga/tabpancanga.dart';
import 'package:kaladasava/screens/home/pancanga/tabrahu.dart';


class Pancanga extends StatefulWidget {
  //final String data;//rout
  Pancanga({ Key key}) : super(key: key);//rout
  @override
  _Pancanga createState() => _Pancanga();
}
class _Pancanga extends State<Pancanga> {
    int _pageIndex = 0;
   // String _data;
  PageController _pageController;

  List<Widget> tabPages = [
    TabPancanga(data:'no need'),
    TabRahu()
  ];

    @override
  void initState(){
    super.initState();
    _pageController = PageController(initialPage: _pageIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  _Pancanga();//rout

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(title: Text('Pancanga')),       
      bottomNavigationBar: BottomNavigationBar(         
                              currentIndex: _pageIndex,
                              onTap: onTabTapped, // this will be set when a new tab is tapped
                              type: BottomNavigationBarType.fixed,//if more than 3 items
                              items: [
                                BottomNavigationBarItem(
                                  icon: Icon(Icons.widgets),
                                  label: 'Pancanga',
                                ),
                                BottomNavigationBarItem(
                                  icon: Icon(Icons.list),
                                  label: 'Rahu'
                                )
                              ],
                              
                            ),
      
      drawer: MenuDrawer(),
      body: PageView(
        children: tabPages,
        onPageChanged: onPageChanged,
        controller: _pageController,
      ),
    
    );
  }




    void onPageChanged(int page) {
    setState(() {
      this._pageIndex = page;
    });
  }

  void onTabTapped(int index) {
    this._pageController.animateToPage(index,duration: const Duration(milliseconds: 500),curve: Curves.easeInOut);
  }
}