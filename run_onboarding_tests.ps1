# Pet Finder Test Runner Script (PowerShell)
# This script runs all types of tests for the onboarding feature

Write-Host "🧪 Pet Finder - Onboarding Tests" -ForegroundColor Cyan
Write-Host "=================================" -ForegroundColor Cyan

# Function to print colored output
function Write-Status {
    param($Message)
    Write-Host "[INFO] $Message" -ForegroundColor Blue
}

function Write-Success {
    param($Message)
    Write-Host "[SUCCESS] $Message" -ForegroundColor Green
}

function Write-Warning {
    param($Message)
    Write-Host "[WARNING] $Message" -ForegroundColor Yellow
}

function Write-Error {
    param($Message)
    Write-Host "[ERROR] $Message" -ForegroundColor Red
}

# Check if Flutter is installed
try {
    $flutterVersion = flutter --version
    Write-Status "Flutter is installed"
    Write-Host $flutterVersion
} catch {
    Write-Error "Flutter is not installed or not in PATH"
    exit 1
}

# Get dependencies
Write-Status "Getting dependencies..."
try {
    flutter pub get
    Write-Success "Dependencies retrieved successfully"
} catch {
    Write-Error "Failed to get dependencies"
    exit 1
}

# Run unit tests
Write-Status "Running unit tests..."
try {
    flutter test test/onboarding_logic_test.dart --coverage
    Write-Success "Unit tests passed"
} catch {
    Write-Error "Unit tests failed"
    exit 1
}

# Run widget tests
Write-Status "Running widget tests..."
try {
    flutter test test/onboarding_screen_test.dart --coverage
    Write-Success "Widget tests passed"
} catch {
    Write-Error "Widget tests failed"
    exit 1
}

# Run all tests with coverage
Write-Status "Running all tests with coverage..."
try {
    flutter test --coverage
    Write-Success "All tests passed"
} catch {
    Write-Error "Some tests failed"
    exit 1
}

# Check if coverage files exist
if (Test-Path "coverage/lcov.info") {
    Write-Success "Coverage report generated: coverage/lcov.info"
} else {
    Write-Warning "Coverage report not found"
}

Write-Success "All onboarding tests completed successfully! 🎉"
Write-Host ""
Write-Host "📊 Test Summary:" -ForegroundColor Cyan
Write-Host "✅ Unit Tests - Onboarding Logic" -ForegroundColor Green
Write-Host "✅ Widget Tests - OnboardingScreen UI" -ForegroundColor Green
Write-Host "📋 Integration Tests - End-to-end flow (requires device)" -ForegroundColor Yellow
Write-Host ""
Write-Host "📁 Test Coverage: coverage/lcov.info" -ForegroundColor Blue
Write-Host ""
Write-Host "💡 To run integration tests:" -ForegroundColor Cyan
Write-Host "   flutter test integration_test/onboarding_integration_test.dart" -ForegroundColor Gray