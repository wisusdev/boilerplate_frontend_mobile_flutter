String capitalizeText(String text) {
    if (text.isEmpty) {
        return text;
    }
    
    return text[0].toUpperCase() + text.substring(1).toLowerCase();
}

String pluralizeText(String text) {
    if (text.isEmpty) {
        return text;
    }
  
    return '${text}s';
}

String singularizeText(String text) {
    if (text.isEmpty) {
        return text;
    }
  
    return text.substring(0, text.length - 1);
}

String toUpperCaseText(String text) {
    return text.toUpperCase();
}

String toLowerCaseText(String text) {
    return text.toLowerCase();
}