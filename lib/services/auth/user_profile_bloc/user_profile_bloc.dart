// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:todos_bloc_app/services/auth/user_profile_bloc/user.dart';

// import 'package:flutter/foundation.dart' show immutable;
// import 'package:todos_bloc_app/services/auth/user_profile_bloc/user_provider.dart';

// part 'user_profile_event.dart';
// part 'user_profile_state.dart';

// class UserBloc extends Bloc<UserEvent, UserState> {
//   final UserRepository _userRepository;

//   UserBloc(this._userRepository) : super(UserInitial()) {
//     on<FetchUser>((event, emit) async {
//       emit(UserLoading());
//       try {
//         final user = await _userRepository
//             .fetchUser(); // Implement fetching user data from Firestore
//         emit(UserLoaded(user));
//       } catch (e) {
//         emit(UserError('Failed to load user data'));
//       }
//     });
//     on<UpdateUser>((event, emit) async {
//       emit(UserLoading());
//       try {
//         await _userRepository.updateUser(
//             event.updatedUser); // Implement updating user data in Firestore
//         emit(UserLoaded(event.updatedUser));
//       } catch (e) {
//         emit(UserError('Failed to update user data'));
//       }
//     });
//     on<ProfileEditEvent>(
//       (event, emit) {
//         emit(UserProfileUpdating());
//       },
//     );
//   }
// }
