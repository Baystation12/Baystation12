// Originally a debug verb, made it a proper adminverb for ~fun~
/client/proc/makePAI(turf/t in range(world.view), name as text, pai_key as null|text)
	set name = "Make pAI"
	set category = "Admin"

	if(!check_rights(R_ADMIN))
		return

	if(!pai_key)
		var/client/C = input("Select client") as null|anything in GLOB.clients
		if(!C) return
		pai_key = C.key

	log_and_message_admins("made a pAI with key=[pai_key] at ([t.x],[t.y],[t.z])")
	var/obj/item/device/paicard/card = new(t)
	var/mob/living/silicon/pai/pai = new(card)
	pai.key = pai_key
	card.setPersonality(pai)

	if(name)
		pai.fully_replace_character_name(name)
