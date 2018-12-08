import 'package:flutter/material.dart';
import 'CalendarPage.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: const Color(0xFFD50110),
        fontFamily: 'Lato',
      ),
      home: SearchPage(),
    );
  }
}

class SearchPage extends StatefulWidget {
  // SearchPage({Key key}) : super(key: key);
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  void _goToProfile() {}
  void _goToCalendar() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CalendarPage(),
      ),
    );
  }

  void _goToFilter() {}

  var color = Colors.transparent;
  var red = const Color(0xFFD50110);
  var lightRed = const Color(0x2FD50110);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text('Search'),
        leading: IconButton(
          icon: Icon(Icons.person),
          onPressed: _goToProfile,
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.filter_list),
            onPressed: _goToFilter,
          ),
          IconButton(
            padding: EdgeInsets.only(right: 15.0),
            icon: Icon(Icons.calendar_today),
            onPressed: _goToCalendar,
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            expandedHeight: 60,
            flexibleSpace: FlexibleSpaceBar(
              background: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  children: <Widget>[
                    Container(
                      child: TextField(
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Search for anything',
                          prefixIcon: Icon(Icons.search),
                        ),
                      ),
                      decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(const Radius.circular(4.0)),
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            floating: true,
            snap: true,
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                Card(
                  margin: EdgeInsets.all(10),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border(
                        left: BorderSide(color: red, width: 7),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: EdgeInsets.all(7),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'TRDA 1002',
                                  style: Theme.of(context)
                                      .textTheme
                                      .subtitle
                                      .copyWith(color: red),
                                ),
                                Text(
                                  'Languages of the Stage',
                                  style: Theme.of(context)
                                      .textTheme
                                      .title
                                      .copyWith(
                                          color: red,
                                          fontWeight: FontWeight.bold),
                                ),
                              ]),
                        ),
                        ListView(
                          padding: EdgeInsets.all(0),
                          shrinkWrap: true,
                          children: [
                            Container(
                              color: color,
                              child: GestureDetector(
                                onLongPress: () {
                                  setState(() {
                                    color = lightRed;
                                  });
                                },
                                child: ExpansionTile(
                                  title: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text('01', style: TextStyle(color: red)),
                                      Column(
                                        children: <Widget>[
                                          Row(
                                            children: [
                                              Container(
                                                width: 10,
                                                height: 10,
                                                color: red,
                                              ),
                                              Container(
                                                width: 10,
                                                height: 10,
                                                color: red,
                                              ),
                                              Container(
                                                width: 10,
                                                height: 10,
                                                color: red,
                                              ),
                                              Container(
                                                width: 10,
                                                height: 10,
                                                color: red,
                                              ),
                                              Container(
                                                width: 10,
                                                height: 10,
                                                color: red,
                                              ),
                                              Text("5:00-6:45",
                                                  style: TextStyle(color: red)),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Container(
                                                width: 10,
                                                height: 10,
                                                color: red,
                                              ),
                                              Container(
                                                width: 10,
                                                height: 10,
                                                color: red,
                                              ),
                                              Container(
                                                width: 10,
                                                height: 10,
                                                color: red,
                                              ),
                                              Container(
                                                width: 10,
                                                height: 10,
                                                color: red,
                                              ),
                                              Container(
                                                width: 10,
                                                height: 10,
                                                color: red,
                                              ),
                                              Text("12:00-1:45")
                                            ],
                                          ),
                                        ],
                                      ),
                                      Text('13919'),
                                    ],
                                  ),
                                  children: [
                                    Container(
                                      padding: EdgeInsets.fromLTRB(15,0,15,10),
                                      alignment: Alignment.centerLeft,
                                      child: Text('d'),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              child: GestureDetector(
                                onLongPress: () {
                                  print('d');
                                },
                                child: ExpansionTile(
                                  title: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text('01'),
                                      Column(
                                        children: <Widget>[
                                          Row(
                                            children: [
                                              Container(
                                                width: 10,
                                                height: 10,
                                                color: red,
                                              ),
                                              Container(
                                                width: 10,
                                                height: 10,
                                                color: red,
                                              ),
                                              Container(
                                                width: 10,
                                                height: 10,
                                                color: red,
                                              ),
                                              Container(
                                                width: 10,
                                                height: 10,
                                                color: red,
                                              ),
                                              Container(
                                                width: 10,
                                                height: 10,
                                                color: red,
                                              ),
                                              Text("5:00-6:45"),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Container(
                                                width: 10,
                                                height: 10,
                                                color: red,
                                              ),
                                              Container(
                                                width: 10,
                                                height: 10,
                                                color: red,
                                              ),
                                              Container(
                                                width: 10,
                                                height: 10,
                                                color: red,
                                              ),
                                              Container(
                                                width: 10,
                                                height: 10,
                                                color: red,
                                              ),
                                              Container(
                                                width: 10,
                                                height: 10,
                                                color: red,
                                              ),
                                              Text("12:00-1:45")
                                            ],
                                          ),
                                        ],
                                      ),
                                      Text('13919'),
                                    ],
                                  ),
                                  children: [
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 15.0),
                                      alignment: Alignment.centerLeft,
                                      child: Text('d'),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
