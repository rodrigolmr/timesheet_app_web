# Estrutura de Dados do Firebase

## Estrutura Refinada para o Firestore

### Coleções

- `/users/{id}` - Usuários do sistema
- `/employees/{id}` - Funcionários/trabalhadores
- `/company_cards/{id}` - Cartões corporativos
- `/expenses/{id}` - Recibos de despesas
- `/job_records/{id}` - Registros de trabalho (timesheets)
- `/job_drafts/{id}` - Rascunhos de registros de trabalho

### Estrutura de Documentos

#### Collection: `users`
```json
{
  // Campos do sistema (não visíveis ao usuário final)
  "id": "string",               // ID do documento (gerado pelo Firestore)
  "auth_uid": "string",         // UID do Firebase Auth
  
  // Campos visíveis ao usuário
  "email": "string",            // Email do usuário
  "first_name": "string",       // Primeiro nome
  "last_name": "string",        // Sobrenome
  "role": "string",             // "admin", "manager" ou "user"
  "is_active": true,            // Status de atividade do usuário
  
  // Campos de controle (sistema)
  "created_at": "timestamp",    // Data de criação
  "updated_at": "timestamp"     // Data da última modificação
}
```

#### Collection: `employees`
```json
{
  // Campos do sistema (não visíveis ao usuário final)
  "id": "string",               // ID do documento (gerado pelo Firestore)
  
  // Campos visíveis ao usuário
  "first_name": "string",       // Primeiro nome
  "last_name": "string",        // Sobrenome
  "is_active": true,            // Status de atividade do funcionário
  
  // Campos de controle (sistema)
  "created_at": "timestamp",    // Data de criação
  "updated_at": "timestamp"     // Data da última modificação
}
```

#### Collection: `company_cards`
```json
{
  // Campos do sistema (não visíveis ao usuário final)
  "id": "string",               // ID do documento (gerado pelo Firestore)
  
  // Campos visíveis ao usuário
  "holder_name": "string",      // Nome do titular
  "last_four_digits": "string", // Últimos 4 dígitos do cartão
  "is_active": true,            // Status de atividade do cartão
  
  // Campos de controle (sistema)
  "created_at": "timestamp",    // Data de criação
  "updated_at": "timestamp"     // Data da última modificação
}
```

#### Collection: `expenses`
```json
{
  // Campos do sistema (não visíveis ao usuário final)
  "id": "string",               // ID do documento (gerado pelo Firestore)
  "user_id": "string",          // ID do usuário que registrou
  "card_id": "string",          // ID do cartão usado
  
  // Campos visíveis ao usuário
  "amount": 0.0,                // Valor da transação (número)
  "date": "timestamp",          // Data da transação
  "description": "string",      // Descrição da compra
  "image_url": "string",        // URL da imagem do recibo
  
  // Campos de controle (sistema)
  "created_at": "timestamp",    // Data de criação
  "updated_at": "timestamp"     // Data da última modificação
}
```

#### Collection: `job_records`
```json
{
  // Campos do sistema (não visíveis ao usuário final)
  "id": "string",               // ID do documento (gerado pelo Firestore)
  "user_id": "string",          // ID do usuário que criou o timesheet
  
  // Header - Informações gerais do trabalho (visíveis ao usuário)
  "job_name": "string",         // Nome do projeto/trabalho
  "date": "timestamp",          // Data do trabalho realizado
  "territorial_manager": "string", // Nome do manager do trabalho
  "job_size": "string",         // Tamanho do trabalho
  "material": "string",         // Material usado no trabalho
  "job_description": "string",  // Descrição detalhada do trabalho
  "foreman": "string",          // Nome do encarregado do trabalho
  "vehicle": "string",          // Numero ou nome do veiculo usado no trabalho
  
  // Array de funcionários (visível ao usuário)
  "employees": [
    {
      // Campo de referência (parcialmente visível - ID não, mas nome sim)
      "employee_id": "string",      // ID do documento referente a esse funcionário na collection employees
      "employee_name": "string",    // Nome do trabalhador
      
      // Campos de entrada do usuário
      "start_time": "string",       // Horario de inicio (formato HH:MM)
      "finish_time": "string",      // Horario de termino (formato HH:MM)
      "hours": 0.0,                 // Horas trabalhadas (número)
      "travel_hours": 0.0,          // Tempo de deslocamento (número)
      "meal": 0.0                   // Numero de vales refeicao
    }
  ],
  
  // Campos de controle (sistema)
  "created_at": "timestamp",    // Data de criação
  "updated_at": "timestamp"     // Data da última modificação
}
```

#### Collection: `job_drafts`
```json
{
  // Campos do sistema (não visíveis ao usuário final)
  "id": "string",               // ID do documento (gerado pelo Firestore)
  "user_id": "string",          // ID do usuário que está criando o draft
  
  // Header - Informações gerais do trabalho (visíveis ao usuário)
  "job_name": "string",         // Nome do projeto/trabalho
  "date": "timestamp",          // Data do trabalho realizado
  "territorial_manager": "string", // Nome do manager do trabalho
  "job_size": "string",         // Tamanho do trabalho
  "material": "string",         // Material usado no trabalho
  "job_description": "string",  // Descrição detalhada do trabalho
  "foreman": "string",          // Nome do encarregado do trabalho
  "vehicle": "string",          // Numero ou nome do veiculo usado no trabalho
  
  // Array de funcionários (visível ao usuário)
  "employees": [
    {
      // Campo de referência (parcialmente visível - ID não, mas nome sim)
      "employee_id": "string",      // ID do documento referente a esse funcionário na collection employees
      "employee_name": "string",    // Nome do trabalhador
      
      // Campos de entrada do usuário
      "start_time": "string",       // Horario de inicio (formato HH:MM)
      "finish_time": "string",      // Horario de termino (formato HH:MM)
      "hours": 0.0,                 // Horas trabalhadas (número)
      "travel_hours": 0.0,          // Tempo de deslocamento (número)
      "meal": 0.0                   // Numero de vales refeicao
    }
  ],
  
  // Campos de controle (sistema)
  "created_at": "timestamp",    // Data de criação
  "updated_at": "timestamp"     // Data da última modificação
}
```

## Notas sobre os tipos de campos:

### Campos do Sistema
- IDs de documentos
- Referências a outras collections (user_id, card_id, employee_id)
- auth_uid (Firebase Auth)
- created_at/updated_at

### Campos Visíveis ao Usuário
- Todos os dados de entrada que o usuário pode ver/editar
- Nomes, descrições, valores, datas
- Estados (is_active, role)

### Campos de Controle
- Timestamps de criação e modificação
- Usados para auditoria e controle interno

### Campos de Referência
- IDs que referenciam outras collections
- Normalmente o ID não é mostrado, mas o nome correspondente sim