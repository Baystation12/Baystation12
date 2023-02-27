#define FEEDBACK_YOU_LACK_DEXTERITY SPAN_WARNING("You don't have the dexterity to do this!")
#define FEEDBACK_ACCESS_DENIED SPAN_WARNING("Access Denied!")

/// Generic feedback failure message handler.
#define FEEDBACK_FAILURE(USER, MSG) to_chat(USER, SPAN_WARNING(MSG))

/// Feedback messages intended for use in `use_*` overrides. These assume the presence of the `user` variable.
#define USE_FEEDBACK_FAILURE(MSG) FEEDBACK_FAILURE(user, MSG)

/// Feedback messages intended for use in `use_grab()` overrides. These assume the presence of the `grab` variable.
#define USE_FEEDBACK_GRAB_FAILURE(MSG) FEEDBACK_FAILURE(grab.assailant, MSG)
