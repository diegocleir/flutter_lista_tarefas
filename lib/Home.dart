import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:async';
import 'dart:convert';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  List _listaTarefas = [];
  TextEditingController _controllerTarefa = TextEditingController();

  Future<File> _getFile() async {
    final diretorio = await getApplicationDocumentsDirectory();
    var arquivo = File( "${diretorio.path}/dados.json" );
    return arquivo;
  }

  _salvarTarefa() async {

    String textoDigitado = _controllerTarefa.text;

    Map<String, dynamic> tarefa = Map();
    tarefa["titulo"] = textoDigitado;
    tarefa["realizada"] = false;

    setState(() {
      _listaTarefas.add( tarefa );
    });
    _salvarArquivo();
    _controllerTarefa.text = "";

  }

  _salvarArquivo() async {

    var arquivo = await _getFile();

    String dados = json.encode( _listaTarefas );
    arquivo.writeAsString( dados );

    //print("Caminho: " + diretorio.path);

  }

  _lerArquivo() async {

    try{

      final arquivo = await _getFile();
      return arquivo.readAsString();

    }catch(e){
      return null;
    }

  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _lerArquivo().then( (dados){
      setState(() {
        _listaTarefas = json.decode(dados);
      });
    } );
  }

  @override
  Widget build(BuildContext context) {

    //_salvarArquivo();

    print("itens: " + _listaTarefas.toString() );

    return Scaffold(
      appBar: AppBar(
        title: Text("Lista de tarefas"),
        backgroundColor: Colors.purple,
      ),
      body: Container(
        child: Column(
          children: [
            Expanded(
                child: ListView.builder(
                  itemCount: _listaTarefas.length,
                  itemBuilder: (context, index){
                    return CheckboxListTile(
                      title: Text( _listaTarefas[index]['titulo'] ),
                        value: _listaTarefas[index]['realizada'],
                        onChanged: (valorAlterado){

                        setState(() {
                          _listaTarefas[index]['realizada'] = valorAlterado;
                        });

                        _salvarArquivo();

                          print("valor: " + valorAlterado.toString() );
                        }
                    );
                    /*
                    return ListTile(
                      title: Text( _listaTarefas[index]['titulo'] ),
                    );
                    */
                  },
                )

            )
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: (){

          showDialog(
              context: context,
              builder: (context){
                return AlertDialog(
                  title: Text("Adicionar Tarefa"),
                  content: TextField(
                    controller: _controllerTarefa,
                    decoration: InputDecoration(
                      labelText: "Digite sua tarefa"
                    ),
                    onChanged: (text){

                    },
                  ),
                  actions: [
                    TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text("Cancelar")
                    ),
                    TextButton(
                        onPressed: (){
                          //salvar
                          _salvarTarefa();
                          Navigator.pop(context);
                        },
                        child: Text("Salvar")
                    )
                  ],
                );
              }
          );

        },
        child: Icon(Icons.add),
        backgroundColor: Colors.purple,
      ),
    );
  }
}
