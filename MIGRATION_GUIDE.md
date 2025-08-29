# Guia de Migração - Cordova QRScanner Plugin

## Alterações Realizadas para Compatibilidade Moderna

### 1. **Atualização do Gradle (qrscanner.gradle)**

#### Problemas Identificados:
- Uso de `compile` (descontinuado desde Gradle 3.0)
- Repositório `jcenter()` descontinuado
- Bibliotecas Android Support antigas
- buildToolsVersion muito antigo (23.0.2)

#### Correções Aplicadas:
```gradle
repositories {
    google()           // Adicionado para bibliotecas AndroidX
    mavenCentral()     // Substituído jcenter()
}

dependencies {
    implementation 'com.journeyapps:zxing-android-embedded:4.3.0'  // Atualizado de 3.3.0
    implementation 'androidx.appcompat:appcompat:1.6.1'            // Migrado para AndroidX
    implementation 'androidx.core:core:1.10.1'                     // Adicionado para suporte AndroidX
}

android {
    compileSdkVersion 34        // Atualizado para SDK moderno
    buildToolsVersion '34.0.0'  // Atualizado
    
    defaultConfig {
        minSdkVersion 21        // Definido explicitamente
        targetSdkVersion 34     // Compatível com Android 14
    }
    
    compileOptions {
        sourceCompatibility JavaVersion.VERSION_1_8  // Java 8 mínimo
        targetCompatibility JavaVersion.VERSION_1_8
    }
}
```

### 2. **Migração para AndroidX (QRScanner.java)**

#### Problemas Identificados:
- Import de `android.support.v4.app.ActivityCompat`

#### Correções Aplicadas:
```java
// Antigo
import android.support.v4.app.ActivityCompat;

// Novo
import androidx.core.app.ActivityCompat;
```

### 3. **Atualização do Plugin.xml**

#### Problemas Identificados:
- Versão mínima do Cordova muito antiga (>=3.4.0)
- Falta de especificação de versões das plataformas
- Falta de configuração AndroidX

#### Correções Aplicadas:
```xml
<engines>
    <engine name="cordova" version=">=11.0.0"/>
    <engine name="cordova-android" version=">=11.0.0"/>
    <engine name="cordova-ios" version=">=6.0.0"/>
</engines>

<!-- Adicionado suporte AndroidX -->
<preference name="AndroidXEnabled" value="true" />
```

### 4. **Atualização do Package.json**

#### Problemas Identificados:
- Dependências de desenvolvimento muito antigas
- Versões de ferramentas incompatíveis com Node.js moderno

#### Correções Aplicadas:
- `webrtc-adapter`: 3.1.4 → 8.2.3
- `gulp`: 3.9.1 → 4.0.2
- `webpack`: 2.7.0 → 5.88.2
- `husky`: 0.13.1 → 8.0.3
- E outras dependências atualizadas

## Compatibilidade Resultante

### Ambiente Suportado:
- **Cordova**: ≥ 11.0.0
- **Cordova Android**: ≥ 11.0.0
- **JDK**: 17 (compatível)
- **Gradle**: 7.6+ (compatível)
- **Android SDK**: API 21-34
- **Android Studio**: Versão moderna

### Funcionalidades Mantidas:
- ✅ Escaneamento de QR Code
- ✅ Controle de flash/lanterna
- ✅ Troca de câmera (frontal/traseira)
- ✅ Prévia da câmera
- ✅ Permissões de câmera
- ✅ Suporte a múltiplas plataformas

### Melhorias de Segurança:
- ✅ Bibliotecas atualizadas para versões sem vulnerabilidades conhecidas
- ✅ APIs de permissão modernas (AndroidX)
- ✅ Compatibilidade com Android 12+ (targetSdk 34)

## Notas Importantes

### 1. **API de Câmera**
O plugin ainda utiliza a API `android.hardware.Camera` (API nível 21) através da biblioteca ZXing. Esta API, embora depreciada, ainda é suportada e funcional. A biblioteca ZXing 4.3.0 gerencia internamente a compatibilidade.

### 2. **AndroidX**
A migração para AndroidX é obrigatória para projetos modernos. Certifique-se de que seu projeto principal também use AndroidX.

### 3. **Compatibilidade com Versões Anteriores**
- **Android**: Suporte mantido para API 21+ (Android 5.0+)
- **iOS**: Compatível com versões recentes
- **Browser**: Funcionalidade mantida

## Próximos Passos Recomendados

### Para Uso em Produção:
1. Teste extensivo em dispositivos Android 12+
2. Verifique compatibilidade com outras dependências do projeto
3. Execute testes de regressão para todas as funcionalidades
4. Considere atualizar a versão do plugin (3.0.1 → 3.1.0)

### Melhorias Futuras (Opcionais):
1. **Migração para Camera2 API**: Para aproveitar recursos modernos
2. **Suporte a ML Kit**: Para melhor performance de detecção
3. **Permissions modernas**: Implementar novos padrões de permissão do Android 13+

## Comandos para Testar

```bash
# Instalar dependências atualizadas
npm install

# Adicionar ao projeto Cordova
cordova plugin add /caminho/para/o/plugin

# Build do projeto
cordova build android
```
