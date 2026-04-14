import 'dart:io';

void main() async {
  print('=============================================');
  print('🚀 Agente de Repositorio de GitHub 🚀');
  print('=============================================');

  // Verificar si GIT está instalado
  if (!await _isGitInstalled()) {
    print('❌ Error: Git no está instalado o no se reconoce como comando del sistema.');
    print('Por favor, instala Git desde https://git-scm.com/downloads');
    return;
  }

  // Inicializar repositorio si no lo es
  bool isRepo = await _isGitRepository();
  if (!isRepo) {
    print('📦 Inicializando repositorio Git vacío...');
    await _runCommand('git', ['init']);
  }

  // Preguntar por URL del remoto
  String? url = _askUser('➤ Ingresa la URL del repositorio de GitHub\n  (Ej. https://github.com/usuario/repo.git)\n  (O deja en blanco si ya está configurado y no deseas cambiarlo):');
  
  if (url != null && url.trim().isNotEmpty) {
    bool hasRemote = await _hasOriginRemote();
    if (hasRemote) {
      await _runCommand('git', ['remote', 'set-url', 'origin', url.trim()]);
      print('✅ URL del remoto "origin" actualizada.');
    } else {
      await _runCommand('git', ['remote', 'add', 'origin', url.trim()]);
      print('✅ Remoto "origin" agregado.');
    }
  } else {
     bool hasRemote = await _hasOriginRemote();
     if (!hasRemote) {
       print('⚠️ No se ingresó URL y no hay ningún remoto "origin" configurado.');
       print('Abortando: No hay lugar a donde subir el código.');
       return;
     } else {
       print('✅ Utilizando la configuración remota "origin" existente.');
     }
  }

  // Preguntar por la rama
  String? branch = _askUser('➤ Ingresa el nombre de la rama a usar\n  (Presiona Enter para usar la rama por defecto: "main"):');
  if (branch == null || branch.trim().isEmpty) {
    branch = 'main';
  } else {
    branch = branch.trim();
  }

  // Renombrar rama actual a la seleccionada
  await _runCommand('git', ['branch', '-M', branch]);

  // Preparar archivos (Add)
  print('🔨 Preparando (staging) todos los archivos...');
  await _runCommand('git', ['add', '.']);

  // Verificar si hay cambios para hacer commit
  if (!await _hasChangesToCommit()) {
     print('⚠️ No hay archivos nuevos o modificados para hacer commit.');
     print('Probando hacer push de los commits existentes...');
  } else {
    // Preguntar por el mensaje de commit
    String? commitMessage = _askUser('➤ Ingresa el mensaje del commit\n  (Presiona Enter para mensaje por defecto: "Actualización inicial del proyecto"):');
    if (commitMessage == null || commitMessage.trim().isEmpty) {
      commitMessage = 'Actualización inicial del proyecto';
    }

    print('📝 Realizando commit...');
    await _runCommand('git', ['commit', '-m', commitMessage]);
  }

  // Subir (Push)
  print('☁️  Subiendo tu código a GitHub en la rama "$branch"...');
  print('---------------------------------------------');
  int pushExitCode = await _runCommandVisible('git', ['push', '-u', 'origin', branch]);
  print('---------------------------------------------');

  if (pushExitCode == 0) {
    print('🎉 ¡ÉXITO! El código se ha subido a GitHub correctamente.');
  } else {
    print('❌ Hubo un error al intentar subir el código.');
    print('💡 Posibles causas:');
    print('  - Credenciales (token/contraseña) incorrectas o no configuradas.');
    print('  - La rama remota tiene cambios que tú no tienes (necesitas hacer pull primero).');
    print('  - Repositorio inexistente o URL mal escrita.');
  }
}

// ------------------------------------------
// Funciones Auxiliares
// ------------------------------------------

String? _askUser(String prompt) {
  stdout.write('$prompt\n> ');
  return stdin.readLineSync();
}

Future<bool> _isGitInstalled() async {
  try {
    ProcessResult result = await Process.run('git', ['--version']);
    return result.exitCode == 0;
  } catch (e) {
    return false;
  }
}

Future<bool> _isGitRepository() async {
  try {
    ProcessResult result = await Process.run('git', ['status']);
    // Git status retorna diferente a 0 si no es repositorio o si no está inicializado un HEAD
    // Vamos a checar explícitamente el texto "fatal: not a git repository"
    if (result.stderr.toString().toLowerCase().contains('not a git repository')) {
      return false;
    }
    return true; 
  } catch (e) {
    return false;
  }
}

Future<bool> _hasOriginRemote() async {
  try {
    ProcessResult result = await Process.run('git', ['remote']);
    String out = result.stdout as String;
    return out.split('\n').map((e) => e.trim()).contains('origin');
  } catch (e) {
    return false;
  }
}

Future<bool> _hasChangesToCommit() async {
  try {
    ProcessResult result = await Process.run('git', ['status', '--porcelain']);
    String out = result.stdout as String;
    return out.trim().isNotEmpty;
  } catch (e) {
    return false;
  }
}

Future<int> _runCommand(String executable, List<String> arguments) async {
  ProcessResult result = await Process.run(executable, arguments);
  if (result.exitCode != 0) {
    print('⚠️ Error al tratar de ejecutar: $executable ${arguments.join(' ')}');
    if (result.stderr.toString().isNotEmpty) {
      print(result.stderr);
    } else {
      print(result.stdout);
    }
  }
  return result.exitCode;
}

Future<int> _runCommandVisible(String executable, List<String> arguments) async {
  Process process = await Process.start(
    executable, 
    arguments,
    mode: ProcessStartMode.inheritStdio, 
  );
  return await process.exitCode;
}
