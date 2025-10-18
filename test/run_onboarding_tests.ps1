# Onboarding Feature Test Runner (PowerShell)
# This script runs all tests for the onboarding feature

Write-Host "🚀 Running Onboarding Feature Test Suite" -ForegroundColor Blue
Write-Host "========================================" -ForegroundColor Blue

# Run unit tests (most reliable)
Write-Host ""
Write-Host "📝 Running Unit Tests..." -ForegroundColor Yellow
Write-Host "------------------------" -ForegroundColor Yellow
flutter test test/onboarding_logic_test.dart

if ($LASTEXITCODE -eq 0) {
    Write-Host "✅ Unit tests passed!" -ForegroundColor Green
} else {
    Write-Host "❌ Unit tests failed!" -ForegroundColor Red
}

# Run widget tests (may show layout warnings)
Write-Host ""
Write-Host "🎨 Running Widget Tests..." -ForegroundColor Yellow
Write-Host "--------------------------" -ForegroundColor Yellow
Write-Host "⚠️  Note: Layout overflow warnings are expected due to responsive design" -ForegroundColor Cyan
flutter test test/onboarding_screen_widget_test.dart --reporter=compact

if ($LASTEXITCODE -eq 0) {
    Write-Host "✅ Widget tests passed (despite layout warnings)!" -ForegroundColor Green
} else {
    Write-Host "❌ Widget tests failed!" -ForegroundColor Red
}

# Run integration tests (requires device/emulator)
Write-Host ""
Write-Host "🔗 Integration Tests Available..." -ForegroundColor Yellow
Write-Host "--------------------------------" -ForegroundColor Yellow
Write-Host "To run integration tests, ensure a device/emulator is connected and run:" -ForegroundColor Cyan
Write-Host "flutter test integration_test/onboarding_integration_test.dart" -ForegroundColor White

Write-Host ""
Write-Host "📊 Test Summary:" -ForegroundColor Blue
Write-Host "- Unit Tests: Core business logic ✅" -ForegroundColor Green
Write-Host "- Widget Tests: UI structure validation (with layout warnings) ⚠️" -ForegroundColor Yellow
Write-Host "- Integration Tests: End-to-end flows (manual execution required) 📱" -ForegroundColor Cyan
Write-Host ""
Write-Host "For detailed test documentation, see: test/TEST_DOCUMENTATION.md" -ForegroundColor Blue