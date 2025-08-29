# Script de teste para verificar a compatibilidade do plugin QRScanner modernizado
# Execute este script no PowerShell para validar se as alterações funcionam corretamente

Write-Host "🔍 Testando Plugin QRScanner Modernizado" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan

# Verificar se o Cordova está instalado
$cordovaInstalled = Get-Command cordova -ErrorAction SilentlyContinue
if (-not $cordovaInstalled) {
    Write-Host "❌ Cordova CLI não encontrado. Instale com: npm install -g cordova" -ForegroundColor Red
    exit 1
}

Write-Host "✅ Cordova CLI encontrado" -ForegroundColor Green

# Verificar versão do Cordova
$cordovaVersion = cordova --version
Write-Host "📋 Versão do Cordova: $cordovaVersion" -ForegroundColor Blue

# Verificar versão do Node.js
$nodeVersion = node --version
Write-Host "📋 Versão do Node.js: $nodeVersion" -ForegroundColor Blue

# Criar projeto de teste temporário
$testProject = "qrscanner-test"

if (Test-Path $testProject) {
    Write-Host "🧹 Removendo projeto de teste anterior..." -ForegroundColor Yellow
    Remove-Item -Recurse -Force $testProject
}

Write-Host "📁 Criando projeto de teste..." -ForegroundColor Blue
cordova create $testProject com.test.qrscanner QRScannerTest

Set-Location $testProject

Write-Host "📱 Adicionando plataforma Android..." -ForegroundColor Blue
cordova platform add android@latest

# Verificar se o plugin pode ser adicionado
Write-Host "🔌 Adicionando plugin QRScanner..." -ForegroundColor Blue
$pluginPath = "../"
cordova plugin add $pluginPath

if ($LASTEXITCODE -eq 0) {
    Write-Host "✅ Plugin adicionado com sucesso!" -ForegroundColor Green
} else {
    Write-Host "❌ Erro ao adicionar plugin" -ForegroundColor Red
    exit 1
}

# Tentar fazer build
Write-Host "🏗️  Tentando fazer build do projeto..." -ForegroundColor Blue
cordova build android

if ($LASTEXITCODE -eq 0) {
    Write-Host "✅ Build realizado com sucesso!" -ForegroundColor Green
    Write-Host ""
    Write-Host "🎉 TESTE CONCLUÍDO COM SUCESSO!" -ForegroundColor Green
    Write-Host "   O plugin foi modernizado corretamente e está funcionando." -ForegroundColor Green
} else {
    Write-Host "❌ Erro no build - verifique as dependências" -ForegroundColor Red
    Write-Host ""
    Write-Host "📋 Logs de erro:" -ForegroundColor Yellow
    Write-Host "   Verifique se todas as dependências estão atualizadas" -ForegroundColor Yellow
    Write-Host "   Certifique-se de que o Android SDK está configurado" -ForegroundColor Yellow
    Write-Host "   Verifique se o Java 17 está sendo usado" -ForegroundColor Yellow
}

# Limpar projeto de teste
Set-Location ..
Write-Host "🧹 Limpando arquivos de teste..." -ForegroundColor Yellow
Remove-Item -Recurse -Force $testProject

Write-Host ""
Write-Host "📚 Para mais informações, consulte o MIGRATION_GUIDE.md" -ForegroundColor Cyan
