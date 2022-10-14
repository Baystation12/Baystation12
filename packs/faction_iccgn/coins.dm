/obj/item/material/coin/challenge/gcc
	abstract_type = /obj/item/material/coin/challenge/gcc
	icon = 'packs/faction_iccgn/coins.dmi'
	icon_state = "error"


/obj/item/material/coin/challenge/gcc/navy
	default_material = MATERIAL_IRON
	name = "confederation navy challenge coin"
	icon_state = "navy"
	desc = {"\
		A challenge coin issued by the Confederation Navy. \
		On the front is the insignia of the Navy, and on the back \
		is a rendering of the late Admiral Yevgeny Novikov.\
	"}


/obj/item/material/coin/challenge/gcc/navy_old
	default_material = MATERIAL_IRON
	name = "old confederation navy challenge coin"
	icon_state = "navy-old"
	desc = {"\
		A tarnished challenge coin once issued by the \
		Confederation Navy. On the front is the insignia of the \
		Navy, and on the back is an older model of cruiser with \
		Pan-Slavic text written around it.\
	"}


/obj/item/material/coin/challenge/gcc/guard
	default_material = MATERIAL_IRON
	name = "colonial guard challenge coin"
	icon_state = "guard"
	desc = {"\
		A challenge coin issued by the Confederation Navy. \
		On the front is the insignia of the Colonial Guard, and on \
		the back is a smiling crewman in dress uniform holding an \
		ancient ceremonial rifle.\
	"}


/obj/item/material/coin/challenge/gcc/surface
	default_material = MATERIAL_IRON
	name = "surface warfare challenge coin"
	icon_state = "surface"
	desc = {"\
		A challenge coin issued by the Confederation Surface \
		Warfare Corps. On the front is a mace against the Corps's \
		parade colors, and on the back is an emboss of a bearded \
		soldier giving a thumbs-up.\
	"}


/datum/gear/trinket/gcc_challenge_coin
	display_name = "confederation challenge coin selection"
	description = {"\
		A selection of challenge coins used by confederation military \
		forces for identification, collection, or bragging rights.\
	"}
	path = /obj/item/material/coin/challenge/gcc
	cost = 1


/datum/gear/trinket/gcc_challenge_coin/New()
	..()
	var/list/options = list()
	options["confederation navy"] = /obj/item/material/coin/challenge/gcc/navy
	options["colonial guard"] = /obj/item/material/coin/challenge/gcc/guard
	options["surface warfare"] = /obj/item/material/coin/challenge/gcc/surface
	gear_tweaks += new /datum/gear_tweak/path (options)
