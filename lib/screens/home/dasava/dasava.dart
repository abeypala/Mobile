import 'package:flutter/material.dart';
import 'package:kaladasava/screens/home/dasava/tabchart.dart';
import 'package:kaladasava/screens/home/dasava/tabdasa.dart';
import 'package:kaladasava/screens/home/dasava/tabnaks.dart';
import 'package:kaladasava/menudrawer.dart';
import 'package:kaladasava/static/staticadd.dart';
import 'tabgraha.dart';

class Dasava extends StatefulWidget {
  final Map<String, Object> data;
  Dasava({ Key key, @required this.data, }) : super(key: key);
  @override
  _Dasava createState() => _Dasava(data);
}
class _Dasava extends State<Dasava> {
  int _pageIndex = 0;
  PageController _pageController;
  List<DropdownMenuItem>_lddmi;
  String _currentlySelectedItem='',pid='';
  List<Widget> tabPages;
    _Dasava(Map<String, Object> data){
      _pageIndex = data['page'];
      pid = data['pid'];
tabPages = [
  TabChart(),
  TabGraha(pid:pid),
  TabNaks(),
  TabDasa(),
];
    }




    @override
  void initState(){
    super.initState();
    _pageController = PageController(initialPage: _pageIndex); 
    _lddmi=StaticAdd().listfullBioData.map((value) => DropdownMenuItem(child: Text(value.name),value: value.pid,)).toList();
   _currentlySelectedItem = StaticAdd().selectedPid!=''?StaticAdd().selectedPid:_lddmi.length>0?_lddmi[0].value:'';
  } 

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Widget dropdownWidget() {
    return 
    
   DropdownButton(
       
                icon: Icon(Icons.people),
                items: _lddmi,
                onChanged: (value) {setState(() { _currentlySelectedItem = StaticAdd().selectedPid = value; print(value.toString());
                  Navigator.of(context).pop();         
                  Navigator.of(context).pushNamed('/dasava',arguments: {'page':_pageIndex,'pid':_currentlySelectedItem});                    
                });},
                isExpanded: false,//this wont make dropdown expanded and fill the horizontal space     
                value: _currentlySelectedItem,//make default value of dropdown the first value of our list 
              );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        title: Text('Dasava'),
        actions: <Widget>[
          dropdownWidget(),//Add the dropdown widget to the `Action` part of our appBar. it can also be Momong the `leading` part
        ]),
        
       bottomNavigationBar: BottomNavigationBar(         
                              currentIndex: _pageIndex,
                              onTap: onTabTapped, // this will be set when a new tab is tapped
                              type: BottomNavigationBarType.fixed,//if more than 3 items
                              items: [
                                BottomNavigationBarItem(
                                  icon: Icon(Icons.widgets),
                                  label: 'Charts',
                                ),
/*                                 BottomNavigationBarItem(
                                  icon: Icon(Icons.category),
                                  title: Text('Tathkala'),
                                ), */
                                BottomNavigationBarItem(
                                  icon: Icon(Icons.bubble_chart),
                                  label: 'Planets',
                                ),
                                BottomNavigationBarItem(
                                  icon: Icon(Icons.stars),
                                  label: 'Nakṣatra',
                                ), 
                                BottomNavigationBarItem(
                                  icon: Icon(Icons.list),
                                  label: 'Dasa'
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
         print(_currentlySelectedItem);
              print(page);
    setState(() {
      this._pageIndex = page;
    });
  }

  void onTabTapped(int index) {
    print(_currentlySelectedItem);
    this._pageController.animateToPage(index,duration: const Duration(milliseconds: 500),curve: Curves.easeInOut);
  }
}