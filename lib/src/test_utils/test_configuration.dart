part of test_utils;

class TestConfiguration extends SimpleConfiguration {

    bool get stopTestOnExpectFailure => true;

    String formatResult(TestCase testCase) {

        return """
Running test '${testCase.description}'... 

=== output ===
""";
    }

    void onLogMessage(TestCase testCase, String message) {

        print("\t$message");
    }

    void onTestStart(TestCase testCase) {
        super.onTestStart(testCase);
        print("""====================================
[${testCase.currentGroup}] Running test '${testCase.description}'
""");
    }

    void onTestResult(TestCase testCase) {
        super.onTestResult(testCase);

        print("""

Time: ${testCase.runningTime}
Result: ${testCase.result}
${testCase.message}
""");
    }

    void onTestResultChanged(TestCase testCase) {
        super.onTestResultChanged(testCase);
        print("Test Result Changed for test '${testCase.description}'");
    }

    void onExpectFailure(String reason) {
        super.onExpectFailure(reason);
        print("""Failure:
${reason}
""");
    }

    void onInit() {
        print("Initializing test suite...");
    }

    void onStart() {
        print("Starting test suite... \n");
    }

    void onDone(bool success) {
        String result = success ? "PASSED" : "FAILED";
        print("""


Result: $result
""");
    }

    void onSummary(int passed, int failed, int errors, List<TestCase> results, String uncaughtError) {

        print("""====================================
Passed: $passed
Failed: $failed
Errors: $errors

failed tests:
""");
        for (TestCase testCase in results) {
            if ( ! testCase.passed) {
                print("'${testCase.description}'");
            }
        }

        if (null != uncaughtError && uncaughtError.isEmpty) {
            print("""

Uncaught Error: $uncaughtError
""");
        }
    }
}
