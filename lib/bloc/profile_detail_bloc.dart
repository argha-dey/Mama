
import 'package:rxdart/rxdart.dart';
import '../model/group_model.dart';
import '../model/profile_detail_model.dart';
import '../repository/repository.dart';

class ProfileDetailBloc {
  final _getProfileDetail = PublishSubject<ProfileDetailsModel>();
  final _repository = Repository();
  Stream<ProfileDetailsModel> get getProfileDetailStream => _getProfileDetail.stream;

  Future profileDetailblocSink() async {
    final ProfileDetailsModel model = await _repository.onProfileDetailApi();
    _getProfileDetail.sink.add(model);
  }

  void dispose() {
    _getProfileDetail.close();
  }
}

final getProfileDetailBloc = ProfileDetailBloc();
