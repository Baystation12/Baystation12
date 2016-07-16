//Brain slug proc for voluntary removal of control.
/mob/living/carbon/proc/release_control()

	set category = "Abilities"
	set name = "Release Control"
	set desc = "Release control of your host's body."

	var/mob/living/simple_animal/borer/B = has_brain_worms()

	if(B && B.host_brain)
		src << "\red <B>You withdraw your probosci, releasing control of [B.host_brain]</B>"

		B.detatch()

		verbs -= /mob/living/carbon/proc/release_control
		verbs -= /mob/living/carbon/proc/punish_host
		verbs -= /mob/living/carbon/proc/spawn_larvae

	else
		src << "\red <B>ERROR NO BORER OR BRAINMOB DETECTED IN THIS MOB, THIS IS A BUG !</B>"

//Brain slug proc for tormenting the host.
/mob/living/carbon/proc/punish_host()
	set category = "Abilities"
	set name = "Torment host"
	set desc = "Punish your host with agony."

	var/mob/living/simple_animal/borer/B = has_brain_worms()

	if(!B)
		return

	if(B.host_brain.ckey)
		src << "\red <B>You send a punishing spike of psychic agony lancing into your host's brain.</B>"

		if (species && (species.flags & NO_PAIN))
			B.host_brain << "\red You feel a strange sensation as a foreign influence prods your mind."
			src << "\red <B>It doesn't seem to be as effective as you hoped.</B>"
		else
			B.host_brain << "\red <B><FONT size=3>Horrific, burning agony lances through you, ripping a soundless scream from your trapped mind!</FONT></B>"

/mob/living/carbon/proc/spawn_larvae()
	set category = "Abilities"
	set name = "Reproduce"
	set desc = "Spawn several young."

	var/mob/living/simple_animal/borer/B = has_brain_worms()

	if(!B)
		return

	if(B.chemicals >= 100)
		src << "\red <B>Your host twitches and quivers as you rapidly excrete a larva from your sluglike body.</B>"
		visible_message("\red <B>[src] heaves violently, expelling a rush of vomit and a wriggling, sluglike creature!</B>")
		B.chemicals -= 100
		B.has_reproduced = 1

		new /obj/effect/decal/cleanable/vomit(get_turf(src))
		playsound(loc, 'sound/effects/splat.ogg', 50, 1)
		new /mob/living/simple_animal/borer(get_turf(src), B.generation + 1)

	else
		src << "You do not have enough chemicals stored to reproduce."
		return
		
/**
 *  Attempt to devour victim
 *
 *  Returns TRUE on success, FALSE on failure
 */
/mob/living/carbon/proc/devour(mob/victim)
	var/can_eat = can_devour(victim)
	if(!can_eat)
		return FALSE
	
	src.visible_message("<span class='danger'>\The [src] is attempting to devour \the [victim]!</span>")
	if(can_eat == DEVOUR_FAST)
		if(!do_mob(src, victim, 30)) return FALSE
	else
		if(!do_mob(src, victim, 100)) return FALSE
	src.visible_message("<span class='danger'>\The [src] devours \the [victim]!</span>")
	admin_attack_log(src, victim, "Devoured.", "Was devoured by.", "devoured")
	victim.forceMove(src)
	src.stomach_contents.Add(victim)
	
	return TRUE