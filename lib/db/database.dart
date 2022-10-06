import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:warehouse_mnmt/Page/Model/Product.dart';
import 'package:warehouse_mnmt/Page/Model/ProductModel.dart';
import 'package:warehouse_mnmt/Page/Model/ProductModel_ndProperty.dart';
import 'package:warehouse_mnmt/Page/Model/ProductModel_stProperty.dart';
import 'package:warehouse_mnmt/Page/Model/Purchasing_item.dart';

import 'package:warehouse_mnmt/Page/Model/Shop.dart';
import '../Page/Model/Dealer.dart';
import '../Page/Model/ProductCategory.dart';
import '../Page/Model/ProductLot.dart';

import '../Page/Model/Profile.dart';
import '../Page/Model/Purchasing.dart';

class DatabaseManager {
  static final DatabaseManager instance = DatabaseManager._init();
  static Database? _database;

  DatabaseManager._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('main17.db');
    return _database!;
  }

  // Initial DB
  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute(createTableProfile);
      await db.execute(createTableShop);
      await db.execute(createTableProduct);
      await db.execute(createTableProductCategory);
      await db.execute(createTableProductModel);
      await db.execute(createTableProductModel_stProperty);
      await db.execute(createTableProductModel_ndProperty);
      await db.execute(createTableProductLot);
      await db.execute(createTablePurchasing);
      await db.execute(createTablePurchasingItems);
      await db.execute(createTableDealer);
    });
  }

  static const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL';
  static const boolType = 'BOOLEAN NOT NULL';
  static const integerType = 'INTEGER';
  static const textType = 'TEXT';

  static final createTableProfile = """
  CREATE TABLE IF NOT EXISTS $tableProfile (
        ${ProfileFields.id} $idType,
  ${ProfileFields.name} $textType,
  ${ProfileFields.phone} $textType,
  ${ProfileFields.image} $textType,
  ${ProfileFields.pin} $textType
      );""";

  static final createTableShop = """
  CREATE TABLE IF NOT EXISTS $tableShop (
       ${ShopFields.shopid} $idType,
  ${ShopFields.name} $textType,
  ${ShopFields.phone} $textType,
  ${ShopFields.image} $textType,
  ${ShopFields.profileId} $integerType

      );""";
  // Product (6 Tables)
  static final createTableProduct = """
  CREATE TABLE IF NOT EXISTS $tableProduct (
       ${ProductFields.prodId} $idType,
  ${ProductFields.prodName} $textType,
  ${ProductFields.prodDescription} $textType,
  ${ProductFields.prodImage} $textType,
  ${ProductFields.prodCategId} $integerType,
  ${ProductFields.shopId} $integerType
      );""";

  static final createTableProductCategory = """
  CREATE TABLE IF NOT EXISTS $tableProductCategory (
  ${ProductCategoryFields.prodCategId} $idType,
  ${ProductCategoryFields.prodCategName} $textType,
  ${ProductCategoryFields.shopId} $integerType
      );""";

  static final createTableProductModel = """
  CREATE TABLE IF NOT EXISTS $tableProductModel (
  ${ProductModelFields.prodModelId} $idType,
  ${ProductModelFields.prodModelname} $textType,
  ${ProductModelFields.stProperty} $textType,
  ${ProductModelFields.ndProperty} $textType,
  ${ProductModelFields.cost} $integerType,
  ${ProductModelFields.price} $integerType,
  ${ProductModelFields.prodId} $integerType
      );""";
  static final createTableProductModel_stProperty = """
  CREATE TABLE IF NOT EXISTS $tableProductModel_stProperty (
  ${ProductModel_stPropertyFields.pmstPropId} $idType,
  ${ProductModel_stPropertyFields.pmstPropName} $textType,
  ${ProductModel_stPropertyFields.prodModelId} $integerType
      );""";
  static final createTableProductModel_ndProperty = """
  CREATE TABLE IF NOT EXISTS $tableProductModel_ndProperty (
  ${ProductModel_ndPropertyFields.pmndPropId} $idType,
  ${ProductModel_ndPropertyFields.pmndPropName} $textType,
  ${ProductModel_ndPropertyFields.prodModelId} $integerType
      );""";
  static final createTableProductLot = """
  CREATE TABLE IF NOT EXISTS $tableProductLot (
  ${ProductLotFields.prodLotId} $idType,
  ${ProductLotFields.orderedTime} $textType,
  ${ProductLotFields.amount} $integerType,
  ${ProductLotFields.remainAmount} $integerType,
  ${ProductLotFields.prodModelId} $integerType
      );""";
  // Product
  // Purchasing
  static final createTablePurchasing = """
  CREATE TABLE IF NOT EXISTS $tablePurchasing (
  ${PurchasingFields.purId} $idType,
  ${PurchasingFields.orderedDate} $textType,
  ${PurchasingFields.dealerId} $integerType,
  ${PurchasingFields.shippingId} $integerType,
  ${PurchasingFields.shippingCost} $integerType,
  ${PurchasingFields.amount} $integerType,
  ${PurchasingFields.total} $integerType,
  ${PurchasingFields.isReceive} $boolType
      );""";
  static final createTablePurchasingItems = """
  CREATE TABLE IF NOT EXISTS $tablePurchasingItems (
  ${PurchasingItemsFields.purItemsId} $idType,
  ${PurchasingItemsFields.prodId} $integerType,
  ${PurchasingItemsFields.amount} $integerType,
  ${PurchasingItemsFields.total} $integerType,
  ${PurchasingItemsFields.purId} $integerType
      );""";
  static final createTableDealer = """
  CREATE TABLE IF NOT EXISTS $tableDealer (
  ${DealerFields.dealerId} $idType,
  ${DealerFields.dName} $textType,
  ${DealerFields.dAddress} $textType,
  ${DealerFields.dPhone} $textType
      );""";

  // Purchasing

  // Future _createDB(Database db, int version) async {
  //   await db.execute(createTableProfile);
  //   await db.execute(createTableShop);
  //   await db.execute(createTableProduct);
  //   await db.execute(createTableProductCategory);
  // }

//   Future<void> DropTableIfExistsThenReCreate() async {
//     String filePath = 'main.db';
//     final dbPath = await getDatabasesPath();
//     final path = join(dbPath, filePath);

//     Database db = await openDatabase(path, onCreate: _createDB,
//         onUpgrade: (db, oldVersion, newVersion) async {
//       var batch = db.batch();
//       if (oldVersion == 1) {
//         // We update existing table and create the new tables
//         _createTableProdCategory(batch);
//       }
//       await batch.commit();
//     });
//     await db.execute("DROP TABLE IF EXISTS $tableProfile");

//     const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL';
//     const boolType = 'BOOLEAN NOT NULL';
//     const integerType = 'INTEGER NOT NULL';
//     const textType = 'TEXT NOT NULL';

//     await db.execute('''
// CREATE TABLE $tableProfile (
//   ${ProfileFields.id} $idType,
//   ${ProfileFields.name} $textType,
//   ${ProfileFields.phone} $textType,
//   ${ProfileFields.image} $textType,
//   ${ProfileFields.pin} $textType
//   )
// ''');
//     await db.execute('''
// CREATE TABLE $tableShop (
//   ${ShopFields.shopid} $idType,
//   ${ShopFields.name} $textType,
//   ${ShopFields.phone} $textType,
//   ${ShopFields.image} $textType,
//   ${ShopFields.profileId} $integerType
//   )
// ''');
//   }

  void _createTableProdCategory(Batch batch) {
    batch.execute(createTableProductCategory);
  }

  // Profile
  Future<Profile> createProfile(Profile profile) async {
    final db = await instance.database;

    final id = await db.insert(tableProfile, profile.toJson());
    return profile.copy(id: id);
  }

  Future<List<Profile>> readAllProfiles() async {
    final db = await instance.database;
    final orderBy = '${ProfileFields.id} ASC';
    // final result = await db.rawQuery('SELECT * FROM $tableShops ORDER BY $orderBy');
    final result = await db.query(tableProfile, orderBy: orderBy);
    print(result);
    return result.map((json) => Profile.fromJson(json)).toList();
  }

  Future<Profile?> readProfile(int id) async {
    final db = await instance.database;
    final maps = await db.query(tableProfile,
        columns: ProfileFields.values,
        where: '${ProfileFields.id} = ?',
        whereArgs: [id]);

    if (maps.isNotEmpty) {
      print('Found -> ${maps}');
      return Profile.fromJson(maps.first);
    } else {
      return null;
      throw Exception('ID $id not found');
    }
  }

  Future<int> updateProfile(Profile profile) async {
    final db = await instance.database;
    return db.update(tableProfile, profile.toJson(),
        where: '${ProfileFields.id} = ?', whereArgs: [profile.id]);
  }

  Future<int> deleteProfile(int id) async {
    final db = await instance.database;
    return db.delete(tableProfile,
        where: '${ProfileFields.id} = ?', whereArgs: [id]);
  }

  // Profile

  // Shop
  Future<Shop> createShop(Shop shop) async {
    final db = await instance.database;

    final id = await db.insert(tableShop, shop.toJson());
    return shop.copy(shopid: id);
  }

  Future<List<Shop>> readAllShops() async {
    final db = await instance.database;
    final orderBy = '${ShopFields.shopid} ASC';
    final result = await db.query(tableShop, orderBy: orderBy);
    return result.map((json) => Shop.fromJson(json)).toList();
  }

  Future<Shop> readShop(int id) async {
    final db = await instance.database;
    final maps = await db.query(tableShop,
        columns: ShopFields.values,
        where: '${ShopFields.shopid} = ?',
        whereArgs: [id]);

    if (maps.isNotEmpty) {
      print('Found -> ${maps}');
      return Shop.fromJson(maps.first);
    } else {
      throw Exception('ID $id not found');
    }
  }

  Future<int> updateShop(Shop shop) async {
    final db = await instance.database;
    return db.update(tableShop, shop.toJson(),
        where: '${ShopFields.shopid} = ?', whereArgs: [shop.shopid]);
  }

  Future<int> deleteShop(int id) async {
    final db = await instance.database;
    return db
        .delete(tableShop, where: '${ShopFields.shopid} = ?', whereArgs: [id]);
  }

// Shop
// Product
  Future<List<Product>> readAllProducts(int shopId) async {
    final db = await instance.database;
    final orderBy = '${ProductFields.prodId} DESC';
    final result = await db.query(tableProduct,
        columns: ProductFields.values,
        where: '${ProductFields.shopId} = ?',
        whereArgs: [shopId],
        orderBy: orderBy);
    print(result);
    return result.map((json) => Product.fromJson(json)).toList();
  }

  Future<List<Product>> readAllProductsByName(int shopId, name) async {
    final db = await instance.database;
    final orderBy = '${ProductFields.prodId} ASC';

    final result = await db.rawQuery(
        "SELECT * FROM $tableProduct WHERE ${ProductFields.prodName} LIKE '${name}%'");
    print(result);
    return result.map((json) => Product.fromJson(json)).toList();
  }

  Future<List<Product>> readAllProductsByCategory(
      int shopId, int categoryId) async {
    final db = await instance.database;
    final orderBy = '${ProductFields.prodId} DESC';

    final result = await db.rawQuery(
        "SELECT * FROM $tableProduct WHERE ${ProductFields.prodCategId} = ${categoryId} ORDER BY ${orderBy}");
    print(result);
    return result.map((json) => Product.fromJson(json)).toList();
  }

  Future<Product> createProduct(Product product) async {
    final db = await instance.database;
    final id = await db.insert(tableProduct, product.toJson());
    return product.copy(prodId: id);
  }

  Future<int> updateProduct(Product product) async {
    final db = await instance.database;
    return db.update(tableProduct, product.toJson(),
        where: '${ProductFields.prodId} = ?', whereArgs: [product.prodId]);
  }

  Future<int> deleteProduct(int id) async {
    final db = await instance.database;
    return db.delete(tableProduct,
        where: '${ProductFields.prodId} = ?', whereArgs: [id]);
  }

// Product

// ProductCategory
  Future<ProductCategory> createProductCategory(
      ProductCategory prodCateg) async {
    final db = await instance.database;
    final id = await db.insert(tableProductCategory, prodCateg.toJson());
    return prodCateg.copy(prodCategId: id);
  }

  Future<List<ProductCategory>> readProductCategoryReturnName(
      int prodId) async {
    final db = await instance.database;
    final result = await db.rawQuery(
        "SELECT ${ProductCategoryFields.prodCategName} FROM $tableProductCategory WHERE ${ProductCategoryFields.prodCategId} = ${prodId}");
    print(result);
    return result.map((json) => ProductCategory.fromJson(json)).toList();
  }

  Future<List<ProductCategory>> readAllProductCategorys(int shopId) async {
    final db = await instance.database;
    final orderBy = '${ProductCategoryFields.prodCategId} DESC';
    final result = await db.query(tableProductCategory,
        columns: ProductCategoryFields.values,
        where: '${ProductCategoryFields.shopId} = ?',
        orderBy: orderBy,
        whereArgs: [shopId]);
    print(result);
    return result.map((json) => ProductCategory.fromJson(json)).toList();
  }

  Future<int> deleteProductCategory(int id) async {
    final db = await instance.database;
    return db.delete(tableProductCategory,
        where: '${ProductCategoryFields.prodCategId} = ?', whereArgs: [id]);
  }

// ProductCategory
// ProductModel
  Future<ProductModel> createProductModel(ProductModel prodModel) async {
    final db = await instance.database;
    final id = await db.insert(tableProductModel, prodModel.toJson());
    return prodModel.copy(prodModelId: id);
  }

  Future<List<ProductModel>> readAllProductModels() async {
    final db = await instance.database;
    final orderBy = '${ProductModelFields.prodModelId} ASC';
    final result = await db.query(tableProductModel, orderBy: orderBy);
    return result.map((json) => ProductModel.fromJson(json)).toList();
  }

  Future<List<ProductModel>> readAllProductModelsInProduct(int prodId) async {
    final db = await instance.database;
    final orderBy = '${ProductModelFields.prodModelId} ASC';
    final result = await db.query(tableProductModel,
        columns: ProductModelFields.values,
        where: '${ProductModelFields.prodId} = ?',
        orderBy: orderBy,
        whereArgs: [prodId]);

    return result.map((json) => ProductModel.fromJson(json)).toList();
  }

  Future<int> deleteProductModel(int id) async {
    final db = await instance.database;
    return db.delete(tableProductModel,
        where: '${ProductModelFields.prodModelId} = ?', whereArgs: [id]);
  }
  // 1st Property

  Future<ProductModel_stProperty> create1stProperty(
      ProductModel_stProperty property) async {
    final db = await instance.database;
    final id = await db.insert(tableProductModel_stProperty, property.toJson());
    return property.copy(pmstPropId: id);
  }

  Future<List<ProductModel_stProperty>> readAll1stProperty(
      int prodModelID) async {
    final db = await instance.database;
    final orderBy = '${ProductModel_stPropertyFields.pmstPropId} ASC';
    final result = await db.query(tableProductModel_stProperty,
        columns: ProductModel_stPropertyFields.values,
        where: '${ProductModel_stPropertyFields.prodModelId} = ?',
        whereArgs: [prodModelID],
        orderBy: orderBy);
    return result
        .map((json) => ProductModel_stProperty.fromJson(json))
        .toList();
  }

  Future<int> update1stProperty(ProductModel_stProperty property) async {
    final db = await instance.database;
    return db.update(tableProductModel_stProperty, property.toJson(),
        where: '${ProductModel_stPropertyFields.pmstPropId} = ?',
        whereArgs: [property.pmstPropId]);
  }

  Future<int> delete1stProperty(int id) async {
    final db = await instance.database;
    return db.delete(tableProduct,
        where: '${ProductFields.prodId} = ?', whereArgs: [id]);
  }

  // 1st Property

  // 2nd Property
  Future<ProductModel_ndProperty> create2ndProperty(
      ProductModel_ndProperty property) async {
    final db = await instance.database;
    final id = await db.insert(tableProductModel_ndProperty, property.toJson());
    return property.copy(pmndPropId: id);
  }

  Future<List<ProductModel_ndProperty>> readAll2ndProperty(
      int prodModelID) async {
    final db = await instance.database;
    final orderBy = '${ProductModel_ndPropertyFields.pmndPropId} ASC';
    final result = await db.query(tableProductModel_ndProperty,
        columns: ProductModel_ndPropertyFields.values,
        where: '${ProductModel_ndPropertyFields.prodModelId} = ?',
        whereArgs: [prodModelID],
        orderBy: orderBy);
    return result
        .map((json) => ProductModel_ndProperty.fromJson(json))
        .toList();
  }

  Future<int> update2ndProperty(ProductModel_ndProperty property) async {
    final db = await instance.database;
    return db.update(tableProductModel_ndProperty, property.toJson(),
        where: '${ProductModel_ndPropertyFields.pmndPropId} = ?',
        whereArgs: [property.pmndPropId]);
  }

  Future<int> delete2ndProperty(int id) async {
    final db = await instance.database;
    return db.delete(tableProductModel_ndProperty,
        where: '${ProductModel_ndPropertyFields.pmndPropId} = ?',
        whereArgs: [id]);
  }
  // 2nd Property

  // Product lot ????????????????????????????????????????????
  // ?
  // Product lot ????????????????????????????????????????????

  // Purchasing
  Future<PurchasingModel> createPurchasing(PurchasingModel pur) async {
    final db = await instance.database;
    final id = await db.insert(tablePurchasing, pur.toJson());
    return pur.copy(pruId: id);
  }

  Future<int> updatePurchasing(PurchasingModel pur) async {
    final db = await instance.database;
    return db.update(tablePurchasing, pur.toJson(),
        where: '${PurchasingFields.purId} = ?', whereArgs: [pur.purId]);
  }

  Future<int> deletePurchasing(int purId) async {
    final db = await instance.database;
    return db.delete(tablePurchasing,
        where: '${PurchasingFields.purId} = ?', whereArgs: [purId]);
  }

  // PurchasingItems
  Future<PurchasingItemsModel> createPurchasingItem(
      PurchasingItemsModel purItem) async {
    final db = await instance.database;
    final id = await db.insert(tablePurchasingItems, purItem.toJson());
    return purItem.copy(pruItemsId: id);
  }

  Future<int> updatePurchasingItem(PurchasingItemsModel purItem) async {
    final db = await instance.database;
    return db.update(tablePurchasingItems, purItem.toJson(),
        where: '${PurchasingItemsFields.purItemsId} = ?',
        whereArgs: [purItem.purItemsId]);
  }

  Future<int> deletePurchasingItem(int purItemId) async {
    final db = await instance.database;
    return db.delete(tablePurchasingItems,
        where: '${PurchasingItemsFields.purItemsId} = ?',
        whereArgs: [purItemId]);
  }
  // PurchasingItems

  // Dealers
  Future<List<DealerModel>> readAllDealers() async {
    final db = await instance.database;
    final orderBy = '${DealerFields.dealerId} DESC';
    final result = await db.query(tableDealer, orderBy: orderBy);
    print(result);
    return result.map((json) => DealerModel.fromJson(json)).toList();
  }

  Future<DealerModel> createDealer(DealerModel dealer) async {
    final db = await instance.database;
    final id = await db.insert(tableDealer, dealer.toJson());
    return dealer.copy(dealerId: id);
  }

  Future<int> updateDealer(DealerModel dealer) async {
    final db = await instance.database;
    return db.update(tableDealer, dealer.toJson(),
        where: '${DealerFields.dealerId} = ?', whereArgs: [dealer.dealerId]);
  }

  Future<int> deleteDealer(int dealerId) async {
    final db = await instance.database;
    return db.delete(tableDealer,
        where: '${DealerFields.dealerId} = ?', whereArgs: [dealerId]);
  }
  // Dealers

  // Purchasing

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
