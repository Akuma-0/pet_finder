@echo off
REM Test Runner Script for Pet Finder Onboarding Feature (Windows)
REM This script provides convenient commands to run different test suites

echo 🧪 Pet Finder Onboarding Test Runner
echo ======================================

if "%1"=="" goto :show_usage

if "%1"=="unit" goto :run_unit_tests
if "%1"=="widget" goto :run_widget_tests
if "%1"=="integration" goto :run_integration_tests
if "%1"=="all" goto :run_all_tests
if "%1"=="coverage" goto :run_tests_with_coverage
if "%1"=="summary" goto :show_test_summary

echo ❌ Unknown option: %1
echo Use '%~nx0' without arguments to see available options.
goto :eof

:run_unit_tests
echo 📋 Running Unit Tests...
flutter test test/onboarding_logic_test.dart
goto :end

:run_widget_tests
echo 🎨 Running Widget Tests...
flutter test test/onboarding_screen_widget_test.dart
goto :end

:run_integration_tests
echo 🔗 Running Integration Tests...
echo ⚠️  Make sure you have a device connected or emulator running!
flutter test integration_test/onboarding_integration_test.dart
goto :end

:run_all_tests
echo 🚀 Running All Tests...
flutter test
goto :end

:run_tests_with_coverage
echo 📊 Running Tests with Coverage...
flutter test --coverage
echo 📈 Coverage report generated in coverage/lcov.info
goto :end

:show_test_summary
echo.
echo 📋 Test Summary:
echo ----------------
echo Unit Tests:        12 tests (Business logic, data persistence)
echo Widget Tests:      7 tests  (UI components, responsive design)
echo Integration Tests: 5 tests  (End-to-end user journeys)
echo Smoke Test:        1 test   (App initialization)
echo Total:             25 tests
echo.
goto :eof

:show_usage
echo.
echo Usage: %~nx0 [option]
echo.
echo Options:
echo   unit        Run unit tests only
echo   widget      Run widget tests only
echo   integration Run integration tests only
echo   all         Run all tests
echo   coverage    Run all tests with coverage
echo   summary     Show test summary
echo.
echo Examples:
echo   %~nx0 unit
echo   %~nx0 all
echo   %~nx0 coverage
echo.
call :show_test_summary
goto :eof

:end
echo.
echo ✅ Test execution completed!