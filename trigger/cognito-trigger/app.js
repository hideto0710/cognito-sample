exports.handler = async (event, context) => {
    console.log(event);
    // event.userName
    // event.request.password
    const user = {
        emailAddress: 'h.inamura0710@gmail.com',
    }
    event.response.userAttributes = {
        "email": user.emailAddress,
        "email_verified": "true"
    };
    event.response.finalUserStatus = "CONFIRMED";
    event.response.messageAction = "SUPPRESS";
    context.succeed(event);
    return;
};
