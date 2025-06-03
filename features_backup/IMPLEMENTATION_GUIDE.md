# Guia de Reimplementação das Funcionalidades

## 1. Sistema de Notificações

### Arquivos para copiar:
- `features_backup/notifications/notifications/` → `lib/src/features/notifications/`
- `features_backup/notifications/notification_service.dart` → `lib/src/core/services/notification_service.dart`
- `features_backup/notifications/firebase-messaging-sw.js` → `web/firebase-messaging-sw.js`
- `features_backup/notifications/index.js` → `functions/index.js`
- `features_backup/notifications/package.json` → `functions/package.json`

### Modificações necessárias em arquivos existentes:

#### 1. `pubspec.yaml`
Adicionar dependências:
```yaml
  firebase_messaging: ^15.1.7
  flutter_local_notifications: ^18.0.1
```

#### 2. `web/index.html`
Adicionar antes do </body>:
```html
  <script>
    if ('serviceWorker' in navigator) {
      window.addEventListener('load', function () {
        navigator.serviceWorker.register('/firebase-messaging-sw.js');
      });
    }
  </script>
```

#### 3. `lib/main.dart`
Adicionar imports e inicialização:
```dart
import 'package:timesheet_app/src/core/services/notification_service.dart';

// No main():
await NotificationService.initialize();
```

#### 4. `lib/src/core/navigation/routes.dart`
Adicionar rotas:
```dart
import '../features/notifications/presentation/screens/notifications_screen.dart';
import '../features/notifications/presentation/screens/notifications_admin_screen.dart';
import '../features/notifications/presentation/screens/user_notifications_screen.dart';

// Nas rotas:
route('/notifications', name: notificationsRoute) {
  return NotificationsScreen();
},
route('/notifications/admin', name: notificationsAdminRoute) {
  return NotificationsAdminScreen();
},
route('/user-notifications/:userId', name: userNotificationsRoute) {
  String userId = pathParams.get('userId')!;
  return UserNotificationsScreen(userId: userId);
},
```

#### 5. `lib/src/features/auth/domain/models/role_permissions.dart`
Adicionar permissões:
```dart
// Em adminPermissions:
  AppPermission.viewNotifications,
  AppPermission.manageNotifications,

// Em supervisorPermissions:
  AppPermission.viewNotifications,

// Em employeePermissions:
  AppPermission.viewNotifications,

// No enum AppPermission:
  viewNotifications,
  manageNotifications,
```

#### 6. `lib/src/features/home/presentation/screens/home_screen.dart`
Adicionar import e navegação:
```dart
import '../../notifications/presentation/widgets/notification_icon_button.dart';

// No AppBar:
NotificationIconButton(),

// Adicionar card de navegação para admins:
if (permissions.contains(AppPermission.manageNotifications))
  NavigationCard(
    icon: Icons.notifications_active,
    title: 'Notifications Admin',
    onTap: () => context.push('/notifications/admin'),
  ),
```

#### 7. `firebase.json`
Adicionar configuração de functions:
```json
{
  "hosting": {
    // ... configurações existentes
  },
  "functions": {
    "source": "functions"
  }
}
```

## 2. Badge de Job Records Pendentes

### Arquivos para copiar:
- `features_backup/pending_job_records/` → `lib/src/features/job_record/presentation/providers/`

### Modificações necessárias:

#### 1. `lib/src/features/job_record/presentation/widgets/job_record_card.dart`
Adicionar widget de badge de notificação nos cards pendentes.

#### 2. `lib/src/features/home/presentation/screens/home_screen.dart`
Adicionar provider e mostrar badge:
```dart
import '../../job_record/presentation/providers/pending_job_records_provider.dart';

// No build:
final pendingCount = ref.watch(pendingJobRecordsCountProvider).valueOrNull ?? 0;

// No NavigationCard de Job Records:
NavigationCard(
  icon: Icons.work,
  title: 'Job Records',
  badge: pendingCount > 0 ? pendingCount : null,
  onTap: () => context.push('/job-records'),
),
```

## 3. Hours Management

### Arquivos para copiar:
- `features_backup/hours_management/hours_management/` → `lib/src/features/hours_management/`

### Modificações necessárias:

#### 1. `lib/src/core/navigation/routes.dart`
Adicionar rota:
```dart
import '../features/hours_management/presentation/screens/hours_management_screen.dart';

// Nas rotas:
route('/hours-management', name: hoursManagementRoute) {
  return HoursManagementScreen();
},
```

#### 2. `lib/src/features/auth/domain/models/role_permissions.dart`
Adicionar permissões:
```dart
// Em adminPermissions e supervisorPermissions:
  AppPermission.viewHoursManagement,
  AppPermission.manageHours,

// No enum AppPermission:
  viewHoursManagement,
  manageHours,
```

#### 3. `lib/src/features/home/presentation/screens/home_screen.dart`
Adicionar card de navegação:
```dart
if (permissions.contains(AppPermission.viewHoursManagement))
  NavigationCard(
    icon: Icons.access_time,
    title: 'Hours Management',
    onTap: () => context.push('/hours-management'),
  ),
```

#### 4. `lib/src/features/employee/data/models/employee_model.dart`
Adicionar campos:
```dart
final double? weeklyHoursGoal;
final double? monthlyHoursGoal;

// No construtor e copyWith
```

#### 5. `lib/src/features/user/data/models/user_model.dart`
Adicionar campo:
```dart
final String? employeeId;

// No construtor e copyWith
```

## Comandos após implementação:

```bash
# Instalar dependências do Flutter
flutter pub get

# Gerar arquivos
dart run build_runner build --delete-conflicting-outputs

# Instalar dependências das Cloud Functions
cd functions
npm install
cd ..

# Deploy das Cloud Functions
firebase deploy --only functions

# Executar o app
flutter run -d chrome
```

## Observações Importantes:

1. Verificar se todas as importações estão corretas após copiar os arquivos
2. Executar o build_runner após adicionar os novos arquivos
3. Testar as notificações em ambiente de produção (localhost não funciona para push notifications)
4. Configurar as permissões corretas no Firebase Console para notifications
5. O badge de job records pendentes usa Stream para atualização em tempo real
6. Hours Management permite visualização por semana/mês e comparação com metas