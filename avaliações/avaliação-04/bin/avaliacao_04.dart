import 'dart:io';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() async {
  // Initialize FFI (needed for desktop Dart apps to access SQLite)
  sqfliteFfiInit();

  // Open or create the database in current directory
  var databaseFactory = databaseFactoryFfi;
  final db = await databaseFactory.openDatabase('aluno.db');

  // Create the TB_ALUNO table if it doesn't exist
  await db.execute('''
    CREATE TABLE IF NOT EXISTS TB_ALUNO (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      nome TEXT NOT NULL CHECK(length(nome) <= 50)
    )
  ''');

  print('Banco de dados inicializado com sucesso.\n');

  while (true) {
    print('Escolha uma op��o:');
    print('1 - Inserir um novo aluno');
    print('2 - Listar todos os alunos');
    print('3 - Sair');
    stdout.write('Op��o: ');
    String? option = stdin.readLineSync();

    if (option == '1') {
      await inserirAluno(db);
    } else if (option == '2') {
      await listarAlunos(db);
    } else if (option == '3') {
      print('Encerrando o programa...');
      await db.close();
      break;
    } else {
      print('Op��o inv�lida. Tente novamente.\n');
    }
  }
}

// Fun��o para inserir um aluno na tabela
Future<void> inserirAluno(Database db) async {
  stdout.write('Digite o nome do aluno (m�x 50 caracteres): ');
  String? nome = stdin.readLineSync();

  if (nome == null || nome.trim().isEmpty) {
    print('Nome inv�lido. N�o pode ser vazio.\n');
    return;
  }

  if (nome.length > 50) {
    print('Nome muito longo. Deve ter no m�ximo 50 caracteres.\n');
    return;
  }

  try {
    int id = await db.insert('TB_ALUNO', {'nome': nome.trim()});
    print('Aluno inserido com sucesso com id $id.\n');
  } catch (e) {
    print('Erro ao inserir aluno: $e\n');
  }
}

// Fun��o para listar todos os alunos da tabela
Future<void> listarAlunos(Database db) async {
  try {
    List<Map<String, Object?>> resultados = await db.query('TB_ALUNO', orderBy: 'id ASC');
    if (resultados.isEmpty) {
      print('Nenhum aluno cadastrado.\n');
      return;
    }

    print('\nLista de alunos:');
    for (var aluno in resultados) {
      print('ID: ${aluno['id']}  |  Nome: ${aluno['nome']}');
    }
    print('');
  } catch (e) {
    print('Erro ao listar alunos: $e\n');
  }
}
