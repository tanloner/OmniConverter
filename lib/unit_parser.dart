// lib/unit_parser.dart

import 'package:flutter/foundation.dart';

import 'models.dart';

enum TokenType { unit, multiply, divide, exponent, lParen, rParen, eof }

class Token {
  final TokenType type;
  final String value;

  Token(this.type, this.value);
}

class Lexer {
  final String input;
  int pos = 0;
  late int length;

  Lexer(this.input) {
    length = input.length;
  }

  List<Token> tokenize() {
    List<Token> tokens = [];
    while (pos < length) {
      String currentChar = input[pos];

      if (_isWhitespace(currentChar)) {
        pos++;
        continue;
      }

      if (currentChar == '*') {
        tokens.add(Token(TokenType.multiply, '*'));
        pos++;
        continue;
      }

      if (currentChar == '/') {
        tokens.add(Token(TokenType.divide, '/'));
        pos++;
        continue;
      }

      if (currentChar == '(') {
        tokens.add(Token(TokenType.lParen, '('));
        pos++;
        continue;
      }

      if (currentChar == ')') {
        tokens.add(Token(TokenType.rParen, ')'));
        pos++;
        continue;
      }

      if (currentChar == '^') {
        tokens.add(Token(TokenType.exponent, '^'));
        pos++;
        continue;
      }

      if (_isAlpha(currentChar) || currentChar == 'Ω') {
        String unitName = '';
        while (pos < length && (_isAlpha(input[pos]) || _isDigit(input[pos]))) {
          unitName += input[pos];
          pos++;
        }
        tokens.add(Token(TokenType.unit, unitName));
        continue;
      }

      if (_isDigit(currentChar) || currentChar == '-' || currentChar == '.') {
        String number = '';
        bool hasDecimal = false;
        if (currentChar == '-') {
          number += currentChar;
          pos++;
          if (pos >= length || !_isDigit(input[pos])) {
            throw FormatException('Invalid exponent format at position $pos');
          }
        }
        while (pos < length && (_isDigit(input[pos]) || input[pos] == '.')) {
          if (input[pos] == '.') {
            if (hasDecimal) {
              throw FormatException(
                  'Invalid number format with multiple decimals at position $pos');
            }
            hasDecimal = true;
          }
          number += input[pos];
          pos++;
        }
        tokens.add(Token(TokenType.exponent, number));
        continue;
      }

      throw FormatException(
          'Unknown character "$currentChar" at position $pos');
    }

    tokens.add(Token(TokenType.eof, ''));
    return tokens;
  }

  bool _isWhitespace(String ch) =>
      ch == ' ' || ch == '\t' || ch == '\n' || ch == '\r';

  bool _isAlpha(String ch) =>
      (ch.codeUnitAt(0) >= 'a'.codeUnitAt(0) &&
          ch.codeUnitAt(0) <= 'z'.codeUnitAt(0)) ||
      (ch.codeUnitAt(0) >= 'A'.codeUnitAt(0) &&
          ch.codeUnitAt(0) <= 'Z'.codeUnitAt(0));

  bool _isDigit(String ch) =>
      ch.codeUnitAt(0) >= '0'.codeUnitAt(0) &&
      ch.codeUnitAt(0) <= '9'.codeUnitAt(0);
}

class Parser {
  final List<Token> tokens;
  int current = 0;

  Parser(this.tokens);

  Token get currentToken => tokens[current];

  void eat(TokenType type) {
    if (currentToken.type == type) {
      current++;
    } else {
      throw FormatException(
          'Expected token type $type but found ${currentToken.type} with value "${currentToken.value}"');
    }
  }

  // Grammar:
  // expression = term (( '*' | '/' ) term)*
  // term = factor ( '^' exponent )?
  // factor = unit | '(' expression ')'
  // exponent = number

  Dimension parseExpression() {
    Dimension result = parseTerm();

    while (currentToken.type == TokenType.multiply ||
        currentToken.type == TokenType.divide) {
      Token operator = currentToken;
      if (operator.type == TokenType.multiply) {
        eat(TokenType.multiply);
        Dimension nextTerm = parseTerm();
        result = result * nextTerm;
      } else if (operator.type == TokenType.divide) {
        eat(TokenType.divide);
        Dimension nextTerm = parseTerm();
        result = result / nextTerm;
      }
    }

    return result;
  }

  Dimension parseTerm() {
    Dimension factor = parseFactor();

    if (currentToken.type == TokenType.exponent) {
      eat(TokenType.exponent); //the ^ sign
      String exponentStr = currentToken.value;
      eat(TokenType.exponent); //the actual value
      double exponent = double.parse(exponentStr);
      factor = factor.pow(exponent);
    }

    return factor;
  }

  Dimension parseFactor() {
    if (currentToken.type == TokenType.unit) {
      String unitName = currentToken.value;
      eat(TokenType.unit);
      Unit? unit = baseUnits[unitName];
      if (unit == null) {
        throw FormatException('Unknown unit "$unitName"');
      }
      return unit.dimension;
    } else if (currentToken.type == TokenType.lParen) {
      eat(TokenType.lParen);
      Dimension expr = parseExpression();
      if (currentToken.type != TokenType.rParen) {
        throw FormatException('Expected ")" but found "${currentToken.value}"');
      }
      eat(TokenType.rParen);
      return expr;
    } else {
      throw FormatException(
          'Unexpected token "${currentToken.value}" of type ${currentToken.type}');
    }
  }
}

class UnitParser {
  final Map<String, Unit> units;

  UnitParser(this.units);

  /// Parses a unit string and returns the corresponding Dimension.
  /// Supports parentheses and exponents (including negative and decimal).
  /// Example: "(kg*m)/s^2" -> Dimension(mass:1, length:1, time:-2)
  Dimension? parse(String unitStr) {
    if (unitStr.isEmpty) return null;

    Lexer lexer = Lexer(unitStr);
    List<Token> tokens;
    try {
      tokens = lexer.tokenize();
    } catch (e) {
      if (kDebugMode) {
        print('Tokenization error: $e');
      }
      return null;
    }

    Parser parser = Parser(tokens);
    try {
      Dimension dimension = parser.parseExpression();
      if (parser.currentToken.type != TokenType.eof) {
        throw FormatException(
            'Unexpected token "${parser.currentToken.value}" at the end of expression.');
      }
      return dimension;
    } catch (e) {
      if (kDebugMode) {
        print('Parsing error: $e');
      }
      return null;
    }
  }
}
