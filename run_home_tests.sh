#!/bin/bash

# Home Feature Test Runner Script
# This script runs comprehensive tests for the home feature

echo "🧪 Running Home Feature Tests..."
echo "================================="

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${2}${1}${NC}"
}

# Function to run tests and check results
run_test() {
    local test_name="$1"
    local test_command="$2"
    
    print_status "Running $test_name..." "$BLUE"
    
    if eval "$test_command"; then
        print_status "✅ $test_name passed!" "$GREEN"
        return 0
    else
        print_status "❌ $test_name failed!" "$RED"
        return 1
    fi
}

# Initialize counters
total_tests=0
passed_tests=0

# Unit Tests
echo
print_status "📋 UNIT TESTS" "$YELLOW"
echo "=============="

# HomeCubit tests
total_tests=$((total_tests + 1))
if run_test "HomeCubit Unit Tests" "flutter test test/home_cubit_test.dart"; then
    passed_tests=$((passed_tests + 1))
fi

# HomeRepo tests
total_tests=$((total_tests + 1))
if run_test "HomeRepo Unit Tests" "flutter test test/home_repo_test.dart"; then
    passed_tests=$((passed_tests + 1))
fi

# Breeds Model tests
total_tests=$((total_tests + 1))
if run_test "Breeds Model Tests" "flutter test test/breeds_model_test.dart"; then
    passed_tests=$((passed_tests + 1))
fi

# Widget Tests
echo
print_status "🎨 WIDGET TESTS" "$YELLOW"
echo "==============="

# SearchBox widget tests
total_tests=$((total_tests + 1))
if run_test "SearchBox Widget Tests" "flutter test test/search_box_widget_test.dart"; then
    passed_tests=$((passed_tests + 1))
fi

# BreedTile widget tests
total_tests=$((total_tests + 1))
if run_test "BreedTile Widget Tests" "flutter test test/breed_tile_widget_test.dart"; then
    passed_tests=$((passed_tests + 1))
fi

# BreedsListView widget tests
total_tests=$((total_tests + 1))
if run_test "BreedsListView Widget Tests" "flutter test test/breeds_list_view_widget_test.dart"; then
    passed_tests=$((passed_tests + 1))
fi

# HomeBlocBuilder widget tests
total_tests=$((total_tests + 1))
if run_test "HomeBlocBuilder Widget Tests" "flutter test test/home_bloc_builder_widget_test.dart"; then
    passed_tests=$((passed_tests + 1))
fi

# HomeScreen widget tests
total_tests=$((total_tests + 1))
if run_test "HomeScreen Widget Tests" "flutter test test/home_screen_widget_test.dart"; then
    passed_tests=$((passed_tests + 1))
fi

# Integration Tests
echo
print_status "🔗 INTEGRATION TESTS" "$YELLOW"
echo "===================="

# Home Feature Integration tests
total_tests=$((total_tests + 1))
if run_test "Home Feature Integration Tests" "flutter test integration_test/home_feature_integration_test.dart"; then
    passed_tests=$((passed_tests + 1))
fi

# Test Coverage (optional)
echo
print_status "📊 GENERATING TEST COVERAGE" "$YELLOW"
echo "============================"

if command -v lcov >/dev/null 2>&1; then
    print_status "Generating coverage report..." "$BLUE"
    flutter test --coverage
    if [ -f "coverage/lcov.info" ]; then
        genhtml coverage/lcov.info -o coverage/html
        print_status "✅ Coverage report generated in coverage/html/" "$GREEN"
    else
        print_status "⚠️  Coverage file not found" "$YELLOW"
    fi
else
    print_status "⚠️  lcov not installed, skipping coverage report" "$YELLOW"
fi

# Summary
echo
print_status "📈 TEST SUMMARY" "$YELLOW"
echo "==============="

if [ $passed_tests -eq $total_tests ]; then
    print_status "🎉 All tests passed! ($passed_tests/$total_tests)" "$GREEN"
    exit_code=0
else
    failed_tests=$((total_tests - passed_tests))
    print_status "❌ $failed_tests out of $total_tests tests failed" "$RED"
    print_status "✅ $passed_tests out of $total_tests tests passed" "$GREEN"
    exit_code=1
fi

# Performance Tests (optional)
echo
print_status "⚡ PERFORMANCE CHECKS" "$YELLOW"
echo "===================="

print_status "Running performance analysis..." "$BLUE"
if flutter test --verbose test/ | grep -i "performance\|memory\|timeout"; then
    print_status "⚠️  Performance issues detected, check logs above" "$YELLOW"
else
    print_status "✅ No obvious performance issues detected" "$GREEN"
fi

# Recommendations
echo
print_status "💡 RECOMMENDATIONS" "$YELLOW"
echo "=================="

if [ $exit_code -eq 0 ]; then
    print_status "• Great job! All tests are passing" "$GREEN"
    print_status "• Consider adding more edge case tests" "$BLUE"
    print_status "• Monitor test execution time for performance" "$BLUE"
else
    print_status "• Fix failing tests before merging" "$RED"
    print_status "• Review test logs for specific error details" "$YELLOW"
    print_status "• Consider adding more unit tests for edge cases" "$BLUE"
fi

print_status "• Run 'flutter test --coverage' for detailed coverage" "$BLUE"
print_status "• Use 'flutter test --watch' for continuous testing during development" "$BLUE"

echo
print_status "Test execution completed!" "$GREEN"
exit $exit_code