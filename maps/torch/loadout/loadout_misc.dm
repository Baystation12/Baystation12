/datum/gear/trinket/photograph
	display_name = "photo"
	description = "A definable photograph. The only limit is your imagination."
	path = /obj/item/phototrinket

/datum/gear/trinket/scg_challenge_coin
	display_name = "sol challenge coin selection"
	description = "A selection of challenge coins for identification, collection or simply bragging rights."
	path = /obj/item/material/coin/challenge
	cost = 1


/datum/gear/trinket/scg_challenge_coin/New()
	..()
	var/list/options = list()
	options["fleet"] = /obj/item/material/coin/challenge/sol/fleet
	options["army"] = /obj/item/material/coin/challenge/scga/army
	options["armsmen"] = /obj/item/material/coin/challenge/sol/armsmen
	options["gaia conflict"] = /obj/item/material/coin/challenge/sol/gaia
	options["observatory"] = /obj/item/material/coin/challenge/sol/observatory
	options["field operations"] = /obj/item/material/coin/challenge/sol/field_ops
	options["torch"] = /obj/item/material/coin/challenge/sol/torch
	gear_tweaks += new /datum/gear_tweak/path (options)


/datum/gear/trinket/misc_challenge_coin
	display_name = "misc challenge coin selection"
	description = "A selection of challenge coins for identification, collection or simply bragging rights."
	path = /obj/item/material/coin/challenge/misc
	cost = 1


/datum/gear/trinket/misc_challenge_coin/New()
	..()
	var/list/options = list()
	options["PCRC"] = /obj/item/material/coin/challenge/misc/pcrc
	options["SAARE"] = /obj/item/material/coin/challenge/misc/saare
	gear_tweaks += new /datum/gear_tweak/path (options)


/datum/gear/trinket/gcc_challenge_coin/allowed_branches = list(
	/datum/mil_branch/civilian,
	/datum/mil_branch/iccgn
)

/datum/gear/union_card/allowed_branches = list(
	/datum/mil_branch/civilian
)
