/obj/item/grab/normal/vamp

	type_name = GRAB_VAMP
	start_grab_name = VAMP_PASSIVE

/obj/item/grab/normal/vamp/dropped()
	..()
	//remove spells: Feed, Enthrall, Embrace.



/datum/grab/normal/passive/vamp
	state_name = VAMP_PASSIVE


	upgrab_name = VAMP_AGGRESSIVE

/datum/grab/normal/passive/vamp/upgrade_effect()
	//add the Feed spell.

/datum/grab/normal/aggressive/vamp
	state_name = VAMP_AGGRESSIVE

	upgrab_name = VAMP_NECK
	downgrab_name = VAMP_PASSIVE


/datum/grab/normal/aggressive/vamp/downgrade_effect()
	//Remove the Feed spell.

/datum/grab/normal/aggressive/vamp/upgrade_effect()
	//add the Embrace spell.

/datum/grab/normal/neck/vamp
	state_name = VAMP_NECK

	upgrab_name = VAMP_KILL
	downgrab_name = VAMP_AGGRESSIVE
	ladder_carry = 1
	icon_state = "bite" //Todo: Pinwheel progression sprite.
	break_chance_table = list(5, 10, 20, 50, 70)


//Where the magic happens.
/datum/grab/normal/kill/vamp
	state_name = VAMP_KILL

	downgrab_name = VAMP_NECK
	icon_state = "bite1"
	break_chance_table = list(5, 10, 20, 40, 60)

/datum/grab/normal/aggressive/vamp/downgrade_effect()
	//Remove the Embrace spell.

/datum/grab/normal/kill/vamp/process_effect(var/obj/item/grab/G)
	..()
	var/mob/living/carbon/human/aff = G.affecting

	aff.Stun(3)

	aff.drop_l_hand()
	aff.drop_r_hand()

	if(aff.lying)
		aff.Weaken(4)

/datum/grab/normal/kill/vamp/on_hit_harm(var/obj/item/grab/G, var/zone)
	var/mob/living/carbon/human/ass = G.assailant
	var/mob/living/carbon/human/aff = G.affecting
	if(do_after(5 SECONDS))
		visible_message("<span class = 'warning'> You sink your teeth into [G.affecting]'s [zone], only to tear the flesh away shortly after. </span>","<span class = 'warning'>[G.assailant] sinks their teeth into [G.affecting]'s [zone], tearing at their flesh!</span>", "<span class = 'warning'>You hear meat being ripped and torn.</span>")
		//Do some crazy brute after a bit of time. Comparable to a throatslit. More damage if feral.