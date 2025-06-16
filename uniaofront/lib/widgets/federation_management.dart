import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lucasbeatsfederacao/models/user_model.dart';
import 'package:lucasbeatsfederacao/models/federation_model.dart';
import 'package:lucasbeatsfederacao/services/federation_service.dart';
import 'package:lucasbeatsfederacao/services/api_service.dart';
import 'package:lucasbeatsfederacao/services/auth_service.dart';
import 'package:lucasbeatsfederacao/widgets/custom_snackbar.dart';
import 'package:lucasbeatsfederacao/utils/logger.dart';

class FederationManagement extends StatefulWidget {
  final UserModel currentUser;

  const FederationManagement({
    super.key,
    required this.currentUser,
  });

  @override
  State<FederationManagement> createState() => _FederationManagementState();
}

class _FederationManagementState extends State<FederationManagement> {
  late FederationService _federationService;
  List<Federation> _federations = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    final authService = Provider.of<AuthService>(context, listen: false);
    _federationService = FederationService(ApiService(), authService);
    _loadFederations();
  }

  Future<void> _loadFederations() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final federations = await _federationService.getAllFederations();
      setState(() {
        _federations = federations;
      });
    } catch (e) {
      Logger.error('Error loading federations: $e');
      if (mounted) {
        CustomSnackbar.showError(context, 'Erro ao carregar federações: ${e.toString()}');
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Cabeçalho
          Row(
            children: [
              const Text(
                'Gerenciamento de Federações',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              ElevatedButton.icon(
                onPressed: _showCreateFederationDialog,
                icon: const Icon(Icons.add),
                label: const Text('Nova Federação'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Botão de atualizar
          Row(
            children: [
              ElevatedButton.icon(
                onPressed: _isLoading ? null : _loadFederations,
                icon: _isLoading 
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.refresh),
                label: const Text('Atualizar'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Estatísticas das federações
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  'Total de Federações',
                  _federations.length.toString(),
                  Icons.group_work,
                  Colors.purple,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  'Total de Clãs',
                  _federations.fold<int>(0, (sum, fed) => sum + fed.clans.length).toString(),
                  Icons.groups,
                  Colors.orange,
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Lista de federações
          if (_isLoading)
            const Center(child: CircularProgressIndicator())
          else if (_federations.isEmpty)
            const Center(
              child: Text(
                'Nenhuma federação encontrada',
                style: TextStyle(color: Colors.white),
              ),
            )
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _federations.length,
              itemBuilder: (context, index) {
                final federation = _federations[index];
                return _buildFederationCard(federation);
              },
            ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Card(
      color: Colors.grey.shade800.withOpacity(0.8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              title,
              style: TextStyle(
                color: Colors.grey.shade400,
                fontSize: 10,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFederationCard(Federation federation) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: Colors.grey.shade800.withOpacity(0.8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Cabeçalho da federação
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.purple,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.group_work,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        federation.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (federation.description != null)
                        Text(
                          federation.description!,
                          style: TextStyle(
                            color: Colors.grey.shade400,
                            fontSize: 14,
                          ),
                        ),
                    ],
                  ),
                ),
                PopupMenuButton<String>(
                  icon: const Icon(Icons.more_vert, color: Colors.white),
                  onSelected: (action) => _handleFederationAction(action, federation),
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'view_details',
                      child: Row(
                        children: [
                          Icon(Icons.info, color: Colors.orange),
                          SizedBox(width: 8),
                          Text('Ver Detalhes'),
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(Icons.delete, color: Colors.red),
                          SizedBox(width: 8),
                          Text('Excluir'),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Informações da federação
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildFederationStat(
                        'Clãs',
                        federation.clans.length.toString(),
                        Icons.groups,
                      ),
                      _buildFederationStat(
                        'Líder',
                        federation.leader.username,
                        Icons.person,
                      ),
                      // if (federation.createdAt != null)
                      //   _buildFederationStat(
                      //     'Criada em',
                      //     _formatDate(federation.createdAt!),
                      //     Icons.calendar_today,
                      //   ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // Lista de clãs
            if (federation.clans.isNotEmpty) ...[
              const Text(
                'Clãs da Federação:',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 4,
                children: federation.clans.map((clan) {
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.blue.withOpacity(0.3)),
                    ),
                    child: Text(
                      clan.name + (clan.tag != null ? ' [${clan.tag}]' : ''),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],

            // Lista de aliados
            if (federation.allies.isNotEmpty) ...[
              const SizedBox(height: 12),
              const Text(
                'Federações Aliadas:',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 4,
                children: federation.allies.map((ally) {
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.green.withOpacity(0.3)),
                    ),
                    child: Text(
                      ally.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],

            // Lista de inimigos
            if (federation.enemies.isNotEmpty) ...[
              const SizedBox(height: 12),
              const Text(
                'Federações Inimigas:',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 4,
                children: federation.enemies.map((enemy) {
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.red.withOpacity(0.3)),
                    ),
                    child: Text(
                      enemy.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildFederationStat(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.blue, size: 16),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        Text(
          label,
          style: TextStyle(
            color: Colors.grey.shade400,
            fontSize: 10,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  void _showCreateFederationDialog() {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController descriptionController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Criar Nova Federação'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Nome da Federação',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(
                labelText: 'Descrição',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (nameController.text.isNotEmpty) {
                Navigator.pop(context);
                
                try {
                  final federation = await _federationService.createFederation({
                    'name': nameController.text,
                    'description': descriptionController.text,
                  });
                  
                  if (federation != null) {
                    CustomSnackbar.showSuccess(context, 'Federação "${nameController.text}" criada com sucesso!');
                    _loadFederations(); // Recarregar a lista
                  } else {
                    CustomSnackbar.showError(context, 'Erro ao criar federação');
                  }
                } catch (e) {
                  Logger.error('Error creating federation: $e');
                  CustomSnackbar.showError(context, 'Erro ao criar federação: ${e.toString()}');
                }
              }
            },
            child: const Text('Criar'),
          ),
        ],
      ),
    );
  }

  void _handleFederationAction(String action, Federation federation) {
    switch (action) {
      case 'view_details':
        _viewFederationDetails(federation);
        break;
      case 'delete':
        _deleteFederation(federation);
        break;
    }
  }

  void _viewFederationDetails(Federation federation) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Detalhes: ${federation.name}'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('ID: ${federation.id}'),
              const SizedBox(height: 8),
              if (federation.description != null) ...[
                Text('Descrição: ${federation.description}'),
                const SizedBox(height: 8),
              ],
              ...[
              Text('Líder: ${federation.leader.username}'),
              const SizedBox(height: 8),
            ],
              Text('Número de Clãs: ${federation.clans.length}'),
              const SizedBox(height: 8),
              Text('Número de Aliados: ${federation.allies.length}'),
              const SizedBox(height: 8),
              Text('Número de Inimigos: ${federation.enemies.length}'),
              // if (federation.createdAt != null) ...[
              //   const SizedBox(height: 8),
              //   Text('Criada em: ${_formatDate(federation.createdAt!)}'),
              // ],
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Fechar'),
          ),
        ],
      ),
    );
  }

  void _deleteFederation(Federation federation) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar Exclusão'),
        content: Text('Tem certeza que deseja excluir a federação "${federation.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              
              try {
                final success = await _federationService.deleteFederation(federation.id);
                
                if (success) {
                  CustomSnackbar.showSuccess(context, 'Federação "${federation.name}" excluída com sucesso!');
                  _loadFederations(); // Recarregar a lista
                } else {
                  CustomSnackbar.showError(context, 'Erro ao excluir federação');
                }
              } catch (e) {
                Logger.error('Error deleting federation: $e');
                CustomSnackbar.showError(context, 'Erro ao excluir federação: ${e.toString()}');
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Excluir'),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }
}

