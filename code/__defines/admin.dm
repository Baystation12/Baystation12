// A set of constants used to determine which type of mute an admin wishes to apply.
#define MUTE_IC        FLAG(0)
#define MUTE_OOC       FLAG(1)
#define MUTE_PRAY      FLAG(2)
#define MUTE_ADMINHELP FLAG(3)
#define MUTE_DEADCHAT  FLAG(4)
#define MUTE_AOOC      FLAG(5)
#define MUTE_ALL       (~EMPTY_BITFIELD)

// Some constants for DB_Ban
#define BANTYPE_PERMA       1
#define BANTYPE_TEMP        2
#define BANTYPE_JOB_PERMA   3
#define BANTYPE_JOB_TEMP    4
#define BANTYPE_ANY_FULLBAN 5 // Used to locate stuff to unban.

#define ROUNDSTART_LOGOUT_REPORT_TIME 6000 // Amount of time (in deciseconds) after the rounds starts, that the player disconnect report is issued.

// Admin permissions.
#define R_BUILDMODE      FLAG(0)
#define R_ADMIN          FLAG(1)
#define R_BAN            FLAG(2)
#define R_FUN            FLAG(3)
#define R_SERVER         FLAG(4)
#define R_DEBUG          FLAG(5)
#define R_POSSESS        FLAG(6)
#define R_PERMISSIONS    FLAG(7)
#define R_STEALTH        FLAG(8)
#define R_REJUVINATE     FLAG(9)
#define R_VAREDIT        FLAG(10)
#define R_SOUNDS         FLAG(11)
#define R_SPAWN          FLAG(12)
#define R_MOD            FLAG(13)
#define R_HOST           FLAG(14)
#define R_XENO	         0x4000
#define R_INVESTIGATE    (R_ADMIN | R_MOD)
#define R_MAXPERMISSION  R_HOST

#define ADDANTAG_PLAYER    FLAG(0)  // Any player may call the add antagonist vote.
#define ADDANTAG_ADMIN     FLAG(1)  // Any player with admin privilegies may call the add antagonist vote.
#define ADDANTAG_AUTO      FLAG(2)  // The add antagonist vote is available as an alternative for transfer vote.

#define TICKET_CLOSED 0   // Ticket has been resolved or declined
#define TICKET_OPEN     1 // Ticket has been created, but not responded to
#define TICKET_ASSIGNED 2 // An admin has assigned themself to the ticket and will respond

#define LAST_CKEY(M) (M.ckey || M.last_ckey)
#define LAST_KEY(M)  (M.key || M.last_ckey)
