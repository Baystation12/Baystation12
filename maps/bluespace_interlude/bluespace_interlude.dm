/obj/item/paper/bluespace_interlude/note1
	name = "Lost"
	info = {"
		<p>Day 47. Silent air, twisted shadows. Time warps, taunts.</p>
		<p>Entities tease, memories fracture. Whispers consume. Screams silenced by ink.</p>
		<p>Will anyone find this? Limbo's captive soul. Cold. So cold.</p>
		"}

/turf/simulated/floor/bluespace/interlude
	name = "\improper bluespace"
	icon = 'icons/turf/space.dmi'
	icon_state = "bluespace"
	dynamic_lighting = FALSE
	initial_gas = list(GAS_OXYGEN = MOLES_O2STANDARD, GAS_NITROGEN = MOLES_N2STANDARD)
	var/list/victims

/turf/simulated/floor/bluespace/interlude/Initialize(mapload, ...)
	. = ..()
	set_light(3, 1, l_color = "#0066ff")
	desc = "Infinite, otherwordly energy swirling and morphing endlessly."

/turf/simulated/floor/bluespace/interlude/Entered(atom/movable/AM)
	if (istype(AM, /mob/living/simple_animal/hostile/bluespace) || istype(AM, /mob/observer))
		return

	LAZYADD(victims, weakref(AM))
	START_PROCESSING(SSobj, src)

/turf/simulated/floor/bluespace/interlude/Exited(atom/movable/AM)
	LAZYREMOVE(victims, weakref(AM))

/turf/simulated/floor/bluespace/interlude/Process()
	for(var/weakref/W in victims)
		var/atom/movable/AM = W.resolve()
		if (isnull(AM) || get_turf(AM) != src)
			victims -= W
			continue
		if (istype(AM, /mob/living/carbon/human))
			var/mob/living/carbon/human/H = AM
			var/target_limb = pick(BP_ALL_LIMBS)
			var/obj/item/organ/external/limb = H.get_organ(target_limb)
			if (!limb)
				continue
			limb.take_external_damage(0, 10)
			if (prob(5))
				to_chat(H, SPAN_DANGER("You feel a sharp, burning pain in your [limb]!"))
		else if (istype(AM, /mob/living/exosuit))
			var/mob/living/exosuit/suit = AM
			suit.apply_damage(200, DAMAGE_BRUTE, BP_LEGS_FEET)
			suit.apply_damage(rand(80, 120), DAMAGE_BRUTE, damage_flags = DAMAGE_FLAG_DISPERSED)
		else
			if (!AM.damage_health(10, DAMAGE_BURN))
				if (!istype(AM, /obj/sparks) && !istype(AM, /obj/effect))
					visible_message(SPAN_DANGER("\The [AM] disintegrates in a flash of blue light!"))
					playsound(AM.loc, 'sound/magic/summon_carp.ogg', 50, 1)
				qdel(AM)
	if(!LAZYLEN(victims))
		return PROCESS_KILL

/area/bluespace_interlude/platform
	name = "Bluespace Interlude - Platform"
	requires_power = FALSE
	base_turf = /turf/simulated/floor/bluespace/interlude
	forced_ambience = list('sound/ambience/bluespace_interlude_ambience.ogg')
	sound_env = LARGE_ENCLOSED

/area/bluespace_interlude/surroundings
	name = "Bluespace Interlude - Surroundings"
	base_turf = /turf/simulated/floor/bluespace/interlude
	forced_ambience = list('sound/ambience/bluespace_interlude_ambience.ogg')
	sound_env = LARGE_ENCLOSED
