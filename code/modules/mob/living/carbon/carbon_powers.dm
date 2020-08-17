//Brain slug proc for voluntary removal of control.
/mob/living/carbon/proc/release_control()

	set category = "Abilities"
	set name = "Release Control"
	set desc = "Release control of your host's body."

	var/mob/living/simple_animal/borer/B = has_brain_worms()

	if(B && B.host_brain)
		to_chat(src, "<span class='danger'>You withdraw your probosci, releasing control of [B.host_brain]</span>")

		B.detatch()

		verbs -= /mob/living/carbon/proc/release_control
		verbs -= /mob/living/carbon/proc/punish_host
		verbs -= /mob/living/carbon/proc/spawn_larvae

	else
		to_chat(src, "<span class='danger'>ERROR NO BORER OR BRAINMOB DETECTED IN THIS MOB, THIS IS A BUG !</span>")

//Brain slug proc for tormenting the host.
/mob/living/carbon/proc/punish_host()
	set category = "Abilities"
	set name = "Torment host"
	set desc = "Punish your host with agony."

	var/mob/living/simple_animal/borer/B = has_brain_worms()

	if(!B)
		return

	if(B.host_brain.ckey)
		to_chat(src, "<span class='danger'>You send a punishing spike of psychic agony lancing into your host's brain.</span>")
		if (!can_feel_pain())
			to_chat(B.host_brain, "<span class='warning'>You feel a strange sensation as a foreign influence prods your mind.</span>")
			to_chat(src, "<span class='danger'>It doesn't seem to be as effective as you hoped.</span>")
		else
			to_chat(B.host_brain, "<span class='danger'><FONT size=3>Horrific, burning agony lances through you, ripping a soundless scream from your trapped mind!</FONT></span>")

/mob/living/carbon/proc/spawn_larvae()
	set category = "Abilities"
	set name = "Reproduce"
	set desc = "Spawn several young."

	var/mob/living/simple_animal/borer/B = has_brain_worms()

	if(!B)
		return

	if(B.chemicals >= 100)
		to_chat(src, "<span class='danger'>Your host twitches and quivers as you rapidly excrete a larva from your sluglike body.</span>")
		visible_message("<span class='danger'>\The [src] heaves violently, expelling a rush of vomit and a wriggling, sluglike creature!</span>")
		B.chemicals -= 100
		B.has_reproduced = 1

		new /obj/effect/decal/cleanable/vomit(get_turf(src))
		playsound(loc, 'sound/effects/splat.ogg', 50, 1)
		new /mob/living/simple_animal/borer(get_turf(src), B.generation + 1)

	else
		to_chat(src, "<span class='warning'>You do not have enough chemicals stored to reproduce.</span>")
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
	src.visible_message("<span class='danger'>\The [src] is attempting to devour \the [victim] whole!</span>")
	var/mob/target = victim
	if(isobj(victim))
		target = src
	if(!do_after(src, eat_speed, target))
		return FALSE
	src.visible_message("<span class='danger'>\The [src] devours \the [victim] whole!</span>")
	if(ismob(victim))
		admin_attack_log(src, victim, "Devoured.", "Was devoured by.", "devoured")
	else
		src.drop_from_inventory(victim)
	move_to_stomach(victim)

	return TRUE

/mob/living/carbon/proc/move_to_stomach(atom/movable/victim)
	return

/mob/living/carbon/proc/consume()
	set name = "Consume"
	set desc = "Regain life and infect others by feeding upon them."
	set category = "Abilities"

	if (last_special > world.time)
		to_chat(src, SPAN_WARNING("You aren't ready to do that! Wait [round(last_special - world.time) / 10] seconds."))
		return

	var/mob/living/carbon/human/target
	var/list/victims = list()
	for (var/mob/living/carbon/human/L in get_turf(src))
		if (L != src && (L.lying || L.stat == DEAD))
			if(isspecies(L, SPECIES_ZOMBIE))
				to_chat(src, SPAN_WARNING("\The [L] isn't fresh anymore!"))
				continue
			if(!(L.species.name in ORGANIC_SPECIES) || isspecies(L,SPECIES_DIONA) || L.isFBP())
				to_chat(src, SPAN_WARNING("You'd break your teeth on \the [L]!"))
				continue
			victims += L

	if(!victims.len)
		to_chat(src, SPAN_WARNING("No valid targets nearby!"))
		return
	if(client)
		if(victims.len == 1) //No need to choose
			target = victims[1]
		else
			target = input("Who would you like to consume?") as null|anything in victims
	else //NPCs
		if(victims.len > 0)
			target = victims[1]

	if (!target)
		to_chat(src, SPAN_WARNING("You aren't on top of a victim!"))
		return
	if (get_turf(src) != get_turf(target) || !(target.lying || target.stat == DEAD))
		to_chat(src, SPAN_WARNING("You're no longer on top of \the [target]!"))
		return

	last_special = world.time + 5 SECONDS

	src.visible_message(SPAN_DANGER("\The [src] hunkers down over \the [target], tearing into their flesh."))
	playsound(loc, 'sound/effects/bonebreak3.ogg', 20, 1)

	target.adjustHalLoss(50)

	if(do_after(src, 5 SECONDS, target, DO_DEFAULT, INCAPACITATION_KNOCKOUT))
		admin_attack_log(src, target, "Consumed their victim.", "Was consumed.", "consumed")

		if (!target.lying && target.stat != DEAD) //Check victims are still prone
			return

		target.reagents.add_reagent(/datum/reagent/zombie, 35) //Just in case they haven't been infected already
		if(target.getBruteLoss() > target.maxHealth*1.5)
			if(target.stat != DEAD)
				to_chat(src,SPAN_WARNING("You've scraped \the [target] down to the bones already!."))
				target.zombify()
			else
				to_chat(src,SPAN_DANGER("You shred and rip apart \the [target]'s remains!."))
				target.gib()
				playsound(loc, 'sound/effects/splat.ogg', 40, 1)
			return

		to_chat(target,SPAN_DANGER("\The [src] scrapes your flesh from your bones!"))
		to_chat(src,SPAN_DANGER("You feed hungrily off \the [target]'s flesh."))

		if(isspecies(target, SPECIES_ZOMBIE)) //Just in case they turn whilst being eaten
			return

		target.apply_damage(rand(50,60), BRUTE, BP_CHEST)
		target.adjustBruteLoss(20)
		target.update_surgery() //Update broken ribcage sprites etc.

		src.adjustBruteLoss(-5)
		src.adjustFireLoss(-15)
		src.adjustToxLoss(-5)
		src.adjustBrainLoss(-5)
		src.adjust_nutrition(40)

		playsound(loc, 'sound/effects/splat.ogg', 20, 1)
		new /obj/effect/decal/cleanable/blood/splatter(get_turf(src), target.species.blood_color)
		if(target.getBruteLoss() > target.maxHealth*0.75)
			if(prob(50))
				gibs(get_turf(src), target.dna)
				src.visible_message(SPAN_DANGER("\The [src] tears out \the [target]'s insides!"))
	else
		src.visible_message(SPAN_WARNING("\The [src] leaves their meal for later."))
