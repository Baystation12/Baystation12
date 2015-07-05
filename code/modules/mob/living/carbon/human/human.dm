/mob/living/carbon/human
	name = "unknown"
	real_name = "unknown"
	voice_name = "unknown"
	icon = 'icons/mob/human.dmi'
	icon_state = "body_m_s"

	var/list/hud_list[9]
	var/embedded_flag	  //To check if we've need to roll for damage on movement while an item is imbedded in us.

/mob/living/carbon/human/New(var/new_loc, var/new_species = null)

	if(!dna)
		dna = new /datum/dna(null)
		// Species name is handled by set_species()

	if(!species)
		if(new_species)
			set_species(new_species,1)
		else
			set_species()

	var/datum/reagents/R = new/datum/reagents(1000)
	reagents = R
	R.my_atom = src

	hud_list[HEALTH_HUD]      = image('icons/mob/hud.dmi', src, "hudhealth100")
	hud_list[STATUS_HUD]      = image('icons/mob/hud.dmi', src, "hudhealthy")
	hud_list[ID_HUD]          = image('icons/mob/hud.dmi', src, "hudunknown")
	hud_list[WANTED_HUD]      = image('icons/mob/hud.dmi', src, "hudblank")
	hud_list[IMPLOYAL_HUD]    = image('icons/mob/hud.dmi', src, "hudblank")
	hud_list[IMPCHEM_HUD]     = image('icons/mob/hud.dmi', src, "hudblank")
	hud_list[IMPTRACK_HUD]    = image('icons/mob/hud.dmi', src, "hudblank")
	hud_list[SPECIALROLE_HUD] = image('icons/mob/hud.dmi', src, "hudblank")
	hud_list[STATUS_HUD_OOC]  = image('icons/mob/hud.dmi', src, "hudhealthy")

	..()

	if(dna)
		dna.real_name = real_name
	make_blood()

/mob/living/carbon/human/Stat()
	..()
	statpanel("Status")

	stat(null, "Intent: [a_intent]")
	stat(null, "Move Mode: [m_intent]")
	if(ticker && ticker.mode && ticker.mode.name == "AI malfunction")
		if(ticker.mode:malf_mode_declared)
			stat(null, "Time left: [max(ticker.mode:AI_win_timeleft/(ticker.mode:apcs/3), 0)]")
	if(emergency_shuttle)
		var/eta_status = emergency_shuttle.get_status_panel_eta()
		if(eta_status)
			stat(null, eta_status)

	if (client.statpanel == "Status")

		if (internal)
			if (!internal.air_contents)
				del(internal)
			else
				stat("Internal Atmosphere Info", internal.name)
				stat("Tank Pressure", internal.air_contents.return_pressure())
				stat("Distribution Pressure", internal.distribute_pressure)

		var/datum/organ/internal/xenos/plasmavessel/P = internal_organs_by_name["plasma vessel"]
		if(P)
			stat(null, "Phoron Stored: [P.stored_plasma]/[P.max_plasma]")

		if(back && istype(back,/obj/item/weapon/rig))
			var/obj/item/weapon/rig/suit = back
			var/cell_status = "ERROR"
			if(suit.cell) cell_status = "[suit.cell.charge]/[suit.cell.maxcharge]"
			stat(null, "Suit charge: [cell_status]")

		if(mind)
			if(mind.changeling)
				stat("Chemical Storage", mind.changeling.chem_charges)
				stat("Genetic Damage Time", mind.changeling.geneticdamage)

/mob/living/carbon/human/ex_act(severity)
	if(!blinded)
		flick("flash", flash)

	var/shielded = 0
	var/b_loss = null
	var/f_loss = null
	switch (severity)
		if (1.0)
			b_loss += 500
			if (!prob(getarmor(null, "bomb")))
				gib()
				return
			else
				var/atom/target = get_edge_target_turf(src, get_dir(src, get_step_away(src, src)))
				throw_at(target, 200, 4)
			//return
//				var/atom/target = get_edge_target_turf(user, get_dir(src, get_step_away(user, src)))
				//user.throw_at(target, 200, 4)

		if (2.0)
			if (!shielded)
				b_loss += 60

			f_loss += 60

			if (prob(getarmor(null, "bomb")))
				b_loss = b_loss/1.5
				f_loss = f_loss/1.5

			if (!istype(l_ear, /obj/item/clothing/ears/earmuffs) && !istype(r_ear, /obj/item/clothing/ears/earmuffs))
				ear_damage += 30
				ear_deaf += 120
			if (prob(70) && !shielded)
				Paralyse(10)

		if(3.0)
			b_loss += 30
			if (prob(getarmor(null, "bomb")))
				b_loss = b_loss/2
			if (!istype(l_ear, /obj/item/clothing/ears/earmuffs) && !istype(r_ear, /obj/item/clothing/ears/earmuffs))
				ear_damage += 15
				ear_deaf += 60
			if (prob(50) && !shielded)
				Paralyse(10)

	var/update = 0

	// focus most of the blast on one organ
	var/datum/organ/external/take_blast = pick(organs)
	update |= take_blast.take_damage(b_loss * 0.9, f_loss * 0.9, used_weapon = "Explosive blast")

	// distribute the remaining 10% on all limbs equally
	b_loss *= 0.1
	f_loss *= 0.1

	var/weapon_message = "Explosive Blast"

	for(var/datum/organ/external/temp in organs)
		switch(temp.name)
			if("head")
				update |= temp.take_damage(b_loss * 0.2, f_loss * 0.2, used_weapon = weapon_message)
			if("chest")
				update |= temp.take_damage(b_loss * 0.4, f_loss * 0.4, used_weapon = weapon_message)
			if("l_arm")
				update |= temp.take_damage(b_loss * 0.05, f_loss * 0.05, used_weapon = weapon_message)
			if("r_arm")
				update |= temp.take_damage(b_loss * 0.05, f_loss * 0.05, used_weapon = weapon_message)
			if("l_leg")
				update |= temp.take_damage(b_loss * 0.05, f_loss * 0.05, used_weapon = weapon_message)
			if("r_leg")
				update |= temp.take_damage(b_loss * 0.05, f_loss * 0.05, used_weapon = weapon_message)
			if("r_foot")
				update |= temp.take_damage(b_loss * 0.05, f_loss * 0.05, used_weapon = weapon_message)
			if("l_foot")
				update |= temp.take_damage(b_loss * 0.05, f_loss * 0.05, used_weapon = weapon_message)
			if("r_arm")
				update |= temp.take_damage(b_loss * 0.05, f_loss * 0.05, used_weapon = weapon_message)
			if("l_arm")
				update |= temp.take_damage(b_loss * 0.05, f_loss * 0.05, used_weapon = weapon_message)
	if(update)	UpdateDamageIcon()


/mob/living/carbon/human/blob_act()
	if(stat == 2)	return
	show_message("\red The blob attacks you!")
	var/dam_zone = pick("chest", "l_hand", "r_hand", "l_leg", "r_leg")
	var/datum/organ/external/affecting = get_organ(ran_zone(dam_zone))
	apply_damage(rand(30,40), BRUTE, affecting, run_armor_check(affecting, "melee"))
	return

/mob/living/carbon/human/meteorhit(O as obj)
	for(var/mob/M in viewers(src, null))
		if ((M.client && !( M.blinded )))
			M.show_message("\red [src] has been hit by [O]", 1)
	if (health > 0)
		var/datum/organ/external/affecting = get_organ(pick("chest", "chest", "chest", "head"))
		if(!affecting)	return
		if (istype(O, /obj/effect/immovablerod))
			if(affecting.take_damage(101, 0))
				UpdateDamageIcon()
		else
			if(affecting.take_damage((istype(O, /obj/effect/meteor/small) ? 10 : 25), 30))
				UpdateDamageIcon()
		updatehealth()
	return

/mob/living/carbon/human/proc/implant_loyalty(mob/living/carbon/human/M, override = FALSE) // Won't override by default.
	if(!config.use_loyalty_implants && !override) return // Nuh-uh.

	var/obj/item/weapon/implant/loyalty/L = new/obj/item/weapon/implant/loyalty(M)
	L.imp_in = M
	L.implanted = 1
	var/datum/organ/external/affected = M.organs_by_name["head"]
	affected.implants += L
	L.part = affected

/mob/living/carbon/human/proc/is_loyalty_implanted(mob/living/carbon/human/M)
	for(var/L in M.contents)
		if(istype(L, /obj/item/weapon/implant/loyalty))
			for(var/datum/organ/external/O in M.organs)
				if(L in O.implants)
					return 1
	return 0

/mob/living/carbon/human/restrained()
	if (handcuffed)
		return 1
	if (istype(wear_suit, /obj/item/clothing/suit/straight_jacket))
		return 1
	return 0

/mob/living/carbon/human/var/co2overloadtime = null
/mob/living/carbon/human/var/temperature_resistance = T0C+75


/mob/living/carbon/human/show_inv(mob/user as mob)
	var/obj/item/clothing/under/suit = null
	if (istype(w_uniform, /obj/item/clothing/under))
		suit = w_uniform

	user.set_machine(src)
	var/dat = {"
	<B><HR><FONT size=3>[name]</FONT></B>
	<BR><HR>
	<BR><B>Head(Mask):</B> <A href='?src=\ref[src];item=mask'>[(wear_mask ? wear_mask : "Nothing")]</A>
	<BR><B>Left Hand:</B> <A href='?src=\ref[src];item=l_hand'>[(l_hand ? l_hand  : "Nothing")]</A>
	<BR><B>Right Hand:</B> <A href='?src=\ref[src];item=r_hand'>[(r_hand ? r_hand : "Nothing")]</A>
	<BR><B>Gloves:</B> <A href='?src=\ref[src];item=gloves'>[(gloves ? gloves : "Nothing")]</A>
	<BR><B>Eyes:</B> <A href='?src=\ref[src];item=eyes'>[(glasses ? glasses : "Nothing")]</A>
	<BR><B>Left Ear:</B> <A href='?src=\ref[src];item=l_ear'>[(l_ear ? l_ear : "Nothing")]</A>
	<BR><B>Right Ear:</B> <A href='?src=\ref[src];item=r_ear'>[(r_ear ? r_ear : "Nothing")]</A>
	<BR><B>Head:</B> <A href='?src=\ref[src];item=head'>[(head ? head : "Nothing")]</A>
	<BR><B>Shoes:</B> <A href='?src=\ref[src];item=shoes'>[(shoes ? shoes : "Nothing")]</A>
	<BR><B>Belt:</B> <A href='?src=\ref[src];item=belt'>[(belt ? belt : "Nothing")]</A> [((istype(wear_mask, /obj/item/clothing/mask) && istype(belt, /obj/item/weapon/tank) && !( internal )) ? text(" <A href='?src=\ref[];item=internal'>Set Internal</A>", src) : "")]
	<BR><B>Uniform:</B> <A href='?src=\ref[src];item=uniform'>[(w_uniform ? w_uniform : "Nothing")]</A> [(suit) ? ((suit.has_sensor == 1) ? text(" <A href='?src=\ref[];item=sensor'>Sensors</A>", src) : "") :]
	<BR><B>(Exo)Suit:</B> <A href='?src=\ref[src];item=suit'>[(wear_suit ? wear_suit : "Nothing")]</A>
	<BR><B>Back:</B> <A href='?src=\ref[src];item=back'>[(back ? back : "Nothing")]</A> [((istype(wear_mask, /obj/item/clothing/mask) && istype(back, /obj/item/weapon/tank) && !( internal )) ? text(" <A href='?src=\ref[];item=internal'>Set Internal</A>", src) : "")]
	<BR><B>ID:</B> <A href='?src=\ref[src];item=id'>[(wear_id ? wear_id : "Nothing")]</A>
	<BR><B>Suit Storage:</B> <A href='?src=\ref[src];item=s_store'>[(s_store ? s_store : "Nothing")]</A> [((istype(wear_mask, /obj/item/clothing/mask) && istype(s_store, /obj/item/weapon/tank) && !( internal )) ? text(" <A href='?src=\ref[];item=internal'>Set Internal</A>", src) : "")]
	<BR>[(handcuffed ? text("<A href='?src=\ref[src];item=handcuff'>Handcuffed</A>") : text("<A href='?src=\ref[src];item=handcuff'>Not Handcuffed</A>"))]
	<BR>[(legcuffed ? text("<A href='?src=\ref[src];item=legcuff'>Legcuffed</A>") : text(""))]
	<BR>[(suit) ? ((suit.accessories.len) ? text(" <A href='?src=\ref[];item=tie'>Remove Accessory</A>", src) : "") :]
	<BR>[(internal ? text("<A href='?src=\ref[src];item=internal'>Remove Internal</A>") : "")]
	<BR><A href='?src=\ref[src];item=splints'>Remove Splints</A>
	<BR><A href='?src=\ref[src];item=pockets'>Empty Pockets</A>
	<BR><A href='?src=\ref[user];refresh=1'>Refresh</A>
	<BR><A href='?src=\ref[user];mach_close=mob[name]'>Close</A>
	<BR>"}
	user << browse(dat, text("window=mob[name];size=340x540"))
	onclose(user, "mob[name]")
	return

// called when something steps onto a human
// this handles mulebots and vehicles
/mob/living/carbon/human/Crossed(var/atom/movable/AM)
	if(istype(AM, /obj/machinery/bot/mulebot))
		var/obj/machinery/bot/mulebot/MB = AM
		MB.RunOver(src)

	if(istype(AM, /obj/vehicle))
		var/obj/vehicle/V = AM
		V.RunOver(src)

// Get rank from ID, ID inside PDA, PDA, ID in wallet, etc.
/mob/living/carbon/human/proc/get_authentification_rank(var/if_no_id = "No id", var/if_no_job = "No job")
	var/obj/item/device/pda/pda = wear_id
	if (istype(pda))
		if (pda.id)
			return pda.id.rank
		else
			return pda.ownrank
	else
		var/obj/item/weapon/card/id/id = get_idcard()
		if(id)
			return id.rank ? id.rank : if_no_job
		else
			return if_no_id

//gets assignment from ID or ID inside PDA or PDA itself
//Useful when player do something with computers
/mob/living/carbon/human/proc/get_assignment(var/if_no_id = "No id", var/if_no_job = "No job")
	var/obj/item/device/pda/pda = wear_id
	if (istype(pda))
		if (pda.id)
			return pda.id.assignment
		else
			return pda.ownjob
	else
		var/obj/item/weapon/card/id/id = get_idcard()
		if(id)
			return id.assignment ? id.assignment : if_no_job
		else
			return if_no_id

//gets name from ID or ID inside PDA or PDA itself
//Useful when player do something with computers
/mob/living/carbon/human/proc/get_authentification_name(var/if_no_id = "Unknown")
	var/obj/item/device/pda/pda = wear_id
	if (istype(pda))
		if (pda.id)
			return pda.id.registered_name
		else
			return pda.owner
	else
		var/obj/item/weapon/card/id/id = get_idcard()
		if(id)
			return id.registered_name
		else
			return if_no_id

//repurposed proc. Now it combines get_id_name() and get_face_name() to determine a mob's name variable. Made into a seperate proc as it'll be useful elsewhere
/mob/living/carbon/human/proc/get_visible_name()
	if( wear_mask && (wear_mask.flags_inv&HIDEFACE) )	//Wearing a mask which hides our face, use id-name if possible
		return get_id_name("Unknown")
	if( head && (head.flags_inv&HIDEFACE) )
		return get_id_name("Unknown")		//Likewise for hats
	var/face_name = get_face_name()
	var/id_name = get_id_name("")
	if(id_name && (id_name != face_name))
		return "[face_name] (as [id_name])"
	return face_name

//Returns "Unknown" if facially disfigured and real_name if not. Useful for setting name when polyacided or when updating a human's name variable
/mob/living/carbon/human/proc/get_face_name()
	var/datum/organ/external/head/head = get_organ("head")
	if( !head || head.disfigured || (head.status & ORGAN_DESTROYED) || !real_name || (HUSK in mutations) )	//disfigured. use id-name if possible
		return "Unknown"
	return real_name

//gets name from ID or PDA itself, ID inside PDA doesn't matter
//Useful when player is being seen by other mobs
/mob/living/carbon/human/proc/get_id_name(var/if_no_id = "Unknown")
	. = if_no_id
	if(istype(wear_id,/obj/item/device/pda))
		var/obj/item/device/pda/P = wear_id
		return P.owner
	if(wear_id)
		var/obj/item/weapon/card/id/I = wear_id.GetID()
		if(I)
			return I.registered_name
	return

//gets ID card object from special clothes slot or null.
/mob/living/carbon/human/proc/get_idcard()
	if(wear_id)
		return wear_id.GetID()

//Removed the horrible safety parameter. It was only being used by ninja code anyways.
//Now checks siemens_coefficient of the affected area by default
/mob/living/carbon/human/electrocute_act(var/shock_damage, var/obj/source, var/base_siemens_coeff = 1.0, var/def_zone = null)
	if(status_flags & GODMODE)	return 0	//godmode

	if (!def_zone)
		def_zone = pick("l_hand", "r_hand")

	var/datum/organ/external/affected_organ = get_organ(check_zone(def_zone))
	var/siemens_coeff = base_siemens_coeff * get_siemens_coefficient_organ(affected_organ)

	return ..(shock_damage, source, siemens_coeff, def_zone)


/mob/living/carbon/human/Topic(href, href_list)
	if (href_list["refresh"])
		if((machine)&&(in_range(src, usr)))
			show_inv(machine)

	if (href_list["mach_close"])
		var/t1 = text("window=[]", href_list["mach_close"])
		unset_machine()
		src << browse(null, t1)

	if ((href_list["item"] && !( usr.stat ) && usr.canmove && !( usr.restrained() ) && in_range(src, usr) && ticker)) //if game hasn't started, can't make an equip_e
		var/obj/effect/equip_e/human/O = new /obj/effect/equip_e/human(  )
		O.source = usr
		O.target = src
		O.item = usr.get_active_hand()
		O.s_loc = usr.loc
		O.t_loc = loc
		O.place = href_list["item"]
		requests += O
		spawn( 0 )
			O.process()
			return

	if (href_list["criminal"])
		if(hasHUD(usr,"security"))

			var/modified = 0
			var/perpname = "wot"
			if(wear_id)
				var/obj/item/weapon/card/id/I = wear_id.GetID()
				if(I)
					perpname = I.registered_name
				else
					perpname = name
			else
				perpname = name

			if(perpname)
				for (var/datum/data/record/E in data_core.general)
					if (E.fields["name"] == perpname)
						for (var/datum/data/record/R in data_core.security)
							if (R.fields["id"] == E.fields["id"])

								var/setcriminal = input(usr, "Specify a new criminal status for this person.", "Security HUD", R.fields["criminal"]) in list("None", "*Arrest*", "Incarcerated", "Parolled", "Released", "Cancel")

								if(hasHUD(usr, "security"))
									if(setcriminal != "Cancel")
										R.fields["criminal"] = setcriminal
										modified = 1

										spawn()
											BITSET(hud_updateflag, WANTED_HUD)
											if(istype(usr,/mob/living/carbon/human))
												var/mob/living/carbon/human/U = usr
												U.handle_regular_hud_updates()
											if(istype(usr,/mob/living/silicon/robot))
												var/mob/living/silicon/robot/U = usr
												U.handle_regular_hud_updates()

			if(!modified)
				usr << "\red Unable to locate a data core entry for this person."

	if (href_list["secrecord"])
		if(hasHUD(usr,"security"))
			var/perpname = "wot"
			var/read = 0

			if(wear_id)
				if(istype(wear_id,/obj/item/weapon/card/id))
					perpname = wear_id:registered_name
				else if(istype(wear_id,/obj/item/device/pda))
					var/obj/item/device/pda/tempPda = wear_id
					perpname = tempPda.owner
			else
				perpname = src.name
			for (var/datum/data/record/E in data_core.general)
				if (E.fields["name"] == perpname)
					for (var/datum/data/record/R in data_core.security)
						if (R.fields["id"] == E.fields["id"])
							if(hasHUD(usr,"security"))
								usr << "<b>Name:</b> [R.fields["name"]]	<b>Criminal Status:</b> [R.fields["criminal"]]"
								usr << "<b>Minor Crimes:</b> [R.fields["mi_crim"]]"
								usr << "<b>Details:</b> [R.fields["mi_crim_d"]]"
								usr << "<b>Major Crimes:</b> [R.fields["ma_crim"]]"
								usr << "<b>Details:</b> [R.fields["ma_crim_d"]]"
								usr << "<b>Notes:</b> [R.fields["notes"]]"
								usr << "<a href='?src=\ref[src];secrecordComment=`'>\[View Comment Log\]</a>"
								read = 1

			if(!read)
				usr << "\red Unable to locate a data core entry for this person."

	if (href_list["secrecordComment"])
		if(hasHUD(usr,"security"))
			var/perpname = "wot"
			var/read = 0

			if(wear_id)
				if(istype(wear_id,/obj/item/weapon/card/id))
					perpname = wear_id:registered_name
				else if(istype(wear_id,/obj/item/device/pda))
					var/obj/item/device/pda/tempPda = wear_id
					perpname = tempPda.owner
			else
				perpname = src.name
			for (var/datum/data/record/E in data_core.general)
				if (E.fields["name"] == perpname)
					for (var/datum/data/record/R in data_core.security)
						if (R.fields["id"] == E.fields["id"])
							if(hasHUD(usr,"security"))
								read = 1
								var/counter = 1
								while(R.fields[text("com_[]", counter)])
									usr << text("[]", R.fields[text("com_[]", counter)])
									counter++
								if (counter == 1)
									usr << "No comment found"
								usr << "<a href='?src=\ref[src];secrecordadd=`'>\[Add comment\]</a>"

			if(!read)
				usr << "\red Unable to locate a data core entry for this person."

	if (href_list["secrecordadd"])
		if(hasHUD(usr,"security"))
			var/perpname = "wot"
			if(wear_id)
				if(istype(wear_id,/obj/item/weapon/card/id))
					perpname = wear_id:registered_name
				else if(istype(wear_id,/obj/item/device/pda))
					var/obj/item/device/pda/tempPda = wear_id
					perpname = tempPda.owner
			else
				perpname = src.name
			for (var/datum/data/record/E in data_core.general)
				if (E.fields["name"] == perpname)
					for (var/datum/data/record/R in data_core.security)
						if (R.fields["id"] == E.fields["id"])
							if(hasHUD(usr,"security"))
								var/t1 = sanitize(copytext(input("Add Comment:", "Sec. records", null, null)  as message,1,MAX_MESSAGE_LEN))
								if ( !(t1) || usr.stat || usr.restrained() || !(hasHUD(usr,"security")) )
									return
								var/counter = 1
								while(R.fields[text("com_[]", counter)])
									counter++
								if(istype(usr,/mob/living/carbon/human))
									var/mob/living/carbon/human/U = usr
									R.fields[text("com_[counter]")] = text("Made by [U.get_authentification_name()] ([U.get_assignment()]) on [time2text(world.realtime, "DDD MMM DD hh:mm:ss")], [game_year]<BR>[t1]")
								if(istype(usr,/mob/living/silicon/robot))
									var/mob/living/silicon/robot/U = usr
									R.fields[text("com_[counter]")] = text("Made by [U.name] ([U.modtype] [U.braintype]) on [time2text(world.realtime, "DDD MMM DD hh:mm:ss")], [game_year]<BR>[t1]")

	if (href_list["medical"])
		if(hasHUD(usr,"medical"))
			var/perpname = "wot"
			var/modified = 0

			if(wear_id)
				if(istype(wear_id,/obj/item/weapon/card/id))
					perpname = wear_id:registered_name
				else if(istype(wear_id,/obj/item/device/pda))
					var/obj/item/device/pda/tempPda = wear_id
					perpname = tempPda.owner
			else
				perpname = src.name

			for (var/datum/data/record/E in data_core.general)
				if (E.fields["name"] == perpname)
					for (var/datum/data/record/R in data_core.general)
						if (R.fields["id"] == E.fields["id"])

							var/setmedical = input(usr, "Specify a new medical status for this person.", "Medical HUD", R.fields["p_stat"]) in list("*SSD*", "*Deceased*", "Physically Unfit", "Active", "Disabled", "Cancel")

							if(hasHUD(usr,"medical"))
								if(setmedical != "Cancel")
									R.fields["p_stat"] = setmedical
									modified = 1
									if(PDA_Manifest.len)
										PDA_Manifest.Cut()

									spawn()
										if(istype(usr,/mob/living/carbon/human))
											var/mob/living/carbon/human/U = usr
											U.handle_regular_hud_updates()
										if(istype(usr,/mob/living/silicon/robot))
											var/mob/living/silicon/robot/U = usr
											U.handle_regular_hud_updates()

			if(!modified)
				usr << "\red Unable to locate a data core entry for this person."

	if (href_list["medrecord"])
		if(hasHUD(usr,"medical"))
			var/perpname = "wot"
			var/read = 0

			if(wear_id)
				if(istype(wear_id,/obj/item/weapon/card/id))
					perpname = wear_id:registered_name
				else if(istype(wear_id,/obj/item/device/pda))
					var/obj/item/device/pda/tempPda = wear_id
					perpname = tempPda.owner
			else
				perpname = src.name
			for (var/datum/data/record/E in data_core.general)
				if (E.fields["name"] == perpname)
					for (var/datum/data/record/R in data_core.medical)
						if (R.fields["id"] == E.fields["id"])
							if(hasHUD(usr,"medical"))
								usr << "<b>Name:</b> [R.fields["name"]]	<b>Blood Type:</b> [R.fields["b_type"]]"
								usr << "<b>DNA:</b> [R.fields["b_dna"]]"
								usr << "<b>Minor Disabilities:</b> [R.fields["mi_dis"]]"
								usr << "<b>Details:</b> [R.fields["mi_dis_d"]]"
								usr << "<b>Major Disabilities:</b> [R.fields["ma_dis"]]"
								usr << "<b>Details:</b> [R.fields["ma_dis_d"]]"
								usr << "<b>Notes:</b> [R.fields["notes"]]"
								usr << "<a href='?src=\ref[src];medrecordComment=`'>\[View Comment Log\]</a>"
								read = 1

			if(!read)
				usr << "\red Unable to locate a data core entry for this person."

	if (href_list["medrecordComment"])
		if(hasHUD(usr,"medical"))
			var/perpname = "wot"
			var/read = 0

			if(wear_id)
				if(istype(wear_id,/obj/item/weapon/card/id))
					perpname = wear_id:registered_name
				else if(istype(wear_id,/obj/item/device/pda))
					var/obj/item/device/pda/tempPda = wear_id
					perpname = tempPda.owner
			else
				perpname = src.name
			for (var/datum/data/record/E in data_core.general)
				if (E.fields["name"] == perpname)
					for (var/datum/data/record/R in data_core.medical)
						if (R.fields["id"] == E.fields["id"])
							if(hasHUD(usr,"medical"))
								read = 1
								var/counter = 1
								while(R.fields[text("com_[]", counter)])
									usr << text("[]", R.fields[text("com_[]", counter)])
									counter++
								if (counter == 1)
									usr << "No comment found"
								usr << "<a href='?src=\ref[src];medrecordadd=`'>\[Add comment\]</a>"

			if(!read)
				usr << "\red Unable to locate a data core entry for this person."

	if (href_list["medrecordadd"])
		if(hasHUD(usr,"medical"))
			var/perpname = "wot"
			if(wear_id)
				if(istype(wear_id,/obj/item/weapon/card/id))
					perpname = wear_id:registered_name
				else if(istype(wear_id,/obj/item/device/pda))
					var/obj/item/device/pda/tempPda = wear_id
					perpname = tempPda.owner
			else
				perpname = src.name
			for (var/datum/data/record/E in data_core.general)
				if (E.fields["name"] == perpname)
					for (var/datum/data/record/R in data_core.medical)
						if (R.fields["id"] == E.fields["id"])
							if(hasHUD(usr,"medical"))
								var/t1 = sanitize(copytext(input("Add Comment:", "Med. records", null, null)  as message,1,MAX_MESSAGE_LEN))
								if ( !(t1) || usr.stat || usr.restrained() || !(hasHUD(usr,"medical")) )
									return
								var/counter = 1
								while(R.fields[text("com_[]", counter)])
									counter++
								if(istype(usr,/mob/living/carbon/human))
									var/mob/living/carbon/human/U = usr
									R.fields[text("com_[counter]")] = text("Made by [U.get_authentification_name()] ([U.get_assignment()]) on [time2text(world.realtime, "DDD MMM DD hh:mm:ss")], [game_year]<BR>[t1]")
								if(istype(usr,/mob/living/silicon/robot))
									var/mob/living/silicon/robot/U = usr
									R.fields[text("com_[counter]")] = text("Made by [U.name] ([U.modtype] [U.braintype]) on [time2text(world.realtime, "DDD MMM DD hh:mm:ss")], [game_year]<BR>[t1]")

	if (href_list["lookitem"])
		var/obj/item/I = locate(href_list["lookitem"])
		src.examinate(I)

	if (href_list["lookmob"])
		var/mob/M = locate(href_list["lookmob"])
		src.examinate(M)

	if (href_list["flavor_change"])
		switch(href_list["flavor_change"])
			if("done")
				src << browse(null, "window=flavor_changes")
				return
			if("general")
				var/msg = input(usr,"Update the general description of your character. This will be shown regardless of clothing, and may include OOC notes and preferences.","Flavor Text",html_decode(flavor_texts[href_list["flavor_change"]])) as message
				if(msg != null)
					msg = copytext(msg, 1, MAX_MESSAGE_LEN)
					msg = html_encode(msg)
				flavor_texts[href_list["flavor_change"]] = msg
				return
			else
				var/msg = input(usr,"Update the flavor text for your [href_list["flavor_change"]].","Flavor Text",html_decode(flavor_texts[href_list["flavor_change"]])) as message
				if(msg != null)
					msg = copytext(msg, 1, MAX_MESSAGE_LEN)
					msg = html_encode(msg)
				flavor_texts[href_list["flavor_change"]] = msg
				set_flavor()
				return
	..()
	return

///eyecheck()
///Returns a number between -1 to 2
/mob/living/carbon/human/eyecheck()
	var/number = 0

	if(!species.has_organ["eyes"]) //No eyes, can't hurt them.
		return 2

	if(internal_organs_by_name["eyes"]) // Eyes are fucked, not a 'weak point'.
		var/datum/organ/internal/I = internal_organs_by_name["eyes"]
		if(I.status & ORGAN_CUT_AWAY)
			return 2
	else
		return 2

	if(istype(src.head, /obj/item/clothing/head/welding))
		if(!src.head:up)
			number += 2
	if(istype(back, /obj/item/weapon/rig))
		var/obj/item/weapon/rig/O = back
		if(O.helmet && O.helmet == head && (O.helmet.body_parts_covered & EYES))
			number += 2
	if(istype(src.head, /obj/item/clothing/head/helmet/space))
		number += 2
	if(istype(src.head, /obj/item/clothing/head/helmet/space/emergency))
		number -= 2
	if(istype(src.glasses, /obj/item/clothing/glasses/thermal))
		number -= 1
	if(istype(src.glasses, /obj/item/clothing/glasses/sunglasses))
		number += 1
	if(istype(src.glasses, /obj/item/clothing/glasses/welding))
		var/obj/item/clothing/glasses/welding/W = src.glasses
		if(!W.up)
			number += 2
	return number

/mob/living/carbon/human/IsAdvancedToolUser(var/silent)
	if(species.has_fine_manipulation)
		return 1
	if(!silent)
		src << "<span class='warning'>You don't have the dexterity to use that!<span>"
	return 0

/mob/living/carbon/human/abiotic(var/full_body = 0)
	if(full_body && ((src.l_hand && !( src.l_hand.abstract )) || (src.r_hand && !( src.r_hand.abstract )) || (src.back || src.wear_mask || src.head || src.shoes || src.w_uniform || src.wear_suit || src.glasses || src.l_ear || src.r_ear || src.gloves)))
		return 1

	if( (src.l_hand && !src.l_hand.abstract) || (src.r_hand && !src.r_hand.abstract) )
		return 1

	return 0


/mob/living/carbon/human/proc/check_dna()
	dna.check_integrity(src)
	return

/mob/living/carbon/human/get_species()
	if(!species)
		set_species()
	return species.name

/mob/living/carbon/human/proc/play_xylophone()
	if(!src.xylophone)
		visible_message("\red [src] begins playing his ribcage like a xylophone. It's quite spooky.","\blue You begin to play a spooky refrain on your ribcage.","\red You hear a spooky xylophone melody.")
		var/song = pick('sound/effects/xylophone1.ogg','sound/effects/xylophone2.ogg','sound/effects/xylophone3.ogg')
		playsound(loc, song, 50, 1, -1)
		xylophone = 1
		spawn(1200)
			xylophone=0
	return

/mob/living/carbon/human/proc/vomit()

	if(species.flags & IS_SYNTHETIC)
		return //Machines don't throw up.

	if(!lastpuke)
		lastpuke = 1
		src << "<span class='warning'>You feel nauseous...</span>"
		spawn(150)	//15 seconds until second warning
			src << "<span class='warning'>You feel like you are about to throw up!</span>"
			spawn(100)	//and you have 10 more for mad dash to the bucket
				Stun(5)

				src.visible_message("<span class='warning'>[src] throws up!</span>","<span class='warning'>You throw up!</span>")
				playsound(loc, 'sound/effects/splat.ogg', 50, 1)

				var/turf/location = loc
				if (istype(location, /turf/simulated))
					location.add_vomit_floor(src, 1)

				nutrition -= 40
				adjustToxLoss(-3)
				spawn(350)	//wait 35 seconds before next volley
					lastpuke = 0

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
		r_facial = hex2num(copytext(new_facial, 2, 4))
		g_facial = hex2num(copytext(new_facial, 4, 6))
		b_facial = hex2num(copytext(new_facial, 6, 8))

	var/new_hair = input("Please select hair color.", "Character Generation",rgb(r_hair,g_hair,b_hair)) as color
	if(new_facial)
		r_hair = hex2num(copytext(new_hair, 2, 4))
		g_hair = hex2num(copytext(new_hair, 4, 6))
		b_hair = hex2num(copytext(new_hair, 6, 8))

	var/new_eyes = input("Please select eye color.", "Character Generation",rgb(r_eyes,g_eyes,b_eyes)) as color
	if(new_eyes)
		r_eyes = hex2num(copytext(new_eyes, 2, 4))
		g_eyes = hex2num(copytext(new_eyes, 4, 6))
		b_eyes = hex2num(copytext(new_eyes, 6, 8))

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
		del(H) // delete the hair after it's all done

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
		del(H)

	new_style = input("Please select facial style", "Character Generation",f_style)  as null|anything in fhairs

	if(new_style)
		f_style = new_style

	var/new_gender = alert(usr, "Please select gender.", "Character Generation", "Male", "Female")
	if (new_gender)
		if(new_gender == "Male")
			gender = MALE
		else
			gender = FEMALE
	regenerate_icons()
	check_dna()

	visible_message("\blue \The [src] morphs and changes [get_visible_gender() == MALE ? "his" : get_visible_gender() == FEMALE ? "her" : "their"] appearance!", "\blue You change your appearance!", "\red Oh, god!  What the hell was that?  It sounded like flesh getting squished and bone ground into a different shape!")

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
	var/mob/target = input ("Who do you want to project your mind to ?") as null|anything in creatures
	if (isnull(target))
		return

	var/say = input ("What do you wish to say")
	if(mRemotetalk in target.mutations)
		target.show_message("\blue You hear [src.real_name]'s voice: [say]")
	else
		target.show_message("\blue You hear a voice that seems to echo around the room: [say]")
	usr.show_message("\blue You project your mind into [target.real_name]: [say]")
	log_say("[key_name(usr)] sent a telepathic message to [key_name(target)]: [say]")
	for(var/mob/dead/observer/G in world)
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

/mob/living/carbon/human/proc/get_visible_gender()
	if(wear_suit && wear_suit.flags_inv & HIDEJUMPSUIT && ((head && head.flags_inv & HIDEMASK) || wear_mask))
		return NEUTER
	return gender

/mob/living/carbon/human/proc/increase_germ_level(n)
	if(gloves)
		gloves.germ_level += n
	else
		germ_level += n

/mob/living/carbon/human/revive()
	for (var/datum/organ/external/O in organs)
		O.status &= ~ORGAN_BROKEN
		O.status &= ~ORGAN_BLEEDING
		O.status &= ~ORGAN_SPLINTED
		O.status &= ~ORGAN_CUT_AWAY
		O.status &= ~ORGAN_ATTACHABLE
		if (!O.amputated)
			O.status &= ~ORGAN_DESTROYED
			O.destspawn = 0
		O.wounds.Cut()
		O.heal_damage(1000,1000,1,1)

	var/datum/organ/external/head/h = organs_by_name["head"]
	h.disfigured = 0

	if(species && !(species.flags & NO_BLOOD))
		vessel.add_reagent("blood",560-vessel.total_volume)
		fixblood()

	// Fix up any missing organs.
	// This will ignore any prosthetics in the prefs currently.
	species.create_organs(src)

	if(!client || !key) //Don't boot out anyone already in the mob.
		for (var/obj/item/organ/brain/H in world)
			if(H.brainmob)
				if(H.brainmob.real_name == src.real_name)
					if(H.brainmob.mind)
						H.brainmob.mind.transfer_to(src)
						del(H)

	for(var/datum/organ/internal/I in internal_organs)
		I.damage = 0

	for (var/datum/disease/virus in viruses)
		virus.cure()
	for (var/ID in virus2)
		var/datum/disease2/disease/V = virus2[ID]
		V.cure(src)

	losebreath = 0
	failed_last_breath = 0 //So mobs that died of oxyloss don't revive and have perpetual out of breath.

	..()

/mob/living/carbon/human/proc/is_lung_ruptured()
	var/datum/organ/internal/lungs/L = internal_organs_by_name["lungs"]
	return L && L.is_bruised()

/mob/living/carbon/human/proc/rupture_lung()
	var/datum/organ/internal/lungs/L = internal_organs_by_name["lungs"]

	if(L && !L.is_bruised())
		src.custom_pain("You feel a stabbing pain in your chest!", 1)
		L.damage = L.min_bruised_damage

/*
/mob/living/carbon/human/verb/simulate()
	set name = "sim"
	set background = 1

	var/damage = input("Wound damage","Wound damage") as num

	var/germs = 0
	var/tdamage = 0
	var/ticks = 0
	while (germs < 2501 && ticks < 100000 && round(damage/10)*20)
		log_misc("VIRUS TESTING: [ticks] : germs [germs] tdamage [tdamage] prob [round(damage/10)*20]")
		ticks++
		if (prob(round(damage/10)*20))
			germs++
		if (germs == 100)
			world << "Reached stage 1 in [ticks] ticks"
		if (germs > 100)
			if (prob(10))
				damage++
				germs++
		if (germs == 1000)
			world << "Reached stage 2 in [ticks] ticks"
		if (germs > 1000)
			damage++
			germs++
		if (germs == 2500)
			world << "Reached stage 3 in [ticks] ticks"
	world << "Mob took [tdamage] tox damage"
*/
//returns 1 if made bloody, returns 0 otherwise

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
	if(clean_feet && !shoes && istype(feet_blood_DNA, /list) && feet_blood_DNA.len)
		feet_blood_color = null
		del(feet_blood_DNA)
		update_inv_shoes(1)
		return 1

/mob/living/carbon/human/get_visible_implants(var/class = 0)

	var/list/visible_implants = list()
	for(var/datum/organ/external/organ in src.organs)
		for(var/obj/item/weapon/O in organ.implants)
			if(!istype(O,/obj/item/weapon/implant) && (O.w_class > class) && !istype(O,/obj/item/weapon/shard/shrapnel))
				visible_implants += O

	return(visible_implants)

/mob/living/carbon/human/proc/handle_embedded_objects()

	for(var/datum/organ/external/organ in src.organs)
		if(organ.status & ORGAN_SPLINTED) //Splints prevent movement.
			continue
		for(var/obj/item/weapon/O in organ.implants)
			if(!istype(O,/obj/item/weapon/implant) && prob(5)) //Moving with things stuck in you could be bad.
				// All kinds of embedded objects cause bleeding.
				var/msg = null
				switch(rand(1,3))
					if(1)
						msg ="<span class='warning'>A spike of pain jolts your [organ.display_name] as you bump [O] inside.</span>"
					if(2)
						msg ="<span class='warning'>Your movement jostles [O] in your [organ.display_name] painfully.</span>"
					if(3)
						msg ="<span class='warning'>[O] in your [organ.display_name] twists painfully as you move.</span>"
				src << msg

				organ.take_damage(rand(1,3), 0, 0)
				if(!(organ.status & ORGAN_ROBOT) && !(species.flags & NO_BLOOD)) //There is no blood in protheses.
					organ.status |= ORGAN_BLEEDING
					src.adjustToxLoss(rand(1,3))

/mob/living/carbon/human/verb/check_pulse()
	set category = "Object"
	set name = "Check pulse"
	set desc = "Approximately count somebody's pulse. Requires you to stand still at least 6 seconds."
	set src in view(1)
	var/self = 0

	if(usr.stat == 1 || usr.restrained() || !isliving(usr)) return

	if(usr == src)
		self = 1
	if(!self)
		usr.visible_message("\blue [usr] kneels down, puts \his hand on [src]'s wrist and begins counting their pulse.",\
		"You begin counting [src]'s pulse")
	else
		usr.visible_message("\blue [usr] begins counting their pulse.",\
		"You begin counting your pulse.")

	if(src.pulse)
		usr << "\blue [self ? "You have a" : "[src] has a"] pulse! Counting..."
	else
		usr << "\red [src] has no pulse!"	//it is REALLY UNLIKELY that a dead person would check his own pulse
		return

	usr << "Don't move until counting is finished."
	var/time = world.time
	sleep(60)
	if(usr.l_move_time >= time)	//checks if our mob has moved during the sleep()
		usr << "You moved while counting. Try again."
	else
		usr << "\blue [self ? "Your" : "[src]'s"] pulse is [src.get_pulse(GETPULSE_HAND)]."

/mob/living/carbon/human/proc/set_species(var/new_species, var/default_colour)

	if(!dna)
		if(!new_species)
			new_species = "Human"
	else
		if(!new_species)
			new_species = dna.species
		else
			dna.species = new_species

	if(species)

		if(species.name && species.name == new_species)
			return
		if(species.language)
			remove_language(species.language)

		if(species.default_language)
			remove_language(species.default_language)

		// Clear out their species abilities.
		species.remove_inherent_verbs(src)

	species = all_species[new_species]

	species.create_organs(src)

	if(species.language)
		add_language(species.language)

	if(species.default_language)
		add_language(species.default_language)

	if(species.base_color && default_colour)
		//Apply colour.
		r_skin = hex2num(copytext(species.base_color,2,4))
		g_skin = hex2num(copytext(species.base_color,4,6))
		b_skin = hex2num(copytext(species.base_color,6,8))
	else
		r_skin = 0
		g_skin = 0
		b_skin = 0

	species.handle_post_spawn(src)

	maxHealth = species.total_health

	spawn(0)
		regenerate_icons()
		vessel.add_reagent("blood",560-vessel.total_volume)
		fixblood()

	// Rebuild the HUD. If they aren't logged in then login() should reinstantiate it for them.
	if(client && client.screen)
		client.screen.len = null
		if(hud_used)
			del(hud_used)
		hud_used = new /datum/hud(src)

	if(species)
		return 1
	else
		return 0

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
		src << "<span class='warning'>Your [src.gloves] are getting in the way.</span>"
		return

	var/turf/simulated/T = src.loc
	if (!istype(T)) //to prevent doodling out of mechs and lockers
		src << "<span class='warning'>You cannot reach the floor.</span>"
		return

	var/direction = input(src,"Which way?","Tile selection") as anything in list("Here","North","South","East","West")
	if (direction != "Here")
		T = get_step(T,text2dir(direction))
	if (!istype(T))
		src << "<span class='warning'>You cannot doodle there.</span>"
		return

	var/num_doodles = 0
	for (var/obj/effect/decal/cleanable/blood/writing/W in T)
		num_doodles++
	if (num_doodles > 4)
		src << "<span class='warning'>There is no space to write on!</span>"
		return

	var/max_length = bloody_hands * 30 //tweeter style

	var/message = stripped_input(src,"Write a message. It cannot be longer than [max_length] characters.","Blood writing", "")

	if (message)
		var/used_blood_amount = round(length(message) / 30, 1)
		bloody_hands = max(0, bloody_hands - used_blood_amount) //use up some blood

		if (length(message) > max_length)
			message += "-"
			src << "<span class='warning'>You ran out of blood to write with!</span>"

		var/obj/effect/decal/cleanable/blood/writing/W = new(T)
		W.basecolor = (hand_blood_color) ? hand_blood_color : "#A10808"
		W.update_icon()
		W.message = message
		W.add_fingerprint(src)

/mob/living/carbon/human/can_inject(var/mob/user, var/error_msg, var/target_zone)
	. = 1

	if(!target_zone)
		if(!user)
			target_zone = pick("chest","chest","chest","left leg","right leg","left arm", "right arm", "head")
		else
			target_zone = user.zone_sel.selecting

	switch(target_zone)
		if("head")
			if(head && head.flags & THICKMATERIAL)
				. = 0
		else
			if(wear_suit && wear_suit.flags & THICKMATERIAL)
				. = 0
	if(!. && error_msg && user)
 		// Might need re-wording.
		user << "<span class='alert'>There is no exposed flesh or thin material [target_zone == "head" ? "on their head" : "on their body"] to inject into.</span>"

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

	flavor_text = flavor_texts["general"]
	flavor_text += "\n\n"
	for (var/T in flavor_texts)
		if(flavor_texts[T] && flavor_texts[T] != "")
			if((T == "head" && head_exposed) || (T == "face" && face_exposed) || (T == "eyes" && eyes_exposed) || (T == "torso" && torso_exposed) || (T == "arms" && arms_exposed) || (T == "hands" && hands_exposed) || (T == "legs" && legs_exposed) || (T == "feet" && feet_exposed))
				flavor_text += flavor_texts[T]
				flavor_text += "\n\n"
	if(!shrink)
		return flavor_text
	else
		return ..()

/mob/living/carbon/human/getDNA()
	if(species.flags & NO_SCAN)
		return null
	..()

/mob/living/carbon/human/setDNA()
	if(species.flags & NO_SCAN)
		return
	..()

/mob/living/carbon/human/has_brain()
	if(internal_organs_by_name["brain"])
		var/datum/organ/internal/brain = internal_organs_by_name["brain"]
		if(brain && istype(brain))
			return 1
	return 0

/mob/living/carbon/human/has_eyes()
	if(internal_organs_by_name["eyes"])
		var/datum/organ/internal/eyes = internal_organs_by_name["eyes"]
		if(eyes && istype(eyes) && !(eyes.status & ORGAN_CUT_AWAY))
			return 1
	return 0

/mob/living/carbon/human/slip(var/slipped_on, stun_duration=8)
	if((species.flags & NO_SLIP) || (shoes && (shoes.flags & NOSLIP)))
		return 0
	..(slipped_on,stun_duration)

/mob/living/carbon/human/reset_view(atom/A, update_hud = 1)
	..()
	if(update_hud)
		handle_regular_hud_updates()
