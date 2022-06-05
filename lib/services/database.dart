import 'dart:async';
import 'package:sqflite/sqflite.dart';
class MyDatabase{

   String savedMoviesTable = 'savedMovies';
   String savedSeriesTable ='savedSeries';

   Database? db;
   int get _version => 1;


   Future<void> init() async {
     print('Called init');
    if (db != null) { return; }

      String _path = await getDatabasesPath() + 'savedMoviesDB';
      db = await openDatabase(_path, version: _version, onCreate: onCreate);

  }

   void onCreate(Database db, int version) async {
     await db.execute(
         'CREATE TABLE $savedMoviesTable (id INTEGER PRIMARY KEY, movieID INTEGER)');

     await db.execute(
         'CREATE TABLE $savedSeriesTable (id INTEGER PRIMARY KEY, seriesID INTEGER)');

     print('Created DB');

   }


   Future<List<Map<String, dynamic>>> query(String table) async => db!.query(table);


    Future<int> insert(int id,String tableName) async {

      if(tableName == savedMoviesTable){
       return await db!.insert(savedMoviesTable, {'movieID': id});
      }else{
       return await db!.insert(savedSeriesTable, {'seriesID': id});
      }
    }

   Future<int> delete(int id,String tableName) async {

     if(tableName == savedMoviesTable) {
       return await db!.delete(savedMoviesTable, where: 'movieID = ?', whereArgs: [id]);
     }else{
       return await db!.delete(savedSeriesTable, where: 'seriesID = ?', whereArgs: [id]);

     }

   }


}