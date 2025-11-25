import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:path/path.dart';


class DbService {
  static Database? _db;

  static Future<Database> getDatabase() async {
    if (_db != null) return _db!;

    final path = join(await getDatabasesPath(), 'favorites.db');

    _db = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        return db.execute('CREATE TABLE favorites(id INTEGER PRIMARY KEY)');
      },
    );
    return _db!;
  }

  static Future<void> toggleFavorite(int id) async {
    final db = await getDatabase();
    final exists = await db.query(
      'favorites',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (exists.isEmpty) {
      await db.insert('favorites', {'id': id});
    } else {
      await db.delete('favorites', where: 'id = ?', whereArgs: [id]);
    }
  }

  static Future<List<int>> getFavorites() async {
    final db = await getDatabase();
    final result = await db.query('favorites');
    return result.map((e) => e['id'] as int).toList();
  }
}
