/spell/targeted/projectile/dumbfire/passage
	name = "Passage"
	desc = "throw a spell towards an area and teleport to it."
	feedback = "PA"
	proj_type = /obj/item/projectile/spell_projectile/passage


	school = "abjuration"
	charge_max = 250
	spell_flags = 0
	invocation = "A'YASAMA"
	invocation_type = SpI_SHOUT
	range = 15


	level_max = list(Sp_TOTAL = 1, Sp_SPEED = 0, Sp_POWER = 1)
	spell_flags = NEEDSCLOTHES
	duration = 15

	proj_step_delay = 1

	hud_state = "gen_project"


/spell/targeted/projectile/dumbfire/passage/prox_cast(var/list/targets, atom/spell_holder)
	for(var/mob/living/L in targets)
		apply_spell_damage(L)

	var/turf/T = get_turf(spell_holder)

	holder.forceMove(T)
	var/datum/effect/effect/system/smoke_spread/S = new /datum/effect/effect/system/smoke_spread()
	S.set_up(3,0,T)
	S.start()


/spell/targeted/projectile/dumbfire/passage/empower_spell()
	if(!..())
		return 0

	amt_stunned += 3

	return "[src] now stuns those who get hit by it."

/obj/item/projectile/spell_projectile/passage
	name = "spell"
	icon_state = "energy2"