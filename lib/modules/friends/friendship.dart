import 'package:sochat_client/modules/users/user.dart';

class Friendship {
  User user;
  User friend;
  FriendshipStatus status;

  Friendship({required this.user, required this.friend, required this.status});

  void operator []=(String other, Friendship value) {}

  bool isOutgoing(int currentUserId) {
    return status == FriendshipStatus.PENDING &&
        user.id == currentUserId;
  }

  bool isIncoming(int currentUserId) {
    return status == FriendshipStatus.PENDING &&
        friend.id == currentUserId;
  }

  User getOtherUser(int currentUserId) {
    return user.id == currentUserId ? friend : user;
  }

}

enum FriendshipStatus{
  PENDING,
  ACCEPTED,
  BLOCKED,
}