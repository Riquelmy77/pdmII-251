// Agregação e Composição
import 'dart:convert';

class Dependente {
  late String _nome;

  Dependente(String nome) {
    this._nome = nome;
  }
}

class Funcionario {
  late String _nome;
  late List<Dependente> _dependentes;

  Funcionario(String nome, List<Dependente> dependentes) {
    this._nome = nome;
    this._dependentes = dependentes;
  }
}

class EquipeProjeto {
  late String _nomeProjeto;
  late List<Funcionario> _funcionarios;

  EquipeProjeto(String nomeprojeto, List<Funcionario> funcionarios) {
    _nomeProjeto = nomeprojeto;
    _funcionarios = funcionarios;
  }
}

void main() {
  // 1. Criar varios objetos Dependentes
  Dependente d1 = Dependente("Lucas");
  Dependente d2 = Dependente("Gabriel");
  Dependente d3 = Dependente("Pedro");
  // 2. Criar varios objetos Funcionario
  Funcionario f1 = Funcionario("Carlos", [d1, d2]);
  Funcionario f2 = Funcionario("Francisco", [d3, d2]);
  Funcionario f3 = Funcionario("Roberto", [d1, d3]);
  // 3. Associar os Dependentes criados aos respectivos
  //    funcionarios
  //    (já foi feito no passo 2)
  // 4. Criar uma lista de Funcionarios
  List<Funcionario> funcionarios = [f1, f2, f3];
  // 5. criar um objeto Equipe Projeto chamando o metodo
  //    contrutor que da nome ao projeto e insere uma
  //    coleção de funcionario
  EquipeProjeto equipe = EquipeProjeto("Projeto Mago dos Games", funcionarios);
  // 6. Printar no formato JSON o objeto Equipe Projeto.
  //    (usar o toJson)
  String json = jsonEncode({
    'nomeProjeto': equipe._nomeProjeto,
    'funcionarios':
        equipe._funcionarios.map((f) {
          return {
            'nome': f._nome,
            'dependentes': f._dependentes.map((d) => d._nome).toList(),
          };
        }).toList(),
  });
  print(json);
}
