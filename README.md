
## Description

Chat application developed in Swift 3. Used Firebase as backend.

## Screenshots

<img src="/Screenshots/SignInPage.jpg" width="350">

<img src="/Screenshots/FriendList.jpg" width="350">

<img src="/Screenshots/ChatRoom.jpg" width="350">

## Requirements

[Xcode 8 beta 1](https://developer.apple.com/go/?id=xcode-8-beta)

The application will not compile in other beta versions.

## Dependencies

- [Firebase](https://firebase.google.com/)
- [JSQMessagesViewController](https://github.com/jessesquires/JSQMessagesViewController)

## Sample Database Structure

```json
{
  "chatRoom_Messages" : {
    "-KO36-HhQ6uEFztAIaRf" : {
      "-KO364K2h6KO6jGgcy1v" : {
        "senderDisplayName" : "",
        "senderId" : "qVAf9n02n1axswu55UHw76VdRsu1",
        "text" : "Test message 1"
      },
      "-KO364axyvsNtpbrM1IQ" : {
        "senderDisplayName" : "Test User",
        "senderId" : "kBuf3SodAwZYyLkOl9tiTJIJkLo2",
        "text" : "How are you doing?"
      },
      "-KO365YU88tv9YcXtPuP" : {
        "senderDisplayName" : "",
        "senderId" : "qVAf9n02n1axswu55UHw76VdRsu1",
        "text" : "Test message 2"
      },
      "-KO365jtM1f5U2s8RjnA" : {
        "senderDisplayName" : "Test User",
        "senderId" : "kBuf3SodAwZYyLkOl9tiTJIJkLo2",
        "text" : "Goodbye"
      },
      "-KO3677u12FZeG_6IqOq" : {
        "senderDisplayName" : "",
        "senderId" : "qVAf9n02n1axswu55UHw76VdRsu1",
        "text" : "Test message 3"
      }
    }
  },
  "chatRooms" : {
    "-KO36-HhQ6uEFztAIaRf" : true
  },
  "user_ChatRooms" : {
    "kBuf3SodAwZYyLkOl9tiTJIJkLo2" : {
      "-KO36-HhQ6uEFztAIaRf" : "qVAf9n02n1axswu55UHw76VdRsu1"
    },
    "qVAf9n02n1axswu55UHw76VdRsu1" : {
      "-KO36-HhQ6uEFztAIaRf" : "kBuf3SodAwZYyLkOl9tiTJIJkLo2"
    }
  },
  "user_FriendRequests" : {
    "kBuf3SodAwZYyLkOl9tiTJIJkLo2" : {
      "qVAf9n02n1axswu55UHw76VdRsu1" : true
    },
    "qVAf9n02n1axswu55UHw76VdRsu1" : {
      "8vkOpCJFEeOW0uGqvrPARp7jcIM2" : true
    }
  },
  "user_Friends" : {
    "qVAf9n02n1axswu55UHw76VdRsu1" : {
      "kBuf3SodAwZYyLkOl9tiTJIJkLo2" : true
    }
  },
  "users" : {
    "8vkOpCJFEeOW0uGqvrPARp7jcIM2" : {
      "email" : "friendRequestSimulator",
      "name" : "friendRequestSimulator"
    },
    "LtTIcbZqbOS7lOKgJmURXjFUPFr2" : {
      "email" : "justinlee@gmail.com",
      "name" : "Justin Lee"
    },
    "kBuf3SodAwZYyLkOl9tiTJIJkLo2" : {
      "email" : "testuser@gmail.com",
      "name" : "Test User"
    },
    "qVAf9n02n1axswu55UHw76VdRsu1" : {
      "email" : "newuser@gmail.com",
      "name" : "New User"
    }
  }
}
```
