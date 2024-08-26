/mob/living/carbon/human/examine(mob/user, distance)
	. = TRUE
	var/skipgloves = 0
	var/skipsuitstorage = 0
	var/skipjumpsuit = 0
	var/skipshoes = 0
	var/skipmask = 0
	var/skipears = 0
	var/skipeyes = 0
	var/skipface = 0

	//exosuits and helmets obscure our view and stuff.
	if(wear_suit)
		skipgloves = wear_suit.flags_inv & HIDEGLOVES
		skipsuitstorage = wear_suit.flags_inv & HIDESUITSTORAGE
		skipjumpsuit = wear_suit.flags_inv & HIDEJUMPSUIT
		skipshoes = wear_suit.flags_inv & HIDESHOES

	if(head)
		skipmask = head.flags_inv & HIDEMASK
		skipeyes = head.flags_inv & HIDEEYES
		skipears = head.flags_inv & HIDEEARS
		skipface = head.flags_inv & HIDEFACE

	if(wear_mask)
		skipeyes |= wear_mask.flags_inv & HIDEEYES
		skipears |= wear_mask.flags_inv & HIDEEARS
		skipface |= wear_mask.flags_inv & HIDEFACE

	//no accuately spotting headsets from across the room.
	if(distance > 3)
		skipears = 1

	var/list/msg = list("*---------*\nThis is ")

	var/datum/pronouns/P = choose_from_pronouns()
	if((skipjumpsuit && skipface) || !(user.knows_target(src))) //big suits/masks/helmets make it hard to tell their gender
		P = GLOB.pronouns.by_key[PRONOUNS_THEY_THEM]
	else
		if(icon)
			msg += "[icon2html(icon, user)] " //fucking BYOND: this should stop dreamseeker crashing if we -somehow- examine somebody before their icon is generated

	if(!P)
		// Just in case someone VVs the pronouns to something strange. It'll runtime anyway when it hits usages, better to CRASH() now with a helpful message.
		CRASH("Pronoun datum was null; key was '[(skipjumpsuit && skipface) ? PLURAL : pronouns]'")

	if(!user.knows_target(src))
		msg += "<EM>Unknown</EM>"
	else
		if(src.fake_name)
			msg += "<EM>[src.fake_name]</EM>"
		else
			msg += "<EM>[src.name]</EM>"

	var/is_synth = isSynthetic()
	if(!(skipjumpsuit && skipface))
		var/species_name = "\improper "
		if(is_synth && species.cyborg_noun)
			species_name += "[species.cyborg_noun] [species.get_bodytype(src)]"
		else
			species_name += "[species.name]"
		msg += ", <b>[SPAN_COLOR(species.get_flesh_colour(src), "\a [species_name]!")]</b>[(user.can_use_codex() && SScodex.get_codex_entry(get_codex_value())) ?  SPAN_NOTICE(" \[<a href='?src=\ref[SScodex];show_examined_info=\ref[src];show_to=\ref[user]'>?</a>\]") : ""]"

	var/extra_species_text = species.get_additional_examine_text(src)
	if(extra_species_text)
		msg += "[extra_species_text]<br>"

	msg += "<br>"

	//uniform
	if(w_uniform && !skipjumpsuit)
		msg += "[P.He] [P.is] wearing [w_uniform.get_examine_line()].\n"

	//head
	if(head)
		msg += "[P.He] [P.is] wearing [head.get_examine_line()] on [P.his] head.\n"

	//suit/armour
	if(wear_suit)
		msg += "[P.He] [P.is] wearing [wear_suit.get_examine_line()].\n"
		//suit/armour storage
		if(s_store && !skipsuitstorage)
			msg += "[P.He] [P.is] carrying [s_store.get_examine_line()] on [P.his] [wear_suit.name].\n"

	//back
	if(back)
		msg += "[P.He] [P.has] [back.get_examine_line()] on [P.his] back.\n"

	//left hand
	if(l_hand)
		msg += "[P.He] [P.is] holding [l_hand.get_examine_line()] in [P.his] left hand.\n"

	//right hand
	if(r_hand)
		msg += "[P.He] [P.is] holding [r_hand.get_examine_line()] in [P.his] right hand.\n"

	//gloves
	if(gloves && !skipgloves)
		msg += "[P.He] [P.has] [gloves.get_examine_line()] on [P.his] hands.\n"
	else if(blood_DNA)
		msg += "[SPAN_WARNING("[P.He] [P.has] [(hand_blood_color != SYNTH_BLOOD_COLOUR) ? "blood" : "oil"]-stained hands!")]\n"

	//belt
	if(belt)
		msg += "[P.He] [P.has] [belt.get_examine_line()] about [P.his] waist.\n"

	//shoes
	if(shoes && !skipshoes)
		msg += "[P.He] [P.is] wearing [shoes.get_examine_line()] on [P.his] feet.\n"
	else if(feet_blood_color)
		msg += "[SPAN_WARNING("[P.He] [P.has] [(feet_blood_color != SYNTH_BLOOD_COLOUR) ? "blood" : "oil"]-stained feet!")]\n"

	//mask
	if(wear_mask && !skipmask)
		msg += "[P.He] [P.has] [wear_mask.get_examine_line()] on [P.his] face.\n"

	//eyes
	if(glasses && !skipeyes)
		msg += "[P.He] [P.has] [glasses.get_examine_line()] covering [P.his] eyes.\n"

	//left ear
	if(l_ear && !skipears)
		msg += "[P.He] [P.has] [l_ear.get_examine_line()] on [P.his] left ear.\n"

	//right ear
	if(r_ear && !skipears)
		msg += "[P.He] [P.has] [r_ear.get_examine_line()] on [P.his] right ear.\n"

	//ID
	if(wear_id)
		msg += "[P.He] [P.is] wearing [wear_id.get_examine_line()].\n"

	//handcuffed?
	if(handcuffed)
		if(istype(handcuffed, /obj/item/handcuffs/cable))
			msg += "[SPAN_WARNING("[P.He] [P.is] [icon2html(handcuffed, user)] restrained with cable!")]\n"
		else
			msg += "[SPAN_WARNING("[P.He] [P.is] [icon2html(handcuffed, user)] handcuffed!")]\n"

	//buckled
	if(buckled)
		msg += "[SPAN_WARNING("[P.He] [P.is] [icon2html(buckled, user)] buckled to [buckled]!")]\n"

	//Jitters
	if(is_jittery)
		if(jitteriness >= 300)
			msg += "[SPAN_WARNING("<B>[P.He] [P.is] convulsing violently!</B>")]\n"
		else if(jitteriness >= 200)
			msg += "[SPAN_WARNING("[P.He] [P.is] extremely jittery.")]\n"
		else if(jitteriness >= 100)
			msg += "[SPAN_WARNING("[P.He] [P.is] twitching ever so slightly.")]\n"

	//Disfigured face
	if(!skipface) //Disfigurement only matters for the head currently.
		var/obj/item/organ/external/head/E = get_organ(BP_HEAD)
		if(E && (E.status & ORGAN_DISFIGURED)) //Check to see if we even have a head and if the head's disfigured.
			if(E.species) //Check to make sure we have a species
				msg += E.species.disfigure_msg(src)
			else //Just in case they lack a species for whatever reason.
				msg += "[SPAN_WARNING("[P.His] face is horribly mangled!")]\n"
		var/datum/robolimb/robohead = all_robolimbs[E.model]
		if(length(robohead?.display_text) && facial_hair_style == "Text")
			msg += "The message \"[robohead.display_text]\" is displayed on its screen.\n"

	//splints
	for(var/organ in list(BP_L_LEG, BP_R_LEG, BP_L_ARM, BP_R_ARM))
		var/obj/item/organ/external/o = get_organ(organ)
		if(o && o.splinted && o.splinted.loc == o)
			msg += "[SPAN_WARNING("[P.He] [P.has] \a [o.splinted] on [P.his] [o.name]!")]\n"

	if(mSmallsize in mutations)
		msg += "[P.He] [P.is] small halfling!\n"

	if (src.stat)
		msg += "[SPAN_WARNING("[P.He] [P.is]n't responding to anything around [P.him] and seems to be unconscious.")]\n"
		if((stat == DEAD || is_asystole() || losebreath || status_flags & FAKEDEATH) && distance <= 3)
			msg += "[SPAN_WARNING("[P.He] [P.does] not appear to be breathing.")]\n"

	if (fire_stacks > 0)
		msg += "[P.He] looks flammable.\n"
	else if (fire_stacks < 0)
		msg += "[P.He] looks wet.\n"
	if(on_fire)
		msg += "[SPAN_WARNING("[P.He] [P.is] on fire!.")]\n"

	var/ssd_msg = species.get_ssd(src)
	if(ssd_msg && (!should_have_organ(BP_BRAIN) || has_brain()) && stat != DEAD)
		if(!key)
			msg += SPAN_DEBUG("[P.He] [P.is] [ssd_msg]. [P.He] won't be recovering any time soon. (Ghosted)") + "\n"
		else if(!client)
			msg += SPAN_DEBUG("[P.He] [P.is] [ssd_msg]. (Disconnected)") + "\n"

	if (admin_paralyzed)
		msg += SPAN_DEBUG("OOC: [P.He] [P.has] been paralyzed by staff. Please avoid interacting with [P.him] unless cleared to do so by staff.") + "\n"

	var/obj/item/organ/external/head/H = organs_by_name[BP_HEAD]
	if(istype(H) && H.forehead_graffiti && H.graffiti_style)
		msg += "[SPAN_NOTICE("[P.He] [P.has] \"[H.forehead_graffiti]\" written on [P.his] [H.name] in [H.graffiti_style]!")]\n"

	if (changed_age)
		var/scale = abs(changed_age) / age
		if (scale > 0.5)
			scale = "a lot "
		else if (scale > 0.25)
			scale = ""
		else
			scale = "a little "
		msg += "[P.He] looks [scale][changed_age > 0 ? "older" : "younger"] than you remember.\n"

	for (var/obj/aura/web/W in auras)
		msg += SPAN_WARNING("[P.He] is covered in webs!\n")
		break

	var/list/wound_flavor_text = list()
	var/applying_pressure = ""
	var/list/shown_objects = list()
	var/list/hidden_bleeders = list()

	for(var/organ_tag in species.has_limbs)

		var/list/organ_data = species.has_limbs[organ_tag]
		var/organ_descriptor = organ_data["descriptor"]
		var/obj/item/organ/external/E = organs_by_name[organ_tag]

		if(!E)
			wound_flavor_text[organ_descriptor] = "<b>[P.He] [P.is] missing [P.his] [organ_descriptor].</b>\n"
			continue

		wound_flavor_text[E.name] = ""

		if(E.applied_pressure == src)
			applying_pressure = "[SPAN_INFO("[P.He] [P.is] applying pressure to [P.his] [E.name].")]<br>"

		var/obj/item/clothing/hidden
		var/list/clothing_items = list(head, wear_mask, wear_suit, w_uniform, gloves, shoes)
		for(var/obj/item/clothing/C in clothing_items)
			if(istype(C) && (C.body_parts_covered & E.body_part))
				hidden = C
				break

		if(hidden && user != src)
			if(E.status & ORGAN_BLEEDING && !(hidden.item_flags & ITEM_FLAG_THICKMATERIAL)) //not through a spacesuit
				if(!hidden_bleeders[hidden])
					hidden_bleeders[hidden] = list()
				hidden_bleeders[hidden] += E.name
		else
			if(E.is_stump())
				wound_flavor_text[E.name] += "<b>[P.He] [P.has] a stump where [P.his] [organ_descriptor] should be.</b>\n"
				if(LAZYLEN(E.wounds) && E.parent)
					wound_flavor_text[E.name] += "[P.He] [P.has] [E.get_wounds_desc()] on [P.his] [E.parent.name].<br>"
			else
				if(!is_synth && BP_IS_ROBOTIC(E) && (E.parent && !BP_IS_ROBOTIC(E.parent) && !BP_IS_ASSISTED(E.parent)))
					wound_flavor_text[E.name] = "[P.He] [P.has] a [E.name].\n"
				var/wounddesc = E.get_wounds_desc()
				if(wounddesc != "nothing")
					wound_flavor_text[E.name] += "[P.He] [P.has] [wounddesc] on [P.his] [E.name].<br>"
		if(!hidden || distance <=1)
			if(E.dislocated > 0)
				wound_flavor_text[E.name] += "[P.His] [E.joint] is dislocated!<br>"
			if(((E.status & ORGAN_BROKEN) && E.brute_dam > E.min_broken_damage) || (E.status & ORGAN_MUTATED))
				wound_flavor_text[E.name] += "[P.His] [E.name] is dented and swollen!<br>"

		for(var/datum/wound/wound in E.wounds)
			var/list/embedlist = wound.embedded_objects
			if(LAZYLEN(embedlist))
				shown_objects += embedlist
				var/parsedembed[0]
				for(var/obj/embedded in embedlist)
					if(!length(parsedembed) || (!parsedembed.Find(embedded.name) && !parsedembed.Find("multiple [embedded.name]")))
						parsedembed.Add(embedded.name)
					else if(!parsedembed.Find("multiple [embedded.name]"))
						parsedembed.Remove(embedded.name)
						parsedembed.Add("multiple "+embedded.name)
				wound_flavor_text["[E.name]"] += "The [wound.desc] on [P.his] [E.name] has \a [english_list(parsedembed, and_text = " and a ", comma_text = ", a ")] sticking out of it!<br>"
	for(var/hidden in hidden_bleeders)
		wound_flavor_text[hidden] = "[P.He] [P.has] blood soaking through [hidden] around [P.his] [english_list(hidden_bleeders[hidden])]!<br>"

	var/wound_msg = ""
	for(var/limb in wound_flavor_text)
		wound_msg += wound_flavor_text[limb]
	msg += SPAN_WARNING(wound_msg)

	for(var/obj/implant in get_visible_implants(0))
		if(implant in shown_objects)
			continue
		if(src.fake_name)
			msg += "[SPAN_DANGER("[src.fake_name] [P.has] \a [implant.name] sticking out of [P.his] flesh!")]\n"
		else
			msg += "[SPAN_DANGER("[src] [P.has] \a [implant.name] sticking out of [P.his] flesh!")]\n"
	if(digitalcamo)
		msg += "[P.He] [P.is] repulsively uncanny!\n"

	if(hasHUD(user, HUD_SECURITY))
		var/perpname = "wot"
		var/criminal = "None"

		var/obj/item/card/id/id = GetIdCard()
		if(istype(id))
			perpname = id.registered_name
		else
			if(src.fake_name)
				perpname=src.fake_name
			else
				perpname=src.name

		if(perpname)
			var/datum/computer_file/report/crew_record/R = get_crewmember_record(perpname)
			if(R)
				criminal = R.get_criminalStatus()

			msg += "[SPAN_CLASS("deptradio", "Criminal status:")] <a href='?src=\ref[src];criminal=1'>\[[criminal]\]</a>\n"
			msg += "[SPAN_CLASS("deptradio", "Security records:")] <a href='?src=\ref[src];secrecord=`'>\[View\]</a>\n"

	if(hasHUD(user, HUD_MEDICAL))
		var/perpname = "wot"
		var/medical = "None"

		var/obj/item/card/id/id = GetIdCard()
		if(istype(id))
			perpname = id.registered_name
		else
			if(src.fake_name)
				perpname=src.fake_name
			else
				perpname=src.name

		var/datum/computer_file/report/crew_record/R = get_crewmember_record(perpname)
		if(R)
			medical = R.get_status()

		msg += "[SPAN_CLASS("deptradio", "Physical status:")] <a href='?src=\ref[src];medical=1'>\[[medical]\]</a>\n"
		msg += "[SPAN_CLASS("deptradio", "Medical records:")] <a href='?src=\ref[src];medrecord=`'>\[View\]</a>\n"


	if(print_flavor_text()) msg += "[print_flavor_text()]\n"

	msg += "*---------*<br>"
	msg += applying_pressure

	if (pose)
		if( findtext(pose,".",length(pose)) == 0 && findtext(pose,"!",length(pose)) == 0 && findtext(pose,"?",length(pose)) == 0 )
			pose = addtext(pose,".") //Makes sure all emotes end with a period.
		msg += "[P.He] [pose]\n"

	var/show_descs = show_descriptors_to(user)
	if(show_descs)
		msg += SPAN_NOTICE("[jointext(show_descs, "<br>")]")
	to_chat(user, SPAN_INFO(jointext(msg, null)))

//Helper procedure. Called by /mob/living/carbon/human/examine() and /mob/living/carbon/human/Topic() to determine HUD access to security and medical records.
/proc/hasHUD(mob/M as mob, hudtype)
	if(istype(M, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = M
		var/obj/item/clothing/glasses/G = H.glasses
		var/obj/item/card/id/ID = M.GetIdCard()
		var/obj/item/organ/internal/augment/active/hud/AUG
		var/obj/item/clothing/accessory/glassesmod/hud/ACC
		for (var/obj/item/organ/internal/augment/active/hud/A in H.internal_organs) // Check for installed and active HUD implants
			if (A.hud_type & hudtype)
				AUG = A
				break

		if (G)
			for (var/obj/item/clothing/accessory/glassesmod/hud/C in G.accessories) // Check for HUD accessories on worn eyewear
				if (C.hud_type & hudtype)
					ACC = C
					break

		return ((istype(G) && ((G.hud_type & hudtype) || (G.hud && (G.hud.hud_type & hudtype)))) && G.check_access(ID)) || AUG?.active && AUG.check_access(ID) || ACC?.active
	else if(istype(M, /mob/living/silicon/robot))
		for (var/obj/item/borg/sight/sight as anything in M.GetAllHeld(/obj/item/borg/sight))
			if (sight.hud_type & hudtype)
				return TRUE
	return FALSE

/mob/living/carbon/human/verb/pose()
	set name = "Set Pose"
	set desc = "Sets a description which will be shown when someone examines you."
	set category = "IC"
	var/datum/pronouns/P = choose_from_pronouns()

	if(src.fake_name)
		pose =  sanitize(input(usr, "This is [src.fake_name]. [P.He]...", "Pose", null)  as text)
	else
		pose =  sanitize(input(usr, "This is [src]. [P.He]...", "Pose", null)  as text)

/mob/living/carbon/human/verb/set_flavor()
	set name = "Set Flavour Text"
	set desc = "Sets an extended description of your character's features."
	set category = "IC"

	var/list/HTML = list()
	HTML += "<head><meta charset='utf-8'></head><body>"
	HTML += "<tt><center>"
	HTML += "<b>Update Flavour Text</b> <hr />"
	HTML += "<br></center>"
	HTML += "<a href='byond://?src=\ref[src];flavor_change=general'>General:</a> "
	HTML += TextPreview(flavor_texts["general"])
	HTML += "<br>"
	HTML += "<a href='byond://?src=\ref[src];flavor_change=head'>Head:</a> "
	HTML += TextPreview(flavor_texts["head"])
	HTML += "<br>"
	HTML += "<a href='byond://?src=\ref[src];flavor_change=face'>Face:</a> "
	HTML += TextPreview(flavor_texts["face"])
	HTML += "<br>"
	HTML += "<a href='byond://?src=\ref[src];flavor_change=eyes'>Eyes:</a> "
	HTML += TextPreview(flavor_texts["eyes"])
	HTML += "<br>"
	HTML += "<a href='byond://?src=\ref[src];flavor_change=torso'>Body:</a> "
	HTML += TextPreview(flavor_texts["torso"])
	HTML += "<br>"
	HTML += "<a href='byond://?src=\ref[src];flavor_change=arms'>Arms:</a> "
	HTML += TextPreview(flavor_texts["arms"])
	HTML += "<br>"
	HTML += "<a href='byond://?src=\ref[src];flavor_change=hands'>Hands:</a> "
	HTML += TextPreview(flavor_texts["hands"])
	HTML += "<br>"
	HTML += "<a href='byond://?src=\ref[src];flavor_change=legs'>Legs:</a> "
	HTML += TextPreview(flavor_texts["legs"])
	HTML += "<br>"
	HTML += "<a href='byond://?src=\ref[src];flavor_change=feet'>Feet:</a> "
	HTML += TextPreview(flavor_texts["feet"])
	HTML += "<br>"
	HTML += "<hr />"
	HTML +="<a href='?src=\ref[src];flavor_change=done'>\[Done\]</a>"
	HTML += "<tt>"
	show_browser(src, jointext(HTML,null), "window=flavor_changes;size=430x300")
