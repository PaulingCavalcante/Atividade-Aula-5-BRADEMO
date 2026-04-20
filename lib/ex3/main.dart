import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Constraints Flutter',
      theme: ThemeData(primarySwatch: Colors.indigo),
      home: const ConstraintsPage(),
    );
  }
}

class ConstraintsPage extends StatelessWidget {
  const ConstraintsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Layout Constraints')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          _ExampleCard(
            number: 1,
            title: 'Container ocupa tela inteira',
            description:
                'O Scaffold passa constraints tight (exatas) para o Container, '
                'forçando-o a preencher a tela toda.',
            child: _Example1(),
          ),
          _ExampleCard(
            number: 2,
            title: 'Container com tamanho específico',
            description:
                'Container filho pede 100×100, mas o pai (sem outros filhos) '
                'ainda impõe constraints tight – o filho ocupa tudo.',
            child: _Example2(),
          ),
          _ExampleCard(
            number: 3,
            title: 'Center libera constraints (loose)',
            description:
                'Center recebe tight constraints do pai, mas passa constraints '
                'loose (0 até max) para o filho – o Container de 100×100 fica menor.',
            child: _Example3(),
          ),
          _ExampleCard(
            number: 4,
            title: 'Align posiciona dentro do pai',
            description:
                'Align recebe tight constraints e posiciona o filho de 100×100 '
                'no canto inferior direito. O parent define a posição.',
            child: _Example4(),
          ),
          _ExampleCard(
            number: 5,
            title: 'Row divide espaço entre filhos',
            description:
                'Row distribui a largura disponível. Filhos sem Expanded '
                'recebem apenas o espaço que precisam (loose na largura).',
            child: _Example5(),
          ),
          _ExampleCard(
            number: 6,
            title: 'Expanded força filho a preencher',
            description:
                'Expanded passa constraints tight de largura para o filho, '
                'fazendo-o preencher todo o espaço restante da Row.',
            child: _Example6(),
          ),
          _ExampleCard(
            number: 7,
            title: 'UnconstrainedBox ignora constraints',
            description:
                'UnconstrainedBox remove as constraints do pai antes de '
                'passá-las ao filho – o filho pode ser maior que o pai (overflow).',
            child: _Example7(),
          ),
          _ExampleCard(
            number: 8,
            title: 'OverflowBox – overflow controlado',
            description:
                'OverflowBox permite que o filho extrapole o espaço disponível '
                'sem gerar erro, apenas um aviso visual de overflow.',
            child: _Example8(),
          ),
          _ExampleCard(
            number: 9,
            title: 'FittedBox escala o filho',
            description:
                'FittedBox redimensiona e posiciona o filho para caber '
                'dentro das constraints do pai.',
            child: _Example9(),
          ),
          _ExampleCard(
            number: 10,
            title: 'SizedBox.expand – preenche o pai',
            description:
                'SizedBox.expand impõe constraints tight double.infinity, '
                'forçando o filho a ocupar todo o espaço disponível.',
            child: _Example10(),
          ),
        ],
      ),
    );
  }
}

class _ExampleCard extends StatelessWidget {
  final int number;
  final String title;
  final String description;
  final Widget child;

  const _ExampleCard({
    required this.number,
    required this.title,
    required this.description,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 20),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Exemplo $number – $title',
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              description,
              style: TextStyle(fontSize: 12, color: Colors.grey[700]),
            ),
            const SizedBox(height: 12),
            SizedBox(height: 120, child: child),
          ],
        ),
      ),
    );
  }
}

class _Example1 extends StatelessWidget {
  const _Example1();
  @override
  Widget build(BuildContext context) {
    return Container(color: Colors.indigo[100]);
  }
}

class _Example2 extends StatelessWidget {
  const _Example2();
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.indigo[100],
      child: Container(width: 100, height: 100, color: Colors.indigo[400]),
    );
  }
}

class _Example3 extends StatelessWidget {
  const _Example3();
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.indigo[50],
      child: Center(
        child: Container(width: 100, height: 100, color: Colors.indigo[400]),
      ),
    );
  }
}

class _Example4 extends StatelessWidget {
  const _Example4();
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.indigo[50],
      child: Align(
        alignment: Alignment.bottomRight,
        child: Container(width: 80, height: 80, color: Colors.deepOrange),
      ),
    );
  }
}

class _Example5 extends StatelessWidget {
  const _Example5();
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.indigo[50],
      child: Row(
        children: [
          Container(width: 80, height: 80, color: Colors.red[200]),
          Container(width: 60, height: 60, color: Colors.green[200]),
          Container(width: 100, height: 80, color: Colors.blue[200]),
        ],
      ),
    );
  }
}

class _Example6 extends StatelessWidget {
  const _Example6();
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.indigo[50],
      child: Row(
        children: [
          Container(width: 60, height: 80, color: Colors.red[200]),
          Expanded(
            child: Container(height: 80, color: Colors.green[300]),
          ),
          Container(width: 60, height: 80, color: Colors.blue[200]),
        ],
      ),
    );
  }
}


class _Example7 extends StatelessWidget {
  const _Example7();
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.yellow[100],
      child: UnconstrainedBox(
        child: Container(
          width: 500,
          height: 80,
          color: Colors.orange[400],
          child: const Center(
            child: Text(
              'Sem constraints – overflow!',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}


class _Example8 extends StatelessWidget {
  const _Example8();
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.pink[50],
      child: OverflowBox(
        minWidth: 0,
        maxWidth: double.infinity,
        child: Container(
          width: 400,
          height: 80,
          color: Colors.pink[300],
          child: const Center(
            child: Text(
              'OverflowBox permite extrapolação',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}

class _Example9 extends StatelessWidget {
  const _Example9();
  @override
  Widget build(BuildContext context) {
    return FittedBox(
      child: Container(
        width: 400,
        height: 400,
        color: Colors.teal[200],
        child: const Center(
          child: Text('400×400 → cabe no pai', style: TextStyle(fontSize: 30)),
        ),
      ),
    );
  }
}

class _Example10 extends StatelessWidget {
  const _Example10();
  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Container(
        color: Colors.purple[200],
        child: const Center(
          child: Text(
            'SizedBox.expand\npreenche o pai',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
