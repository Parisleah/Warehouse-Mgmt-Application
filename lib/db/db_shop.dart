// import 'dart:async';
// import 'package:path/path.dart';
// import 'package:sqflite/sqflite.dart';

// import 'package:warehouse_mnmt/Page/Model/Shop.dart';

// class ShopsDatabase {
//   static final ShopsDatabase instance = ShopsDatabase._init();
//   static Database? _database;

//   ShopsDatabase._init();

//   Future<Database> get database async {
//     if (_database != null) return _database!;
//     _database = await _initDB('shops.db');
//     return _database!;
//   }

//   Future<Database> _initDB(String filePath) async {
//     final dbPath = await getDatabasesPath();
//     final path = join(dbPath, filePath);
//     return await openDatabase(path, version: 1, onCreate: _createDB);
//   }

//   Future _createDB(Database db, int version) async {
//     const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
//     const boolType = 'BOOLEAN NOT NULL';
//     const integerType = 'INTEGER NOT NULL';
//     const textType = 'TEXT NOT NULL';

//     await db.execute('''
// CREATE TABLE $tableShops (
//   ${ShopFields.id} $idType,
//   ${ShopFields.name} $textType,
//   ${ShopFields.phone} $textType,
//   ${ShopFields.image} $textType,
//   ${ShopFields.profileID} $integerType
//   )
// ''');
//   }

//   Future<Shop> create(Shop shop) async {
//     final db = await instance.database;

//     final id = await db.insert(tableShops, shop.toJson());
//     return shop.copy(id: id);
//   }

//   Future<Shop> readShop(int id) async {
//     final db = await instance.database;
//     final maps = await db.query(tableShops,
//         columns: ShopFields.values,
//         where: '${ShopFields.id} = ?',
//         whereArgs: [id]);
//     if (maps.isNotEmpty) {
//       return Shop.fromJson(maps.first);
//     } else {
//       throw Exception('ID $id not found');
//     }
//   }

//   Future<List<Shop>> readAllShops() async {
//     final db = await instance.database;
//     final orderBy = '${ShopFields.id} ASC';
//     // final result = await db.rawQuery('SELECT * FROM $tableShops ORDER BY $orderBy');
//     final result = await db.query(tableShops, orderBy: orderBy);
//     return result.map((json) => Shop.fromJson(json)).toList();
//   }

//   Future<int> update(Shop shop) async {
//     final db = await instance.database;
//     return db.update(tableShops, shop.toJson(),
//         where: '${ShopFields.id} = ?', whereArgs: [shop.id]);
//   }

//   Future<int> delete(int id) async {
//     final db = await instance.database;
//     return db
//         .delete(tableShops, where: '${ShopFields.id} = ?', whereArgs: [id]);
//   }

//   Future close() async {
//     final db = await instance.database;
//     db.close();
//   }
// }
