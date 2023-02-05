import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:get/get.dart';
import 'package:rick_and_morty_app/features/characters/domain/models/character.dart';
import 'package:rick_and_morty_app/features/characters/domain/repositories/characters_repository.dart';
import 'package:rick_and_morty_app/features/characters/infraestructure/dto/data.dart';

part 'characters_event.dart';
part 'characters_state.dart';

class CharactersBloc extends Bloc<CharactersEvent, CharactersState> {
  final CharactersRepository _charactersRepository;

  CharactersBloc({charactersRepository})
      : _charactersRepository =
            charactersRepository ?? Get.find<CharactersRepository>(),
        super(CharactersInitial()) {
    on<CharactersEvent>(
      (event, emit) async {
        if (event is CharactersFetch) {
          return _fetchToState(event, emit);
        }
      },
      //transformer: restartable(),
    );
  }

  Future<void> _fetchToState(CharactersFetch event, Emitter emit) async {
    emit(CharactersLoading());
    try {
      final Data _response = await _charactersRepository.fetchCharacters();
      final List<Character> _characters = _response.results;
      emit(CharactersLoaded(characters: _characters));
    } catch (e) {
      emit(CharactersError());
    }
  }
}
