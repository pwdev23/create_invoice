int extractNumbers(String input) {
  String numbers = input.replaceAll(RegExp(r'\D'), '');
  return numbers.isNotEmpty ? int.parse(numbers) : 0;
}
