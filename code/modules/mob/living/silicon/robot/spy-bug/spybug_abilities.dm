// spybug ABILITIES
/mob/living/silicon/robot/spybug/verb/set_mail_tag()
	set name = "Set Mail Tag"
	set desc = "Tag yourself for delivery through the disposals system."
	set category = "Robot Commands"

	var/new_tag = input("Select the desired destination.", "Set Mail Tag", null) as null|anything in tagger_locations

	if(!new_tag)
		mail_destination = ""
		return

	src << "\blue You configure your internal beacon, tagging yourself for delivery to '[new_tag]'."
	mail_destination = new_tag

	//Auto flush if we use this verb inside a disposal chute.
	var/obj/machinery/disposal/D = src.loc
	if(istype(D))
		src << "\blue \The [D] acknowledges your signal."
		D.flush_count = D.flush_every_ticks

	return

/mob/living/silicon/robot/spybug/verb/disconnect()
	set name = "Disconnect"
	set desc = "Disconnect the VR uplink."
	set category = "Virtual Reality"

	src << "Unlocking neural clamp..."
	sleep(70)
	src << "<b>Unlocked</b>."

	verbs -= spybot_verbs_default

	var/mob/living/body = user_body
	var/mob/living/spybug

	if(spybug.mind.special_verbs.len)//If the spybug had any special verbs, remove them from the mob verb list.
		for(var/V in spybug.mind.special_verbs)//Since the spybug is using an object spell system, this is mostly moot.
			spybug.verbs -= V//But a safety nontheless.

	if(body.mind.special_verbs.len)//Now remove all of the body's verbs.
		for(var/V in body.mind.special_verbs)
			body.verbs -= V

	var/mob/dead/observer/ghost = body.ghostize(0) // In case some mind tried to take control while the person was away

	spybug.mind.transfer_to(body)

	if(body.mind.special_verbs.len)//To add all the special verbs for the original spybug.
		for(var/V in spybug.mind.special_verbs)//Not too important but could come into play.
			spybug.verbs += V

	spybug.key = ghost.key	//have to transfer the key since the mind was not active
	spybug.spell_list = ghost.spell_list

	if(spybug.mind.special_verbs.len)//If they had any special verbs, we add them here.
		for(var/V in spybug.mind.special_verbs)
			spybug.verbs += V

	user_body = null


//Actual picking-up event.
/mob/living/silicon/robot/spybug/attack_hand(mob/living/carbon/human/M as mob)

	if(M.a_intent == "help" || M.a_intent == "grab")
		get_scooped(M)
	..()
