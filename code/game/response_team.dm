//STRIKE TEAMS
//Thanks to Kilakk for the admin-button portion of this code.

var/list/response_team_members = list()
var/global/send_emergency_team = 0 // Used for automagic response teams
                                   // 'admin_emergency_team' for admin-spawned response teams
var/ert_base_chance = 10 // Default base chance. Will be incremented by increment ERT chance.
var/can_call_ert

var/medic_slots = 0
var/sec_slots = 0
var/command_slots = 0
var/engineer_slots = 0

/client/proc/response_team()
	set name = "Dispatch Emergency Response Team"
	set category = "Special Verbs"
	set desc = "Send an emergency response team to the station"

	if(!holder)
		usr << "\red Only administrators may use this command."
		return
	if(!ticker)
		usr << "\red The game hasn't started yet!"
		return
	if(ticker.current_state == 1)
		usr << "\red The round hasn't started yet!"
		return
	if(send_emergency_team)
		usr << "\red Central Command has already dispatched an emergency response team!"
		return
	if(alert("Do you want to dispatch an Emergency Response Team?",,"Yes","No") != "Yes")
		return
	if(get_security_level() != "red") // Allow admins to reconsider if the alert level isn't Red
		switch(alert("The station is not in red alert. Do you still want to dispatch a response team?",,"Yes","No"))
			if("No")
				return

	var/selected_role = input("Choose the ERT type!") in list ("Security", "Medical", "Engineering", "Other")
	switch(selected_role)
		if("Security")
			ERT_TYPE = 1
			command_slots = 1
			sec_slots = 2
			engineer_slots = 1
			medic_slots = 1
		if("Medical")
			ERT_TYPE = 2
			command_slots = 1
			sec_slots = 1
			engineer_slots = 1
			medic_slots = 2
		if("Engineering")
			ERT_TYPE = 3
			command_slots = 1
			sec_slots = 1
			engineer_slots = 2
			medic_slots = 1
		if("Other")
			ERT_TYPE = 4
			command_slots = 1
			sec_slots = 2
			engineer_slots = 2
			medic_slots = 2

	if(send_emergency_team)
		usr << "\red Looks like somebody beat you to it!"
		return

	message_admins("[key_name_admin(usr)] is dispatching an Emergency Response Team.", 1)
	log_admin("[key_name(usr)] used Dispatch Response Team.")
	log_admin_single("[key_name(usr)] used Dispatch Response Team.")
	trigger_armed_response_team(1)

client/verb/JoinResponseTeam()
	set category = "IC"
	var/role_new

	if(!MayRespawn(1))
		return

	if(istype(usr,/mob/dead/observer) || istype(usr,/mob/new_player))
		if(!send_emergency_team)
			usr << "No emergency response team is currently being sent."
			return
	/*	if(admin_emergency_team)
			usr << "An emergency response team has already been sent."
			return */
		if(jobban_isbanned(usr, "Syndicate") || jobban_isbanned(usr, "Emergency Response Team") || jobban_isbanned(usr, "Security Officer"))
			usr << "<font color=red><b>You are jobbanned from the emergency reponse team!"
			return

		var/selected_role = input("Choose your ERT role") in list ("Commander", "Security", "Medical", "Engineering")
		switch(selected_role)
			// ERT_ROLE: 1 = Security, 2 = Medical, 3 = Engineering, 4 = Commander
			if("Commander")
				if(command_slots == 0)
					usr << "\red This slot has already been filled."
					return
				role_new = 4
				command_slots--
			if("Security")
				if(sec_slots == 0)
					usr << "\red This slot has already been filled."
					return
				role_new = 1
				sec_slots--
			if("Medical")
				if(medic_slots == 0)
					usr << "\red This slot has already been filled."
					return
				role_new = 2
				medic_slots--
			if("Engineering")
				if(engineer_slots == 0)
					usr << "\red This slot has already been filled."
					return
				role_new = 3
				engineer_slots--


		if(response_team_members.len > 5) usr << "The emergency response team is already full!"


		for (var/obj/effect/landmark/L in landmarks_list) if (L.name == "Commando")
			L.name = null//Reserving the place.
			var/new_name = input(usr, "Pick a name","Name") as null|text
			if(!new_name)//Somebody changed his mind, place is available again.
				L.name = "Commando"
				return


			var/leader_selected = isemptylist(response_team_members)
			var/mob/living/carbon/human/new_commando = create_response_team(L.loc, leader_selected, new_name, role_new)
			del(L)
			new_commando.mind.key = usr.key
			new_commando.key = usr.key
			new_commando.ert_role = role_new
			new_commando << "\blue You are a part of an Emergency Response Team, a type of military division under CentComm's service. There is a distress signal originating from [station_name()], you are tasked to go and fix the problem."
			new_commando << "<b>You should first gear up and discuss a plan with your team. More members may be joining, don't move out before you're ready."
			if(new_commando.ert_role != 4)
				new_commando << "<b>As member of the Emergency Response Team, you answer only to your leader and CentComm officials.</b>"
			else
				new_commando << "<b>As leader of the Emergency Response Team, you answer only to CentComm, and have authority to override the Captain where it is necessary to achieve your mission goals. It is recommended that you attempt to cooperate with the captain where possible, however."
			return

	else
		usr << "You need to be an observer or new player to use this."

// returns a number of dead players in %
proc/percentage_dead()
	var/total = 0
	var/deadcount = 0
	for(var/mob/living/carbon/human/H in mob_list)
		if(H.client) // Monkeys and mice don't have a client, amirite?
			if(H.stat == 2) deadcount++
			total++

	if(total == 0) return 0
	else return round(100 * deadcount / total)

// counts the number of antagonists in %
proc/percentage_antagonists()
	var/total = 0
	var/antagonists = 0
	for(var/mob/living/carbon/human/H in mob_list)
		if(is_special_character(H) >= 1)
			antagonists++
		total++

	if(total == 0) return 0
	else return round(100 * antagonists / total)

// Increments the ERT chance automatically, so that the later it is in the round,
// the more likely an ERT is to be able to be called.
proc/increment_ert_chance()
	while(send_emergency_team == 0) // There is no ERT at the time.
		if(get_security_level() == "green")
			ert_base_chance += 1
		if(get_security_level() == "blue")
			ert_base_chance += 2
		if(get_security_level() == "red")
			ert_base_chance += 3
		if(get_security_level() == "delta")
			ert_base_chance += 10           // Need those big guns
		sleep(600 * 3) // Minute * Number of Minutes


proc/trigger_armed_response_team(var/force = 0)
	if(!can_call_ert && !force)
		return
	if(send_emergency_team)
		return

	var/send_team_chance = ert_base_chance // Is incremented by increment_ert_chance.
	send_team_chance += 2*percentage_dead() // the more people are dead, the higher the chance
	send_team_chance += percentage_antagonists() // the more antagonists, the higher the chance
	send_team_chance = min(send_team_chance, 100)

	if(force) send_team_chance = 100

	// there's only a certain chance a team will be sent
	if(!prob(send_team_chance))
		command_announcement.Announce("It would appear that an emergency response team was requested for [station_name()]. Unfortunately, we were unable to send one at this time.", "Central Command")
		can_call_ert = 0 // Only one call per round, ladies.
		return

	command_announcement.Announce("An emergency response team is being dispatched to [station_name()] in response to a distress signal we've recieved. It will be deployed as soon as possible.", "Nanotrasen Emergency Dispatch")

	can_call_ert = 0 // Only one call per round, gentleman.
	send_emergency_team = 1

	sleep(600 * 5)
	send_emergency_team = 0 // Can no longer join the ERT.

/*	var/area/security/nuke_storage/nukeloc = locate()//To find the nuke in the vault
	var/obj/machinery/nuclearbomb/nuke = locate() in nukeloc
	if(!nuke)
		nuke = locate() in world
	var/obj/item/weapon/paper/P = new
	P.info = "Your orders, Commander, are to use all means necessary to return the station to a survivable condition.<br>To this end, you have been provided with the best tools we can give in the three areas of Medicine, Engineering, and Security. The nuclear authorization code is: <b>[ nuke ? nuke.r_code : "AHH, THE NUKE IS GONE!"]</b>. Be warned, if you detonate this without good reason, we will hold you to account for damages. Memorise this code, and then burn this message."
	P.name = "Emergency Nuclear Code, and ERT Orders"
	for (var/obj/effect/landmark/A in world)
		if (A.name == "nukecode")
			P.loc = A.loc
			del(A)
			continue
*/

/client/proc/create_response_team(obj/spawn_location, leader_selected = 0, commando_name, var/ert_role_new)

	//usr << "\red ERT has been temporarily disabled. Talk to a coder."
	//return

	var/mob/living/carbon/human/M = new(null)
	response_team_members |= M

	//todo: god damn this.
	//make it a panel, like in character creation
	var/new_facial = input("Please select facial hair color.", "Character Generation") as color
	if(new_facial)
		M.r_facial = hex2num(copytext(new_facial, 2, 4))
		M.g_facial = hex2num(copytext(new_facial, 4, 6))
		M.b_facial = hex2num(copytext(new_facial, 6, 8))

	var/new_hair = input("Please select hair color.", "Character Generation") as color
	if(new_facial)
		M.r_hair = hex2num(copytext(new_hair, 2, 4))
		M.g_hair = hex2num(copytext(new_hair, 4, 6))
		M.b_hair = hex2num(copytext(new_hair, 6, 8))

	var/new_eyes = input("Please select eye color.", "Character Generation") as color
	if(new_eyes)
		M.r_eyes = hex2num(copytext(new_eyes, 2, 4))
		M.g_eyes = hex2num(copytext(new_eyes, 4, 6))
		M.b_eyes = hex2num(copytext(new_eyes, 6, 8))

	var/new_tone = input("Please select skin tone level: 1-220 (1=albino, 35=caucasian, 150=black, 220='very' black)", "Character Generation")  as text

	if (!new_tone)
		new_tone = 35
	M.s_tone = max(min(round(text2num(new_tone)), 220), 1)
	M.s_tone =  -M.s_tone + 35

	// hair
	var/list/all_hairs = typesof(/datum/sprite_accessory/hair) - /datum/sprite_accessory/hair
	var/list/hairs = list()

	// loop through potential hairs
	for(var/x in all_hairs)
		var/datum/sprite_accessory/hair/H = new x // create new hair datum based on type x
		hairs.Add(H.name) // add hair name to hairs
		del(H) // delete the hair after it's all done

//	var/new_style = input("Please select hair style", "Character Generation")  as null|anything in hairs
//hair
	var/new_hstyle = input(usr, "Select a hair style", "Grooming")  as null|anything in hair_styles_list
	if(new_hstyle)
		M.h_style = new_hstyle

	// facial hair
	var/new_fstyle = input(usr, "Select a facial hair style", "Grooming")  as null|anything in facial_hair_styles_list
	if(new_fstyle)
		M.f_style = new_fstyle

	// if new style selected (not cancel)
/*	if (new_style)
		M.h_style = new_style

		for(var/x in all_hairs) // loop through all_hairs again. Might be slightly CPU expensive, but not significantly.
			var/datum/sprite_accessory/hair/H = new x // create new hair datum
			if(H.name == new_style)
				M.h_style = H // assign the hair_style variable a new hair datum
				break
			else
				del(H) // if hair H not used, delete. BYOND can garbage collect, but better safe than sorry

	// facial hair
	var/list/all_fhairs = typesof(/datum/sprite_accessory/facial_hair) - /datum/sprite_accessory/facial_hair
	var/list/fhairs = list()

	for(var/x in all_fhairs)
		var/datum/sprite_accessory/facial_hair/H = new x
		fhairs.Add(H.name)
		del(H)

	new_style = input("Please select facial style", "Character Generation")  as null|anything in fhairs

	if(new_style)
		M.f_style = new_style
		for(var/x in all_fhairs)
			var/datum/sprite_accessory/facial_hair/H = new x
			if(H.name == new_style)
				M.f_style = H
				break
			else
				del(H)
*/
	var/new_gender = alert(usr, "Please select gender.", "Character Generation", "Male", "Female")
	if (new_gender)
		if(new_gender == "Male")
			M.gender = MALE
		else
			M.gender = FEMALE
	//M.rebuild_appearance()
	M.update_hair()
	M.update_body()
	M.check_dna(M)

	M.real_name = commando_name
	M.name = commando_name
	M.age = !leader_selected ? rand(23,35) : rand(35,45)

	M.ert_role = ert_role_new
	M.dna.ready_dna(M)//Creates DNA.

	//Creates mind stuff.
	M.mind = new
	M.mind.current = M
	M.mind.original = M
	M.mind.assigned_role = "MODE"
	M.mind.special_role = "Response Team"
	if(!(M.mind in ticker.minds))
		ticker.minds += M.mind//Adds them to regular mind list.
	M.loc = spawn_location
	M.equip_strike_team(leader_selected)
	M.implant_loyalty(M)
	return M

/mob/living/carbon/human/proc/equip_strike_team(leader_selected = 0)

	//Special radio setup
	equip_to_slot_or_del(new /obj/item/device/radio/headset/ert(src), slot_l_ear)

	//Replaced with new ERT uniform
	equip_to_slot_or_del(new /obj/item/clothing/under/ert(src), slot_w_uniform)
	equip_to_slot_or_del(new /obj/item/clothing/shoes/swat(src), slot_shoes)
	equip_to_slot_or_del(new /obj/item/clothing/gloves/swat(src), slot_gloves)
	equip_to_slot_or_del(new /obj/item/clothing/glasses/sunglasses(src), slot_glasses)
	equip_to_slot_or_del(new /obj/item/weapon/comknife(src), slot_l_hand)
/*

	//Old ERT Uniform
	//Basic Uniform
	equip_to_slot_or_del(new /obj/item/clothing/under/syndicate/tacticool(src), slot_w_uniform)
	equip_to_slot_or_del(new /obj/item/device/flashlight(src), slot_l_store)
	equip_to_slot_or_del(new /obj/item/weapon/clipboard(src), slot_r_store)
	equip_to_slot_or_del(new /obj/item/weapon/gun/energy/gun(src), slot_belt)
	equip_to_slot_or_del(new /obj/item/clothing/mask/gas/swat(src), slot_wear_mask)

	//Glasses
	equip_to_slot_or_del(new /obj/item/clothing/glasses/sunglasses/sechud(src), slot_glasses)

	//Shoes & gloves
	equip_to_slot_or_del(new /obj/item/clothing/shoes/swat(src), slot_shoes)
	equip_to_slot_or_del(new /obj/item/clothing/gloves/swat(src), slot_gloves)

	//Removed
//	equip_to_slot_or_del(new /obj/item/clothing/suit/armor/swat(src), slot_wear_suit)
//	equip_to_slot_or_del(new /obj/item/clothing/head/helmet/space/deathsquad(src), slot_head)

	//Backpack
	equip_to_slot_or_del(new /obj/item/weapon/storage/backpack/security(src), slot_back)
	equip_to_slot_or_del(new /obj/item/weapon/storage/box/engineer(src), slot_in_backpack)
	equip_to_slot_or_del(new /obj/item/weapon/storage/firstaid/regular(src), slot_in_backpack)
*/
	var/obj/item/weapon/card/id/centcom/ERT/W = new(src)
	if(src.ert_role == 1)
		W.assignment = "Emergency Response Team Security"
		W.access = (get_centcom_access("Security"), get_all_accesses())
	if(src.ert_role == 2)
		W.assignment = "Emergency Response Team Medic"
		W.access = (get_centcom_access("Medic"), get_all_accesses())
	if(src.ert_role == 3)
		W.assignment = "Emergency Response Team Engineer"
		W.access = (get_centcom_access("Engineer"), get_all_accesses())
	if(src.ert_role == 4)
		W.assignment = "Emergency Response Team Commander"
		W.access = (get_centcom_access("Commander"), get_all_accesses())
	W.registered_name = real_name
	W.name = "[real_name]'s ID Card ([W.assignment])"
	equip_to_slot_or_del(W, slot_wear_id)

	return 1

//debug verb (That is horribly coded, LEAVE THIS OFF UNLESS PRIVATELY TESTING. Seriously.
/*client/verb/ResponseTeam()
	set category = "Admin"
	if(!send_emergency_team)
		send_emergency_team = 1*/
