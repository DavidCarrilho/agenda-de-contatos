// Contact focará em representar a estrutura de dados do contato, estrutura tal que a
// DatabaseProvider utilizará para salvar no banco de dados as informações que forem
//cadastradas, editadas ou removidas pelo usuário

// Nome dos campos na tabela do banco de dados, por isso são constantes

final String contactTable = "contactTable";
final String idColumn = "idColumn";
final String nameColumn = "nameColumn";
final String emailColumn = "emailColumn";
final String phoneColumn = "phoneColumn";

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
