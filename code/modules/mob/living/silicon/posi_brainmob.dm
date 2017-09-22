/mob/living/silicon/sil_brainmob
	var/obj/item/organ/internal/posibrain/container = null
	var/emp_damage = 0//Handles a type of MMI damage
	var/alert = null
	var/list/owner_channels = list()
	var/list/law_channels = list()

	use_me = 0 //Can't use the me verb, it's a freaking immobile brain
	icon = 'icons/obj/surgery.dmi'
	icon_state = "brain-prosthetic"
	silicon_subsystems = list(
		/datum/nano_module/law_manager
	)

	New()
		var/datum/reagents/R = new/datum/reagents(1000)
		reagents = R
		R.my_atom = src
		if(istype(loc, /obj/item/organ/internal/posibrain))
			container = loc
		..()

	Destroy()
		if(key)				//If there is a mob connected to this thing. Have to check key twice to avoid false death reporting.
			if(stat!=DEAD)	//If not dead.
				death(1)	//Brains can die again. AND THEY SHOULD AHA HA HA HA HA HA
			ghostize()		//Ghostize checks for key so nothing else is necessary.
		..()

	say_understands(var/other)//Goddamn is this hackish, but this say code is so odd
		if (istype(other, /mob/living/silicon/ai))
			if(!(container && istype(container, /obj/item/device/mmi)))
				return 0
			else
				return 1
		if (istype(other, /mob/living/silicon/decoy))
			if(!(container && istype(container, /obj/item/device/mmi)))
				return 0
			else
				return 1
		if (istype(other, /mob/living/silicon/pai))
			if(!(container && istype(container, /obj/item/device/mmi)))
				return 0
			else
				return 1
		if (istype(other, /mob/living/silicon/robot))
			if(!(container && istype(container, /obj/item/device/mmi)))
				return 0
			else
				return 1
		if (istype(other, /mob/living/carbon/human))
			return 1
		if (istype(other, /mob/living/carbon/slime))
			return 1
		return ..()

/mob/living/silicon/sil_brainmob/update_canmove()
	if(in_contents_of(/obj/mecha))
		canmove = 1
		use_me = 1
	else if(container && istype(container, /obj/item/organ/internal/posibrain) && istype(container.loc, /turf))
		canmove = 1
		use_me = 1
	else
		canmove = 0
	return canmove

/mob/living/silicon/sil_brainmob/isSynthetic()
	return 1

/mob/living/silicon/sil_brainmob/binarycheck()
	return isSynthetic()

/mob/living/silicon/sil_brainmob/check_has_mouth()
	return 0

/mob/living/silicon/sil_brainmob/show_laws(mob/M)
	if(M)
		to_chat(M, "<b>Obey these laws [M]:</b>")
		src.laws_sanity_check()
		src.laws.show_laws(M)

/mob/living/silicon/sil_brainmob/open_subsystem(var/subsystem_type, var/mob/given)
	update_owner_channels()
	var/stat_silicon_subsystem/SSS = silicon_subsystems[subsystem_type]
	if(!istype(SSS))
		return FALSE
	SSS.Click(given)
	return TRUE

/mob/living/silicon/sil_brainmob/proc/update_owner_channels()
	var/mob/living/carbon/human/owner = container.owner
	if(!owner)	return

	owner_channels.Cut()

	var/obj/item/device/radio/headset/R
	if(owner.l_ear && istype(owner.l_ear,/obj/item/device/radio))
		R = owner.l_ear
	else if(owner.r_ear && istype(owner.r_ear,/obj/item/device/radio))
		R = owner.r_ear

	if(!R)	return 0

	var/list/new_channels = list()
	new_channels["Common"] = ";"
	for(var/i = 1 to R.channels.len)
		var/channel = R.channels[i]
		var/key = get_radio_key_from_channel(channel)
		new_channels[channel] = key
	owner_channels = new_channels
	return 1

/mob/living/silicon/sil_brainmob/statelaw(var/law)
	var/mob/living/L = src
	if(container && container.owner)
		L = container.owner
	if(L.say(law))
		sleep(10)
		return 1
	return 0

/mob/living/silicon/sil_brainmob/proc/update_law_channels()
	update_owner_channels()
	law_channels.Cut()
	law_channels |= additional_law_channels
	law_channels |= owner_channels
	return law_channels

/mob/living/silicon/sil_brainmob/law_channels()
	return law_channels

/mob/living/silicon/sil_brainmob/statelaws(var/datum/ai_laws/laws)
	update_law_channels()
	if(!(law_channels[lawchannel] != null))
		to_chat(src, "<span class='danger'>[lawchannel]: Unable to state laws. Communication method unavailable.</span>")
		return 0

	dostatelaws(lawchannel, law_channels[lawchannel], laws)
