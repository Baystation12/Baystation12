/spell/aoe_turf/conjure/grove
	name = "Grove"
	desc = "Creates a sanctuary of nature around the wizard as well as creating a healing plant."

	spell_flags = IGNOREDENSE | IGNORESPACE | NEEDSCLOTHES | Z2NOCAST | IGNOREPREV
	charge_max = 1200
	school = "transmutation"

	range = 1
	cooldown_min = 600

	level_max = list(Sp_TOTAL = 3, Sp_SPEED = 3, Sp_POWER = 1)

	summon_amt = 47
	summon_type = list(/turf/simulated/floor/grass)
	var/spread = 0
	var/datum/seed/seed
	var/seed_type = /datum/seed/merlin_tear

/spell/aoe_turf/conjure/grove/New()
	..()
	if(seed_type)
		seed = new seed_type()
	else
		seed = plant_controller.create_random_seed(1)

/spell/aoe_turf/conjure/grove/before_cast()
	var/turf/T = get_turf(holder)
	var/obj/effect/vine/P = new(T,seed)
	P.spread_chance = spread


/spell/aoe_turf/conjure/grove/sanctuary
	name = "Sanctuary"
	desc = "Creates a sanctuary of nature around the wizard as well as creating a healing plant."
	feedback = "SY"
	invocation = "Bo K'Iitan!"
	invocation_type = SpI_SHOUT
	spell_flags = IGNOREDENSE | IGNORESPACE | NEEDSCLOTHES | Z2NOCAST | IGNOREPREV
	cooldown_min = 600

	level_max = list(Sp_TOTAL = 3, Sp_SPEED = 3, Sp_POWER = 1)

	seed_type = /datum/seed/merlin_tear
	newVars = list("name" = "sanctuary", "desc" = "This grass makes you feel comfortable. Peaceful.","blessed" = 1)

	hud_state = "wiz_grove"
/spell/aoe_turf/conjure/grove/sanctuary/empower_spell()
	if(!..())
		return 0

	seed.set_trait(TRAIT_SPREAD,2) //make it grow.
	spread = 40
	return "Your sanctuary will now grow beyond that of the grassy perimeter."

/datum/seed/merlin_tear
	name = "merlin tears"
	seed_name = "merlin tears"
	display_name = "merlin tears"
	chems = list(/datum/reagent/bicaridine = list(3,7), /datum/reagent/dermaline = list(3,7), /datum/reagent/dylovene = list(3,7), /datum/reagent/tricordrazine = list(3,7), /datum/reagent/alkysine = list(1,2), /datum/reagent/imidazoline = list(1,2), /datum/reagent/peridaxon = list(4,5))
	kitchen_tag = "berries"

/datum/seed/merlin_tear/New()
	..()
	set_trait(TRAIT_PLANT_ICON,"bush5")
	set_trait(TRAIT_PRODUCT_ICON,"berry")
	set_trait(TRAIT_PRODUCT_COLOUR,"#4d4dff")
	set_trait(TRAIT_PLANT_COLOUR, "#ff6600")
	set_trait(TRAIT_YIELD,4)
	set_trait(TRAIT_MATURATION,6)
	set_trait(TRAIT_PRODUCTION,6)
	set_trait(TRAIT_POTENCY,10)
	set_trait(TRAIT_HARVEST_REPEAT,1)
	set_trait(TRAIT_IMMUTABLE,1) //no making op plants pls