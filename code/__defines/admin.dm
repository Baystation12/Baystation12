// A set of constants used to determine which type of mute an admin wishes to apply.
// Please read and understand the muting/automuting stuff before changing these. MUTE_IC_AUTO, etc. = (MUTE_IC << 1)
// Therefore there needs to be a gap between the flags for the automute flags.
#define MUTE_IC        1
#define MUTE_OOC       2
#define MUTE_PRAY      4
#define MUTE_ADMINHELP 8
#define MUTE_DEADCHAT  16
#define MUTE_ALL       31

// Number of identical messages required to get the spam-prevention auto-mute thing to trigger warnings and automutes.
#define SPAM_TRIGGER_WARNING  5
#define SPAM_TRIGGER_AUTOMUTE 10

// Some constants for DB_Ban
#define BANTYPE_PERMA       1
#define BANTYPE_TEMP        2
#define BANTYPE_JOB_PERMA   3
#define BANTYPE_JOB_TEMP    4
#define BANTYPE_ANY_FULLBAN 5 // Used to locate stuff to unban.

#define ROUNDSTART_LOGOUT_REPORT_TIME 6000 // Amount of time (in deciseconds) after the rounds starts, that the player disconnect report is issued.

// Admin permissions. Please don't edit these values without speaking to Errorage first. ~Carn
#define R_BUILDMODE     1
#define R_ADMIN         2
#define R_BAN           4
#define R_FUN           8
#define R_SERVER        16
#define R_DEBUG         32
#define R_POSSESS       64
#define R_PERMISSIONS   128
#define R_STEALTH       256
#define R_REJUVINATE    512
#define R_VAREDIT       1024
#define R_SOUNDS        2048
#define R_SPAWN         4096
#define R_MOD           8192
#define R_MENTOR        16384
#define R_HOST          32768

#define R_MAXPERMISSION 32768 // This holds the maximum value for a permission. It is used in iteration, so keep it updated.