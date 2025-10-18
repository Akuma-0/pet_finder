#!/bin/bash

# Test Runner Script for Pet Finder Onboarding Feature
# This script provides convenient commands to run different test suites

echo "🧪 Pet Finder Onboarding Test Runner"
echo "======================================"

# Function to run unit tests
run_unit_tests() {
    echo "📋 Running Unit Tests..."
    flutter test test/onboarding_logic_test.dart
}

# Function to run widget tests
run_widget_tests() {
    echo "🎨 Running Widget Tests..."
    flutter test test/onboarding_screen_widget_test.dart
}

# Function to run integration tests
run_integration_tests() {
    echo "🔗 Running Integration Tests..."
    echo "⚠️  Make sure you have a device connected or emulator running!"
    flutter test integration_test/onboarding_integration_test.dart
}

# Function to run all tests
run_all_tests() {
    echo "🚀 Running All Tests..."
    flutter test
}

# Function to run tests with coverage
run_tests_with_coverage() {
    echo "📊 Running Tests with Coverage..."
    flutter test --coverage
    echo "📈 Coverage report generated in coverage/lcov.info"
}

# Function to show test summary
show_test_summary() {
    echo ""
    echo "📋 Test Summary:"
    echo "----------------"
    echo "Unit Tests:        12 tests (Business logic, data persistence)"
    echo "Widget Tests:      7 tests  (UI components, responsive design)"
    echo "Integration Tests: 5 tests  (End-to-end user journeys)"
    echo "Smoke Test:        1 test   (App initialization)"
    echo "Total:             25 tests"
    echo ""
}

# Main menu
if [ $# -eq 0 ]; then
    echo ""
    echo "Usage: $0 [option]"
    echo ""
    echo "Options:"
    echo "  unit        Run unit tests only"
    echo "  widget      Run widget tests only"
    echo "  integration Run integration tests only"
    echo "  all         Run all tests"
    echo "  coverage    Run all tests with coverage"
    echo "  summary     Show test summary"
    echo ""
    echo "Examples:"
    echo "  $0 unit"
    echo "  $0 all"
    echo "  $0 coverage"
    echo ""
    show_test_summary
    exit 0
fi

# Process command line arguments
case $1 in
    "unit")
        run_unit_tests
        ;;
    "widget")
        run_widget_tests
        ;;
    "integration")
        run_integration_tests
        ;;
    "all")
        run_all_tests
        ;;
    "coverage")
        run_tests_with_coverage
        ;;
    "summary")
        show_test_summary
        ;;
    *)
        echo "❌ Unknown option: $1"
        echo "Use '$0' without arguments to see available options."
        exit 1
        ;;
esac

echo ""
echo "✅ Test execution completed!"