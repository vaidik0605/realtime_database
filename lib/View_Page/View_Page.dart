import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:realtime_database/Inseart_Page/Inseart_Page.dart';

class View_Page extends StatefulWidget {
  const View_Page({Key? key}) : super(key: key);

  @override
  State<View_Page> createState() => _View_PageState();
}

class _View_PageState extends State<View_Page> {
  // Query dbref = FirebaseDatabase.instance.ref().child('contactbook');
  Future<List> getdata() async {
    DatabaseReference ref = FirebaseDatabase.instance.ref("contactbook");

    DatabaseEvent event = await ref.once();

    DataSnapshot snapshot = event.snapshot;

    print(snapshot.value);

    Map m = snapshot.value as Map;
    List l = [];
    m.forEach((key, value) {
      l.add(value);
    });
    print(l);
    return l;
  }

  var isSelected = false;
  var mycolor = Colors.white;
  void toggleSelection() {
    setState(() {
      if (isSelected) {
        mycolor = Colors.white;
        isSelected = false;
      } else {
        mycolor = Colors.grey.shade300;
        isSelected = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("View Page"),
        centerTitle: true,
      ),
      // body: FirebaseAnimatedList(
      //   query: dbref,
      //   itemBuilder: (context, snapshot, animation, index) {
      //     Map m = snapshot.value as Map;
      //     return ListTile(
      //       leading: CircleAvatar(
      //         child: Text(m['name'].toString().toUpperCase().split("")[0]),
      //       ),
      //       title: Text("${m['name']}"),
      //       subtitle: Text("${m['contect']}"),
      //     );
      //   },
      // ),
      body: FutureBuilder(
        future: getdata(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              List l = snapshot.data as List;
              l.sort((a, b) => a['name']
                  .toString()
                  .toLowerCase()
                  .compareTo(b['name'].toString().toLowerCase()));
              return ListView.builder(
                physics: BouncingScrollPhysics(),
                itemCount: l.length,
                itemBuilder: (context, index) {
                  Map m = l[index];
                  user u = user.fromJson(m);
                  return ListTile(
                    onLongPress: toggleSelection,
                    onTap: () async {
                      print(m);
                      FlutterPhoneDirectCaller.callNumber(m['contect']);
                    },
                    leading: CircleAvatar(
                      child: Text(
                          "${u.name.toString().toUpperCase().split("")[0]}"),
                    ),
                    title: Text("${u.name}"),
                    subtitle: Text("${u.contect}"),
                    trailing: SizedBox(
                      width: 100,
                      child: Row(
                        children: [
                          IconButton(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: Text("Delete Contect"),
                                      actions: [
                                        ElevatedButton(
                                            onPressed: () {
                                              Navigator.pop(context);

                                              DatabaseReference ref =
                                                  FirebaseDatabase.instance
                                                      .ref("contactbook")
                                                      .child("${u.userid}");

                                              ref.remove();
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(const SnackBar(
                                                      duration: Duration(
                                                        seconds: 2,
                                                      ),
                                                      content: Text(
                                                          "Delete Successfully")));
                                              Navigator.pushReplacement(context,
                                                  MaterialPageRoute(
                                                builder: (context) {
                                                  return View_Page();
                                                },
                                              ));
                                            },
                                            style: ElevatedButton.styleFrom(
                                                side: const BorderSide(
                                                    color: Colors.black,
                                                    width: 2)),
                                            child: Text("Yes")),
                                        ElevatedButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            style: ElevatedButton.styleFrom(
                                                primary: Colors.grey,
                                                side: const BorderSide(
                                                    color: Colors.black,
                                                    width: 2)),
                                            child: Text("No")),
                                      ],
                                      content: const Text(
                                          "Are you sure to wanted to delete this contect?"),
                                    );
                                  },
                                );
                              },
                              icon: Icon(Icons.delete)),
                          IconButton(
                              onPressed: () {
                                Navigator.pushReplacement(context,
                                    MaterialPageRoute(
                                  builder: (context) {
                                    return Insert_Page(
                                      map: m,
                                    );
                                  },
                                ));
                              },
                              icon: Icon(Icons.update_rounded))
                        ],
                      ),
                    ),
                  );
                },
              );
            } else {
              return Center(child: Text("NO DATA FOUND"));
            }
          }

          return Center(child: CircularProgressIndicator());
        },
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.pushReplacement(context, MaterialPageRoute(
              builder: (context) {
                return Insert_Page();
              },
            ));
          },
          child: Icon(Icons.add)),
    );
  }
}

class user {
  String? contect;
  String? name;
  String? userid;

  user({this.contect, this.name, this.userid});

  user.fromJson(Map json) {
    contect = json['contect'];
    name = json['name'];
    userid = json['userid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['contect'] = this.contect;
    data['name'] = this.name;
    data['userid'] = this.userid;
    return data;
  }
}
