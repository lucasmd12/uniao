/// Enum de papéis do usuário alinhado com o backend.
/// Inclui papéis usados no frontend que podem precisar de alinhamento com o backend.
enum Role {
  ADM,         // Backend: "ADM"
  Leader,      // Backend: "Leader"
  SubLeader,   // Backend: "SubLeader"
  Member,      // Backend: "Member"
  User,        // Backend: "User"
  federationAdmin, // Usado no frontend para admins de federação. Assumimos que pode mapear para ADM no backend federationRole.
  clanLeader,      // Usado no frontend para líderes de clã. Assumimos que pode mapear para Leader no backend clanRole.
  clanSubLeader,   // Usado no frontend para sub-líderes de clã. Assumimos que pode mapear para SubLeader no backend clanRole.
  clanMember,      // Usado no frontend para membros de clã. Assumimos que pode mapear para Member no backend clanRole.
  guest,           // Usado no frontend para usuários não autenticados ou com papel indefinido. Pode não ter correspondência direta no backend.
}

/// Converte string do backend para enum Role.
/// ATENÇÃO: Sempre alinhe os valores aqui com o backend!
/// Exemplo de uso: Role userRole = roleFromString(json['role']);
Role roleFromString(String? roleString) {
  switch (roleString) {
    case 'ADM':
      return Role.ADM;
    case 'Leader':
      return Role.Leader;
    case 'SubLeader':
      return Role.SubLeader;
    case 'Member':
      return Role.Member;
    // Mapeamento baseado em suposições para papéis usados no frontend.
    // Pode ser necessário ajustar com base nos valores reais que vêm do backend para clanRole e federationRole.
    case 'federationAdmin':
      return Role.federationAdmin;
    case 'clanLeader':
      return Role.clanLeader;
    case 'clanSubLeader':
      return Role.clanSubLeader;
    case 'clanMember':
      return Role.clanMember;
    case 'User':
    // case 'guest':
    //   return Role.guest; // Se precisar lógica local
    default:
      return Role.User; // Valor padrão seguro
  }
}

/// Converte enum Role para string do backend.
/// Exemplo de uso: String roleStr = roleToString(user.role);
String roleToString(Role role) {
  switch (role) {
    case Role.ADM:
      return 'ADM';
    case Role.Leader:
      return 'Leader';
    case Role.SubLeader:
      return 'SubLeader';
    case Role.Member:
      return 'Member';
    case Role.User: // Mapeia User do frontend para User do backend
 return 'User';
    // Convertendo papéis do frontend para strings. Estes podem precisar ser ajustados
    // para corresponderem aos valores de string esperados pelo backend para clanRole e federationRole.
    case Role.federationAdmin:
      return 'federationAdmin';
    case Role.clanLeader:
      return 'clanLeader';
    case Role.clanSubLeader:
      return 'clanSubLeader';
    case Role.clanMember:
      return 'clanMember';
    case Role.guest:
 return 'guest';
  }
}

/// ANOTAÇÕES PARA O BACKEND:
/// - Sempre alinhe o enum e as funções helpers com o backend para evitar bugs de permissão e navegação.

/// EXEMPLO DE USO NO MODELO:
/// ```
/// final user = UserModel(role: roleFromString(json['role']));
/// print(roleToString(user.role)); // Envia para o backend
/// ```
