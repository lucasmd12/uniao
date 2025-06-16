import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lucasbeatsfederacao/providers/auth_provider.dart';
import 'package:lucasbeatsfederacao/models/role_model.dart';
import 'package:lucasbeatsfederacao/widgets/admin_dashboard.dart';
import 'package:lucasbeatsfederacao/widgets/federation_management.dart';
import 'package:lucasbeatsfederacao/widgets/user_promotion_dialog.dart';
import 'package:lucasbeatsfederacao/widgets/global_stats_widget.dart';

class AdminPanelScreen extends StatefulWidget {
  const AdminPanelScreen({super.key});

  @override
  State<AdminPanelScreen> createState() => _AdminPanelScreenState();
}

class _AdminPanelScreenState extends State<AdminPanelScreen> with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        final currentUser = authProvider.currentUser;
        
        // Verificar se o usuário é realmente ADM
        if (currentUser?.role != Role.federationAdmin) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Acesso Negado'),
              backgroundColor: Colors.red,
            ),
            body: const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.block,
                    size: 64,
                    color: Colors.red,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Acesso restrito a administradores',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        return Scaffold(
          appBar: AppBar(
            title: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.admin_panel_settings,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                const Text('Painel Administrativo'),
              ],
            ),
            backgroundColor: Colors.red.shade900,
            bottom: TabBar(
              controller: _tabController,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.grey.shade400,
              indicatorColor: Colors.white,
              tabs: const [
                Tab(text: 'Dashboard', icon: Icon(Icons.dashboard, size: 16)),
                Tab(text: 'Federações', icon: Icon(Icons.group_work, size: 16)),
                Tab(text: 'Usuários', icon: Icon(Icons.people, size: 16)),
                Tab(text: 'Estatísticas', icon: Icon(Icons.analytics, size: 16)),
              ],
            ),
          ),
          body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.red.shade900,
                  Colors.black,
                ],
              ),
            ),
            child: TabBarView(
              controller: _tabController,
              children: [
                AdminDashboard(currentUser: currentUser!),
                FederationManagement(currentUser: currentUser),
                _buildUserManagement(),
                GlobalStatsWidget(),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildUserManagement() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Gerenciamento de Usuários',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          
          // Ações rápidas
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => _showPromoteUserDialog(),
                  icon: const Icon(Icons.person_add),
                  label: const Text('Promover Usuário'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.all(16),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => _showCreateClanDialog(),
                  icon: const Icon(Icons.group_add),
                  label: const Text('Criar Clã'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.all(16),
                  ),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 20),
          
          // Lista de usuários recentes
          Card(
            color: Colors.grey.shade800.withOpacity(0.8),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Usuários Recentes',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: 5, // Mock data
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.blue,
                          child: Text('U${index + 1}'),
                        ),
                        title: Text(
                          'Usuário ${index + 1}',
                          style: const TextStyle(color: Colors.white),
                        ),
                        subtitle: Text(
                          'Membro',
                          style: TextStyle(color: Colors.grey.shade400),
                        ),
                        trailing: PopupMenuButton<String>(
                          icon: const Icon(Icons.more_vert, color: Colors.white),
                          onSelected: (action) => _handleUserAction(action, index),
                          itemBuilder: (context) => [
                            const PopupMenuItem(
                              value: 'promote',
                              child: Text('Promover'),
                            ),
                            const PopupMenuItem(
                              value: 'ban',
                              child: Text('Banir'),
                            ),
                            const PopupMenuItem(
                              value: 'view',
                              child: Text('Ver Perfil'),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showPromoteUserDialog() {
    showDialog(
      context: context,
      builder: (context) => UserPromotionDialog(
        onPromote: (username, role) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('$username promovido para $role')),
          );
        },
      ),
    );
  }

  void _showCreateClanDialog() {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController tagController = TextEditingController();
    final TextEditingController leaderController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Criar Novo Clã'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Nome do Clã',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: tagController,
              decoration: const InputDecoration(
                labelText: 'Tag do Clã',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: leaderController,
              decoration: const InputDecoration(
                labelText: 'Username do Líder',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Clã ${nameController.text} criado')),
              );
            },
            child: const Text('Criar'),
          ),
        ],
      ),
    );
  }

  void _handleUserAction(String action, int userIndex) {
    switch (action) {
      case 'promote':
        _showPromoteUserDialog();
        break;
      case 'ban':
        _showBanUserDialog(userIndex);
        break;
      case 'view':
        _showUserProfile(userIndex);
        break;
    }
  }

  void _showBanUserDialog(int userIndex) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Banir Usuário'),
        content: Text('Tem certeza que deseja banir o Usuário ${userIndex + 1}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Usuário ${userIndex + 1} banido')),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Banir'),
          ),
        ],
      ),
    );
  }

  void _showUserProfile(int userIndex) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Perfil do Usuário ${userIndex + 1}'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Username: usuario123'),
            Text('Role: Membro'),
            Text('Clã: Exemplo'),
            Text('Data de Registro: 01/01/2024'),
            Text('Último Login: Hoje'),
          ],
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
}

