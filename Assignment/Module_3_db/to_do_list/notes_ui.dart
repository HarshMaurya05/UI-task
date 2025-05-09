import 'package:flutter/material.dart';
import 'package:local_db_fl/db_helper_1.dart';

class Notes_ui extends StatefulWidget {
  const Notes_ui({super.key});

  @override
  State<Notes_ui> createState() => _Notes_uiState();
}

class _Notes_uiState extends State<Notes_ui> {
  List<Map<String, dynamic>> allNotes = [];
  DBHelper? dbRef;
  TextEditingController title = TextEditingController();
  TextEditingController desc = TextEditingController();

  @override
  void initState() {
    super.initState();
    dbRef = DBHelper.getInstance;
    getNotes();
  }

  void getNotes() async {
    allNotes = await dbRef!.getALLnotes();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("To- Do List")),

      //notes showed here
      body:
          allNotes.isNotEmpty
              ? ListView.builder(
                itemBuilder: (_, index) {
                  return ListTile(
                    leading: Text("${index + 1}"),
                    title: Text(allNotes[index][DBHelper.COLUMN_NOTE_TITLE]),
                    subtitle: Text(allNotes[index][DBHelper.COLUMN_NOTE_DESC]),
                    trailing: Container(
                      color: Colors.grey.shade50,
                      width: 100,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          IconButton(
                            onPressed: () {
                              // Set text to the controllers properly before showing bottom sheet
                              title.text =
                                  allNotes[index][DBHelper.COLUMN_NOTE_TITLE];
                              desc.text =
                                  allNotes[index][DBHelper.COLUMN_NOTE_DESC];

                              showModalBottomSheet(
                                context: context,
                                builder:
                                    (context) => Container(
                                      width: double.infinity,
                                      padding: EdgeInsets.all(16),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text("Update Here"),
                                          SizedBox(height: 20),

                                          TextField(
                                            controller: title,
                                            decoration: InputDecoration(
                                              focusedBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                borderSide: BorderSide(
                                                  color: Colors.black,
                                                  width: 0.5,
                                                ),
                                              ),
                                              label: Text("title"),
                                              hintText: "Add title",
                                            ),
                                          ),
                                          SizedBox(height: 10),

                                          TextField(
                                            controller: desc,
                                            decoration: InputDecoration(
                                              focusedBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                borderSide: BorderSide(
                                                  color: Colors.black,
                                                  width: 0.5,
                                                ),
                                              ),
                                              label: Text("Description"),
                                              hintText: "Add Description",
                                            ),
                                            maxLines: 3,
                                          ),
                                          SizedBox(height: 10),

                                          Row(
                                            children: [
                                              Expanded(
                                                child: ElevatedButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                    title.clear();
                                                    desc.clear();
                                                  },
                                                  child: Text("Cancel"),
                                                ),
                                              ),
                                              SizedBox(width: 10),
                                              Expanded(
                                                child: ElevatedButton(
                                                  onPressed: () async {
                                                    var snno =
                                                        allNotes[index][DBHelper
                                                            .COLUMN_NOTE_SNO];

                                                    bool check = await dbRef!
                                                        .updateNote(
                                                          utitle: title.text,
                                                          udesc: desc.text,
                                                          sno: snno,
                                                        );

                                                    if (check) {
                                                      getNotes();
                                                    }

                                                    Navigator.pop(context);
                                                    title.clear();
                                                    desc.clear();
                                                  },
                                                  child: Text("Update"),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                              );
                            },
                            icon: Icon(Icons.edit),
                          ),
                          IconButton(
                            onPressed: () async {
                              var snno =
                                  allNotes[index][DBHelper.COLUMN_NOTE_SNO];
                              bool check = await dbRef!.DdeleteNote(sno: snno);
                              if (check) {
                                getNotes();
                              }
                            },
                            icon: Icon(Icons.delete),
                          ),
                        ],
                      ),
                    ),
                  );
                },
                itemCount: allNotes.length,
              )
              : Center(child: Text("No Notes Yet!")),

      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          //Notes add form here
          showModalBottomSheet(
            context: context,
            builder:
                (context) => Container(
                  width: double.infinity,
                  child: Column(
                    children: [
                      Text("Title"),
                      SizedBox(height: 20),
                      TextField(
                        controller: title,
                        decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: BorderSide(
                              color: Colors.black,
                              width: 0.5,
                            ),
                          ),
                          label: Text("title"),
                        ),
                      ),
                      SizedBox(height: 20),

                      TextField(
                        controller: desc,
                        decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: BorderSide(
                              color: Colors.black,
                              width: 0.5,
                            ),
                          ),
                          label: Text("Description"),
                        ),
                        maxLines: 3,
                      ),

                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text("Cancel"),
                            ),
                          ),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () async {
                                var stitle = title.text;
                                var sdesc = desc.text;

                                if (stitle.isNotEmpty && sdesc.isNotEmpty) {
                                  bool check = await dbRef!.addNote(
                                    mtitle: stitle,
                                    mdesc: sdesc,
                                  );
                                  if (check) {
                                    getNotes();
                                  }
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        "All Fields Are Required!!",
                                      ),
                                    ),
                                  );
                                }
                                title.clear();
                                desc.clear();
                                Navigator.pop(context);
                              },
                              child: Text("Save"),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
