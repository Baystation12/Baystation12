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

	time_between_channels = 100
	number_of_channels = 3
	cast_sound = 'sound/effects/squelch2.ogg'
	hud_state = "const_rune"

/spell/aoe_turf/drain_blood/cast(list/targets, mob/user)
	for(var/t in targets)
		for(var/mob/living/L in t)
			if(L.stat == DEAD || L == user)
				continue
			//Hurt target
			if(istype(L, /mob/living/carbon/human))
				var/mob/living/carbon/human/H = L
				H.vessel.remove_reagent(/datum/reagent/blood, 10)
			else
				L.adjustBruteLoss(10)
			to_chat(L, SPAN_DANGER("You feel your lifeforce being ripping out of your body!"))

			//Do effect
			var/obj/item/projectile/beam/blood_effect/effect = new(get_turf(user))
			effect.pixel_x = 0
			effect.pixel_y = 0
			effect.launch(L, "chest")

			//Heal self
			if(istype(user, /mob/living/carbon/human))
				var/mob/living/carbon/human/H = user
				var/amount = min(10, H.species.blood_volume - H.vessel.total_volume)
				if(amount > 0)
					H.vessel.add_reagent(/datum/reagent/blood, amount)
					continue
			L.adjustBruteLoss(-5)
			L.adjustFireLoss(-2.5)
			L.adjustToxLoss(-2.5)

/obj/item/projectile/beam/blood_effect
	name = "blood jet"
	icon_state = "blood"
	damage = 0
	randpixel = 0
	no_attack_log = TRUE
	muzzle_type = /obj/projectile/blood
	tracer_type = /obj/projectile/blood
	impact_type = /obj/projectile/blood

/obj/item/projectile/beam/blood_effect/Bump(atom/a, forced=0)
	if(a == original)
		on_impact(a)
		qdel(src)
		return 1
	return 0


/obj/projectile/blood
	icon_state = "blood"
