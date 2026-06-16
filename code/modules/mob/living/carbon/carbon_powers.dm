//Brain slug proc for voluntary removal of control.
/mob/living/carbon/proc/release_control()

	set category = "Abilities"
	set name = "Release Control"
	set desc = "Release control of your host's body."

	var/mob/living/simple_animal/borer/B = has_brain_worms()

	if(B && B.host_brain)
		to_chat(src, SPAN_DANGER("You withdraw your probosci, releasing control of [B.host_brain]"))

		B.detatch()

		verbs -= /mob/living/carbon/proc/release_control
		verbs -= /mob/living/carbon/proc/punish_host
		verbs -= /mob/living/carbon/proc/spawn_larvae
		verbs -= /mob/living/carbon/proc/borer_stun

	else
		to_chat(src, SPAN_DANGER("ERROR NO BORER OR BRAINMOB DETECTED IN THIS MOB, THIS IS A BUG !"))

//Brain slug proc for tormenting the host.
/mob/living/carbon/proc/punish_host()
	set category = "Abilities"
	set name = "Torment host"
	set desc = "Punish your host with agony."

	var/mob/living/simple_animal/borer/B = has_brain_worms()

	if(!B)
		return

	if(B.host_brain.ckey)
		to_chat(src, SPAN_DANGER("You send a punishing spike of psychic agony lancing into your host's brain."))
		if (!can_feel_pain())
			to_chat(B.host_brain, SPAN_WARNING("You feel a strange sensation as a foreign influence prods your mind."))
			to_chat(src, SPAN_DANGER("It doesn't seem to be as effective as you hoped."))
		else
			to_chat(B.host_brain, SPAN_DANGER(FONT_LARGE("Horrific, burning agony lances through you, ripping a soundless scream from your trapped mind!")))

/mob/living/carbon/proc/spawn_larvae()
	set category = "Abilities"
	set name = "Reproduce"
	set desc = "Spawn several young."

	var/mob/living/simple_animal/borer/B = has_brain_worms()

	if(!B)
		return

	if(B.chemicals >= 100)
		to_chat(src, SPAN_DANGER("Your host twitches and quivers as you rapidly excrete a larva from your sluglike body."))
		visible_message(SPAN_DANGER("\The [src] heaves violently, expelling a rush of vomit and a wriggling, sluglike creature!"))
		B.chemicals -= 100
		B.has_reproduced = 1

		new /obj/decal/cleanable/vomit(get_turf(src))
		playsound(loc, 'sound/effects/splat.ogg', 50, 1)
		new /mob/living/simple_animal/borer(get_turf(src), B.generation + 1)

	else
		to_chat(src, SPAN_WARNING("You do not have enough chemicals stored to reproduce."))
		return

/mob/living/carbon/proc/borer_stun()
	set category = "Abilities"
	set name = "Psi Stun (100)"
	set desc = "Stun a visible target in your field of view."

	var/mob/living/simple_animal/borer/B = has_brain_worms()

	if(!B)
		return

	if(B.neutered)
		return

	var/attack_val = B.deep_link ? 3 : 1
	var/stun_range = B.deep_link ? 6 : 3

	var/list/victims = list()
	for(var/mob/living/carbon/C in oview(stun_range))
		victims += C

	var/mob/living/M = input(src, "Select a mob to stun") as null|anything in victims

	if(!M || !(M in view(stun_range)))
		return

	if(B.chemicals >= 100)
		B.chemicals -= 100

		if(M.deflect_psionic_attack())
			return

		sound_to(src, sound('sound/effects/psi/power_evoke.ogg'))
		sound_to(M, sound('sound/effects/psi/power_evoke.ogg'))

		if(do_psionics_check(5, src))
			to_chat(src, SPAN_DANGER("You try to focus on [M], but you cannot expel any psionic power!"))
			return

		if(M.do_psionics_check(5, src))
			to_chat(src, SPAN_DANGER("You focus on [M], but your psionic assault skates across them like glass."))
			return
		to_chat(M, SPAN_DANGER("You feel a sudden, sharp assault upon your mind that rattles your consciousness!"))
		M.Weaken(attack_val)
		visible_message(SPAN_DANGER("A wave of psychic energy emanates from [src], striking [M]!"), SPAN_DANGER("You focus on [M] and use your psionic energy to disorient them!"))
		B.set_ability_cooldown(15 SECONDS)
	else
		to_chat(src, SPAN_WARNING("You do not have enough chemicals stored to psionically stun."))
		return

/**
 *  Attempt to devour victim
 *
 *  Returns TRUE on success, FALSE on failure
 */
/mob/living/carbon/proc/devour(atom/movable/victim)
	var/can_eat = can_devour(victim)
	if(!can_eat)
		return FALSE

	var/eat_speed = 100
	if(can_eat == DEVOUR_FAST)
		eat_speed = 30
	src.visible_message(SPAN_DANGER("\The [src] is attempting to devour \the [victim] whole!"))
	var/mob/target = victim
	if(isobj(victim))
		target = src
	if(!do_after(src, eat_speed, target, DO_PUBLIC_UNIQUE))
		return FALSE
	src.visible_message(SPAN_DANGER("\The [src] devours \the [victim] whole!"))
	if(ismob(victim))
		admin_attack_log(src, victim, "Devoured.", "Was devoured by.", "devoured")
	else
		src.drop_from_inventory(victim)
	move_to_stomach(victim)

	return TRUE

/mob/living/carbon/proc/move_to_stomach(atom/movable/victim)
	return
