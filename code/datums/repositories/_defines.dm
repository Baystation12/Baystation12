#define mob2unique(mob) "[mob ? mob.ckey : NO_CLIENT_CKEY][ascii2text(7)][mob ? (mob.real_name ? mob.real_name : mob.name) : ""][ascii2text(7)][any2ref(mob)]"

#define CLIENT_EYE_REMOVE     0
#define CLIENT_EYE_SKIP       1
#define CLIENT_EYE_APPLICABLE 2
