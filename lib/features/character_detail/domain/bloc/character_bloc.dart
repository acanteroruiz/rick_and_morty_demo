import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:get/get.dart';
import 'package:rick_and_morty_app/features/character_detail/domain/models/character_detail_viewmodel.dart';
import 'package:rick_and_morty_app/features/character_detail/domain/repositories/character_detail_repository.dart';

part 'character_event.dart';
part 'character_state.dart';

class CharacterBloc extends Bloc<CharacterEvent, CharacterState> {
  final CharacterDetailRepository _characterRepository;

  CharacterBloc({characterRepository})
      : _characterRepository =
            characterRepository ?? Get.find<CharacterDetailRepository>(),
        super(CharacterInitial()) {
    on<CharacterEvent>(
      (event, emit) async {
        if (event is CharacterFetch) {
          return _fetchToState(event, emit);
        }
      },
      //transformer: restartable(),
    );
  }

  Future<void> _fetchToState(CharacterFetch event, Emitter emit) async {
    emit(CharacterLoading());
    try {
      final CharacterDetailViewModel _response =
          await _characterRepository.fetchCharacterDetail(event.id);
      emit(CharacterLoaded(characterDetail: _response));
    } catch (e) {
      emit(CharacterError(message: e.toString()));
    }
  }
}
