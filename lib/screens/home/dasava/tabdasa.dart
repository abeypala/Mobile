import 'package:dynamic_treeview/dynamic_treeview.dart';
import 'package:flutter/material.dart';
//import 'package:intl/intl.dart';
import 'package:kaladasava/models/treeleaf.dart';
class TabDasa extends StatefulWidget {
  @override
  _TabDasa createState() => _TabDasa();
}

 class _TabDasa extends State<TabDasa> {

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: DynamicTreeView(
          data: getData(),
          config: Config(
              parentTextStyle:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
              rootId: "1",
              parentPaddingEdgeInsets:
                  EdgeInsets.only(left: 16, top: 0, bottom: 0)),
          width: MediaQuery.of(context).size.width,
        ),
      ),
    );
  }



List<BaseData> getData() {
  return [
    TreeLeaf(
      id: 1,
      name: 'Root',
      parentId: -1,
      extras: {'key': 'extradata1'},
    ),
    TreeLeaf(
      id: 2,
      name: 'Men',
      parentId: 1
    ),
    TreeLeaf(
      id: 3,
      name: 'Shorts',
      parentId: 2,
      extras: {'key': 'extradata3'},
    ),
    TreeLeaf(
      id: 4,
      name: 'Shoes',
      parentId: 2,
      extras: {'key': 'extradata4'},
    ),
    TreeLeaf(
      id: 5,
      name: 'Women',
      parentId: 1,
      extras: {'key': 'extradata5'},
    ),
    TreeLeaf(
      id: 6,
      name: 'Shoes',
      parentId: 5,
      extras: {'key': 'extradata6'},
    ),
    TreeLeaf(
      id: 7,
      name: 'Shorts',
      parentId: 5,
      extras: {'key': 'extradata7'},
    ),
    TreeLeaf(
      id: 8,
      name: 'Tops',
      parentId: 5,
      extras: {'key': 'extradata8'},
    ),
    TreeLeaf(
      id: 222,
      name: 'Electronics',
      parentId: 1,
      extras: {'key': 'extradata9'},
    ),
    TreeLeaf(
      id: 10,
      name: 'Phones',
      parentId: 9,
      extras: {'key': 'extradata10'},
    ),
    TreeLeaf(
      id: 11,
      name: 'Tvs',
      parentId: 9,
      extras: {'key': 'extradata11'},
    ),
    TreeLeaf(
      id: 12,
      name: 'Laptops',
      parentId: 9,
      extras: {'key': 'extradata12'},
    ),
    TreeLeaf(
      id: 13,
      name: 'Nike shooes',
      parentId: 4,
      extras: {'key': 'extradata13'},
    ),
    TreeLeaf(
      id: 14,
      name: 'puma shoes',
      parentId: 4,
      extras: {'key': 'extradata14'},
    ),
    TreeLeaf(
      id: 15,
      name: 'puma shoes 1',
      parentId: 14,
      extras: {'key': 'extradata15'},
    ),
    TreeLeaf(
      id: 16,
      name: 'puma shoes 2',
      parentId: 14,
      extras: {'key': 'extradata16'},
    ),
    TreeLeaf(
      id: 17,
      name: 'puma shoes 3',
      parentId: 14,
      extras: {'key': 'extradata17'},
    ),
    TreeLeaf(
      id: 211,
      name: 'QMen',
      parentId: 1
    ),

  ];
}

}