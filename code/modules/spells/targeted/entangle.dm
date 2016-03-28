/spell/targeted/entangle
	name = "Entangle"
	desc = "This spell creates vines that immediately entangle a nearby victim."
	feedback = "ET"
	school = "conjuration"
	charge_max = 600
	spell_flags = NEEDSCLOTHES | SELECTABLE | IGNOREPREV
	invocation = "BU EKEL 'INAS"
	invocation_type = SpI_SHOUT
	range = 3
	max_targets = 1

	level_max = list(Sp_TOTAL = 2, Sp_SPEED = 2, Sp_POWER = 2)
	cooldown_min = 300
	duration = 30

	hud_state = "wiz_entangle"
	var/datum/seed/seed

/spell/targeted/entangle/New()
	..()
	seed = new()
	seed.set_trait(TRAIT_PLANT_ICON,"flower")
	seed.set_trait(TRAIT_PRODUCT_ICON,"flower2")
	seed.set_trait(TRAIT_PRODUCT_COLOUR,"#4d4dff")
	seed.set_trait(TRAIT_SPREAD,2)
	seed.name = "heirlooms"
	seed.seed_name = "heirloom"
	seed.display_name = "vines"
	seed.chems = list("nutriment" = list(1,20))

/spell/targeted/entangle/cast(var/list/targets)
	for(var/mob/M in targets)
		var/turf/T = get_turf(M)
		var/obj/effect/plant/single/P = new(T,seed)
		P.can_buckle = 1
		P.health = P.max_health
		P.mature_time = 0
		P.process()

		P.buckle_mob(M)
		M.set_dir(pick(cardinal))
		M.visible_message("<span class='danger'>[P] appear from the floor, spinning around \the [M] tightly!</span>")
/spell/targeted/entangle/empower_spell()
	if(!..())
		return 0

	max_targets++

	return "This spell will now entangle [max_targets] people at the same time."