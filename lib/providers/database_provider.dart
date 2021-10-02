// Nome dos campos na tabela do banco de dados, por isso são constantes
final String contactTable = "contactTable";
final String idColun = "idColumn";
final String nameColumn = "nameColumn";
final String emailColumn = "emailColumn";
final String phoneColumn = "phoneColumn";

///A classe DatabaseProvider cuidará especificamente
// das operações diretas ao banco de dados (criar, editar, remover,
// abrir e fechar conexão)
class DatabaseProvider {}

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
    id = map[idColun];
    name = map[nameColumn];
    email = map[emailColumn];
    phone = map[phoneColumn];
  }
}
