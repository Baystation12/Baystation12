// A set of constants used to determine which type of mute an admin wishes to apply.
// Please read and understand the muting/automuting stuff before changing these. MUTE_IC_AUTO, etc. = (MUTE_IC << 1)
// Therefore there needs to be a gap between the flags for the automute flags.
#define MUTE_IC        0x1
#define MUTE_OOC       0x2
#define MUTE_PRAY      0x4
#define MUTE_ADMINHELP 0x8
#define MUTE_DEADCHAT  0x10
#define MUTE_AOOC      0x20
#define MUTE_ALL       0xFFFF

// Some constants for DB_Ban
#define BANTYPE_PERMA       1
#define BANTYPE_TEMP        2
#define BANTYPE_JOB_PERMA   3
#define BANTYPE_JOB_TEMP    4
#define BANTYPE_ANY_FULLBAN 5 // Used to locate stuff to unban.

#define ROUNDSTART_LOGOUT_REPORT_TIME 6000 // Amount of time (in deciseconds) after the rounds starts, that the player disconnect report is issued.

// Admin permissions.
#define R_BUILDMODE     0x1
#define R_ADMIN         0x2
#define R_BAN           0x4
#define R_FUN           0x8
#define R_SERVER        0x10
#define R_DEBUG         0x20
#define R_POSSESS       0x40
#define R_PERMISSIONS   0x80
#define R_STEALTH       0x100
#define R_REJUVINATE    0x200
#define R_VAREDIT       0x400
#define R_SOUNDS        0x800
#define R_SPAWN         0x1000
#define R_MOD           0x2000
#define R_MENTOR        0x4000
#define R_HOST          0x8000 //higher than this will overflow
#define R_INVESTIGATE   (R_ADMIN|R_MOD)

#define R_MAXPERMISSION 0x8000 // This holds the maximum value for a permission. It is used in iteration, so keep it updated.

#define ADDANTAG_PLAYER 1	// Any player may call the add antagonist vote.
#define ADDANTAG_ADMIN 2	// Any player with admin privilegies may call the add antagonist vote.
#define ADDANTAG_AUTO 4		// The add antagonist vote is available as an alternative for transfer vote.

#define TICKET_CLOSED 0   // Ticket has been resolved or declined
#define TICKET_OPEN     1 // Ticket has been created, but not responded to
#define TICKET_ASSIGNED 2 // An admin has assigned themself to the ticket and will respond