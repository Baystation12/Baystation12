/spell/aoe_turf/conjure/grove
	name = "Grove"
	desc = "Creates a sanctuary of nature around the wizard as well as creating a healing plant."

	spell_flags = IGNOREDENSE | IGNORESPACE | NEEDSCLOTHES | Z2NOCAST | IGNOREPREV
	charge_max = 1200
	school = "conjuration"
	invocation = "Bo k'itan"
	invocation_type = SpI_SHOUT

	range = 1
	cooldown_min = 600

	level_max = list(Sp_TOTAL = 3, Sp_SPEED = 3, Sp_POWER = 1)

	summon_amt = 47
	summon_type = list(/turf/simulated/floor/grass)
	newVars = list("name" = "sanctuary", "desc" = "This grass makes you feel comfortable. Peaceful.","blessed" = 1)

	hud_state = "wiz_grove"
	var/spread = 0
	var/datum/seed/seed

/spell/aoe_turf/conjure/grove/New()
	..()
	seed = new()
	seed.chems = list("bicaridine" = list(3,7), "dermaline" = list(3,7), "anti_toxin" = list(3,7), "tricordrazine" = list(3,7), "alkysine" = list(1,2), "imidazoline" = list(1,2), "peridaxon" = list(4,5)) //super drug, basically.
	seed.set_trait(TRAIT_PLANT_ICON,"bush5")
	seed.set_trait(TRAIT_PRODUCT_ICON,"berry")
	seed.set_trait(TRAIT_PRODUCT_COLOUR,"#4d4dff")
	seed.set_trait(TRAIT_PLANT_COLOUR, "#ff6600")
	//seed.set_trait(TRAIT_SPREAD, 2)
	seed.set_trait(TRAIT_YIELD,4)
	seed.set_trait(TRAIT_MATURATION,6)
	seed.set_trait(TRAIT_PRODUCTION,6)
	seed.set_trait(TRAIT_POTENCY,10)
	seed.set_trait(TRAIT_HARVEST_REPEAT,1)
	seed.set_trait(TRAIT_IMMUTABLE,1) //no making op plants pls
	seed.name = "merlin tear"
	seed.seed_name = "merlin tear"
	seed.display_name = "merlin tears"

/spell/aoe_turf/conjure/grove/before_cast()
	var/turf/T = get_turf(holder)
	var/obj/effect/plant/P = new(T,seed)
	P.spread_chance = spread

/spell/aoe_turf/conjure/grove/empower_spell()
	if(!..())
		return 0

	seed.set_trait(TRAIT_SPREAD,2) //make it grow.
	spread = 40
	return "Your sanctuary will now grow beyond that of the grassy perimeter."