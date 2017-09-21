GLOBAL_DATUM(data_core, /datum/datacore)
// Items that ask to be called every cycle.
GLOBAL_LIST_EMPTY(machines)
GLOBAL_LIST_EMPTY(processing_objects)
GLOBAL_LIST_EMPTY(processing_power_items)
GLOBAL_LIST_EMPTY(active_diseases)
GLOBAL_LIST_EMPTY(med_hud_users)          // List of all entities using a medical HUD.
GLOBAL_LIST_EMPTY(sec_hud_users)          // List of all entities using a security HUD.
GLOBAL_LIST_EMPTY(holowarrant_users)
GLOBAL_LIST_EMPTY(hud_icon_reference)
GLOBAL_LIST_EMPTY(traders)                //List of all nearby traders

GLOBAL_LIST_EMPTY(listening_objects) // List of objects that need to be able to hear, used to avoid recursive searching through contents.
GLOBAL_LIST_EMPTY(powernets)

GLOBAL_LIST_EMPTY(global_mutations) // List of hidden mutation things.

GLOBAL_LIST_EMPTY(reg_dna)

GLOBAL_LIST_EMPTY(global_map)

// Announcer intercom, because too much stuff creates an intercom for one message then hard del()s it. Also headset, for things that should be affected by comms outages.
GLOBAL_DATUM_INIT(global_announcer, /obj/item/device/radio/announcer, new)
GLOBAL_DATUM_INIT(global_headset, /obj/item/device/radio/announcer/subspace, new)

var/host = null //only here until check @ code\modules\ghosttrap\trap.dm:112 is fixed
GLOBAL_DATUM(sun, /datum/sun)
GLOBAL_DATUM_INIT(universe, /datum/universal_state, new)
