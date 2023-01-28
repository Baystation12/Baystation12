/datum/power/changeling/false_identity
	name = "False Identity"
	desc = "We twist our body like clay into an identity of our own making."
	ability_icon_state = "ling_transform"
	genomecost = 1
	power_category = CHANGELING_POWER_INHERENT
	verbpath = /mob/proc/changeling_false_identity

/mob/proc/changeling_false_identity()
	set category = "Changeling"
	set name = "False Identity (10)"
	set desc="Twists our body into a new false identity"
	var/datum/changeling/changeling = changeling_power(10,0,100,CONSCIOUS)
	var/mob/living/carbon/human/C = src
	C.mind.changeling.last_human_form = C.real_name
	C.change_appearance(APPEARANCE_BASIC, state = GLOB.z_state)
	C.visible_message(SPAN_DANGER("\The [src] lets out a vile crunching noise, as their body begins to reshape itself!"))
	playsound(C.loc, 'sound/effects/corpsecube.ogg', 60)
	var/response = input(C, "What would you like to call your new self?", "Name change") as null | text
	response = sanitize(response, MAX_NAME_LEN)
	if (!response)
		return
	C.real_name = response
	C.SetName(response)
	C.dna.real_name = response
	C.sync_organ_dna()
	var/obj/item/organ/external/head/H = C.organs_by_name[BP_HEAD]
	if (istype(H) && H.forehead_graffiti)
		H.forehead_graffiti = null
	if (C.mind)
		C.mind.name = C.name
	if(changeling)
		changeling.chem_charges -= 10
	//to_world("[C.mind.changeling.last_human_form]")
