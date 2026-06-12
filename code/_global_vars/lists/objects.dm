GLOBAL_LIST_EMPTY(med_hud_users)          // List of all entities using a medical HUD.
GLOBAL_LIST_EMPTY(sec_hud_users)          // List of all entities using a security HUD.
GLOBAL_LIST_EMPTY(jani_hud_users)
GLOBAL_LIST_EMPTY(hud_icon_reference)

GLOBAL_LIST_EMPTY(listening_objects) // List of objects that need to be able to hear, used to avoid recursive searching through contents.

GLOBAL_LIST_EMPTY(global_mutations) // List of hidden mutation things.

GLOBAL_LIST_EMPTY(reg_dna)

GLOBAL_LIST_EMPTY(global_map)

// Announcer intercom, because too much stuff creates an intercom for one message then hard del()s it. Also headset, for things that should be affected by comms outages.
GLOBAL_TYPED_NEW(global_announcer, /obj/item/device/radio/announcer)
GLOBAL_TYPED_NEW(global_headset, /obj/item/device/radio/announcer/subspace)
GLOBAL_TYPED_NEW(ert_announcer, /obj/item/device/radio/announcer/subspace/ert)

GLOBAL_TYPED_NEW(universe, /datum/universal_state)

GLOBAL_LIST_AS(full_alphabet, list("a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z"))

GLOBAL_LIST_EMPTY(meteor_list)

GLOBAL_LIST_AS(wall_blend_objects, list(
	/obj/machinery/door,
	/obj/structure/wall_frame,
	/obj/structure/grille,
	/obj/structure/window/reinforced/full,
	/obj/structure/window/reinforced/polarized/full,
	/obj/structure/window/shuttle,
	/obj/structure/window/boron_basic/full,
	/obj/structure/window/boron_reinforced/full
))

GLOBAL_LIST_AS(wall_noblend_objects, list(
	/obj/machinery/door/window
))

GLOBAL_LIST_AS(wall_fullblend_objects, list(
	/obj/structure/wall_frame
))
