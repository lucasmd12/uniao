import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lucasbeatsfederacao/providers/auth_provider.dart';
import 'package:lucasbeatsfederacao/models/user_model.dart';
import 'package:lucasbeatsfederacao/utils/logger.dart';
import 'package:lucasbeatsfederacao/widgets/user_dashboard_widget.dart';
import 'package:lucasbeatsfederacao/widgets/clan_info_widget.dart';
import 'package:lucasbeatsfederacao/widgets/quick_actions_widget.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  @override
  void initState() {
    super.initState();
    Logger.info("HomeTab initialized");
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        final UserModel? currentUser = authProvider.currentUser;
        
        if (currentUser == null) {
          return const Center(
            child: Text(
              'Erro ao carregar dados do usuário',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          );
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Dashboard do usuário
              UserDashboardWidget(user: currentUser),
              
              const SizedBox(height: 20),
              
              // Informações do clã (se o usuário estiver em um clã)
              if (currentUser.clan != null)
                ClanInfoWidget(clanId: currentUser.clan!),
              
              const SizedBox(height: 20),
              
              // Ações rápidas baseadas no role do usuário
              QuickActionsWidget(userRole: currentUser.role, clanId: currentUser.clan),
              
              const SizedBox(height: 20),
              
              // Seção de estatísticas
              _buildStatsSection(currentUser),
              
              const SizedBox(height: 20),
              
              // Seção de notificações/avisos
              _buildNotificationsSection(),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatsSection(UserModel user) {
    return Card(
      color: Colors.grey.shade800.withOpacity(0.8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Estatísticas',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem('Membros Online', '12', Icons.people),
                _buildStatItem('Canais Ativos', '5', Icons.voice_chat),
                _buildStatItem('Missões', '3', Icons.assignment),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.blue, size: 24),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: Colors.grey.shade400,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildNotificationsSection() {
    return Card(
      color: Colors.grey.shade800.withOpacity(0.8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Avisos Importantes',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            _buildNotificationItem(
              'Bem-vindo à FEDERACAO MADOUT!',
              'Explore todas as funcionalidades do aplicativo.',
              Icons.info,
              Colors.blue,
            ),
            const SizedBox(height: 8),
            _buildNotificationItem(
              'Novos canais de voz disponíveis',
              'Confira os novos canais na aba Chat.',
              Icons.headset,
              Colors.green,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationItem(String title, String subtitle, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: Colors.grey.shade400,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

