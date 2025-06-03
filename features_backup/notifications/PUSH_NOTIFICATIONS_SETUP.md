# Configuração de Notificações Push

## Visão Geral

O sistema de notificações push foi implementado para funcionar em dispositivos Android quando a PWA está fechada. As notificações são enviadas automaticamente quando:

- Um novo Job Record é criado
- Um Job Record é atualizado
- Uma nova Expense é criada
- Lembretes de timesheet (sextas-feiras às 9h)

## Componentes Implementados

### 1. Service Worker (firebase-messaging-sw.js)
- Configurado com as credenciais corretas do projeto
- Processa notificações em background
- Gerencia cliques nas notificações
- Suporta ações customizadas por tipo de notificação

### 2. Cloud Functions
- `sendPushNotification`: Envia push quando uma nova notificação é criada no Firestore
- `sendTimesheetReminders`: Envia lembretes semanais
- `cleanupOldNotifications`: Limpa notificações antigas (> 30 dias)

### 3. NotificationService
- Gerencia permissões e tokens FCM
- Configura handlers para mensagens

## Passos para Deploy

### 1. Instalar dependências das Cloud Functions
```bash
cd functions
npm install
```

### 2. Configurar VAPID Key (se necessário)
Se você precisar gerar uma nova VAPID key:
```bash
firebase functions:secrets:set VAPID_KEY
```

### 3. Deploy das Cloud Functions
```bash
firebase deploy --only functions
```

### 4. Deploy do Hosting (incluindo Service Worker)
```bash
flutter build web
firebase deploy --only hosting
```

## Limitações

### iOS/Safari
- Não suporta notificações push em PWAs quando fechadas
- Notificações só funcionam com app aberto

### Android/Chrome
- Suporte completo para notificações em background
- Funciona mesmo com PWA fechada
- Ações customizadas nas notificações

## Testando Notificações

1. Abra a PWA em um dispositivo Android
2. Aceite as permissões de notificação quando solicitado
3. Feche completamente a PWA
4. Crie um novo Job Record ou Expense de outro usuário
5. A notificação deve aparecer no dispositivo

## Troubleshooting

### Notificações não aparecem
1. Verifique se as permissões foram concedidas
2. Verifique o token FCM no Firestore (notification_preferences)
3. Verifique os logs das Cloud Functions no Firebase Console

### Erro de VAPID Key
O NotificationService usa a VAPID key padrão. Se houver erro, você pode gerar uma nova no Firebase Console:
Project Settings > Cloud Messaging > Web Push certificates