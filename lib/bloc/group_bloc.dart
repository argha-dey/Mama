/*
import 'package:rxdart/rxdart.dart';
import '../model/group_model.dart';
import '../repository/repository.dart';

class GroupBloc {
  final _getGroup = PublishSubject<GroupModel>();
  final _repository = Repository();
  Stream<GroupModel> get getGroupStream => _getGroup.stream;

  Future groupblocSink() async {
    final GroupModel model = await _repository.onGroupApi();
    _getGroup.sink.add(model);
  }

  void dispose() {
    _getGroup.close();
  }
}

final getgroupBloc = GroupBloc();*/
