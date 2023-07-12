import '../provider/accept_decline_provider.dart';
import '../provider/admin_rating_review_provider.dart';
import '../provider/edit_profile_provider.dart';
import '../provider/group_provider.dart';
import '../provider/joining_request_provider.dart';
import '../provider/polling_ans_submit_provider.dart';
import '../provider/polling_create_provider.dart';
import '../provider/profile_detail_provider.dart';
import '../provider/register_(prf_fillup)_provider.dart';
import '../provider/login_provider.dart';
import '../screens/dashboard/polling_question_screen.dart';
import '../screens/polling/polling_create_screen.dart';

class Repository {
  //=================== forgot password ===================//
  final RegisterPrfFillupApi register = RegisterPrfFillupApi();
  final LoginApi login = LoginApi();
  final GroupApi group = GroupApi();
  final ProfileDetailApi profileDetail = ProfileDetailApi();
  final EditProfileApi editProfile = EditProfileApi();
  final JoiningReqApi joinreq = JoiningReqApi();
  final PollingCreateApi pollingCreate = PollingCreateApi();
  final AcceptDeclineApi acceptdecline = AcceptDeclineApi();
  final PollingAnsSubmitApi pollingAnsSubmit = PollingAnsSubmitApi();
  final AdminRatingApi rateAdmin = AdminRatingApi();



  Future<dynamic> onRegisterPrfFillupApi(String name, String mobile,String mobile_code,String email,String address,String birth,int group_type,int rol,String img) => register.onRegisterPrfFillupApi(name, mobile,mobile_code, email, address, birth, group_type, rol,img
  );

  Future<dynamic> onLoginApi(String mobile_code, String mobile) => login.onLoginAPI(mobile_code, mobile);
  Future<dynamic> onGroupApi(String searchText) => group.onGroupApi(searchText);
  Future<dynamic> onProfileDetailApi() => profileDetail.onProfileDetailApi();
  Future<dynamic> onEditProfileApiApi(String userid,String name,String email,String address,String birth,int group_type,int rol,String img) => editProfile.onEditProfileApiApi(userid,name, email,address, birth, group_type, rol,img
  );
  Future<dynamic> onJoiningReqApi(String? userid, String? groupid) => joinreq.onJoiningReqApi(userid!,groupid!);
  Future<dynamic> onAcceptDeclineApi(String approveStatus,String memberId,String groupId) => acceptdecline.onAcceptDeclineApi(approveStatus,memberId,groupId);

  Future<dynamic> onPollingCreateApi( String pollingName, String startDateTime,String endDateTime,String pollingQuestion,List<PollingQstnModel> pollQstnList,String groupId) => pollingCreate.onPollingCreateApi(pollingName, startDateTime, endDateTime, pollingQuestion,pollQstnList,groupId);
  Future<dynamic> onPollingAnsSubmitApi( List<PollingAnsDetails> pollAnsList) => pollingAnsSubmit.onPollingAnsSubmitApi(pollAnsList);

  Future<dynamic> onAdminRatingApi(double point, String reviewable_id,String targetable_id, String description) => rateAdmin.onAdminRatingApi(point,reviewable_id,targetable_id,description);

}