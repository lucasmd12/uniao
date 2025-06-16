import 'package:flutter/material.dart';

class GlobalStatsWidget extends StatelessWidget {
  const GlobalStatsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Estatísticas Globais',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),

          // Estatísticas principais
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.2,
            children: [
              _buildStatCard('Usuários Totais', '1,247', Icons.people, Colors.blue),
              _buildStatCard('Usuários Online', '89', Icons.circle, Colors.green),
              _buildStatCard('Federações', '3', Icons.group_work, Colors.purple),
              _buildStatCard('Clãs Ativos', '15', Icons.groups, Colors.orange),
              _buildStatCard('Chamadas Hoje', '156', Icons.call, Colors.teal),
              _buildStatCard('Mensagens', '2,847', Icons.message, Colors.indigo),
            ],
          ),

          const SizedBox(height: 20),

          // Gráfico de atividade (mock)
          Card(
            color: Colors.grey.shade800.withOpacity(0.8),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Atividade dos Últimos 7 Dias',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 200,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        _buildActivityBar('Seg', 0.6, Colors.blue),
                        _buildActivityBar('Ter', 0.8, Colors.green),
                        _buildActivityBar('Qua', 0.4, Colors.orange),
                        _buildActivityBar('Qui', 0.9, Colors.purple),
                        _buildActivityBar('Sex', 1.0, Colors.red),
                        _buildActivityBar('Sáb', 0.7, Colors.teal),
                        _buildActivityBar('Dom', 0.5, Colors.indigo),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Top clãs
          Card(
            color: Colors.grey.shade800.withOpacity(0.8),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Top 5 Clãs Mais Ativos',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildTopClanItem(1, 'Warriors', 'Elite Federation', 45, Colors.gold),
                  _buildTopClanItem(2, 'Legends', 'Elite Federation', 42, Colors.amber),
                  _buildTopClanItem(3, 'Champions', 'Elite Federation', 38, Colors.brown),
                  _buildTopClanItem(4, 'Old Guard', 'Veterans Alliance', 35, Colors.blue),
                  _buildTopClanItem(5, 'Rookies', 'Rising Stars', 32, Colors.green),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Estatísticas de uso
          Row(
            children: [
              Expanded(
                child: Card(
                  color: Colors.grey.shade800.withOpacity(0.8),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        const Icon(Icons.access_time, color: Colors.blue, size: 32),
                        const SizedBox(height: 8),
                        const Text(
                          'Tempo Médio Online',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          '2h 34min',
                          style: TextStyle(
                            color: Colors.blue,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '+12% esta semana',
                          style: TextStyle(
                            color: Colors.green.shade400,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Card(
                  color: Colors.grey.shade800.withOpacity(0.8),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        const Icon(Icons.trending_up, color: Colors.green, size: 32),
                        const SizedBox(height: 8),
                        const Text(
                          'Crescimento',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          '+15%',
                          style: TextStyle(
                            color: Colors.green,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'novos usuários',
                          style: TextStyle(
                            color: Colors.grey.shade400,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Eventos recentes
          Card(
            color: Colors.grey.shade800.withOpacity(0.8),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Eventos Recentes do Sistema',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildEventItem(
                    'Sistema atualizado para v2.0.1',
                    '2 horas atrás',
                    Icons.system_update,
                    Colors.blue,
                  ),
                  _buildEventItem(
                    'Backup automático realizado',
                    '6 horas atrás',
                    Icons.backup,
                    Colors.green,
                  ),
                  _buildEventItem(
                    'Manutenção programada concluída',
                    '1 dia atrás',
                    Icons.build,
                    Colors.orange,
                  ),
                  _buildEventItem(
                    'Nova federação criada',
                    '2 dias atrás',
                    Icons.group_work,
                    Colors.purple,
                  ),
                ],
              ),
            ),
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 32),
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
                fontSize: 12,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityBar(String day, double percentage, Color color) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          width: 30,
          height: 150 * percentage,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          day,
          style: TextStyle(
            color: Colors.grey.shade400,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildTopClanItem(int position, String name, String federation, int members, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Center(
              child: Text(
                position.toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  federation,
                  style: TextStyle(
                    color: Colors.grey.shade400,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                members.toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'membros',
                style: TextStyle(
                  color: Colors.grey.shade400,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEventItem(String title, String time, IconData icon, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 16),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
                Text(
                  time,
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
