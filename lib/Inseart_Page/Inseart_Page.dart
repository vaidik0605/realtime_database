import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:realtime_database/View_Page/View_Page.dart';

class Insert_Page extends StatefulWidget {
  Map? map;
  Insert_Page({this.map});
  @override
  State<Insert_Page> createState() => _Insert_PageState();
}

class _Insert_PageState extends State<Insert_Page> {
  TextEditingController _tname = TextEditingController();
  TextEditingController _tcontect = TextEditingController();

  @override
  void initState() {
    if (widget.map != null) {
      _tname.text = widget.map!['name'];
      _tcontect.text = widget.map!['contect'];
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Navigator.pushReplacement(context, MaterialPageRoute(
          builder: (context) {
            return View_Page();
          },
        ));
        return Future.value();
      },
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
                onPressed: () {
                  Navigator.pushReplacement(context, MaterialPageRoute(
                    builder: (context) {
                      return View_Page();
                    },
                  ));
                },
                icon: Icon(Icons.arrow_back_rounded)),
            title: Text("Inseart Page"),
            centerTitle: true,
          ),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: _tname,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(), label: Text("Name")),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  maxLength: 10,
                  keyboardType: TextInputType.phone,
                  controller: _tcontect,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(), label: Text("Contect")),
                ),
              ),
              ElevatedButton(
                  onPressed: () {
                    String name = _tname.text;
                    String contect = _tcontect.text;
                    FirebaseDatabase database = FirebaseDatabase.instance;
                    if (widget.map == null) {
                      DatabaseReference ref =
                          database.ref("contactbook").push();
                      String? userid = ref.key;
                      Map m = {
                        'userid': userid,
                        'name': name,
                        'contect': contect
                      };

                      ref.set(m);

                      Navigator.pushReplacement(context, MaterialPageRoute(
                        builder: (context) {
                          return const View_Page();
                        },
                      ));
                    } else {
                      String userid = widget.map!['userid'];
                      DatabaseReference ref =
                          database.ref("contactbook").child(userid);
                      Map m = {
                        'userid': userid,
                        'name': name,
                        'contect': contect
                      };
                      ref.set(m);
                      Navigator.pushReplacement(context, MaterialPageRoute(
                        builder: (context) {
                          return const View_Page();
                        },
                      ));
                    }
                  },
                  child: widget.map == null
                      ? const Text("Insert")
                      : const Text("Update"))
            ],
          ),
        ),
      ),
    );
  }
}
