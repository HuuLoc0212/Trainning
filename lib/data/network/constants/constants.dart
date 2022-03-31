class GraphQLConstants {
  GraphQLConstants._();

  ///---------------------------------------------------------------------------
  // VARIABLES
  //{
  //   "input": {
  //     "vfaEmail": "huuloc@123",
  //     "password": "123456789"
  //   }
  // }
  static String signIn = """
    mutation login(\$input:LoginCondition!) {
      login(condition: \$input) {
        token
        token_type
        expires_in
        user {
          userId
          vfaEmail
          vfaAvatar
        }
      }
    }""";

  ///---------------------------------------------------------------------------
  // HEADER
  //{
  //   "authorization": "bearer token????"
  // }
  static String userInformation = """
      query userInformation {
        userInformation{
          response {
            userId
            vfaEmail
  		      vfaAvatar
            vfaPhoneWork
            userFullName
            userBirthday
          }
          error {
            requestResolved
            message
            errorCode
          }
        }
      }""";

  ///---------------------------------------------------------------------------
  //variables:
  // {
  //   "input": {
  //     "activityTypes": "CHECK_IN"
  //   }
  // }
  //
  //// HEADER
  //   //{
  //   //   "authorization": "bearer token????"
  //   // }
  static String checkIn = 'CHECK_IN';
  static String checkOut ='CHECK_OUT';
  static String goOut ='GO_OUT';
  static String comeBack ='COME_BACK';

  static String createActivity = """ 
  mutation createActivity(\$input: CreateActivityCondition!) {
    createActivity(condition: \$input) {
      requestResolved
      message
      errorCode
      createdAt
    }
  }""";

  ///---------------------------------------------------------------------------
  //{
  //   "input": {
  //     "startDate":"2019-10-20",
  //     "endDate":"2019-11-19"
  //   }
  // }
  static String myTimeLine = """
  query myTimeLine(\$input: MyTimeLineCondition) {
    myTimeLine(condition: \$input) {
      response {
        groupDate
        collections {
          activityTypes
          activityDescription
        }
      }
      error {
        requestResolved
        message
        errorCode
      }
    }
  }
  """;
}
