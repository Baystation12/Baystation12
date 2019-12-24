


/* TALLISTA SPICE */

/obj/item/weapon/reagent_containers/food/snacks/tallista_spice
	name = "Tallista spice"
	desc = "A rare glittering substance refined on a desert world."
	icon = 'code/modules/halo/factions/npc_factions/gear/khoros.dmi'
	icon_state = "tallista_spice"
	item_state = "balloon"
	volume = 10

/obj/item/weapon/reagent_containers/food/snacks/tallista_spice/New()
	. = ..()
	reagents.add_reagent(/datum/reagent/tallista_spice, 10)

/datum/reagent/tallista_spice
	name = "Tallista spice"
	description = "A rare glittering substance refined on a desert world."
	taste_description = "fizzy cinnamon"
	overdose = 11
	scannable = 1
	color = "#cc0066"
	color_weight = 2

/datum/reagent/tallista_spice/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed)
	..()
	M.add_chemical_effect(CE_SPEEDBOOST, 0.5)
	M.add_chemical_effect(CE_SLOWREMOVE, 0.5)
	M.add_chemical_effect(CE_PULSE, 0.1)
	M.add_chemical_effect(CE_PAINKILLER, 50)
