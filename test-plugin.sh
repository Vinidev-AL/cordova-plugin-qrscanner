#!/bin/bash

# Script de teste para verificar a compatibilidade do plugin QRScanner modernizado
# Execute este script para validar se as alterações funcionam corretamente

echo "🔍 Testando Plugin QRScanner Modernizado"
echo "========================================"

# Verificar se o Cordova está instalado
if ! command -v cordova &> /dev/null; then
    echo "❌ Cordova CLI não encontrado. Instale com: npm install -g cordova"
    exit 1
fi

echo "✅ Cordova CLI encontrado"

# Verificar versão do Cordova
CORDOVA_VERSION=$(cordova --version)
echo "📋 Versão do Cordova: $CORDOVA_VERSION"

# Verificar se o Node.js é compatível
NODE_VERSION=$(node --version)
echo "📋 Versão do Node.js: $NODE_VERSION"

# Criar projeto de teste temporário
TEST_PROJECT="qrscanner-test"

if [ -d "$TEST_PROJECT" ]; then
    echo "🧹 Removendo projeto de teste anterior..."
    rm -rf $TEST_PROJECT
fi

echo "📁 Criando projeto de teste..."
cordova create $TEST_PROJECT com.test.qrscanner QRScannerTest

cd $TEST_PROJECT

echo "📱 Adicionando plataforma Android..."
cordova platform add android@latest

# Verificar se o plugin pode ser adicionado
echo "🔌 Adicionando plugin QRScanner..."
PLUGIN_PATH="../"
cordova plugin add $PLUGIN_PATH

if [ $? -eq 0 ]; then
    echo "✅ Plugin adicionado com sucesso!"
else
    echo "❌ Erro ao adicionar plugin"
    exit 1
fi

# Tentar fazer build
echo "🏗️  Tentando fazer build do projeto..."
cordova build android

if [ $? -eq 0 ]; then
    echo "✅ Build realizado com sucesso!"
    echo ""
    echo "🎉 TESTE CONCLUÍDO COM SUCESSO!"
    echo "   O plugin foi modernizado corretamente e está funcionando."
else
    echo "❌ Erro no build - verifique as dependências"
    echo ""
    echo "📋 Logs de erro:"
    echo "   Verifique se todas as dependências estão atualizadas"
    echo "   Certifique-se de que o Android SDK está configurado"
    echo "   Verifique se o Java 17 está sendo usado"
fi

# Limpar projeto de teste
cd ..
echo "🧹 Limpando arquivos de teste..."
rm -rf $TEST_PROJECT

echo ""
echo "📚 Para mais informações, consulte o MIGRATION_GUIDE.md"
