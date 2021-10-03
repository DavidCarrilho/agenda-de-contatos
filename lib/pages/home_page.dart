import 'package:app_contact_book/model/model.dart';
import 'package:app_contact_book/pages/pages.dart';
import 'package:app_contact_book/providers/providers.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DatabaseProvider database = DatabaseProvider();
  List<Contact> contacts = List();

  @override
  void initState() {
    super.initState();
    _getAllContacts();
  }

  void _getAllContacts() {
    database.getAllContacts().then((list) {
      setState(() {
        contacts = list;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Contatos'),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showContactPage(),
        child: Icon(Icons.add),
      ),
      body: ListView.builder(
          padding: EdgeInsets.all(10.0),
          itemCount: contacts.length,
          itemBuilder: (context, index) {
            return _contactCard(context, index);
          }),
    );
  }

  Widget _contactCard(BuildContext context, int index) => GestureDetector(
        child: Card(
          child: Padding(
            padding: EdgeInsets.all(10.0),
            child: Row(
              children: [
                Container(
                  height: 80.0,
                  width: 80.0,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                          image: AssetImage('assets/images/person.png'),
                          fit: BoxFit.cover)),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        contacts[index].name ?? "",
                        style: TextStyle(
                            fontSize: 22.0, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        contacts[index].email ?? "",
                        style: TextStyle(
                            fontSize: 18.0, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        contacts[index].phone ?? "",
                        style: TextStyle(
                            fontSize: 18.0, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
        onTap: () => _showOptions(context, index),
      );

  _showOptions(BuildContext context, int index) => showModalBottomSheet(
        context: context,
        builder: (context) => BottomSheet(
          onClosing: () {},
          builder: (context) => Container(
            padding: EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _optionButton(
                  context,
                  'Editar',
                  () {
                    Navigator.pop(context);
                    _showContactPage(contact: contacts[index]);
                  },
                ),
                _optionButton(
                  context,
                  'Excluir',
                  () {
                    database.deleteContact((contacts[index].id));
                    setState(() {
                      contacts.removeAt(index);
                      Navigator.pop(context);
                    });
                  },
                )
              ],
            ),
          ),
        ),
      );

  _optionButton(BuildContext context, title, pressedFunction()) => Padding(
        padding: EdgeInsets.all(10.0),
        child: FlatButton(
          child: Text(
            title,
            style: TextStyle(
              color: Colors.blue,
              fontSize: 20.0,
            ),
          ),
          onPressed: pressedFunction,
        ),
      );

  void _showContactPage({Contact contact}) async {
    final recContact = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ContactPage(
          contact: contact,
        ),
      ),
    );
    if (recContact != null) {
      if (contact != null) {
        await database.updateContact(recContact);
      } else {
        await database.saveContact(recContact);
      }
      _getAllContacts();
    }
  }
}
