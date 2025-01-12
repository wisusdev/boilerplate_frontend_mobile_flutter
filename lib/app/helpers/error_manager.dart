class ErrorManager {
    Map<String, dynamic> _errors = {};

    ErrorManager({required Map<String, dynamic> initialErrors}) {
        _errors = initialErrors;
    }

    void setErrors(Map<String, dynamic> errors) {
        _errors = errors;
    }

    void resetErrors(Map<String, dynamic> initialErrors) {
        _errors = initialErrors;
    }

    Map<String, dynamic> get errors => _errors;
}