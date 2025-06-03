import 'dart:convert';
import 'dart:io';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';

// Classe Professor
class Professor {
  int id;
  String codigo;
  String nome;
  List<Disciplina> disciplinas = [];

  Professor({required this.id, required this.codigo, required this.nome});

  void adicionarDisciplina(Disciplina disciplina) {
    disciplinas.add(disciplina);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'codigo': codigo,
      'nome': nome,
      'disciplinas': disciplinas.map((d) => d.toJson()).toList(),
    };
  }
}

// Classe Disciplina
class Disciplina {
  int id;
  String descricao;
  int qtdAulas;

  Disciplina({
    required this.id,
    required this.descricao,
    required this.qtdAulas,
  });

  Map<String, dynamic> toJson() {
    return {'id': id, 'descricao': descricao, 'qtdAulas': qtdAulas};
  }
}

// Classe Aluno
class Aluno {
  int id;
  String nome;
  String matricula;

  Aluno({required this.id, required this.nome, required this.matricula});

  Map<String, dynamic> toJson() {
    return {'id': id, 'nome': nome, 'matricula': matricula};
  }
}

// Classe Curso
class Curso {
  int id;
  String descricao;
  List<Professor> professores = [];
  List<Disciplina> disciplinas = [];
  List<Aluno> alunos = [];

  Curso({required this.id, required this.descricao});

  void adicionarProfessor(Professor professor) {
    professores.add(professor);
  }

  void adicionarDisciplina(Disciplina disciplina) {
    disciplinas.add(disciplina);
  }

  void adicionarAluno(Aluno aluno) {
    alunos.add(aluno);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'descricao': descricao,
      'professores': professores.map((p) => p.toJson()).toList(),
      'disciplinas': disciplinas.map((d) => d.toJson()).toList(),
      'alunos': alunos.map((a) => a.toJson()).toList(),
    };
  }
}

main() async {
  var profCarlos = Professor(id: 1, codigo: '123456', nome: 'Carlos');
  var profJorge = Professor(id: 2, codigo: '654321', nome: 'Jorge');

  var pedro = Aluno(id: 1, nome: 'Pedro', matricula: '2023175385123');
  var jonas = Aluno(id: 1, nome: 'Jonas', matricula: '2022596243650');

  var matas = Disciplina(id: 1, descricao: 'Matemática', qtdAulas: 4);
  var portas = Disciplina(id: 2, descricao: 'Português', qtdAulas: 4);

  var info = Curso(id: 1, descricao: 'Informática');

  profJorge.adicionarDisciplina(matas);
  profCarlos.adicionarDisciplina(portas);

  info.adicionarAluno(pedro);
  info.adicionarDisciplina(matas);
  info.adicionarProfessor(profJorge);
  info.adicionarAluno(jonas);
  info.adicionarDisciplina(portas);
  info.adicionarProfessor(profCarlos);

  String jsonString = jsonEncode(info.toJson());

  final file = File('curso.json');
  await file.writeAsString(jsonString);

  print(jsonString);

  // Configura as credenciais SMTP do Gmail
  final smtpServer = gmail(
    'riquelmy.ricarte08@aluno.ifce.edu.br',
    'wasr skat csmg lbtc',
  );

  // Cria uma mensagem de e-mail
  final message =
      Message()
        ..from = Address('riquelmy.ricarte08@aluno.ifce.edu.br', 'Riquelmy')
        ..recipients.add('taveira@ifce.edu.br')
        ..subject = 'PROVA PRATICA-DART'
        ..text = jsonString;

  try {
    // Envia o e-mail usando o servidor SMTP do Gmail
    final sendReport = await send(message, smtpServer);

    // Exibe o resultado do envio do e-mail
    print('E-mail enviado: $sendReport');
  } on MailerException catch (e) {
    // Exibe informações sobre erros de envio de e-mail
    print('Erro ao enviar e-mail: ${e.toString()}');
  }
}
