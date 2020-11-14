//////////
// Project Vial
/////////
/obj/item/weapon/reagent_containers/glass/beaker/vial/projectsecret
	name = "unmarked vial"
	reagents_to_add = list(/datum/reagent/random = 30)

/////////
// HF
/////////
/datum/reagent/toxin/hfp
	name = "Heptafluoropropane"
	description = "Liquid heptafluoropropane. You probably don't want to touch this!"
	taste_description = "freezing pain"
	color = "#d3ebea"
	strength = 25
	overdose = REAGENTS_OVERDOSE / 1
	metabolism = REM * 0.5
	var/adj_temp = -80
	var/targ_temp = 190
	target_organ = BP_HEART

/datum/reagent/toxin/hfp/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	..()
	M.confused += 1.5
	if(adj_temp > 0 && M.bodytemperature < targ_temp)
		M.bodytemperature = min(targ_temp, M.bodytemperature + (adj_temp * TEMPERATURE_DAMAGE_COEFFICIENT))
	if(adj_temp < 0 && M.bodytemperature > targ_temp)
		M.bodytemperature = min(targ_temp, M.bodytemperature - (adj_temp * TEMPERATURE_DAMAGE_COEFFICIENT))

/datum/reagent/toxin/hfp/overdose(var/mob/living/carbon/M, var/alien)
	..()
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		if(H.stat != UNCONSCIOUS)
			H.Weaken(2)
		M.add_chemical_effect(CE_PULSE, 15)

//tempcont
/obj/item/weapon/reagent_containers/glass/beaker/vial/hfp
	name = "cold vial"
	reagents_to_add = list(/datum/reagent/toxin/hfp = 30)

/////////
// stable slime toxin
/////////
/datum/reagent/stableslimetoxin
	name = "Thick Sludge"
	description = "A thick viscous substance that probably wouldn't taste too great."
	taste_description = "sludge"
	reagent_state = LIQUID
	color = "#1d633c"
	metabolism = REM * 1
	value = 5

/datum/reagent/stableslimetoxin/affect_blood(var/mob/living/carbon/human/H, var/alien, var/removed)
	if(ishuman(H))
		to_chat(H, "<span class='danger'>Your flesh rapidly mutates!</span>")
		H.set_species(SPECIES_PROMETHEAN)
		H.shapeshifter_set_colour("#05ff9b")
		H.verbs -= /mob/living/carbon/human/proc/shapeshifter_select_colour
	H.update_body()

/obj/item/weapon/reagent_containers/glass/beaker/vial/sludge
	name = "sticky vial"
	reagents_to_add = list(/datum/reagent/stableslimetoxin = 1)

/////////
// Zombie Vial
/////////
/obj/item/weapon/reagent_containers/glass/beaker/vial/zombie
	name = "odd vial"
	reagents_to_add = list(/datum/reagent/zombie = 30)

/////////
// Enfluroprobine
/////////

/datum/reagent/enfluroprobine
	name = "Enfluroprobine"
	description = "A light substance that probably wouldn't taste too great."
	taste_description = "rage"
	reagent_state = LIQUID
	color = "#a62c2b"
	metabolism = REM * 1
	value = 2

//vial
/obj/item/weapon/reagent_containers/glass/beaker/vial/enfluroprobine
	name = "odd vial"
	reagents_to_add = list(/datum/reagent/enfluroprobine = 30)

/////////
// VB Vial
/////////
/obj/item/weapon/reagent_containers/glass/beaker/vial/vecuronium_bromide
	name = "odd vial"
	reagents_to_add = list(/datum/reagent/vecuronium_bromide = 30)

/////////
// Coffee OLD
/////////
/datum/reagent/drink/coffee/old
	name = "old coffee"
	description = "This smells funny."
	taste_description = "something awful"
	color = "#6e4525"
	adj_temp = 85
	overdose = 15

	glass_name = "coffee"
	glass_desc = "This smells funny, and seems incredibly hot."

/////////
// SF4
/////////
/datum/reagent/acid/sf4
	name = "Sulfur Tetrafluoride"
	description = "A highly corrosive gas."
	taste_description = "rotten eggs"
	color = "#debd45"
	touch_met = 100
	power = 85
	meltdose = 5 // How much is needed to melt
	max_damage = 65

//hf
/datum/reagent/acid/hf
	name = "Hydrofluoric acid"
	description = "A highly corrosive acid."
	taste_description = "acid"
	reagent_state = LIQUID
	color = "#619494"