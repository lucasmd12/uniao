import 'package:flutter/material.dart';
import 'package:lucasbeatsfederacao/models/user_model.dart';
import 'package:lucasbeatsfederacao/models/role_model.dart';

class UserDashboardWidget extends StatelessWidget {
  final UserModel user;

  const UserDashboardWidget({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey.shade800.withOpacity(0.8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: _getRoleColor(user.role),
                  backgroundImage: user.avatar != null
                    ? NetworkImage(user.avatar!)
                    : null,
                  child: user.avatar == null
                    ? Text(
                        user.username.isNotEmpty ? user.username[0].toUpperCase() : 'U',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    : null,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user.username,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: _getRoleColor(user.role),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          _getRoleDisplayName(user.role),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      if (user.tag != null && user.tag!.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text(
                          'Tag: ${user.tag}',
                          style: TextStyle(
                            color: Colors.grey.shade400,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                _buildStatusIndicator(),
              ],
            ),
            const SizedBox(height: 16),
            _buildUserStats(),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusIndicator() {
    return Container(
      width: 12,
      height: 12,
      decoration: const BoxDecoration(
        color: Colors.green,
        shape: BoxShape.circle,
      ),
    );
  }

  Widget _buildUserStats() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatColumn('Tempo Online', '2h 30m'),
          _buildStatColumn('Mensagens', '156'),
          _buildStatColumn('Chamadas', '23'),
        ],
      ),
    );
  }

  Widget _buildStatColumn(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
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

  Color _getRoleColor(Role role) {
    switch (role) {
      case Role.federationAdmin:
        return Colors.red;
      case Role.clanLeader:
        return Colors.orange;
      case Role.clanSubLeader:
        return Colors.yellow.shade700;
      case Role.clanMember:
        return Colors.blue;
      case Role.guest:
        return Colors.grey;
      default: // Adicionado para Role.ADM e Role.User, e outros
        return Colors.grey; // Cor padrão
    }
  }

  String _getRoleDisplayName(Role role) {
    switch (role) {
      case Role.federationAdmin:
        return 'ADMINISTRADOR';
      case Role.clanLeader:
        return 'LÍDER';
      case Role.clanSubLeader:
        return 'SUB-LÍDER';
      case Role.clanMember:
        return 'MEMBRO';
      case Role.guest:
        return 'CONVIDADO';
      default: // Adicionado para Role.ADM e Role.User, e outros
        return role.toString().split('.').last.toUpperCase(); // Usa o nome da enum como fallback
    }
  }
}

