import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'empty_content.dart';

typedef ItemWidgetBuilder<T> = Widget Function(BuildContext context, T item);
class ListItemBuilder<T> extends StatelessWidget {
  //const ListItemBuilder<T>({Key? key}) : super(key: key);

  const ListItemBuilder({Key key,@required this.snapshot,@required this.itemBuilder}) : super(key: key);
  final AsyncSnapshot<List<T>> snapshot;
  final ItemWidgetBuilder<T> itemBuilder;

  @override
  Widget build(BuildContext context) {
    if(snapshot.hasData){
      final List<T> items = snapshot.data;
      if(items.isNotEmpty){
        return _buildList(items);
      } else{
        return EmptyContent();
      }
    } else if(snapshot.hasError){
      EmptyContent(
        title: 'Something went wrong',
        message: 'Can\'t load items right now',
      );
    }
    return Center(
      child: Text('No Report added',
      style: TextStyle(
        fontSize: 20.0,
        color: Colors.black,
      ),),
    );
  }

  Widget _buildList(List<T> items) {
    return ListView.separated(
      separatorBuilder: (context,index)=> Divider(height: 0.5),
      itemCount: items.length+2,
        itemBuilder: (context,index){
        if(index==0 || index==items.length+1){
          return Container();
        }
        return itemBuilder(context, items[index-1]);
      },
    );
  }
}
