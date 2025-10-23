@echo off
REM Home Feature Test Runner Script for Windows
REM This script runs comprehensive tests for the home feature

echo 🧪 Running Home Feature Tests...
echo =================================

REM Initialize counters
set total_tests=0
set passed_tests=0

REM Function to run tests
call :run_test "HomeCubit Unit Tests" "flutter test test/home_cubit_test.dart"
call :run_test "HomeRepo Unit Tests" "flutter test test/home_repo_test.dart"
call :run_test "Breeds Model Tests" "flutter test test/breeds_model_test.dart"

echo.
echo 🎨 WIDGET TESTS
echo ===============

call :run_test "SearchBox Widget Tests" "flutter test test/search_box_widget_test.dart"
call :run_test "BreedTile Widget Tests" "flutter test test/breed_tile_widget_test.dart"
call :run_test "BreedsListView Widget Tests" "flutter test test/breeds_list_view_widget_test.dart"
call :run_test "HomeBlocBuilder Widget Tests" "flutter test test/home_bloc_builder_widget_test.dart"
call :run_test "HomeScreen Widget Tests" "flutter test test/home_screen_widget_test.dart"

echo.
echo 🔗 INTEGRATION TESTS
echo ====================

call :run_test "Home Feature Integration Tests" "flutter test integration_test/home_feature_integration_test.dart"

echo.
echo 📊 GENERATING TEST COVERAGE
echo ============================

echo Generating coverage report...
flutter test --coverage
if exist "coverage\lcov.info" (
    echo ✅ Coverage file generated
) else (
    echo ⚠️  Coverage file not found
)

echo.
echo 📈 TEST SUMMARY
echo ===============

if %passed_tests%==%total_tests% (
    echo 🎉 All tests passed! ^(%passed_tests%/%total_tests%^)
    set exit_code=0
) else (
    set /a failed_tests=%total_tests%-%passed_tests%
    echo ❌ %failed_tests% out of %total_tests% tests failed
    echo ✅ %passed_tests% out of %total_tests% tests passed
    set exit_code=1
)

echo.
echo 💡 RECOMMENDATIONS
echo ==================

if %exit_code%==0 (
    echo • Great job! All tests are passing
    echo • Consider adding more edge case tests
    echo • Monitor test execution time for performance
) else (
    echo • Fix failing tests before merging
    echo • Review test logs for specific error details
    echo • Consider adding more unit tests for edge cases
)

echo • Run 'flutter test --coverage' for detailed coverage
echo • Use 'flutter test --watch' for continuous testing during development

echo.
echo Test execution completed!
exit /b %exit_code%

:run_test
set /a total_tests+=1
echo Running %~1...
%~2 >nul 2>&1
if %errorlevel%==0 (
    echo ✅ %~1 passed!
    set /a passed_tests+=1
) else (
    echo ❌ %~1 failed!
)
goto :eof