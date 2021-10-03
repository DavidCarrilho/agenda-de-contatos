import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'package:path/path.dart';

// Nome dos campos na tabela do banco de dados, por isso são constantes

final String contactTable = "contactTable";
final String idColumn = "idColumn";
final String nameColumn = "nameColumn";
final String emailColumn = "emailColumn";
final String phoneColumn = "phoneColumn";

///A classe DatabaseProvider cuidará especificamente
// das operações diretas ao banco de dados (criar, editar, remover,
// abrir e fechar conexão)
class DatabaseProvider {
  // construtor Singleton
  static final DatabaseProvider _instance = DatabaseProvider.internal();
  factory DatabaseProvider() => _instance;
  DatabaseProvider.internal();
  Database _db;

  Future<Database> get db async {
    if (_db != null) {
      return _db;
    } else {
      _db = await initDB();
      return _db;
    }
  }

  Future<Database> initDB() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, "contactsnew.db");

    return await openDatabase(
      path,
      version: 1,
      onCreate: (
        Database db,
        int newerVersion,
      ) async {
        await db.execute(
            "CREATE TABLE $contactTable($idColumn INTEGER PRIMARY KEY, $nameColumn TEXT, $emailColumn TEXT,$phoneColumn TEXT)");
      },
    );
  }

// saveContact cria uma "cópia" para si do objeto db e executa uma operação de inserção passando como
// parâmetros a tabela que deve receber os dados e os dados propriamente ditos tratados pelo método toMap()
  Future<Contact> saveContact(Contact contact) async {
    Database dbContact = await db;
    contact.id = await dbContact.insert(contactTable, contact.toMap());
    return contact;
  }
}

// Contact focará em representar a estrutura de dados do contato, estrutura tal que a
// DatabaseProvider utilizará para salvar no banco de dados as informações que forem
//cadastradas, editadas ou removidas pelo usuário
class Contact {
  int id;
  String name;
  String email;
  String phone;

  Contact();
  // Construtor que converte os dados de mapa (JSON) para objeto do contato
  Contact.fromMap(Map map) {
    id = map[idColumn];
    name = map[nameColumn];
    email = map[emailColumn];
    phone = map[phoneColumn];
  }

// Método que transforma o objeto do contato em Mapa (JSON) para armazenar no banco de dados
  Map toMap() {
    Map<String, dynamic> map = {
      nameColumn: name,
      emailColumn: email,
      phoneColumn: phone,
    };

// O id pode ser nulo caso o registro esteja sendo criado já que é o banco de dados que
// atribui o ID ao registro no ato de salvar. Por isso de vemos testar antes de atribuir
    if (id != null) {
      map[idColumn] = id;
    }
    return map;
  }
}
