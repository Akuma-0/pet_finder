#!/bin/bash

# Pet Finder Test Runner Script
# This script runs all types of tests for the onboarding feature

echo "🧪 Pet Finder - Onboarding Tests"
echo "================================="

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if Flutter is installed
if ! command -v flutter &> /dev/null; then
    print_error "Flutter is not installed or not in PATH"
    exit 1
fi

print_status "Flutter version:"
flutter --version

# Get dependencies
print_status "Getting dependencies..."
flutter pub get

if [ $? -ne 0 ]; then
    print_error "Failed to get dependencies"
    exit 1
fi

print_success "Dependencies retrieved successfully"

# Run unit tests
print_status "Running unit tests..."
flutter test test/onboarding_logic_test.dart --coverage

if [ $? -eq 0 ]; then
    print_success "Unit tests passed"
else
    print_error "Unit tests failed"
    exit 1
fi

# Run widget tests
print_status "Running widget tests..."
flutter test test/onboarding_screen_test.dart --coverage

if [ $? -eq 0 ]; then
    print_success "Widget tests passed"
else
    print_error "Widget tests failed"
    exit 1
fi

# Run all tests with coverage
print_status "Running all tests with coverage..."
flutter test --coverage

if [ $? -eq 0 ]; then
    print_success "All tests passed"
else
    print_error "Some tests failed"
    exit 1
fi

# Generate coverage report (if genhtml is available)
if command -v genhtml &> /dev/null; then
    print_status "Generating coverage report..."
    genhtml coverage/lcov.info -o coverage/html
    print_success "Coverage report generated in coverage/html/"
else
    print_warning "genhtml not found. Install lcov to generate HTML coverage reports"
fi

# Run integration tests (commented out as they require device/emulator)
# print_status "Running integration tests..."
# flutter test integration_test/onboarding_integration_test.dart

# if [ $? -eq 0 ]; then
#     print_success "Integration tests passed"
# else
#     print_error "Integration tests failed"
#     exit 1
# fi

print_success "All onboarding tests completed successfully! 🎉"
echo ""
echo "📊 Test Summary:"
echo "✅ Unit Tests - Onboarding Logic"
echo "✅ Widget Tests - OnboardingScreen UI"
echo "📋 Integration Tests - End-to-end flow (requires device)"
echo ""
echo "📁 Test Coverage: coverage/lcov.info"
echo "🌐 HTML Report: coverage/html/index.html (if genhtml available)"