import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _professionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Flutter Demo Home Page')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _lastNameController,
                    keyboardType: TextInputType.name,
                    decoration: InputDecoration(
                        icon: Icon(Icons.person),
                        hintText: "Quel est votre nom ?",
                        labelText: "Nom *"),
                    validator: (String? value) {
                      return (value == null || value == "")
                          ? "Ce Champ est obligatoire"
                          : null;
                    },
                  ),
                  TextFormField(
                    controller: _firstNameController,
                    keyboardType: TextInputType.name,
                    decoration: InputDecoration(
                        icon: Icon(Icons.person),
                        hintText: "Quel est votre prenom ?",
                        labelText: "Prénom *"),
                    validator: (String? value) {
                      return (value == null || value == "")
                          ? "Ce Champ est obligatoire"
                          : null;
                    },
                  ),
                  TextFormField(
                    controller: _professionController,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                        icon: Icon(Icons.work),
                        hintText: "Quel est votre profession ?",
                        labelText: "Profession *"),
                    validator: (String? value) {
                      return (value == null || value == "")
                          ? "Ce Champ est obligatoire"
                          : null;
                    },
                  )
                ],
              )),
          ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  final prefs=await SharedPreferences.getInstance();
                  prefs.setString("lastName", _lastNameController.text);
                  prefs.setString('firstName', _firstNameController.text);
                  prefs.setString("profession", _professionController.text);
                  //affichage du toast
                  Fluttertoast.showToast(
                      msg: "Les informations ont été enregistrées avec succès",
                    toastLength: Toast.LENGTH_LONG,
                    gravity: ToastGravity.BOTTOM,
                  );
                }
              },
              child: Text('Valider')),
          ElevatedButton(onPressed: (){
            Navigator.push(
                context,
                MaterialPageRoute(builder: (context)=>const InfoPage())
            );
          }, child: Text('Page Suivante'))
        ],
      ),
    );
  }
}

class InfoPage extends StatefulWidget {
  const InfoPage({Key? key}) : super(key: key);

  @override
  State<InfoPage> createState() => _InfoPageState();
}

class _InfoPageState extends State<InfoPage> {
  String _firstName="";
  String _lastName="";
  String _profession="";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Page Informations'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: Column(
              children: [
                RichText(text: TextSpan(
                  style: TextStyle(color: Colors.blue),
                  children: [
                    TextSpan(text: 'Nom : ', style: TextStyle(fontWeight: FontWeight.bold)),
                    TextSpan(text: _lastName)
                  ]
                )),
                RichText(text: TextSpan(
                    style: TextStyle(color: Colors.blue),
                    children: [
                      TextSpan(text: 'Prénom : ', style: TextStyle(fontWeight: FontWeight.bold)),
                      TextSpan(text: _firstName)
                    ]
                )),
                RichText(text: TextSpan(
                    style: TextStyle(color: Colors.blue),
                    children: [
                      TextSpan(text: 'Profession : ', style: TextStyle(fontWeight: FontWeight.bold)),
                      TextSpan(text: _profession)
                    ]
                ))
              ],
            ),
          ),
          ElevatedButton(onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=>const MyHomePage()));
          }, child: Text('Retour'))
        ],
      ),
    );
  }


  _loadInformation() async{
    final prefs=await SharedPreferences.getInstance();
    _firstName = prefs.getString("lastName") ?? "";
    _lastName=prefs.getString("firstName") ?? "";
    _profession=prefs.getString("profession") ?? "";
  }

  void initState(){
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {_loadInformation();});
  }
}

