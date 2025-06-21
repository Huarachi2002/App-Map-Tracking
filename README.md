# 📱 Mobile App - Crucero Tracking

Aplicación móvil multiplataforma desarrollada con **Flutter** para el sistema de tracking de transporte público. Proporciona interfaces diferenciadas para pasajeros y micreros (conductores).

## 🎯 Características Principales

### 👥 Para Pasajeros
- ✅ **Visualización de rutas** en tiempo real
- ✅ **Tracking de micros** en el mapa
- ✅ **Búsqueda de rutas** por entidad operadora
- ✅ **Modo offline** para consultas
- ✅ **Notificaciones** de llegada de micros

### 🚐 Para Micreros (Conductores)
- ✅ **Dashboard de gestión** de rutas
- ✅ **Selección de ruta activa** desde el dashboard
- ✅ **Tracking GPS** en tiempo real
- ✅ **Envío automático** de ubicación
- ✅ **Servicio en background** para tracking continuo
- ✅ **Gestión de viajes** (iniciar/detener)

## 🛠️ Stack Tecnológico

- **[Flutter 3.x](https://flutter.dev/)** - Framework multiplataforma
- **[Dart](https://dart.dev/)** - Lenguaje de programación
- **[Riverpod](https://riverpod.dev/)** - Gestión de estado reactiva
- **[MapLibre GL](https://maplibre.org/)** - Mapas interactivos
- **[Socket.IO Client](https://socket.io/)** - Comunicación en tiempo real
- **[Isar Database](https://isar.dev/)** - Base de datos local NoSQL
- **[Geolocator](https://pub.dev/packages/geolocator)** - Servicios de geolocalización
- **[Go Router](https://pub.dev/packages/go_router)** - Navegación declarativa
- **[Connectivity Plus](https://pub.dev/packages/connectivity_plus)** - Monitoreo de conectividad

## 🏗️ Arquitectura de la App

```
┌─────────────────────────────────────────────────────────────┐
│                        Presentation Layer                   │
├─────────────────────────────────────────────────────────────┤
│  Features/                                                  │
│  ├── Auth (Login, User Type Selection)                     │
│  ├── Map (Client Map, Employee Map, Dashboard)            │
│  └── Providers (Global State Management)                   │
├─────────────────────────────────────────────────────────────┤
│                        Domain Layer                         │
├─────────────────────────────────────────────────────────────┤
│  Domain/                                                    │
│  ├── Entities (Ruta, Entidad, User Models)               │
│  ├── Repositories (Abstractions)                          │
│  └── Use Cases (Business Logic)                           │
├─────────────────────────────────────────────────────────────┤
│                         Data Layer                          │
├─────────────────────────────────────────────────────────────┤
│  Data/                                                      │
│  ├── Datasources (API, Local DB)                          │
│  ├── Models (JSON Serialization)                          │
│  └── Repositories (Implementations)                        │
├─────────────────────────────────────────────────────────────┤
│                       Services Layer                        │
├─────────────────────────────────────────────────────────────┤
│  Services/                                                  │
│  ├── API Service (HTTP Client)                            │
│  ├── Socket Services (Real-time)                          │
│  ├── Location Background Service                          │
│  └── Tracking Socket Service                              │
└─────────────────────────────────────────────────────────────┘
```

## 📁 Estructura del Proyecto

```
mobile/
├── lib/
│   ├── features/                   # Módulos por funcionalidad
│   │   ├── auth/                   # Autenticación
│   │   │   ├── models/
│   │   │   ├── providers/
│   │   │   └── screens/
│   │   ├── map/                    # Funcionalidades del mapa
│   │   │   ├── providers/
│   │   │   ├── screens/
│   │   │   ├── services/
│   │   │   └── widgets/
│   │   ├── providers/              # Providers globales
│   │   └── tracking/               # Sistema de tracking
│   ├── domain/                     # Lógica de negocio
│   │   ├── entities/
│   │   ├── repositories/
│   │   └── usecases/
│   ├── data/                       # Acceso a datos
│   │   ├── datasource/
│   │   ├── models/
│   │   └── repositories_impl/
│   ├── services/                   # Servicios técnicos
│   │   ├── api_service.dart
│   │   ├── socket_service.dart
│   │   ├── location_background_service.dart
│   │   └── tracking_socket_service.dart
│   ├── config/                     # Configuración
│   │   ├── constants.dart
│   │   └── routes.dart
│   ├── common/                     # Utilidades compartidas
│   │   ├── shared_preference_helper.dart
│   │   ├── utils.dart
│   │   └── widgets/
│   └── main.dart                   # Punto de entrada
├── android/                        # Configuración Android
├── ios/                           # Configuración iOS
├── assets/                        # Recursos estáticos
│   ├── images/
│   └── maplibre/
├── pubspec.yaml                   # Dependencias y configuración
└── README.md                      # Este archivo
```

## 🚀 Instalación y Configuración

### 1. Prerrequisitos

```bash
# Verificar instalación de Flutter
flutter --version    # Flutter 3.16.0 o superior
dart --version       # Dart 3.2.0 o superior

# Verificar doctores de Flutter
flutter doctor
```

### 2. Instalación

```bash
# Clonar el repositorio
git clone <repo-url>
cd mobile

# Instalar dependencias
flutter pub get

# Generar código (si es necesario)
flutter packages pub run build_runner build
```

### 3. Configuración de Constantes

Editar `lib/config/constants.dart`:

```dart
// Configuración del servidor
const String baseUrl = 'http://TU_SERVIDOR_IP:3001/api';
const String baseUrlSocket = 'http://TU_SERVIDOR_IP:3001';

// Configuración de MapLibre
const String mapStyleUrl = 'assets/maplibre/style.json';

// Configuración de la app
const String appName = 'Crucero Tracking';
const String appVersion = '1.0.0';
```

### 4. Configuración de Mapas

#### MapLibre Style (assets/maplibre/style.json)
Asegúrarse de que el archivo de estilo de mapa esté configurado correctamente para el área de Santa Cruz.

#### Permisos de Ubicación

**Android (android/app/src/main/AndroidManifest.xml):**
```xml
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
<uses-permission android:name="android.permission.ACCESS_BACKGROUND_LOCATION" />
<uses-permission android:name="android.permission.INTERNET" />
<uses-permission android:name="android.permission.WAKE_LOCK" />
<uses-permission android:name="android.permission.FOREGROUND_SERVICE" />
```

**iOS (ios/Runner/Info.plist):**
```xml
<key>NSLocationWhenInUseUsageDescription</key>
<string>Esta app necesita acceso a la ubicación para mostrar tu posición en el mapa</string>
<key>NSLocationAlwaysAndWhenInUseUsageDescription</key>
<string>Esta app necesita acceso continuo a la ubicación para tracking en segundo plano</string>
```

## 🔧 Ejecución de la App

### Desarrollo
```bash
# Ejecutar en emulador/dispositivo Android
flutter run

# Ejecutar en simulador iOS
flutter run

# Ejecutar con hot reload
flutter run --hot

# Ejecutar en un dispositivo específico
flutter devices
flutter run -d <device-id>
```

### Build para Producción
```bash
# Android APK
flutter build apk --release

# Android App Bundle (recomendado para Play Store)
flutter build appbundle --release

# iOS (requiere macOS y Xcode)
flutter build ios --release
```

## 🎭 Flujos de Usuario

### 🔐 Autenticación

#### 1. Selección de Tipo de Usuario
- **Ubicación**: `UserTypeSelectionPage`
- **Opciones**: Pasajero o Micrero
- **Navegación**: Redirige a login con parámetro `?tipo=cliente|micrero`

#### 2. Login
- **Online**: Autenticación con servidor backend
- **Offline**: Fallback a credenciales guardadas localmente
- **Credentials**: Email y contraseña
- **Funcionalidad**: Login rápido para desarrollo (marco.chofer@gmail.com)

### 👥 Flujo del Pasajero (Cliente)

#### 1. Mapa Principal
```dart
// Ubicación: ClientMapPage
// Funcionalidades:
- Ver mapa interactivo de Santa Cruz
- Visualizar rutas disponibles
- Seguir micros en tiempo real
- Recibir actualizaciones por WebSocket
```

#### 2. Búsqueda de Rutas
```dart
// Funcionalidades:
- Búsqueda por entidad operadora
- Lista de rutas disponibles
- Información detallada de cada ruta
- Modo offline para consultas
```

### 🚐 Flujo del Micrero (Empleado)

#### 1. Dashboard de Micrero
```dart
// Ubicación: MicreroDashboard
// Funcionalidades:
- Lista de rutas de su entidad
- Selección de ruta activa
- Modal con opciones "Ver Ruta" e "Iniciar Viaje"
- Navegación al mapa de empleado
```

#### 2. Mapa de Empleado
```dart
// Ubicación: EmployeeMapPage
// Funcionalidades:
- Tracking GPS automático
- Envío de ubicación por WebSocket
- Gestión de ruta seleccionada
- Servicio en background
```

## 🗃️ Gestión de Estado

### Riverpod Providers

#### Autenticación
```dart
final authStateProvider = StateNotifierProvider<AuthStateNotifier, AuthState>
final userProvider = StateProvider<UserModel?>
```

#### Entidades y Rutas
```dart
final entidadProvider = FutureProvider<List<Entidad>>
final rutasEntidadProvider = FutureProvider.family<List<Ruta>, String>
final rutaProvider = FutureProvider<List<Ruta>>
```

#### Conectividad y Offline
```dart
final connectivityProvider = StreamProvider<ConnectivityResult>
final isOnlineProvider = Provider<bool>
```

#### Mapa y Tracking
```dart
final mapStateProvider = StateNotifierProvider<MapStateNotifier, MapState>
final trackingProvider = StateNotifierProvider<TrackingNotifier, TrackingState>
```

## 🌐 Conectividad y Modo Offline

### Sistema de Sincronización
```dart
// Funcionalidades implementadas:
✅ Detección automática de conectividad
✅ Cache de rutas en base de datos local (Isar)
✅ Sync automático cuando se restaura conexión
✅ Login offline con credenciales guardadas
✅ Fallback a datos locales cuando no hay conexión
```

### Providers de Conectividad
```dart
final connectivityProvider = StreamProvider<ConnectivityResult>((ref) {
  return Connectivity().onConnectivityChanged;
});

final isOnlineProvider = Provider<bool>((ref) {
  final connectivity = ref.watch(connectivityProvider);
  return connectivity.when(
    data: (result) => result != ConnectivityResult.none,
    loading: () => false,
    error: (_, __) => false,
  );
});
```

## 🔌 Integración con Backend

### API Service
```dart
class ApiService {
  static const String baseUrl = 'http://SERVER_IP:3001/api';
  
  // Métodos HTTP disponibles
  Future<Map<String, dynamic>> get(String endpoint);
  Future<Map<String, dynamic>> post(String endpoint, Map<String, dynamic> data);
  Future<Map<String, dynamic>> put(String endpoint, Map<String, dynamic> data);
  Future<Map<String, dynamic>> delete(String endpoint);
}
```

### WebSocket Services

#### Socket Principal
```dart
// Para comunicación general y tracking
final socket = IO.io('http://SERVER_IP:3001', {
  'auth': {
    'microId': microId,
    'token': authToken
  }
});

// Eventos de tracking
socket.emit('updateLocation', locationData);
socket.emit('joinRoute', routeId);
socket.on('routeLocationUpdate', handleLocationUpdate);
```

#### Background Service
```dart
// Servicio para tracking en segundo plano (solo micreros)
class LocationBackgroundService {
  static Future<bool> initializeSafely() async {
    // Verificar permisos y GPS antes de inicializar
    // Inicializar solo para empleados con microId
  }
}
```

## 📊 Base de Datos Local (Isar)

### Modelos Locales
```dart
@collection
class RutaModel {
  Id id = Isar.autoIncrement;
  
  @Index()
  late String rutaId;
  late String nombre;
  late String descripcion;
  late String idEntidad;
  
  // Campos calculados para offline
  @ignore
  bool get esLocal => true;
}

@collection  
class EntidadModel {
  Id id = Isar.autoIncrement;
  
  @Index()
  late String entidadId;
  late String nombre;
  late String tipo;
}
```

### Repositories con Conectividad
```dart
class RutaRepositoryImpl implements RutaRepository {
  @override
  Future<List<Ruta>> getRutasByEntidad(String entidadId) async {
    final isOnline = ref.read(isOnlineProvider);
    
    if (isOnline) {
      // Fetch desde API y guardar en local
      final rutasFromApi = await apiDataSource.getRutasByEntidad(entidadId);
      await localDataSource.saveRutas(rutasFromApi);
      return rutasFromApi;
    } else {
      // Fallback a datos locales
      return await localDataSource.getRutasByEntidad(entidadId);
    }
  }
}
```

## 🛠️ Scripts de Desarrollo

### Comandos Útiles
```bash
# Análisis de código
flutter analyze

# Formatear código
dart format .

# Tests
flutter test

# Limpiar cache
flutter clean
flutter pub get

# Generar código (para Isar, JSON, etc.)
flutter packages pub run build_runner build --delete-conflicting-outputs

# Ver devices conectados
flutter devices

# Logs en tiempo real
flutter logs
```

### Build Variants
```bash
# Debug (desarrollo)
flutter run --debug

# Profile (testing performance)
flutter run --profile

# Release (producción)
flutter run --release
```

## 🔒 Configuración de Seguridad

### Almacenamiento Seguro
```dart
// Usando SharedPreferences para datos no sensibles
await prefs.setString('user_id', userId);
await prefs.setString('entidad_id', entidadId);

// Para datos sensibles, considerar flutter_secure_storage
```

### Autenticación
```dart
// JWT Token storage
class AuthProvider {
  Future<void> saveCredentials(String email, String password, UserModel user) {
    // Guarda hash de password, no password real
    final passwordHash = password.hashCode.toString();
    // Guarda token JWT en storage seguro
  }
}
```

## 🐛 Debugging y Troubleshooting

### Logs del Sistema
```bash
# Ver logs de Flutter
flutter logs

# Logs específicos de la app
I/flutter: 🔐 Iniciando proceso de login...
I/flutter: 👤 Email: jose.cliente@gmail.com
I/flutter: ✅ Login online exitoso
```

### Problemas Comunes

#### 1. Error de Conectividad
```bash
# Verificar IP del servidor en constants.dart
# Verificar que el backend esté ejecutándose
# Comprobar firewall y puertos
```

#### 2. Error de Permisos de Ubicación
```bash
# Verificar permisos en AndroidManifest.xml / Info.plist
# Solicitar permisos en runtime
# Verificar que GPS esté habilitado
```

#### 3. Error de Background Service
```bash
# Solo se inicializa para empleados con microId
# Verificar permisos de background
# Revisar configuración de notificaciones
```

#### 4. Socket No Conecta
```bash
# Verificar URL del socket en constants.dart
# Comprobar que backend esté corriendo
# Revisar logs del servidor
```

## 📈 Performance y Optimización

### Recomendaciones
- ✅ **Lazy Loading**: Rutas se cargan solo cuando se necesitan
- ✅ **Caching**: Datos se guardan en Isar para acceso offline
- ✅ **State Management**: Riverpod optimiza re-renders
- ✅ **Background Optimization**: Service solo para empleados
- 🔄 **Memory Management**: Dispose de controllers apropiadamente

### Métricas
```bash
# Analizar performance
flutter run --profile
flutter run --trace-startup --profile

# Analizar tamaño del APK
flutter build apk --analyze-size
```

## 🚀 Deployment

### Android
```bash
# Generar release APK
flutter build apk --release

# Generar AAB para Play Store
flutter build appbundle --release

# Ubicación de archivos
# APK: build/app/outputs/flutter-apk/app-release.apk
# AAB: build/app/outputs/bundle/release/app-release.aab
```

### iOS
```bash
# Requiere macOS y Xcode configurado
flutter build ios --release

# Luego usar Xcode para archive y distribute
```

## 📞 Soporte y Debugging

### Información de Debug
```dart
// Activar logs detallados en constants.dart
const bool enableDebugLogs = true;

// Información del dispositivo
await DeviceInfo().getDeviceInfo();

// Estado de conectividad
await Connectivity().checkConnectivity();
```

### Reporte de Bugs
Al reportar bugs, incluir:
1. **Versión de Flutter**: `flutter --version`
2. **Dispositivo**: Android/iOS + versión
3. **Logs**: Salida de `flutter logs`
4. **Pasos para reproducir**: Secuencia exacta
5. **Conectividad**: Estado online/offline
