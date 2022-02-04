/mob/living/carbon/human
	name = "unknown"
	real_name = "unknown"
	voice_name = "unknown"
	icon = 'icons/mob/human.dmi'
	icon_state = "body_m_s"

	var/list/hud_list[10]
	var/embedded_flag	  //To check if we've need to roll for damage on movement while an item is imbedded in us.
	var/obj/item/rig/wearing_rig // This is very not good, but it's much much better than calling get_rig() every update_canmove() call.
	var/list/stance_limbs
	var/list/grasp_limbs
	var/step_count
	var/dream_timer

/mob/living/carbon/human/New(var/new_loc, var/new_species = null)

	grasp_limbs = list()
	stance_limbs = list()

	if(!dna)
		dna = new /datum/dna(null)
		// Species name is handled by set_species()

	if(!species)
		if(new_species)
			set_species(new_species,1)
		else
			set_species()

	var/decl/cultural_info/culture = SSculture.get_culture(cultural_info[TAG_CULTURE])
	if(culture)
		real_name = culture.get_random_name(gender, species.name)
		name = real_name
		if(mind)
			mind.name = real_name

	hud_list[HEALTH_HUD]      = new /image/hud_overlay('icons/mob/hud_med.dmi', src, "100")
	hud_list[STATUS_HUD]      = new /image/hud_overlay('icons/mob/hud.dmi', src, "hudhealthy")
	hud_list[LIFE_HUD]	      = new /image/hud_overlay('icons/mob/hud.dmi', src, "hudhealthy")
	hud_list[ID_HUD]          = new /image/hud_overlay(GLOB.using_map.id_hud_icons, src, "hudunknown")
	hud_list[WANTED_HUD]      = new /image/hud_overlay('icons/mob/hud.dmi', src, "hudblank")
	hud_list[IMPLOYAL_HUD]    = new /image/hud_overlay('icons/mob/hud.dmi', src, "hudblank")
	hud_list[IMPCHEM_HUD]     = new /image/hud_overlay('icons/mob/hud.dmi', src, "hudblank")
	hud_list[IMPTRACK_HUD]    = new /image/hud_overlay('icons/mob/hud.dmi', src, "hudblank")
	hud_list[SPECIALROLE_HUD] = new /image/hud_overlay('icons/mob/hud.dmi', src, "hudblank")
	hud_list[STATUS_HUD_OOC]  = new /image/hud_overlay('icons/mob/hud.dmi', src, "hudhealthy")

	GLOB.human_mob_list |= src
	..()

	if(dna)
		dna.ready_dna(src)
		dna.real_name = real_name
		dna.s_base = s_base
		sync_organ_dna()
	make_blood()

/mob/living/carbon/human/Destroy()
	if (dream_timer)
		deltimer(dream_timer)
		dream_timer = null
	GLOB.human_mob_list -= src
	worn_underwear = null
	for(var/organ in organs)
		qdel(organ)
	return ..()

/mob/living/carbon/human/get_ingested_reagents()
	if(should_have_organ(BP_STOMACH))
		var/obj/item/organ/internal/stomach/stomach = internal_organs_by_name[BP_STOMACH]
		if(stomach)
			return stomach.ingested
	return touching // Kind of a shitty hack, but makes more sense to me than digesting them.

/mob/living/carbon/human/proc/metabolize_ingested_reagents()
	if(should_have_organ(BP_STOMACH))
		var/obj/item/organ/internal/stomach/stomach = internal_organs_by_name[BP_STOMACH]
		if(stomach)
			stomach.metabolize()

/mob/living/carbon/human/get_fullness()
	if(!should_have_organ(BP_STOMACH))
		return ..()
	var/obj/item/organ/internal/stomach/stomach = internal_organs_by_name[BP_STOMACH]
	if(stomach)
		var/food_volume = 0
		for(var/datum/reagent/nutriment/A in stomach.ingested.reagent_list)
			food_volume += A.volume
		return nutrition + food_volume * 15
	return 0 //Always hungry, but you can't actually eat. :(

/mob/living/carbon/human/Stat()
	. = ..()
	if(statpanel("Status"))
		stat("Intent:", "[a_intent]")
		stat("Move Mode:", "[move_intent.name]")

		if(evacuation_controller)
			var/eta_status = evacuation_controller.get_status_panel_eta()
			if(eta_status)
				stat(null, eta_status)

		if (istype(internal))
			if (!internal.air_contents)
				qdel(internal)
			else
				stat("Internal Atmosphere Info", internal.name)
				stat("Tank Pressure", internal.air_contents.return_pressure())
				stat("Distribution Pressure", internal.distribute_pressure)

		var/obj/item/organ/internal/cell/potato = internal_organs_by_name[BP_CELL]
		if(potato && potato.cell)
			stat("Battery charge:", "[potato.get_charge()]/[potato.cell.maxcharge]")

		if(back && istype(back,/obj/item/rig))
			var/obj/item/rig/suit = back
			var/cell_status = "ERROR"
			if(suit.cell) cell_status = "[suit.cell.charge]/[suit.cell.maxcharge]"
			stat(null, "Suit charge: [cell_status]")

		if(mind)
			if(mind.changeling)
				stat("Chemical Storage", mind.changeling.chem_charges)
				stat("Genetic Damage Time", mind.changeling.geneticdamage)

/mob/living/carbon/human/ex_act(severity)
	if(!blinded)
		flash_eyes()

	var/b_loss = null
	var/f_loss = null
	switch (severity)
		if (1.0)
			b_loss = 400
			f_loss = 100
			var/atom/target = get_edge_target_turf(src, get_dir(src, get_step_away(src, src)))
			throw_at(target, 200, 4)
		if (2.0)
			b_loss = 60
			f_loss = 60

			if (get_sound_volume_multiplier() >= 0.2)
				ear_damage += 30
				ear_deaf += 120
			if (prob(70))
				Paralyse(10)

		if(3.0)
			b_loss = 30
			if (get_sound_volume_multiplier() >= 0.2)
				ear_damage += 15
				ear_deaf += 60
			if (prob(50))
				Paralyse(10)

	// focus most of the blast on one organ
	apply_damage(0.7 * b_loss, BRUTE, null, DAM_EXPLODE, used_weapon = "Explosive blast")
	apply_damage(0.7 * f_loss, BURN, null, DAM_EXPLODE, used_weapon = "Explosive blast")

	// distribute the remaining 30% on all limbs equally (including the one already dealt damage)
	apply_damage(0.3 * b_loss, BRUTE, null, DAM_EXPLODE | DAM_DISPERSED, used_weapon = "Explosive blast")
	apply_damage(0.3 * f_loss, BURN, null, DAM_EXPLODE | DAM_DISPERSED, used_weapon = "Explosive blast")


/mob/living/carbon/human/proc/implant_loyalty(mob/living/carbon/human/M, override = FALSE) // Won't override by default.
	if(!config.use_loyalty_implants && !override) return // Nuh-uh.

	var/obj/item/implant/loyalty/L = new/obj/item/implant/loyalty(M)
	L.imp_in = M
	L.implanted = 1
	var/obj/item/organ/external/affected = M.organs_by_name[BP_HEAD]
	affected.implants += L
	L.part = affected
	L.implanted(src)

/mob/living/carbon/human/proc/is_loyalty_implanted(mob/living/carbon/human/M)
	for(var/L in M.contents)
		if(istype(L, /obj/item/implant/loyalty))
			for(var/obj/item/organ/external/O in M.organs)
				if(L in O.implants)
					return 1
	return 0

/mob/living/carbon/human/restrained()
	if (handcuffed)
		return 1
	if(grab_restrained())
		return 1
	if (istype(wear_suit, /obj/item/clothing/suit/straight_jacket))
		return 1
	return 0

/mob/living/carbon/human/proc/grab_restrained()
	for (var/obj/item/grab/G in grabbed_by)
		if(G.restrains())
			return TRUE

/mob/living/carbon/human/var/co2overloadtime = null
/mob/living/carbon/human/var/temperature_resistance = T0C+75


/mob/living/carbon/human/show_inv(mob/user as mob)
	if(user.incapacitated()  || !user.Adjacent(src) || !user.IsAdvancedToolUser())
		return

	user.set_machine(src)
	var/dat = "<B><HR><FONT size=3>[name]</FONT></B><BR><HR>"

	for(var/entry in species.hud.gear)
		var/list/slot_ref = species.hud.gear[entry]
		if((slot_ref["slot"] in list(slot_l_store, slot_r_store)))
			continue
		var/obj/item/thing_in_slot = get_equipped_item(slot_ref["slot"])
		dat += "<BR><B>[slot_ref["name"]]:</b> <a href='?src=\ref[src];item=[slot_ref["slot"]]'>[istype(thing_in_slot) ? thing_in_slot : "nothing"]</a>"
		if(istype(thing_in_slot, /obj/item/clothing))
			var/obj/item/clothing/C = thing_in_slot
			if(C.accessories.len)
				dat += "<BR><A href='?src=\ref[src];item=tie;holder=\ref[C]'>Remove accessory</A>"
	dat += "<BR><HR>"

	if(species.hud.has_hands)
		dat += "<BR><b>Left hand:</b> <A href='?src=\ref[src];item=[slot_l_hand]'>[istype(l_hand) ? l_hand : "nothing"]</A>"
		dat += "<BR><b>Right hand:</b> <A href='?src=\ref[src];item=[slot_r_hand]'>[istype(r_hand) ? r_hand : "nothing"]</A>"

	// Do they get an option to set internals?
	if(istype(wear_mask, /obj/item/clothing/mask) || istype(head, /obj/item/clothing/head/helmet/space))
		if(istype(back, /obj/item/tank) || istype(belt, /obj/item/tank) || istype(s_store, /obj/item/tank) || istype(l_store, /obj/item/tank) || istype(r_store, /obj/item/tank))
			dat += "<BR><A href='?src=\ref[src];item=internals'>Toggle internals.</A>"

	var/obj/item/clothing/under/suit = w_uniform
	// Other incidentals.
	if(istype(suit))
		dat += "<BR><b>Pockets:</b> <A href='?src=\ref[src];item=pockets'>Empty or Place Item</A>"
		if(suit.has_sensor == 1)
			dat += "<BR><A href='?src=\ref[src];item=sensors'>Set sensors</A>"
		if (suit.has_sensor && user.get_multitool())
			dat += "<BR><A href='?src=\ref[src];item=lock_sensors'>[suit.has_sensor == SUIT_LOCKED_SENSORS ? "Unl" : "L"]ock sensors</A>"
	if(handcuffed)
		dat += "<BR><A href='?src=\ref[src];item=[slot_handcuffed]'>Handcuffed</A>"

	for (var/obj/aura/web/W in auras)
		dat += "<BR><A href='?src=\ref[src];webbed=1'>Webbed</A>"
		break

	for(var/entry in worn_underwear)
		var/obj/item/underwear/UW = entry
		dat += "<BR><a href='?src=\ref[src];item=\ref[UW]'>Remove \the [UW]</a>"

	dat += "<BR><A href='?src=\ref[src];refresh=1'>Refresh</A>"
	dat += "<BR><A href='?src=\ref[user];mach_close=mob[name]'>Close</A>"

	show_browser(user, dat, text("window=mob[name];size=340x540"))
	onclose(user, "mob[name]")
	return

// called when something steps onto a human
// this handles mulebots and vehicles
/mob/living/carbon/human/Crossed(var/atom/movable/AM)
	if(istype(AM, /mob/living/bot/mulebot))
		var/mob/living/bot/mulebot/MB = AM
		MB.runOver(src)

// Get rank from ID, ID inside PDA, PDA, ID in wallet, etc.
/mob/living/carbon/human/proc/get_authentification_rank(var/if_no_id = "No id", var/if_no_job = "No job")
	var/obj/item/card/id/id = GetIdCard()
	if(istype(id))
		return id.rank ? id.rank : if_no_job
	else
		return if_no_id

//gets assignment from ID or ID inside PDA or PDA itself
//Useful when player do something with computers
/mob/living/carbon/human/proc/get_assignment(var/if_no_id = "No id", var/if_no_job = "No job")
	var/obj/item/card/id/id = GetIdCard()
	if(istype(id))
		return id.assignment ? id.assignment : if_no_job
	else
		return if_no_id

//gets name from ID or ID inside PDA or PDA itself
//Useful when player do something with computers
/mob/living/carbon/human/proc/get_authentification_name(var/if_no_id = "Unknown")
	var/obj/item/card/id/id = GetIdCard()
	if(istype(id))
		return id.registered_name
	else
		return if_no_id

//repurposed proc. Now it combines get_id_name() and get_face_name() to determine a mob's name variable. Made into a separate proc as it'll be useful elsewhere
/mob/living/carbon/human/proc/get_visible_name()
	var/face_name = get_face_name()
	var/id_name = get_id_name("")
	if((face_name == "Unknown") && id_name && (id_name != face_name))
		return "[face_name] (as [id_name])"
	return face_name

//Returns "Unknown" if facially disfigured and real_name if not. Useful for setting name when polyacided or when updating a human's name variable
//Also used in AI tracking people by face, so added in checks for head coverings like masks and helmets
/mob/living/carbon/human/proc/get_face_name()
	var/obj/item/organ/external/H = get_organ(BP_HEAD)
	if(!H || fake_name || (H.status & ORGAN_DISFIGURED) || H.is_stump() || !real_name || (MUTATION_HUSK in mutations) || (wear_mask && (wear_mask.flags_inv&HIDEFACE)) || (head && (head.flags_inv&HIDEFACE)))	//Face is unrecognizeable, use ID if able
		if(istype(wear_mask) && wear_mask.visible_name)
			return wear_mask.visible_name
		else if(istype(wearing_rig) && wearing_rig.visible_name)
			return wearing_rig.visible_name
		else if(fake_name)
			return fake_name
		else
			return "Unknown"
	return real_name

//gets name from ID or PDA itself, ID inside PDA doesn't matter
//Useful when player is being seen by other mobs
/mob/living/carbon/human/proc/get_id_name(var/if_no_id = "Unknown")
	. = if_no_id
	var/obj/item/card/id/I = GetIdCard()
	if(istype(I))
		return I.registered_name

//Removed the horrible safety parameter. It was only being used by ninja code anyways.
//Now checks siemens_coefficient of the affected area by default
/mob/living/carbon/human/electrocute_act(var/shock_damage, var/obj/source, var/base_siemens_coeff = 1.0, var/def_zone = null)

	if(status_flags & GODMODE)	return 0	//godmode

	if(species.siemens_coefficient == -1)
		if(stored_shock_by_ref["\ref[src]"])
			stored_shock_by_ref["\ref[src]"] += shock_damage
		else
			stored_shock_by_ref["\ref[src]"] = shock_damage
		return

	if (!def_zone)
		def_zone = pick(BP_L_HAND, BP_R_HAND)

	return ..(shock_damage, source, base_siemens_coeff, def_zone)

/mob/living/carbon/human/apply_shock(var/shock_damage, var/def_zone, var/base_siemens_coeff = 1.0)
	var/obj/item/organ/external/initial_organ = get_organ(check_zone(def_zone))
	if(!initial_organ)
		initial_organ = pick(organs)

	var/obj/item/organ/external/floor_organ

	if(!lying)
		var/list/obj/item/organ/external/standing = list()
		for(var/limb_tag in list(BP_L_FOOT, BP_R_FOOT))
			var/obj/item/organ/external/E = organs_by_name[limb_tag]
			if(E && E.is_usable())
				standing[E.organ_tag] = E
		if((def_zone == BP_L_FOOT || def_zone == BP_L_LEG) && standing[BP_L_FOOT])
			floor_organ = standing[BP_L_FOOT]
		if((def_zone == BP_R_FOOT || def_zone == BP_R_LEG) && standing[BP_R_FOOT])
			floor_organ = standing[BP_R_FOOT]
		else
			floor_organ = DEFAULTPICK(standing, null)
			if (floor_organ)
				floor_organ = standing[floor_organ]

	if(!floor_organ)
		floor_organ = pick(organs)

	var/list/obj/item/organ/external/to_shock = trace_shock(initial_organ, floor_organ)

	if(to_shock && to_shock.len)
		shock_damage /= to_shock.len
		shock_damage = round(shock_damage, 0.1)
	else
		return 0

	var/total_damage = 0

	for(var/obj/item/organ/external/E in to_shock)
		total_damage += ..(shock_damage, E.organ_tag, base_siemens_coeff * get_siemens_coefficient_organ(E))

	if(total_damage > 10)
		local_emp(initial_organ, 3)

	return total_damage

/mob/living/carbon/human/proc/trace_shock(var/obj/item/organ/external/init, var/obj/item/organ/external/floor)
	var/list/obj/item/organ/external/traced_organs = list(floor)

	if(!init)
		return

	if(!floor || init == floor)
		return list(init)

	for(var/obj/item/organ/external/E in list(floor, init))
		while(E && E.parent_organ)
			var/candidate = organs_by_name[E.parent_organ]
			if(!candidate || (candidate in traced_organs))
				break // Organ parenthood is not guaranteed to be a tree
			E = candidate
			traced_organs += E
			if(E == init)
				return traced_organs

	return traced_organs

/mob/living/carbon/human/proc/local_emp(var/list/limbs, var/severity = 2)
	if(!islist(limbs))
		limbs = list(limbs)

	var/list/EMP = list()
	for(var/obj/item/organ/external/limb in limbs)
		EMP += limb
		EMP += limb.internal_organs
		EMP += limb.implants
	for(var/atom/E in EMP)
		E.emp_act(severity)

/mob/living/carbon/human/OnSelfTopic(href_list, topic_status)
	if (href_list["lookitem"])
		var/obj/item/I = locate(href_list["lookitem"])
		if(I)
			src.examinate(I)
			return TOPIC_HANDLED
	return ..()

/mob/living/carbon/human/CanUseTopic(mob/user, datum/topic_state/state, href_list)
	. = ..()
	if(href_list && (href_list["refresh"] || href_list["item"]))
		return min(., ..(user, GLOB.physical_state, href_list))

/mob/living/carbon/human/OnTopic(mob/user, href_list)
	if (href_list["refresh"])
		show_inv(user)
		return TOPIC_HANDLED

	if(href_list["item"])
		if(!handle_strip(href_list["item"],user,locate(href_list["holder"])))
			show_inv(user)
		return TOPIC_HANDLED

	if (href_list["criminal"])
		if(hasHUD(user, HUD_SECURITY))

			var/modified = 0
			var/perpname = "wot"
			if(wear_id)
				var/obj/item/card/id/I = wear_id.GetIdCard()
				if(I)
					perpname = I.registered_name
				else
					perpname = name
			else
				perpname = name

			var/datum/computer_file/report/crew_record/R = get_crewmember_record(perpname)
			if(R)
				var/setcriminal = input(user, "Specify a new criminal status for this person.", "Security HUD", R.get_criminalStatus()) as null|anything in GLOB.security_statuses
				if(hasHUD(usr, HUD_SECURITY) && setcriminal)
					R.set_criminalStatus(setcriminal)
					modified = 1

					spawn()
						SET_BIT(hud_updateflag, WANTED_HUD)
						if(istype(user,/mob/living/carbon/human))
							var/mob/living/carbon/human/U = user
							U.handle_regular_hud_updates()
						if(istype(user,/mob/living/silicon/robot))
							var/mob/living/silicon/robot/U = user
							U.handle_regular_hud_updates()

			if(!modified)
				to_chat(usr, "<span class='warning'>Unable to locate a data core entry for this person.</span>")
			return TOPIC_HANDLED

	if (href_list["secrecord"])
		if(hasHUD(usr, HUD_SECURITY))
			var/perpname = "wot"
			var/read = 0

			var/obj/item/card/id/id = GetIdCard()
			if(istype(id))
				perpname = id.registered_name
			else
				perpname = src.name
			var/datum/computer_file/report/crew_record/E = get_crewmember_record(perpname)
			if(E)
				if(hasHUD(user, HUD_SECURITY))
					to_chat(user, "<b>Name:</b> [E.get_name()]")
					to_chat(user, "<b>Criminal Status:</b> [E.get_criminalStatus()]")
					to_chat(user, "<b>Details:</b> [E.get_secRecord()]")
					read = 1

			if(!read)
				to_chat(user, "<span class='warning'>Unable to locate a data core entry for this person.</span>")
			return TOPIC_HANDLED

	if (href_list["medical"])
		if(hasHUD(user, HUD_MEDICAL))
			var/perpname = "wot"
			var/modified = 0

			var/obj/item/card/id/id = GetIdCard()
			if(istype(id))
				perpname = id.registered_name
			else
				perpname = src.name

			var/datum/computer_file/report/crew_record/E = get_crewmember_record(perpname)
			if(E)
				var/setmedical = input(user, "Specify a new medical status for this person.", "Medical HUD", E.get_status()) as null|anything in GLOB.physical_statuses
				if(hasHUD(user, HUD_MEDICAL) && setmedical)
					E.set_status(setmedical)
					modified = 1

					spawn()
						if(istype(user,/mob/living/carbon/human))
							var/mob/living/carbon/human/U = user
							U.handle_regular_hud_updates()
						if(istype(user,/mob/living/silicon/robot))
							var/mob/living/silicon/robot/U = user
							U.handle_regular_hud_updates()

			if(!modified)
				to_chat(user, "<span class='warning'>Unable to locate a data core entry for this person.</span>")
			return TOPIC_HANDLED

	if (href_list["medrecord"])
		if(hasHUD(user, HUD_MEDICAL))
			var/perpname = "wot"
			var/read = 0

			var/obj/item/card/id/id = GetIdCard()
			if(istype(id))
				perpname = id.registered_name
			else
				perpname = src.name

			var/datum/computer_file/report/crew_record/E = get_crewmember_record(perpname)
			if(E)
				if(hasHUD(user, HUD_MEDICAL))
					to_chat(usr, "<b>Name:</b> [E.get_name()]")
					to_chat(usr, "<b>Gender:</b> [E.get_sex()]")
					to_chat(usr, "<b>Species:</b> [E.get_species()]")
					to_chat(usr, "<b>Blood Type:</b> [E.get_bloodtype()]")
					to_chat(usr, "<b>Details:</b> [E.get_medRecord()]")
					read = 1
			if(!read)
				to_chat(user, "<span class='warning'>Unable to locate a data core entry for this person.</span>")
			return TOPIC_HANDLED

	if (href_list["webbed"])
		for (var/obj/aura/web/W in auras)
			W.remove_webbing(user)
		return TOPIC_HANDLED


	return ..()

/mob/living/carbon/human/update_flavor_text(key)
	var/msg
	switch(key)
		if("done")
			show_browser(src, null, "window=flavor_changes")
			return
		if("general")
			msg = sanitize(input(src,"Update the general description of your character. This will be shown regardless of clothing. Do not include OOC information here.","Flavor Text",html_decode(flavor_texts[key])) as message, extra = 0)
		else
			if(!(key in flavor_texts))
				return
			msg = sanitize(input(src,"Update the flavor text for your [key].","Flavor Text",html_decode(flavor_texts[key])) as message, extra = 0)
	if(!CanInteract(src, GLOB.self_state))
		return
	flavor_texts[key] = msg
	set_flavor()

///eyecheck()
///Returns a number between -1 to 2
/mob/living/carbon/human/eyecheck()
	var/total_protection = flash_protection
	if(species.has_organ[species.vision_organ])
		var/obj/item/organ/internal/eyes/I = internal_organs_by_name[species.vision_organ]
		if(!I?.is_usable())
			return FLASH_PROTECTION_MAJOR
		else
			total_protection = I.get_total_protection(flash_protection)
	else // They can't be flashed if they don't have eyes.
		return FLASH_PROTECTION_MAJOR
	return total_protection

/mob/living/carbon/human/flash_eyes(var/intensity = FLASH_PROTECTION_MODERATE, override_blindness_check = FALSE, affect_silicon = FALSE, visual = FALSE, type = /obj/screen/fullscreen/flash)
	if(species.has_organ[species.vision_organ])
		var/obj/item/organ/internal/eyes/I = internal_organs_by_name[species.vision_organ]
		if(!isnull(I))
			I.additional_flash_effects(intensity)
	return ..()

/mob/living/carbon/human/proc/getFlashMod()
	if(species.vision_organ)
		var/obj/item/organ/internal/eyes/I = internal_organs_by_name[species.vision_organ]
		if(istype(I))
			return I.flash_mod
	return species.flash_mod

/mob/living/carbon/human/proc/getDarkvisionRange()
	if(species.vision_organ)
		var/obj/item/organ/internal/eyes/I = internal_organs_by_name[species.vision_organ]
		if(istype(I))
			return I.darksight_range
	return species.darksight_range

/mob/living/carbon/human/proc/getDarkvisionTint()
	if(species.vision_organ)
		var/obj/item/organ/internal/eyes/I = internal_organs_by_name[species.vision_organ]
		if(istype(I))
			return I.darksight_tint
	return species.darksight_tint

//Used by various things that knock people out by applying blunt trauma to the head.
//Checks that the species has a "head" (brain containing organ) and that hit_zone refers to it.
/mob/living/carbon/human/proc/headcheck(var/target_zone, var/brain_tag = BP_BRAIN)

	var/obj/item/organ/affecting = internal_organs_by_name[brain_tag]

	target_zone = check_zone(target_zone)
	if(!affecting || affecting.parent_organ != target_zone)
		return 0

	//if the parent organ is significantly larger than the brain organ, then hitting it is not guaranteed
	var/obj/item/organ/parent = get_organ(target_zone)
	if(!parent)
		return 0

	if(parent.w_class > affecting.w_class + 1)
		return prob(100 / 2**(parent.w_class - affecting.w_class - 1))

	return 1

/mob/living/carbon/human/IsAdvancedToolUser(var/silent)
	if(species.has_fine_manipulation(src))
		return 1
	if(!silent)
		to_chat(src, "<span class='warning'>You don't have the dexterity to use that!</span>")
	return 0

/mob/living/carbon/human/abiotic(var/full_body = TRUE)
	if(full_body)
		if(src.head || src.shoes || src.w_uniform || src.wear_suit || src.glasses || src.l_ear || src.r_ear || src.gloves)
			return FALSE
	return ..()

/mob/living/carbon/human/proc/check_dna()
	dna.check_integrity(src)
	return

/mob/living/carbon/human/get_species()
	if(!species)
		set_species()
	return species.name

/mob/living/carbon/human/proc/play_xylophone()
	if(!src.xylophone)
		visible_message("<span class='warning'>\The [src] begins playing \his ribcage like a xylophone. It's quite spooky.</span>","<span class='notice'>You begin to play a spooky refrain on your ribcage.</span>","<span class='warning'>You hear a spooky xylophone melody.</span>")
		var/song = pick('sound/effects/xylophone1.ogg','sound/effects/xylophone2.ogg','sound/effects/xylophone3.ogg')
		playsound(loc, song, 50, 1, -1)
		xylophone = 1
		spawn(1200)
			xylophone=0
	return

/mob/living/proc/check_has_mouth()
	// mobs do not have mouths by default
	return 0

/mob/living/carbon/human/check_has_mouth()
	// Todo, check stomach organ when implemented.
	var/obj/item/organ/external/head/H = get_organ(BP_HEAD)
	if(!H || !istype(H) || !H.can_intake_reagents)
		return 0
	return 1

/mob/living/proc/empty_stomach()
	return

/mob/living/carbon/human/empty_stomach()

	Stun(3)

	var/obj/item/organ/internal/stomach/stomach = internal_organs_by_name[BP_STOMACH]
	var/nothing_to_puke = FALSE
	if(should_have_organ(BP_STOMACH))
		if(!istype(stomach) || (stomach.ingested.total_volume <= 5 && stomach.contents.len == 0))
			nothing_to_puke = TRUE
	else if(!(locate(/mob) in contents))
		nothing_to_puke = TRUE

	if(nothing_to_puke)
		custom_emote(1,"dry heaves.")
		return

	if(should_have_organ(BP_STOMACH))
		for(var/a in stomach.contents)
			var/atom/movable/A = a
			A.dropInto(get_turf(src))
			if(species.gluttonous & GLUT_PROJECTILE_VOMIT)
				A.throw_at(get_edge_target_turf(src,dir),7,7,src)
	else
		for(var/mob/M in contents)
			M.dropInto(get_turf(src))
			if(species.gluttonous & GLUT_PROJECTILE_VOMIT)
				M.throw_at(get_edge_target_turf(src,dir),7,7,src)

	// vomit into a toilet
	for(var/obj/structure/hygiene/toilet/T in range(1, src))
		if(T.open)
			visible_message(SPAN_DANGER("\The [src] throws up into the toilet!"),SPAN_DANGER("You throw up into the toilet!"))
			playsound(loc, 'sound/effects/splat.ogg', 50, 1)
			stomach.ingested.remove_any(15)
			return

	// check if you can vomit into a disposal unit
	// see above comment for how vomit reagents are handled
	for(var/obj/machinery/disposal/D in orange(1, src))
		visible_message(SPAN_DANGER("\The [src] throws up into the disposal unit!"),SPAN_DANGER("You throw up into the disposal unit!"))
		playsound(loc, 'sound/effects/splat.ogg', 50, 1)
		if(stomach.ingested.total_volume)
			stomach.ingested.trans_to_holder(D.reagents, 15)
		return

	var/turf/location = loc

	visible_message(SPAN_DANGER("\The [src] throws up!"),SPAN_DANGER("You throw up!"))
	playsound(loc, 'sound/effects/splat.ogg', 50, 1)
	if(istype(location, /turf/simulated))
		var/obj/effect/decal/cleanable/vomit/splat = new /obj/effect/decal/cleanable/vomit(location)
		if(stomach.ingested.total_volume)
			stomach.ingested.trans_to_obj(splat, min(15, stomach.ingested.total_volume))
		handle_additional_vomit_reagents(splat)
		splat.update_icon()

/mob/living/carbon/human/proc/vomit(timevomit = 1, level = 3, delay = 0)

	set waitfor = 0

	if(!check_has_mouth() || isSynthetic() || !timevomit || !level || stat == DEAD || lastpuke)
		return

	timevomit = clamp(timevomit, 1, 10)
	level = clamp(level, 1, 3)

	lastpuke = TRUE
	if(delay)
		sleep(delay)
	to_chat(src, SPAN_WARNING("You feel nauseous..."))
	if(level > 1)
		sleep(150 / timevomit)	//15 seconds until second warning
		to_chat(src, SPAN_WARNING("You feel like you are about to throw up!"))
		if(level > 2)
			sleep(100 / timevomit)	//and you have 10 more for mad dash to the bucket
			empty_stomach()
	sleep(350)	//wait 35 seconds before next volley
	lastpuke = FALSE

/mob/living/carbon/human/proc/morph()
	set name = "Morph"
	set category = "Superpower"

	if(stat!=CONSCIOUS)
		reset_view(0)
		remoteview_target = null
		return

	if(!(mMorph in mutations))
		src.verbs -= /mob/living/carbon/human/proc/morph
		return

	var/new_facial = input("Please select facial hair color.", "Character Generation",rgb(r_facial,g_facial,b_facial)) as color
	if(new_facial)
		r_facial = hex2num(copytext_char(new_facial, 2, 4))
		g_facial = hex2num(copytext_char(new_facial, 4, 6))
		b_facial = hex2num(copytext_char(new_facial, 6, 8))

	var/new_hair = input("Please select hair color.", "Character Generation",rgb(r_hair,g_hair,b_hair)) as color
	if(new_facial)
		r_hair = hex2num(copytext_char(new_hair, 2, 4))
		g_hair = hex2num(copytext_char(new_hair, 4, 6))
		b_hair = hex2num(copytext_char(new_hair, 6, 8))

	var/new_eyes = input("Please select eye color.", "Character Generation",rgb(r_eyes,g_eyes,b_eyes)) as color
	if(new_eyes)
		r_eyes = hex2num(copytext_char(new_eyes, 2, 4))
		g_eyes = hex2num(copytext_char(new_eyes, 4, 6))
		b_eyes = hex2num(copytext_char(new_eyes, 6, 8))
		update_eyes()

	var/new_tone = input("Please select skin tone level: 1-220 (1=albino, 35=caucasian, 150=black, 220='very' black)", "Character Generation", "[35-s_tone]")  as text

	if (!new_tone)
		new_tone = 35
	s_tone = max(min(round(text2num(new_tone)), 220), 1)
	s_tone =  -s_tone + 35

	// hair
	var/list/all_hairs = typesof(/datum/sprite_accessory/hair) - /datum/sprite_accessory/hair
	var/list/hairs = list()

	// loop through potential hairs
	for(var/x in all_hairs)
		var/datum/sprite_accessory/hair/H = new x // create new hair datum based on type x
		hairs.Add(H.name) // add hair name to hairs
		qdel(H) // delete the hair after it's all done

	var/new_style = input("Please select hair style", "Character Generation",h_style)  as null|anything in hairs

	// if new style selected (not cancel)
	if (new_style)
		h_style = new_style

	// facial hair
	var/list/all_fhairs = typesof(/datum/sprite_accessory/facial_hair) - /datum/sprite_accessory/facial_hair
	var/list/fhairs = list()

	for(var/x in all_fhairs)
		var/datum/sprite_accessory/facial_hair/H = new x
		fhairs.Add(H.name)
		qdel(H)

	new_style = input("Please select facial style", "Character Generation",f_style)  as null|anything in fhairs

	if(new_style)
		f_style = new_style

	var/new_gender = alert(usr, "Please select gender.", "Character Generation", "Male", "Female", "Neutral")
	if (new_gender)
		if(new_gender == "Male")
			gender = MALE
		else if(new_gender == "Female")
			gender = FEMALE
		else
			gender = NEUTER
	regenerate_icons()
	check_dna()

	visible_message("<span class='notice'>\The [src] morphs and changes [get_visible_gender() == MALE ? "his" : get_visible_gender() == FEMALE ? "her" : "their"] appearance!</span>", "<span class='notice'>You change your appearance!</span>", "<span class='warning'>Oh, god!  What the hell was that?  It sounded like flesh getting squished and bone ground into a different shape!</span>")

/mob/living/carbon/human/proc/remotesay()
	set name = "Project mind"
	set category = "Superpower"

	if(stat!=CONSCIOUS)
		reset_view(0)
		remoteview_target = null
		return

	if(!(mRemotetalk in src.mutations))
		src.verbs -= /mob/living/carbon/human/proc/remotesay
		return
	var/list/creatures = list()
	for(var/mob/living/carbon/h in world)
		creatures += h
	var/mob/target = input("Who do you want to project your mind to ?") as null|anything in creatures
	if (isnull(target))
		return

	var/say = sanitize(input("What do you wish to say"))
	if(mRemotetalk in target.mutations)
		target.show_message("<span class='notice'>You hear [src.real_name]'s voice: [say]</span>")
	else
		target.show_message("<span class='notice'>You hear a voice that seems to echo around the room: [say]</span>")
	usr.show_message("<span class='notice'>You project your mind into [target.real_name]: [say]</span>")
	log_say("[key_name(usr)] sent a telepathic message to [key_name(target)]: [say]")
	for(var/mob/observer/ghost/G in world)
		G.show_message("<i>Telepathic message from <b>[src]</b> to <b>[target]</b>: [say]</i>")

/mob/living/carbon/human/proc/remoteobserve()
	set name = "Remote View"
	set category = "Superpower"

	if(stat!=CONSCIOUS)
		remoteview_target = null
		reset_view(0)
		return

	if(!(mRemote in src.mutations))
		remoteview_target = null
		reset_view(0)
		src.verbs -= /mob/living/carbon/human/proc/remoteobserve
		return

	if(client.eye != client.mob)
		remoteview_target = null
		reset_view(0)
		return

	var/list/mob/creatures = list()

	for(var/mob/living/carbon/h in world)
		var/turf/temp_turf = get_turf(h)
		if((temp_turf.z != 1 && temp_turf.z != 5) || h.stat!=CONSCIOUS) //Not on mining or the station. Or dead
			continue
		creatures += h

	var/mob/target = input ("Who do you want to project your mind to ?") as mob in creatures

	if (target)
		remoteview_target = target
		reset_view(target)
	else
		remoteview_target = null
		reset_view(0)

/atom/proc/get_visible_gender()
	return gender

/mob/living/carbon/human/get_visible_gender()
	if(wear_suit && wear_suit.flags_inv & HIDEJUMPSUIT && ((head && head.flags_inv & HIDEMASK) || wear_mask))
		return NEUTER
	return ..()

/mob/living/carbon/human/proc/increase_germ_level(n)
	if(gloves)
		gloves.germ_level += n
	else
		germ_level += n

/mob/living/carbon/human/revive()

	if(should_have_organ(BP_HEART))
		vessel.add_reagent(/datum/reagent/blood,species.blood_volume-vessel.total_volume)
		fixblood()

	species.create_organs(src) // Reset our organs/limbs.
	restore_all_organs()       // Reapply robotics/amputated status from preferences.

	if(!client || !key) //Don't boot out anyone already in the mob.
		for (var/obj/item/organ/internal/brain/H in world)
			if(H.brainmob)
				if(H.brainmob.real_name == src.real_name)
					if(H.brainmob.mind)
						H.brainmob.mind.transfer_to(src)
						qdel(H)

	losebreath = 0

	..()

/mob/living/carbon/human/proc/is_lung_ruptured()
	var/obj/item/organ/internal/lungs/L = internal_organs_by_name[BP_LUNGS]
	return L && L.is_bruised()

/mob/living/carbon/human/proc/rupture_lung()
	var/obj/item/organ/internal/lungs/L = internal_organs_by_name[BP_LUNGS]
	if(L)
		L.rupture()

/mob/living/carbon/human/add_blood(mob/living/carbon/human/M as mob)
	if (!..())
		return 0
	//if this blood isn't already in the list, add it
	if(istype(M))
		if(!blood_DNA[M.dna.unique_enzymes])
			blood_DNA[M.dna.unique_enzymes] = M.dna.b_type
	hand_blood_color = blood_color
	src.update_inv_gloves()	//handles bloody hands overlays and updating
	verbs += /mob/living/carbon/human/proc/bloody_doodle
	return 1 //we applied blood to the item

/mob/living/carbon/human/clean_blood(var/clean_feet)
	.=..()
	if(gloves)
		if(gloves.clean_blood())
			update_inv_gloves(1)
		gloves.germ_level = 0
	else
		if(!isnull(bloody_hands))
			bloody_hands = null
			update_inv_gloves(1)
		germ_level = 0

	for(var/obj/item/organ/external/organ in organs)
		if(clean_feet || (organ.organ_tag in list(BP_L_HAND,BP_R_HAND)))
			organ.gunshot_residue = null

	if(clean_feet && !shoes)
		feet_blood_color = null
		feet_blood_DNA = null
		update_inv_shoes(1)
		return 1

/mob/living/carbon/human/get_visible_implants(var/class = 0)

	var/list/visible_implants = list()
	for(var/obj/item/organ/external/organ in src.organs)
		for(var/obj/item/O in organ.implants)
			if(!istype(O,/obj/item/implant) && (O.w_class > class) && !istype(O,/obj/item/material/shard/shrapnel))
				visible_implants += O

	return(visible_implants)

/mob/living/carbon/human/embedded_needs_process()
	for(var/obj/item/organ/external/organ in src.organs)
		for(var/obj/item/O in organ.implants)
			if(!istype(O, /obj/item/implant)) //implant type items do not cause embedding effects, see handle_embedded_objects()
				return 1
	return 0

/mob/living/carbon/human/handle_embedded_and_stomach_objects()

	if(embedded_flag)
		for(var/obj/item/organ/external/organ in organs)
			if(organ.splinted)
				continue
			for(var/obj/item/O in organ.implants)
				if(!istype(O,/obj/item/implant) && O.w_class > 1 && prob(5)) //Moving with things stuck in you could be bad.
					jostle_internal_object(organ, O)

	var/obj/item/organ/internal/stomach/stomach = internal_organs_by_name[BP_STOMACH]
	if(stomach && stomach.contents.len)
		for(var/obj/item/O in stomach.contents)
			if((O.edge || O.sharp) && prob(5))
				var/obj/item/organ/external/parent = get_organ(stomach.parent_organ)
				if(prob(1) && can_feel_pain() && O.can_embed())
					to_chat(src, SPAN_DANGER("You feel something rip out of your [stomach.name]!"))
					O.dropInto(loc)
					if(parent)
						parent.embed(O)
				else
					jostle_internal_object(parent, O)

/mob/living/carbon/human/proc/jostle_internal_object(var/obj/item/organ/external/organ, var/obj/item/O)
	// All kinds of embedded objects cause bleeding.
	if(!organ.can_feel_pain())
		to_chat(src, SPAN_DANGER("You feel [O] moving inside your [organ.name]."))
	else
		var/msg = pick( \
			SPAN_DANGER("A spike of pain jolts your [organ.name] as you bump [O] inside."), \
			SPAN_DANGER("Your movement jostles [O] in your [organ.name] painfully."),       \
			SPAN_DANGER("Your movement jostles [O] in your [organ.name] painfully."))
		custom_pain(msg,40,affecting = organ)
	organ.take_external_damage(rand(1,3) + O.w_class, DAM_EDGE, 0)

/mob/living/carbon/human/proc/remove_splints()
	set category = "Object"
	set name = "Remove Splints"
	set desc = "Carefully remove splints from someone's limbs."
	set src in view(1)
	var/mob/living/user = usr
	var/removed_splint = 0

	if(usr.stat || usr.restrained() || !isliving(usr)) return

	for(var/obj/item/organ/external/o in organs)
		if (o && o.splinted)
			var/obj/item/S = o.splinted
			if(!istype(S) || S.loc != o) //can only remove splints that are actually worn on the organ (deals with hardsuit splints)
				to_chat(user, "<span class='warning'>You cannot remove any splints on [src]'s [o.name] - [o.splinted] is supporting some of the breaks.</span>")
			else
				S.add_fingerprint(user)
				if(o.remove_splint())
					user.put_in_active_hand(S)
					removed_splint = 1
	if(removed_splint)
		user.visible_message("<span class='danger'>\The [user] removes \the [src]'s splints!</span>")
	else
		to_chat(user, "<span class='warning'>\The [src] has no splints that can be removed.</span>")
	verbs -= /mob/living/carbon/human/proc/remove_splints


/mob/living/carbon/human/verb/check_pulse()
	set category = "Object"
	set name = "Check pulse"
	set desc = "Approximately count somebody's pulse. Requires you to stand still at least 6 seconds."
	set src in view(1)
	var/self = 0

	if(usr.stat || usr.restrained() || !isliving(usr)) return

	if(usr == src)
		self = 1
	if(!self)
		usr.visible_message("<span class='notice'>[usr] kneels down, puts \his hand on [src]'s wrist and begins counting their pulse.</span>",\
		"You begin counting [src]'s pulse")
	else
		usr.visible_message("<span class='notice'>[usr] begins counting their pulse.</span>",\
		"You begin counting your pulse.")

	if (!pulse() || status_flags & FAKEDEATH)
		to_chat(usr, "<span class='danger'>[src] has no pulse!</span>")
		return
	else
		to_chat(usr, "<span class='notice'>[self ? "You have a" : "[src] has a"] pulse! Counting...</span>")

	to_chat(usr, "You must[self ? "" : " both"] remain still until counting is finished.")
	if(do_after(usr, 6 SECONDS, src))
		var/message = "<span class='notice'>[self ? "Your" : "[src]'s"] pulse is [src.get_pulse(GETPULSE_HAND)].</span>"
		to_chat(usr, message)
	else
		to_chat(usr, "<span class='warning'>You failed to check the pulse. Try again.</span>")

/mob/living/carbon/human/verb/lookup()
	set name = "Look up"
	set desc = "If you want to know what's above."
	set category = "IC"


	if(client && !is_physically_disabled())
		if(z_eye)
			reset_view(null)
			QDEL_NULL(z_eye)
			return
		var/turf/above = GetAbove(src)
		if(TURF_IS_MIMICING(above))
			z_eye = new /atom/movable/z_observer/z_up(src, src)
			to_chat(src, "<span class='notice'>You look up.</span>")
			reset_view(z_eye)
			return
		to_chat(src, "<span class='notice'>You can see \the [above ? above : "ceiling"].</span>")
	else
		to_chat(src, "<span class='notice'>You can't look up right now.</span>")

/mob/living/verb/lookdown()
	set name = "Look Down"
	set desc = "If you want to know what's below."
	set category = "IC"

	if(client && !is_physically_disabled())
		if(z_eye)
			reset_view(null)
			QDEL_NULL(z_eye)
			return
		var/turf/T = get_turf(src)
		if(TURF_IS_MIMICING(T) && HasBelow(T.z))
			z_eye = new /atom/movable/z_observer/z_down(src, src)
			to_chat(src, "<span class='notice'>You look down.</span>")
			reset_view(z_eye)
			return
		to_chat(src, "<span class='notice'>You can see \the [T ? T : "floor"].</span>")
	else
		to_chat(src, "<span class='notice'>You can't look below right now.</span>")

/mob/living/carbon/human/proc/set_species(var/new_species, var/default_colour = 1)
	if(!dna)
		if(!new_species)
			new_species = SPECIES_HUMAN
	else
		if(!new_species)
			new_species = dna.species

	// No more invisible screaming wheelchairs because of set_species() typos.
	if(!all_species[new_species])
		new_species = SPECIES_HUMAN
	if(dna)
		dna.species = new_species

	if(species)

		if(species.name && species.name == new_species)
			return

		// Clear out their species abilities.
		species.remove_base_auras(src)
		species.remove_inherent_verbs(src)
		holder_type = null

	species = all_species[new_species]
	species.handle_pre_spawn(src)

	if(species.grab_type)
		current_grab_type = all_grabobjects[species.grab_type]

	if(species.base_color && default_colour)
		//Apply colour.
		r_skin = hex2num(copytext_char(species.base_color,2,4))
		g_skin = hex2num(copytext_char(species.base_color,4,6))
		b_skin = hex2num(copytext_char(species.base_color,6,8))
	else
		r_skin = 0
		g_skin = 0
		b_skin = 0

	if(species.holder_type)
		holder_type = species.holder_type


	if(!(gender in species.genders))
		gender = species.genders[1]

	icon_state = lowertext(species.name)

	species.create_organs(src)
	species.handle_post_spawn(src)

	maxHealth = species.total_health
	remove_extension(src, /datum/extension/armor)
	if(species.natural_armour_values)
		set_extension(src, /datum/extension/armor, species.natural_armour_values)

	default_pixel_x = initial(pixel_x) + species.pixel_offset_x
	default_pixel_y = initial(pixel_y) + species.pixel_offset_y
	default_pixel_z = initial(pixel_z) + species.pixel_offset_z
	pixel_x = default_pixel_x
	pixel_y = default_pixel_y
	pixel_z = default_pixel_z

	if(LAZYLEN(descriptors))
		descriptors = null

	if(LAZYLEN(species.descriptors))
		descriptors = list()
		for(var/desctype in species.descriptors)
			var/datum/mob_descriptor/descriptor = species.descriptors[desctype]
			descriptors[desctype] = descriptor.default_value

	if(!(species.appearance_flags & HAS_UNDERWEAR))
		QDEL_NULL_LIST(worn_underwear)

	available_maneuvers = species.maneuvers.Copy()

	meat_type =     species.meat_type
	meat_amount =   species.meat_amount
	skin_material = species.skin_material
	skin_amount =   species.skin_amount
	bone_material = species.bone_material
	bone_amount =   species.bone_amount

	spawn(0)
		regenerate_icons()
		if(vessel.total_volume < species.blood_volume)
			vessel.maximum_volume = species.blood_volume
			vessel.add_reagent(/datum/reagent/blood, species.blood_volume - vessel.total_volume)
		else if(vessel.total_volume > species.blood_volume)
			vessel.remove_reagent(/datum/reagent/blood, vessel.total_volume - species.blood_volume)
			vessel.maximum_volume = species.blood_volume
		fixblood()

	// Rebuild the HUD and visual elements.
	if(client)
		Login()

	full_prosthetic = null

	var/update_lang
	for(var/token in ALL_CULTURAL_TAGS)
		if(species.force_cultural_info && species.force_cultural_info[token])
			update_lang = TRUE
			set_cultural_value(token, species.force_cultural_info[token], defer_language_update = TRUE)
		else if(!cultural_info[token] || !(cultural_info[token] in species.available_cultural_info[token]))
			update_lang = TRUE
			set_cultural_value(token, species.default_cultural_info[token], defer_language_update = TRUE)

	default_walk_intent = null
	default_run_intent = null
	move_intent = null
	move_intents = species.move_intents.Copy()
	set_move_intent(decls_repository.get_decl(move_intents[1]))
	if(!istype(move_intent))
		set_next_usable_move_intent()

	if(update_lang)
		languages.Cut()
		default_language = null
		update_languages()

	//recheck species-restricted clothing
	for(var/slot in slot_first to slot_last)
		var/obj/item/clothing/C = get_equipped_item(slot)
		if(istype(C) && !C.mob_can_equip(src, slot, 1))
			unEquip(C)

	return 1

/mob/living/carbon/human/proc/update_languages()

	var/list/permitted_languages = list()
	var/list/free_languages =      list()
	var/list/default_languages =   list()

	for(var/thing in cultural_info)
		var/decl/cultural_info/check = cultural_info[thing]
		if(istype(check))
			if(check.default_language)
				free_languages    |= all_languages[check.default_language]
				default_languages |= all_languages[check.default_language]
			if(check.language)
				free_languages    |= all_languages[check.language]
			if(check.name_language)
				free_languages    |= all_languages[check.name_language]
			for(var/lang in check.additional_langs)
				free_languages    |= all_languages[lang]
			for(var/lang in check.get_spoken_languages())
				permitted_languages |= all_languages[lang]

	for(var/thing in languages)
		var/datum/language/lang = thing
		if(lang in permitted_languages)
			continue
		if(!(lang.flags & RESTRICTED) && (lang.flags & WHITELISTED) && is_alien_whitelisted(src, lang))
			continue
		if(lang == default_language)
			default_language = null
		remove_language(lang.name)

	for(var/thing in free_languages)
		var/datum/language/lang = thing
		add_language(lang.name)

	if(LAZYLEN(default_languages) && isnull(default_language))
		default_language = default_languages[1]

/mob/living/carbon/human/proc/bloody_doodle()
	set category = "IC"
	set name = "Write in blood"
	set desc = "Use blood on your hands to write a short message on the floor or a wall, murder mystery style."

	if (src.stat)
		return

	if (usr != src)
		return 0 //something is terribly wrong

	if (!bloody_hands)
		verbs -= /mob/living/carbon/human/proc/bloody_doodle

	if (src.gloves)
		to_chat(src, "<span class='warning'>Your [src.gloves] are getting in the way.</span>")
		return

	var/turf/simulated/T = src.loc
	if (!istype(T)) //to prevent doodling out of mechs and lockers
		to_chat(src, "<span class='warning'>You cannot reach the floor.</span>")
		return

	var/direction = input(src,"Which way?","Tile selection") as anything in list("Here","North","South","East","West")
	if (direction != "Here")
		T = get_step(T,text2dir(direction))
	if (!istype(T))
		to_chat(src, "<span class='warning'>You cannot doodle there.</span>")
		return

	var/num_doodles = 0
	for (var/obj/effect/decal/cleanable/blood/writing/W in T)
		num_doodles++
	if (num_doodles > 4)
		to_chat(src, "<span class='warning'>There is no space to write on!</span>")
		return

	var/max_length = bloody_hands * 30 //tweeter style

	var/message = sanitize(input("Write a message. It cannot be longer than [max_length] characters.","Blood writing", ""))

	if (message)
		var/used_blood_amount = round(length(message) / 30, 1)
		bloody_hands = max(0, bloody_hands - used_blood_amount) //use up some blood

		if (length(message) > max_length)
			message += "-"
			to_chat(src, "<span class='warning'>You ran out of blood to write with!</span>")
		var/obj/effect/decal/cleanable/blood/writing/W = new(T)
		W.basecolor = (hand_blood_color) ? hand_blood_color : COLOR_BLOOD_HUMAN
		W.update_icon()
		W.message = message
		W.add_fingerprint(src)

/mob/living/carbon/human/can_inject(var/mob/user, var/target_zone)
	var/obj/item/organ/external/affecting = get_organ(target_zone)

	if(!affecting)
		to_chat(user, SPAN_WARNING("\The [src] is missing that limb."))
		return 0

	if(BP_IS_ROBOTIC(affecting))
		to_chat(user, SPAN_WARNING("You cannot inject a robotic limb."))
		return 0

	. = CAN_INJECT
	for(var/obj/item/clothing/C in list(head, wear_mask, wear_suit, w_uniform, gloves, shoes))
		if(C && (C.body_parts_covered & affecting.body_part) && (C.item_flags & ITEM_FLAG_THICKMATERIAL))
			if(istype(C, /obj/item/clothing/suit/space))
				. = INJECTION_PORT //it was going to block us, but it's a space suit so it doesn't because it has some kind of port
			else
				to_chat(user, "<span class='warning'>There is no exposed flesh or thin material on [src]'s [affecting.name] to inject into.</span>")
				return 0


/mob/living/carbon/human/print_flavor_text(var/shrink = 1)
	var/list/equipment = list(src.head,src.wear_mask,src.glasses,src.w_uniform,src.wear_suit,src.gloves,src.shoes)
	var/head_exposed = 1
	var/face_exposed = 1
	var/eyes_exposed = 1
	var/torso_exposed = 1
	var/arms_exposed = 1
	var/legs_exposed = 1
	var/hands_exposed = 1
	var/feet_exposed = 1

	for(var/obj/item/clothing/C in equipment)
		if(C.body_parts_covered & HEAD)
			head_exposed = 0
		if(C.body_parts_covered & FACE)
			face_exposed = 0
		if(C.body_parts_covered & EYES)
			eyes_exposed = 0
		if(C.body_parts_covered & UPPER_TORSO)
			torso_exposed = 0
		if(C.body_parts_covered & ARMS)
			arms_exposed = 0
		if(C.body_parts_covered & HANDS)
			hands_exposed = 0
		if(C.body_parts_covered & LEGS)
			legs_exposed = 0
		if(C.body_parts_covered & FEET)
			feet_exposed = 0

	flavor_text = ""
	for (var/T in flavor_texts)
		if(flavor_texts[T] && flavor_texts[T] != "")
			if((T == "general") || (T == "head" && head_exposed) || (T == "face" && face_exposed) || (T == "eyes" && eyes_exposed) || (T == "torso" && torso_exposed) || (T == "arms" && arms_exposed) || (T == "hands" && hands_exposed) || (T == "legs" && legs_exposed) || (T == "feet" && feet_exposed))
				flavor_text += flavor_texts[T]
				flavor_text += "\n\n"
	if(!shrink)
		return flavor_text
	else
		return ..()

/mob/living/carbon/human/getDNA()
	if(species.species_flags & SPECIES_FLAG_NO_SCAN)
		return null
	if(isSynthetic())
		return
	..()

/mob/living/carbon/human/setDNA()
	if(species.species_flags & SPECIES_FLAG_NO_SCAN)
		return
	if(isSynthetic())
		return
	..()

/mob/living/carbon/human/has_brain()
	if(internal_organs_by_name[BP_BRAIN])
		var/obj/item/organ/internal/brain = internal_organs_by_name[BP_BRAIN]
		if(brain && istype(brain))
			return 1
	return 0

/mob/living/carbon/human/has_eyes()
	if(internal_organs_by_name[BP_EYES])
		var/obj/item/organ/internal/eyes = internal_organs_by_name[BP_EYES]
		if(eyes && eyes.is_usable())
			return 1
	return 0

/mob/living/carbon/human/slip(var/slipped_on, stun_duration=8)
	if((species.check_no_slip(src)) || (shoes && (shoes.item_flags & ITEM_FLAG_NOSLIP)))
		return 0
	return !!(..(slipped_on,stun_duration))

/mob/living/carbon/human/proc/undislocate()
	set category = "Object"
	set name = "Undislocate Joint"
	set desc = "Pop a joint back into place. Extremely painful."
	set src in view(1)

	if(!isliving(usr) || !usr.canClick())
		return

	usr.setClickCooldown(20)

	if(usr.stat > 0)
		to_chat(usr, "You are unconcious and cannot do that!")
		return

	if(usr.restrained())
		to_chat(usr, "You are restrained and cannot do that!")
		return

	var/mob/S = src
	var/mob/U = usr
	var/self = null
	if(S == U)
		self = 1 // Removing object from yourself.

	var/list/limbs = list()
	for(var/limb in organs_by_name)
		var/obj/item/organ/external/current_limb = organs_by_name[limb]
		if(current_limb && current_limb.dislocated > 0 && !current_limb.is_parent_dislocated()) //if the parent is also dislocated you will have to relocate that first
			limbs |= current_limb
	var/obj/item/organ/external/current_limb = input(usr,"Which joint do you wish to relocate?") as null|anything in limbs

	if(!current_limb)
		return

	if(self)
		to_chat(src, "<span class='warning'>You brace yourself to relocate your [current_limb.joint]...</span>")
	else
		to_chat(U, "<span class='warning'>You begin to relocate [S]'s [current_limb.joint]...</span>")
	if(!do_after(U, 30, src))
		return
	if(!current_limb || !S || !U)
		return

	var/fail_prob = U.skill_fail_chance(SKILL_MEDICAL, 60, SKILL_ADEPT, 3)
	if(self)
		fail_prob += U.skill_fail_chance(SKILL_MEDICAL, 20, SKILL_EXPERT, 1)
	var/datum/gender/T = gender_datums[get_gender()]
	if(prob(fail_prob))
		visible_message( \
		"<span class='danger'>[U] pops [self ? "[T.his]" : "[S]'s"] [current_limb.joint] in the WRONG place!</span>", \
		"<span class='danger'>[self ? "You pop" : "[U] pops"] your [current_limb.joint] in the WRONG place!</span>" \
		)
		current_limb.add_pain(30)
		current_limb.take_external_damage(5)
		shock_stage += 20
	else
		visible_message( \
		"<span class='danger'>[U] pops [self ? "[T.his]" : "[S]'s"] [current_limb.joint] back in!</span>", \
		"<span class='danger'>[self ? "You pop" : "[U] pops"] your [current_limb.joint] back in!</span>" \
		)
		current_limb.undislocate()

/mob/living/carbon/human/reset_view(atom/A, update_hud = 1)
	..()
	if(update_hud)
		handle_regular_hud_updates()


/mob/living/carbon/human/can_stand_overridden()
	if(wearing_rig && wearing_rig.ai_can_move_suit(check_for_ai = 1))
		// Actually missing a leg will screw you up. Everything else can be compensated for.
		for(var/limbcheck in list(BP_L_LEG,BP_R_LEG))
			var/obj/item/organ/affecting = get_organ(limbcheck)
			if(!affecting)
				return 0
		return 1
	return 0

/mob/living/carbon/human/verb/pull_punches()
	set name = "Switch Stance"
	set desc = "Try not to hurt them."
	set category = "IC"
	species.toggle_stance(src)

// Similar to get_pulse, but returns only integer numbers instead of text.
/mob/living/carbon/human/proc/get_pulse_as_number()
	var/obj/item/organ/internal/heart/heart_organ = internal_organs_by_name[BP_HEART]
	if(!heart_organ)
		return 0

	switch(pulse())
		if(PULSE_NONE)
			return 0
		if(PULSE_SLOW)
			return rand(40, 60)
		if(PULSE_NORM)
			return rand(60, 90)
		if(PULSE_FAST)
			return rand(90, 120)
		if(PULSE_2FAST)
			return rand(120, 160)
		if(PULSE_THREADY)
			return PULSE_MAX_BPM
	return 0

//generates realistic-ish pulse output based on preset levels as text
/mob/living/carbon/human/proc/get_pulse(var/method)	//method 0 is for hands, 1 is for machines, more accurate
	var/obj/item/organ/internal/heart/heart_organ = internal_organs_by_name[BP_HEART]
	if(!heart_organ)
		// No heart, no pulse
		return "0"
	if(heart_organ.open && !method)
		// Heart is a open type (?) and cannot be checked unless it's a machine
		return "muddled and unclear; you can't seem to find a vein"

	var/bpm = get_pulse_as_number()
	if(bpm >= PULSE_MAX_BPM)
		return method ? ">[PULSE_MAX_BPM]" : "extremely weak and fast, patient's artery feels like a thread"

	return "[method ? bpm : bpm + rand(-10, 10)]"
// output for machines ^	 ^ ^ ^ ^ ^ ^ ^ ^ ^ ^ output for people

/mob/living/carbon/human/proc/pulse()
	if (stat == DEAD)
		return PULSE_NONE
	var/obj/item/organ/internal/heart/H = internal_organs_by_name[BP_HEART]
	return H ? H.pulse : PULSE_NONE

/mob/living/carbon/human/can_devour(atom/movable/victim, var/silent = FALSE)

	if(!should_have_organ(BP_STOMACH))
		return ..()

	var/obj/item/organ/internal/stomach/stomach = internal_organs_by_name[BP_STOMACH]
	if(!stomach || !stomach.is_usable())
		if(!silent)
			to_chat(src, SPAN_WARNING("Your stomach is not functional!"))
		return FALSE

	if(!stomach.can_eat_atom(victim))
		if(!silent)
			to_chat(src, SPAN_WARNING("You are not capable of devouring \the [victim] whole!"))
		return FALSE

	if(stomach.is_full(victim))
		if(!silent)
			to_chat(src, SPAN_WARNING("Your [stomach.name] is full!"))
		return FALSE

	. = stomach.get_devour_time(victim) || ..()

/mob/living/carbon/human/move_to_stomach(atom/movable/victim)
	var/obj/item/organ/internal/stomach/stomach = internal_organs_by_name[BP_STOMACH]
	if(istype(stomach))
		victim.forceMove(stomach)

/mob/living/carbon/human/should_have_organ(var/organ_check)

	var/obj/item/organ/external/affecting
	if(organ_check in list(BP_HEART, BP_LUNGS))
		affecting = organs_by_name[BP_CHEST]
	else if(organ_check in list(BP_LIVER, BP_KIDNEYS))
		affecting = organs_by_name[BP_GROIN]

	if(affecting && BP_IS_ROBOTIC(affecting))
		return 0
	return (species && species.has_organ[organ_check])

/mob/living/carbon/human/can_feel_pain(var/obj/item/organ/check_organ)
	if(isSynthetic())
		return 0
	if(check_organ)
		if(!istype(check_organ))
			return 0
		return check_organ.can_feel_pain()
	return !(species.species_flags & SPECIES_FLAG_NO_PAIN)

/mob/living/carbon/human/get_breath_volume()
	. = ..()
	var/obj/item/organ/internal/heart/H = internal_organs_by_name[BP_HEART]
	if(H && !H.open)
		. *= (!BP_IS_ROBOTIC(H)) ? pulse()/PULSE_NORM : 1.5

/mob/living/carbon/human/need_breathe()
	if(!(mNobreath in mutations) && species.breathing_organ && should_have_organ(species.breathing_organ))
		return 1
	else
		return 0

/mob/living/carbon/human/get_adjusted_metabolism(metabolism)
	return ..() * (species ? species.metabolism_mod : 1)

/mob/living/carbon/human/is_invisible_to(var/mob/viewer)
	return (is_cloaked() || ..())

/mob/living/carbon/human/help_shake_act(mob/living/carbon/M)
	if(src != M)
		..()
	else
		var/datum/gender/T = gender_datums[get_gender()]
		visible_message( \
			"<span class='notice'>[src] examines [T.self].</span>", \
			"<span class='notice'>You check yourself for injuries.</span>" \
			)

		for(var/obj/item/organ/external/org in organs)
			var/list/status = list()

			var/feels = 1 + round(org.pain/100, 0.1)
			var/brutedamage = org.brute_dam * feels
			var/burndamage = org.burn_dam * feels

			switch(brutedamage)
				if(1 to 20)
					status += "slightly sore"
				if(20 to 40)
					status += "very sore"
				if(40 to INFINITY)
					status += "throbbing with agony"

			switch(burndamage)
				if(1 to 10)
					status += "tingling"
				if(10 to 40)
					status += "stinging"
				if(40 to INFINITY)
					status += "burning fiercely"

			if(org.is_stump())
				status += "MISSING"
			if(org.status & ORGAN_MUTATED)
				status += "misshapen"
			if(org.dislocated >= 1)
				status += "dislocated"
			if(org.status & ORGAN_BROKEN)
				status += "hurts when touched"
			if(org.status & ORGAN_DEAD)
				status += "is grey and necrotic"
			if(!org.is_usable() || org.is_dislocated())
				status += "dangling uselessly"
			if(status.len)
				src.show_message("My [org.name] is <span class='warning'>[english_list(status)].</span>",1)
			else
				src.show_message("My [org.name] is <span class='notice'>OK.</span>",1)

		if((MUTATION_SKELETON in mutations) && (!w_uniform) && (!wear_suit))
			play_xylophone()

/mob/living/carbon/human/proc/resuscitate()
	if(!is_asystole() || !should_have_organ(BP_HEART))
		return
	var/obj/item/organ/internal/heart/heart = internal_organs_by_name[BP_HEART]
	if(istype(heart) && !(heart.status & ORGAN_DEAD))
		var/species_organ = species.breathing_organ
		var/active_breaths = 0
		if(species_organ)
			var/obj/item/organ/internal/lungs/L = internal_organs_by_name[species_organ]
			if(L)
				active_breaths = L.active_breathing
		if(!nervous_system_failure() && active_breaths)
			visible_message("\The [src] jerks and gasps for breath!")
		else
			visible_message("\The [src] twitches a bit as \his heart restarts!")
		shock_stage = min(shock_stage, 100) // 120 is the point at which the heart stops.
		if(getOxyLoss() >= 75)
			setOxyLoss(75)
		heart.pulse = PULSE_NORM
		heart.handle_pulse()
		return TRUE

/mob/living/carbon/human/proc/make_reagent(amount, reagent_type)
	if(stat == CONSCIOUS)
		var/limit = max(0, reagents.get_overdose(reagent_type) - reagents.get_reagent_amount(reagent_type))
		reagents.add_reagent(reagent_type, min(amount, limit))

//Get fluffy numbers
/mob/living/carbon/human/proc/get_blood_pressure()
	if(status_flags & FAKEDEATH)
		return "[Floor(120+rand(-5,5))*0.25]/[Floor(80+rand(-5,5)*0.25)]"
	var/blood_result = get_blood_circulation()
	return "[Floor((120+rand(-5,5))*(blood_result/100))]/[Floor((80+rand(-5,5))*(blood_result/100))]"

//Point at which you dun breathe no more. Separate from asystole crit, which is heart-related.
/mob/living/carbon/human/nervous_system_failure()
	return getBrainLoss() >= maxHealth * 0.75

/mob/living/carbon/human/melee_accuracy_mods()
	. = ..()
	if(get_shock() > 50)
		. += 15
	if(shock_stage > 10)
		. += 15
	if(shock_stage > 30)
		. += 15

/mob/living/carbon/human/ranged_accuracy_mods()
	. = ..()
	if(get_shock() > 10 && !skill_check(SKILL_WEAPONS, SKILL_ADEPT))
		. -= 1
	if(get_shock() > 50)
		. -= 1
	if(shock_stage > 10)
		. -= 1
	if(shock_stage > 30)
		. -= 1
	if(skill_check(SKILL_WEAPONS, SKILL_ADEPT))
		. += 1
	if(skill_check(SKILL_WEAPONS, SKILL_EXPERT))
		. += 1
	if(skill_check(SKILL_WEAPONS, SKILL_PROF))
		. += 2

/mob/living/carbon/human/can_drown()
	if(!internal && (!istype(wear_mask) || !wear_mask.filters_water()))
		var/obj/item/organ/internal/lungs/L = locate() in internal_organs
		return (!L || L.can_drown())
	return FALSE

/mob/living/carbon/human/get_breath_from_environment(var/volume_needed = STD_BREATH_VOLUME, var/atom/location = src.loc)
	var/turf/T = get_turf(src)
	var/datum/gas_mixture/breath = ..(volume_needed, location)
	if(istype(T) && T == location && T.is_flooded(lying) && should_have_organ(BP_LUNGS))
		//Maybe we could feasibly surface
		if(!lying && T.above && !T.above.is_flooded() && T.above.CanZPass(src, UP) && can_overcome_gravity())
			return ..(volume_needed, T.above)
		var/can_breathe_water = (istype(wear_mask) && wear_mask.filters_water()) ? TRUE : FALSE
		if(!can_breathe_water)
			var/obj/item/organ/internal/lungs/lungs = internal_organs_by_name[BP_LUNGS]
			if(lungs && lungs.can_drown())
				can_breathe_water = TRUE
		if(can_breathe_water)
			if(!breath)
				breath = new
				breath.volume = volume_needed
				breath.temperature = T.temperature
			breath.adjust_gas(GAS_OXYGEN, ONE_ATMOSPHERE*volume_needed/(R_IDEAL_GAS_EQUATION*T20C))
			T.show_bubbles()
	return breath

/mob/living/carbon/human/water_act(var/depth)
	species.water_act(src, depth)
	..(depth)

/mob/living/carbon/human/proc/set_cultural_value(var/token, var/decl/cultural_info/_culture, var/defer_language_update)
	if(!istype(_culture))
		_culture = SSculture.get_culture(_culture)
	if(istype(_culture))
		cultural_info[token] = _culture
		if(!defer_language_update)
			update_languages()

/mob/living/carbon/human/proc/get_cultural_value(var/token)
	return cultural_info[token]

/mob/living/carbon/human/needs_wheelchair()
	var/stance_damage = 0
	for(var/limb_tag in list(BP_L_LEG, BP_R_LEG, BP_L_FOOT, BP_R_FOOT))
		var/obj/item/organ/external/E = organs_by_name[limb_tag]
		if(!E || !E.is_usable())
			stance_damage += 2
	return stance_damage >= 4

/mob/living/carbon/human/get_digestion_product()
	return species.get_digestion_product(src)

// A damaged stomach can put blood in your vomit.
/mob/living/carbon/human/handle_additional_vomit_reagents(var/obj/effect/decal/cleanable/vomit/vomit)
	..()
	if(should_have_organ(BP_STOMACH))
		var/obj/item/organ/internal/stomach/stomach = internal_organs_by_name[BP_STOMACH]
		if(!stomach || stomach.is_broken() || (stomach.is_bruised() && prob(stomach.damage)))
			if(should_have_organ(BP_HEART))
				vessel.trans_to_obj(vomit, 5)
			else
				reagents.trans_to_obj(vomit, 5)

/mob/living/carbon/human/get_footstep(var/footstep_type)
	. = species.get_footstep(src, footstep_type) || ..()

/mob/living/carbon/human/get_sound_volume_multiplier()
	. = ..()
	for(var/obj/item/clothing/ears/C in list(l_ear, r_ear))
		. = min(., C.volume_multiplier)

/mob/living/carbon/human/handle_pull_damage(mob/living/puller)
	. = ..()
	if(.)
		drip(1)

/mob/living/carbon/human/get_bullet_impact_effect_type(var/def_zone)
	var/obj/item/organ/external/E = get_organ(def_zone)
	if(!E || E.is_stump())
		return BULLET_IMPACT_NONE
	if(BP_IS_ROBOTIC(E))
		return BULLET_IMPACT_METAL
	return BULLET_IMPACT_MEAT

/mob/living/carbon/human/bullet_impact_visuals(var/obj/item/projectile/P, var/def_zone, var/damage)
	..()
	switch(get_bullet_impact_effect_type(def_zone))
		if(BULLET_IMPACT_MEAT)
			if(damage && P.damtype == BRUTE)
				var/hit_dir = get_dir(P.starting, src)
				var/obj/effect/decal/cleanable/blood/B = blood_splatter(get_step(src, hit_dir), src, 1, hit_dir)
				B.icon_state = pick("dir_splatter_1","dir_splatter_2")
				var/scale = min(1, round(P.damage / 50, 0.2))
				var/matrix/M = new()
				B.transform = M.Scale(scale)

				new /obj/effect/temp_visual/bloodsplatter(loc, hit_dir, species.blood_color)

/mob/living/carbon/human/proc/dream()
	dream_timer = null
	if (!sleeping)
		return
	if (prob(85))
		return
	for (var/count = 1 to rand(1, 2))
		to_chat(src, SPAN_NOTICE("... [pick(GLOB.dream_tokens)] ..."))

GLOBAL_LIST_INIT(dream_tokens, list(
	"an ID card", "a bottle", "a familiar face", "a crewmember",
	"a toolbox", "a security officer", "the captain", "voices from all around",
	"deep space", "a doctor", "the engine", "a traitor",
	"an ally", "darkness", "light", "a scientist",
	"a monkey", "a catastrophe", "a loved one", "a gun",
	"warmth", "freezing", "the sun", "a hat",
	"a ruined station", "a planet", "phoron", "air",
	"the medical bay", "the bridge", "blinking lights", "a blue light",
	"an abandoned laboratory", "NanoTrasen", "pirates", "mercenaries",
	"blood", "healing", "power", "respect",
	"riches", "space", "a crash", "happiness",
	"pride", "a fall", "water", "flames",
	"ice", "melons", "flying", "the eggs",
	"money", "the chief engineer", "the chief science officer", "the chief medical officer",
	"a station engineer", "the janitor", "the atmospheric technician", "a cargo technician",
	"the botanist", "a shaft miner", "the psychologist", "the chemist",
	"the virologist", "the roboticist", "a chef", "the bartender",
	"a chaplain", "a librarian", "a mouse", "a beach",
	"the holodeck", "a smokey room", "a voice", "the cold",
	"an operating table", "the rain", "a skrell", "an unathi",
	"a beaker of strange liquid", "the supermatter", "a creature built completely of stolen flesh", "a GAS",
	"an IPC", "a Dionaea", "a being made of light", "the commanding officer",
	"the executive officer", "the chief of security", "the corporate liason", "the representative",
	"the senior advisor", "the bridge officer", "the senior engineer", "the physician",
	"the corpsman", "the counselor", "the medical contractor", "the security contractor",
	"a stowaway", "an old friend", "the prospector", "the pilot",
	"the passenger", "the chief of security", "the master at arms", "the forensic technician",
	"the brig chief", "the tower", "the man with no face", "a field of flowers",
	"an old home", "the merc", "a surgery table", "a needle",
	"a blade", "an ocean", "right behind you", "standing above you",
	"someone near by", "a place forgotten"
))
