/spell/aoe_turf/drain_blood
	name = "Drain Blood"
	desc = "this spell allows the caster to borrow blood from those around them. Sharing is caring!"
	feedback = "DB"
	school = "transmutation"
	charge_max = 600
	invocation = "whispers something darkly"
	invocation_type = SpI_EMOTE
	range = 3
	inner_radius = 0

	cast_delay = 50
	time_between_channels = 100
	number_of_channels = 3
	cast_sound = 'sound/effects/squelch2.ogg'
	hud_state = "const_rune"

/spell/aoe_turf/drain_blood/cast(var/list/targets, var/mob/user)
	for(var/t in targets)
		for(var/mob/living/L in t)
			if(L.stat == DEAD || L == user)
				continue
			//Hurt target
			if(istype(L, /mob/living/carbon/human))
				var/mob/living/carbon/human/H = L
				H.vessel.remove_reagent("blood", 10)
			else
				L.adjustBruteLoss(10)
			to_chat(L, "<span class='danger'>You feel your lifeforce being ripping out of your body!</span>")

			//Do effect
			var/obj/item/projectile/beam/blood_effect/effect = new(get_turf(L))
			effect.launch(user, "chest")

			//Heal self
			if(istype(user, /mob/living/carbon/human))
				var/mob/living/carbon/human/H = user
				var/amount = min(10, H.species.blood_volume - H.vessel.total_volume)
				if(amount)
					H.vessel.add_reagent("blood", amount)
					continue
			L.adjustBruteLoss(-5)
			L.adjustFireLoss(-2.5)
			L.adjustToxLoss(-2.5)

/obj/item/projectile/beam/blood_effect
	name = "literally just blood"
	damage = 0
	no_attack_log = 1

/obj/item/projectile/beam/blood_effect/Bump(var/atom/a)
	if(a == original)
		on_impact(a)
		qdel(src)
		return 1
	return 0