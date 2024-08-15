import 'package:beacon/core/resources/data_state.dart';
import 'package:beacon/domain/entities/group/group_entity.dart';
import 'package:beacon/domain/entities/user/user_entity.dart';
import 'package:beacon/domain/usecase/group_usecase.dart';
import 'package:beacon/presentation/home/home_cubit/home_cubit.dart';
import 'package:beacon/presentation/group/cubit/members_cubit/members_state.dart';
import 'package:beacon/locator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MembersCubit extends Cubit<MembersState> {
  final GroupUseCase _groupUseCase;

  MembersCubit._internal(this._groupUseCase) : super(InitialMemberState());

  static MembersCubit? _instance;

  factory MembersCubit(GroupUseCase _groupUseCase) {
    return _instance ?? MembersCubit._internal(_groupUseCase);
  }

  String? _groupId;
  List<UserEntity> _members = [];

  init(GroupEntity group) {
    _groupId = group.id!;
    _members.add(group.leader!);
    group.members!.forEach((member) {
      _members.add(member!);
    });
  }

  clear() {
    _groupId = null;
    _members.clear();
  }

  loadMembers() {
    emit(LoadedMemberState(members: _members));
  }

  void removeMember(String memberId) async {
    emit(LoadingMemberState());
    final dataState = await _groupUseCase.removeMember(_groupId!, memberId);

    if (dataState is DataSuccess) {
      locator<HomeCubit>().removeMember(_groupId!, dataState.data!);
      var updatedList = List<UserEntity>.from(_members)
        ..removeWhere((member) => member.id == memberId);
      _members = updatedList;

      emit(LoadedMemberState(
          members: updatedList,
          message:
              '${dataState.data!.name} is no longer the member of group!'));
    } else {
      emit(LoadedMemberState(members: _members, message: dataState.error));
    }
  }

  void addMember(UserEntity member) {
    _members.add(member);

    emit(LoadedMemberState(
        members: List<UserEntity>.from(_members),
        message: '${member.name} joined the group!'));
  }
}
