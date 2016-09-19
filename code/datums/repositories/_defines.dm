#define mobclient2unique(mob, client) "[client ? client.ckey : (mob ? mob.ckey : "")][ascii2text(7)][mob ? (mob.real_name ? mob.real_name : mob.name) : ""][ascii2text(7)][any2ref(mob)]"
