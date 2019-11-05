
class Validators {
  static final RegExp _emailRegExp = RegExp(
    r'^[a-zA-Z0-9.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$',
  );
  static final RegExp _passwordRegExp = RegExp(
    r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{6,}$',
  );

  static const STRIP_REGEX = r'[^\d]'; 
  static const List<String> BLACKLIST = [
    "00000000000",
    "11111111111",
    "22222222222",
    "33333333333",
    "44444444444",
    "55555555555",
    "66666666666",
    "77777777777",
    "88888888888",
    "99999999999",
    "12345678909"];

  static isValidEmail(String email) {
    return _emailRegExp.hasMatch(email);
  }

static String strip(String cpf) {
    RegExp regExp = RegExp(STRIP_REGEX);
    cpf = cpf == null ? "" : cpf;

    return cpf.replaceAll(regExp, "");
  }


  static isValidCPF(String cpf) {

    cpf = strip(cpf);

    // CPF must be defined
    if (cpf == null || cpf.isEmpty) {
      return false;
    }

    // CPF must have 11 chars
    if (cpf.length != 11) {
      return false;
    }

    // CPF can't be blacklisted
    if (BLACKLIST.indexOf(cpf) != -1) {
      return false;
    }

    String numbers = cpf.substring(0, 9);
    numbers += _verifierDigit(numbers).toString();
    numbers += _verifierDigit(numbers).toString();

    if (numbers.substring(numbers.length - 2) != cpf.substring(cpf.length - 2))
    {
      return false;
    }
    return true;
  }

  static isValidPassword(String password) {
    return _passwordRegExp.hasMatch(password);
  }
   static int _verifierDigit(String cpf) {
    List<int> numbers =
    cpf.split("").map((number) => int.parse(number, radix: 10)).toList();

    int modulus = numbers.length + 1;

    List<int> multiplied = [];

    for (var i = 0; i < numbers.length; i++) {
      multiplied.add(numbers[i] * (modulus - i));
    }

    int mod = multiplied.reduce((buffer, number) => buffer + number) % 11;

    return (mod < 2 ? 0 : 11 - mod);
  }
   static List<String> ufList = ['AC',
                         'AL',
                         'AM',
                         'AP',
                         'BA',
                         'CE',
                         'DF',
                         'ES',
                         'GO',
                         'MA',
                         'MG',
                         'MS',
                         'MT',
                         'PA',
                         'PB',
                         'PE',
                         'PI',
                         'PR',
                         'RJ',
                         'RN',
                         'RO',
                         'RR',
                         'RS',
                         'SC',
                         'SE',
                         'SP',
                         'TO']; 
  static isValidPasswordVerify(String password, String passwordVerify) {
    return (password == passwordVerify);
  }
   static isValidUF(String uf) {
    return ufList.contains(uf.toUpperCase());
  }

  static isValidData(String data) {
    
    return data.length == 8;
  }
}