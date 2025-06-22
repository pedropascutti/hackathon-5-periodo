import 'package:flutter/material.dart';
import '../models/materia.dart';
import '../services/api_service.dart';
import '../services/storage_service.dart';
import 'tela_selecao_turmas.dart';

class TelaSelecaoMaterias extends StatefulWidget {
  const TelaSelecaoMaterias({Key? key}) : super(key: key);

  @override
  State<TelaSelecaoMaterias> createState() => _TelaSelecaoMateriasState();
}

class _TelaSelecaoMateriasState extends State<TelaSelecaoMaterias> {
  List<Materia> _materias = [];
  bool _carregando = true;
  String? _mensagemErro;

  @override
  void initState() {
    super.initState();
    _carregarMaterias();
  }

  Future<void> _carregarMaterias() async {
    setState(() {
      _carregando = true;
      _mensagemErro = null;
    });

    try {
      final usuario = StorageService.getCurrentUser();
      if (usuario != null) {
        final materias = await ApiService.obterMateriasProfessor(usuario.id);
        
        setState(() {
          _materias = materias;
          _carregando = false;
        });
      } else {
        setState(() {
          _mensagemErro = 'Usuário não encontrado';
          _carregando = false;
        });
      }
    } catch (e) {
      setState(() {
        _mensagemErro = 'Erro ao carregar matérias: $e';
        _carregando = false;
      });
    }
  }

  void _selecionarMateria(Materia materia) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => TelaSelecaoTurmas(
          materia: materia,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Selecionar Matéria'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: _construirCorpo(),
    );
  }

  Widget _construirCorpo() {
    if (_carregando) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Carregando matérias...'),
          ],
        ),
      );
    }

    if (_mensagemErro != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red,
            ),
            const SizedBox(height: 16),
            Text(
              _mensagemErro!,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _carregarMaterias,
              child: const Text('Tentar Novamente'),
            ),
          ],
        ),
      );
    }

    if (_materias.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.school_outlined,
              size: 64,
              color: Colors.grey,
            ),
            SizedBox(height: 16),
            Text(
              'Nenhuma matéria encontrada',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _carregarMaterias,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Suas Matérias',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.blue[800],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Selecione uma matéria para continuar',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: ListView.builder(
                itemCount: _materias.length,
                itemBuilder: (context, index) {
                  final materia = _materias[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    elevation: 2,
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(16),
                      leading: CircleAvatar(
                        backgroundColor: Colors.blue,
                        radius: 25,
                        child: Text(
                          materia.codigo.isNotEmpty 
                              ? materia.codigo.substring(0, 2).toUpperCase()
                              : 'M',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      title: Text(
                        materia.nome,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 4),
                          Text('Código: ${materia.codigo}'),
                          if (materia.descricao.isNotEmpty) ...[
                            const SizedBox(height: 2),
                            Text(
                              materia.descricao,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ],
                      ),
                      trailing: const Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.blue,
                      ),
                      onTap: () => _selecionarMateria(materia),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

