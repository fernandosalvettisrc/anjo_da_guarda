import 'dart:async';
import 'package:anjo_guarda/model/responsavel_model.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import 'package:anjo_guarda/repositories/user_repository.dart';
import 'package:anjo_guarda/bloc/register/bloc.dart';
import 'package:anjo_guarda/utilities/utilities.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final UserRepository _userRepository;

  RegisterBloc({@required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository;

  @override
  RegisterState get initialState => RegisterState.empty();

  @override
  Stream<RegisterState> transform(
    Stream<RegisterEvent> events,
    Stream<RegisterState> Function(RegisterEvent event) next,
  ) {
    final observableStream = events as Observable<RegisterEvent>;
    final nonDebounceStream = observableStream.where((event) {
      return (event is! EmailChanged && event is! PasswordChanged);
    });
    final debounceStream = observableStream.where((event) {
      return (event is EmailChanged || event is PasswordChanged);
    }).debounce(Duration(milliseconds: 300));
    return super.transform(nonDebounceStream.mergeWith([debounceStream]), next);
  }

  @override
  Stream<RegisterState> mapEventToState(
    RegisterEvent event,
  ) async* {
    if (event is EmailChanged) {
      yield* _mapEmailChangedToState(event.email);
    } else if (event is PasswordChanged) {
      yield* _mapPasswordChangedToState(event.password);
    } else if (event is PasswordVerifyChanged) {
      yield* _mapPasswordVerifyChangedToState(event.password, event.passwordVerify); 
    }else if (event is CPFChanged) {
      yield* _mapCPFChangedToState (event.cpf);
    }else if (event is DataChanged) {
      yield* _mapDataChangedToState (event.data);
    }else if (event is UFChanged) {
      yield* _mapUFChangedToState(event.uf);
    }else if (event is Submitted) {
      yield* _mapFormSubmittedToState(event.email, event.password, event.novoUsuario);
    }
  }

  Stream<RegisterState> _mapEmailChangedToState(String email) async* {
    yield currentState.update(
      isEmailValid: Validators.isValidEmail(email),
    );
  }

  Stream<RegisterState> _mapPasswordChangedToState(String password) async* {
    yield currentState.update(
      isPasswordValid: Validators.isValidPassword(password),
    );
  }
 Stream<RegisterState> _mapCPFChangedToState(String cpf) async* {
    yield currentState.update(
      isCPFValid: Validators.isValidCPF(cpf),
    );
  }

  Stream<RegisterState> _mapDataChangedToState(String data) async* {
    yield currentState.update(
      isDataValid: Validators.isValidData(data),
    );
  }

  Stream<RegisterState> _mapUFChangedToState(String uf) async* {
    yield currentState.update(
      isUFValid: Validators.isValidUF(uf),
    );
  }

  Stream<RegisterState> _mapPasswordVerifyChangedToState(String password,
                                String passwordVerify) async* {
    yield currentState.update(
      isPasswordVerifyValid: Validators.isValidPasswordVerify(password, passwordVerify),
    );
  }

  Stream<RegisterState> _mapFormSubmittedToState(
    String email,
    String password,
    UsuarioModel responsavelModel
  ) async* {
    yield RegisterState.loading();
    try {
      await _userRepository.signUp(
        email: email,
        password: password,
        userModel: responsavelModel,
      );
      yield RegisterState.success();
    } catch (_) {
      yield RegisterState.failure();
    }
  }
}