/* COMMAND AREAS
 * =============
 */

	//first deck
/area/crew_quarters/heads/captain/secret_room/level_two
	name = "First Deck - Captain's bathroom"
	area_flags = AREA_FLAG_RAD_SHIELDED
	//second deck
/area/crew_quarters/heads/captain/secret_room/level_one
	name = "Second Deck - Captain's restroom"
	area_flags = AREA_FLAG_RAD_SHIELDED

	//first deck
/area/bridge/hall/level_two
	name = "Bridge - Hall - Upper"
	req_access = list(access_sec_doors)
	//second deck
/area/bridge/hall/level_one
	name = "Bridge - Hall - Lower"


/* RND AREAS
 * =========
 */

	//third deck
/area/rnd/xenobiology/entry
	name = "Xenobiology Access"
	icon_state = "xeno_lab"

/area/rnd/xenobiology/storage2
	name = "Xenobiology Access"
	icon_state = "xeno_lab"

/area/rnd/xenobiology/level1
	name = "Xenobiology Level One"
	icon_state = "xeno_lab"

/area/rnd/canister
	name = "Third Deck - Hangar - Canister Storage"
	icon_state = "toxstorage"
	sound_env = SMALL_ENCLOSED
	req_access = list(access_tox_storage)

/area/rnd/xenobiology/atmos
	name = "Xenobiology - Atmos Hub"
	icon_state = "xeno_lab"

/area/rnd/xenobiology/water_cell
	name = "Xenobiology - Water Cell"
	icon_state = "xeno_lab"

	//second deck
/area/rnd/xenobiology/entry2
	name = "Xenobiology Access"
	icon_state = "xeno_lab"

/area/rnd/xenobiology/level2
	name = "Xenobiology Level Two"
	icon_state = "xeno_lab"

/area/rnd/xenobiology/storage
	name = "Xenobiology - Storage"
	icon_state = "xeno_lab"
