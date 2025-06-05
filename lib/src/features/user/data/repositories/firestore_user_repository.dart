import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:timesheet_app_web/src/core/repositories/firestore_repository.dart';
import 'package:timesheet_app_web/src/features/user/data/models/user_model.dart';
import 'package:timesheet_app_web/src/features/user/domain/repositories/user_repository.dart';
import 'package:timesheet_app_web/src/features/employee/data/models/employee_model.dart';
import 'package:timesheet_app_web/src/features/employee/domain/repositories/employee_repository.dart';

class FirestoreUserRepository extends FirestoreRepository<UserModel> implements UserRepository {
  final FirebaseAuth _auth;
  final EmployeeRepository _employeeRepository;
  
  FirestoreUserRepository({
    FirebaseFirestore? firestore, 
    FirebaseAuth? auth,
    required EmployeeRepository employeeRepository,
  })  : _auth = auth ?? FirebaseAuth.instance,
        _employeeRepository = employeeRepository,
        super(
          collectionPath: 'users',
          firestore: firestore,
        );

  @override
  UserModel fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    return UserModel.fromFirestore(doc);
  }

  @override
  Map<String, dynamic> toFirestore(UserModel entity) {
    return entity.toFirestore();
  }

  @override
  Future<UserModel?> getUserByAuthUid(String authUid) async {
    try {
      final querySnapshot = await collection
          .where('auth_uid', isEqualTo: authUid)
          .limit(1)
          .get();
      
      if (querySnapshot.docs.isEmpty) {
        return null;
      }
      
      final doc = querySnapshot.docs.first;
      
      return fromFirestore(doc);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Stream<UserModel?> watchUserByAuthUid(String authUid) {
    return collection
        .where('auth_uid', isEqualTo: authUid)
        .limit(1)
        .snapshots()
        .map((snapshot) {
      if (snapshot.docs.isEmpty) {
        return null;
      }
      
      final doc = snapshot.docs.first;
      
      try {
        final userModel = fromFirestore(doc);
        return userModel;
      } catch (e) {
        rethrow;
      }
    })
    .handleError((error) {
      return null;
    });
  }

  @override
  Future<List<UserModel>> getUsersByRole(String role) async {
    return query(
      (collection) => collection.where('role', isEqualTo: role),
    );
  }

  @override
  Future<void> toggleUserActive(String id, bool isActive) async {
    await collection.doc(id).update({'is_active': isActive});
  }
  
  @override
  Future<void> updateUserTheme(String id, String themePreference, {bool? forcedTheme}) async {
    final updates = <String, dynamic>{
      'theme_preference': themePreference,
      'updated_at': FieldValue.serverTimestamp(),
    };
    
    // Adiciona forcedTheme apenas se foi fornecido
    if (forcedTheme != null) {
      updates['forced_theme'] = forcedTheme;
    }
    
    await collection.doc(id).update(updates);
  }
  
  @override
  Future<String> createUserWithAuth(UserModel user, String password) async {
    try {
      // 1. Criar usuário no Firebase Auth
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: user.email,
        password: password,
      );
      
      if (userCredential.user == null) {
        throw Exception('Failed to create user in Firebase Auth');
      }
      
      // 2. Criar usuário no Firestore com o UID do Auth
      final userWithAuthUid = user.copyWith(
        authUid: userCredential.user!.uid,
      );
      
      // 3. Criar documento no Firestore
      final docId = await create(userWithAuthUid);
      
      return docId;
    } catch (e) {
      // Se algo falhar, tentar deletar o usuário do Auth se foi criado
      try {
        await _auth.currentUser?.delete();
      } catch (_) {
        // Ignorar erro ao tentar deletar
      }
      rethrow;
    }
  }
  
  @override
  Future<String> createUserWithNewEmployee(UserModel user, String password) async {
    try {
      // 1. Criar usuário no Firebase Auth
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: user.email,
        password: password,
      );
      
      if (userCredential.user == null) {
        throw Exception('Failed to create user in Firebase Auth');
      }
      
      // 2. Criar Employee
      final employee = EmployeeModel(
        id: '',
        firstName: user.firstName,
        lastName: user.lastName,
        isActive: user.isActive,
        userId: userCredential.user!.uid,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      
      final employeeId = await _employeeRepository.create(employee);
      
      // 3. Criar User com employeeId
      final userWithAuthAndEmployee = user.copyWith(
        authUid: userCredential.user!.uid,
        employeeId: employeeId,
      );
      
      final userId = await create(userWithAuthAndEmployee);
      
      return userId;
    } catch (e) {
      // Se algo falhar, tentar deletar o usuário do Auth se foi criado
      try {
        await _auth.currentUser?.delete();
      } catch (_) {
        // Ignorar erro ao tentar deletar
      }
      rethrow;
    }
  }
  
  @override
  Future<String> createUserWithExistingEmployee(UserModel user, String password, String employeeId) async {
    try {
      // 1. Verificar se o employee existe e não tem user associado
      final employee = await _employeeRepository.getById(employeeId);
      if (employee == null) {
        throw Exception('Employee not found');
      }
      if (employee.userId != null) {
        throw Exception('Employee already has an associated user');
      }
      
      // 2. Criar usuário no Firebase Auth
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: user.email,
        password: password,
      );
      
      if (userCredential.user == null) {
        throw Exception('Failed to create user in Firebase Auth');
      }
      
      // 3. Associar employee ao user
      await _employeeRepository.associateWithUser(employeeId, userCredential.user!.uid);
      
      // 4. Criar User com employeeId e dados do employee
      final userWithAuthAndEmployee = user.copyWith(
        authUid: userCredential.user!.uid,
        employeeId: employeeId,
        firstName: employee.firstName,
        lastName: employee.lastName,
      );
      
      final userId = await create(userWithAuthAndEmployee);
      
      return userId;
    } catch (e) {
      // Se algo falhar, tentar deletar o usuário do Auth se foi criado
      try {
        await _auth.currentUser?.delete();
      } catch (_) {
        // Ignorar erro ao tentar deletar
      }
      rethrow;
    }
  }
  
  @override
  Future<void> associateUserWithEmployee(String userId, String employeeId) async {
    try {
      // 1. Verificar se o usuário existe e não tem employee
      final user = await getById(userId);
      if (user == null) {
        throw Exception('User not found');
      }
      if (user.employeeId != null) {
        throw Exception('User already has an associated employee');
      }
      
      // 2. Verificar se o employee existe e não tem user
      final employee = await _employeeRepository.getById(employeeId);
      if (employee == null) {
        throw Exception('Employee not found');
      }
      if (employee.userId != null) {
        throw Exception('Employee already has an associated user');
      }
      
      // 3. Usar transação para garantir consistência
      await FirebaseFirestore.instance.runTransaction((transaction) async {
        // Atualizar user com employeeId
        transaction.update(
          collection.doc(userId),
          {
            'employee_id': employeeId,
            'updated_at': FieldValue.serverTimestamp(),
          },
        );
        
        // Atualizar employee com userId (usando authUid do user)
        transaction.update(
          FirebaseFirestore.instance.collection('employees').doc(employeeId),
          {
            'user_id': user.authUid,
            'updated_at': FieldValue.serverTimestamp(),
          },
        );
      });
    } catch (e) {
      rethrow;
    }
  }
}