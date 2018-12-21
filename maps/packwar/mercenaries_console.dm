
/datum/game_mode/packwar

/obj/structure/kigyar_merc_console
	name = "Ram Clan Mercenary Console"
	icon = 'code/modules/halo/icons/machinery/Covenant/Covie_Obj_Stuff.dmi'
	icon_state = "Large Covie Holo"
	desc = "A console for contacting mercenaries"
	var/faction = "Ram Clan"

	/*
	var/datum/job/packwar_skirmisher/merc_murmillo
	var/datum/job/packwar_skirmisher/champion/merc_champion
	var/datum/job/packwar_jackal/merc_defender
	var/datum/job/packwar_jackal/sniper/merc_sniper
	*/

	var/list/merc_job_names = list(\
		"Mercenary - T-Voan Murmillo",\
		"Mercenary - T-Voan Champion",\
		"Mercenary - Ruutian Defender",\
		"Mercenary - Ruutian Sniper"\
		)

	var/list/mercenary_inventory = list()

/obj/structure/kigyar_merc_console/boulder
	name = "Boulder Clan Mercenary Hire Console"
	faction = "Boulder Clan"

/obj/structure/kigyar_merc_console/New()
	. = ..()

	for(var/cur_job_name in merc_job_names)
		var/datum/job/packwar_merc/cur_job = job_master.occupations_by_title["[faction] [cur_job_name]"]

		//setup interact inventory
		add_merc_listing(cur_job)

	/*
	for(var/i=1, i<=interact_inventory.len, i++)
		if(interact_inventory[i]["name"] == T.name)
			if(T.quantity > 0)
				interact_inventory[i]["quantity"] = T.quantity
				interact_inventory[i]["value"] = T.value
			else
				interact_inventory.Cut(i, i+1)
			found = 1
			break
			*/
	/*
	merc_murmillo = job_master.occupations_by_title["[faction] Clan Mercenary - T-Voan Murmillo"]
	merc_champion = job_master.occupations_by_title["[faction] Clan Mercenary - T-Voan Champion"]
	merc_defender = job_master.occupations_by_title["[faction] Clan Mercenary - Ruutian Defender"]
	merc_sniper = job_master.occupations_by_title["[faction] Clan Mercenary - Ruutian Sniper"]
	*/

//this proc does not safety check if an entry already exists
/obj/structure/kigyar_merc_console/proc/add_merc_listing(var/datum/job/packwar_merc/cur_job)
	if(cur_job.available_hires > 0)
		mercenary_inventory.Add(list(list("title" = cur_job.title, "price" = cur_job.current_merc_price, "available" = cur_job.available_hires)))

/obj/structure/kigyar_merc_console/proc/update_merc_available(var/datum/job/packwar_merc/cur_job, var/new_amount = 0, var/set_value = 0)
	if(set_value)
		cur_job.available_hires = new_amount
	else
		cur_job.available_hires += new_amount

	var/found = 0
	for(var/i=1, i<=mercenary_inventory.len, i++)
		if(mercenary_inventory[i]["title"] == cur_job.title)
			mercenary_inventory[i]["price"] = cur_job.current_merc_price
			found = 1

		if(mercenary_inventory[i]["available"] <= 0)
			mercenary_inventory.Cut(i, i+1)

		if(found)
			break

	if(!found)
		add_merc_listing(cur_job)

/obj/structure/kigyar_merc_console/proc/update_merc_price(var/datum/job/packwar_merc/cur_job)
	var/found = 0
	for(var/i=1, i<=mercenary_inventory.len, i++)
		if(mercenary_inventory[i]["title"] == cur_job.title)
			mercenary_inventory[i]["available"] = cur_job.available_hires
			found = 1

		if(mercenary_inventory[i]["available"] <= 0)
			mercenary_inventory.Cut(i, i+1)

		if(found)
			break

	if(!found)
		add_merc_listing(cur_job)

/obj/structure/kigyar_merc_console/attack_hand(var/mob/living/carbon/human/user)
	if(user && istype(user))
		ui_interact(user)

/obj/structure/kigyar_merc_console/ui_interact(mob/user, ui_key = "main", datum/nanoui/ui = null, force_open = 1, var/master_ui = null, var/datum/topic_state/state = GLOB.default_state)
	var/data[0]

	data["interact_inventory"] = mercenary_inventory
	data["carriedCash"] = check_cash(user)
	data["user"] = "\ref[user]"

	ui = GLOB.nanomanager.try_update_ui(user, src, ui_key, ui, data, force_open)
	if(!ui)
		ui = new(user, src, ui_key, "merc_console.tmpl", src.name, 500, 400, master_ui = master_ui, state = state)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)

/obj/structure/kigyar_merc_console/proc/check_cash(var/mob/living/carbon/human/M)
	var/cash_amount = 0

	//right hand
	var/obj/item/weapon/spacecash/S = M.r_hand
	if(S && istype(S) && S.currency == "gekz")
		cash_amount += S.worth

	//left hand
	S = M.l_hand
	if(S && istype(S) && S.currency == "gekz")
		cash_amount += S.worth

	return cash_amount

/obj/structure/kigyar_merc_console/proc/subtract_cash(var/cash_amount = 0, var/mob/living/carbon/human/M)

	//right hand
	var/obj/item/weapon/spacecash/S = M.r_hand
	if(S && istype(S) && S.currency == "gekz")
		var/amount_subtracted = min(cash_amount, S.worth)
		cash_amount -= amount_subtracted
		S.worth -= amount_subtracted
		S.update_icon()
		if(!S.worth)
			M.drop_from_inventory(S)

	//left hand
	S = M.l_hand
	if(S && istype(S) && S.currency == "gekz")
		var/amount_subtracted = min(cash_amount, S.worth)
		cash_amount -= amount_subtracted
		S.worth -= amount_subtracted
		S.update_icon()
		if(!S.worth)
			M.drop_from_inventory(S)

	return cash_amount

/obj/structure/kigyar_merc_console/Topic(href, href_list)

	if(href_list["hire"])
		var/mercname = href_list["hire"]
		var/mob/living/carbon/human/user = locate(href_list["user"])
		var/datum/job/packwar_merc/merc = job_master.occupations_by_title[mercname]

		//check if the user has enough money
		if(check_cash(user) < merc.current_merc_price)
			to_chat(usr,"\icon[src]<span class='warning'>Unable to afford: [mercname]. Please ensure you have enough Gekz.</span>")

		else if(merc.available_hires > 0)
			//remove the cash
			subtract_cash(merc.current_merc_price, user)

			//adjust the values
			merc.current_merc_price += merc.current_merc_price * rand(105,115) / 100	//a bit more expensive
			merc.total_positions += 1

			//update the console menu
			update_merc_available(merc, -1)
			update_merc_price(merc)

			//tell the user
			to_chat(usr,"\icon[src]<span class='info'>Successfully hired: [mercname]</span>")
		else

			//none left
			to_chat(usr,"\icon[src]<span class='warning'>None available: [mercname]</span>")
