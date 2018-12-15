/datum/map_template/ruin/exoplanet/datacapsule
	name = "ejected data capsule"
	id = "datacapsule"
	description = "A damaged capsule with some strange contents."
	suffixes = list("datacapsule/datacapsule.dmm")
	cost = 1
	template_flags = TEMPLATE_FLAG_CLEAR_CONTENTS | TEMPLATE_FLAG_NO_RUINS



/area/map_template/datacapsule
	name = "\improper Ejected Data Capsule"
	icon_state = "blue"



/obj/effect/landmark/corpse/zombiescience
	name = "Dead Scientist"
	corpse_outfits = list(/decl/hierarchy/outfit/zombie_science)

/decl/hierarchy/outfit/zombie_science
	name = OUTFIT_JOB_NAME("Dead Scientist")
	uniform = /obj/item/clothing/under/rank/scientist
	suit = /obj/item/clothing/suit/bio_suit/anomaly
	head = /obj/item/clothing/head/bio_hood/anomaly

/datum/reagent/toxin/zombie/science
	name = "Isolated Corruption"
	description = "An incredibly dark, oily substance. Moves very slightly."
	taste_description = "decayed blood"
	color = "#800000"
	amount_to_zombify = 3


/obj/item/weapon/reagent_containers/glass/bottle/zombiescience
	name = "unknown bottle"
	desc = "A small bottle of some dark, oily liquid."
	icon = 'icons/obj/chemical.dmi'
	icon_state = "bottle-3"


/obj/item/weapon/reagent_containers/glass/bottle/zombiescience/Initialize()
	. = ..()
	reagents.add_reagent(/datum/reagent/toxin/zombie/science, 5) //Should pretty much be death if they decide to chug it, unless explorers happen to follow chemical procedure for once - Pandolphina
	update_icon()

