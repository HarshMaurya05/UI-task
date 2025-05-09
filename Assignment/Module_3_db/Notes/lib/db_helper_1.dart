import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper{
   //singleton
  DBHelper._(); // ._ for make private

static final DBHelper getInstance = DBHelper._();

//table column name
  static final String TABLE_NOTE = "note";
  static final String COLUMN_NOTE_SNO = "s_no";
  static final String COLUMN_NOTE_TITLE = "title";
  static final String COLUMN_NOTE_DESC = "desc";

Database? myDB;
//db open (path - if db exist open else create)

Future<Database> getDB() async{

  if(myDB!=null){
    return myDB!;
  }
  else{
    myDB = await openDB();
    return myDB!;
  }

}

Future<Database> openDB() async{

  Directory appdir =await getApplicationDocumentsDirectory();
  String dbPath = join(appdir.path,"note.db");

  return await openDatabase(dbPath, onCreate: (db , version){
    //create all table here
    db.execute("create table $TABLE_NOTE( $COLUMN_NOTE_SNO integer primary key autoincrement, $COLUMN_NOTE_TITLE text , $COLUMN_NOTE_DESC text)");

  },version: 1);
}


// all queries

// Insert
Future<bool> addNote({required String mtitle ,required String mdesc}) async{
  var db = await getDB();

 int rowsEffected = await  db.insert(TABLE_NOTE, {
    COLUMN_NOTE_TITLE : mtitle,
    COLUMN_NOTE_DESC : mdesc
  });

 return rowsEffected > 0;

}

//reading data (select * from )
Future<List<Map<String,dynamic>>> getALLnotes() async{
  var db = await getDB();

  List<Map<String,dynamic>> mData = await db.query(TABLE_NOTE);

  return mData;

}

//UPDATE HERE
Future<bool> updateNote({required String utitle,required String udesc,required int sno}) async{
  var db = await getDB();

  int RowsEffected = await db.update
    (TABLE_NOTE, {
    COLUMN_NOTE_TITLE : utitle,
    COLUMN_NOTE_DESC : udesc
  } , where: "$COLUMN_NOTE_SNO = $sno");
  return RowsEffected>0;

}

//DELETE HERE
Future<bool> DdeleteNote({required int sno})async{
  var db = await getDB();
 int RowsEffected= await db.delete(TABLE_NOTE,where: "$COLUMN_NOTE_SNO = ?" ,whereArgs: ['$sno']);
 return RowsEffected > 0;

}


}