
/datum/game_mode/packwar

/obj/structure/kigyar_merc_console
	name = "Ram Clan Mercenary Console"
	icon = 'maps/doisac/mercenaries_console.dmi'
	icon_state = "Large Covie Holo"
	desc = "A console for contacting mercenaries"
	density = 1
	anchored = 1
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
	var/list/console_inventory = list()
	var/list/my_mercs = list()

/obj/structure/kigyar_merc_console/boulder
	name = "Boulder Clan Mercenary Hire Console"
	faction = "Boulder Clan"


/obj/structure/kigyar_merc_console/Initialize()
	..()
	return INITIALIZE_HINT_LATELOAD

/obj/structure/kigyar_merc_console/LateInitialize()
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
	my_mercs[cur_job.title] = cur_job
	mercenary_inventory.Add(list(list(\
		"title" = cur_job.title,\
		"price" = cur_job.current_merc_price,\
		"available" = cur_job.available_hires,\
		"ready" = cur_job.total_positions - cur_job.assigned_players.len,\
		"dispatched" = cur_job.assigned_players.len)))

/obj/structure/kigyar_merc_console/proc/update_merc_listing_all()
	for(var/i=1, i<=mercenary_inventory.len, i++)
		var/merc_title = mercenary_inventory[i]["title"]
		var/datum/job/packwar_merc/cur_job = my_mercs[merc_title]
		update_merc_listing_index(i, cur_job)

/obj/structure/kigyar_merc_console/proc/update_merc_listing_job(var/datum/job/packwar_merc/cur_job)
	var/found = 0
	for(var/i=1, i<=mercenary_inventory.len, i++)
		if(mercenary_inventory[i]["title"] == cur_job.title)
			found = 1
			update_merc_listing_index(i, cur_job)
			break

	if(!found)
		add_merc_listing(cur_job)

/obj/structure/kigyar_merc_console/proc/update_merc_listing_index(var/merc_index, var/datum/job/packwar_merc/cur_job)
	mercenary_inventory[merc_index]["available"] = cur_job.available_hires
	mercenary_inventory[merc_index]["price"] = cur_job.current_merc_price
	mercenary_inventory[merc_index]["ready"] = cur_job.total_positions - cur_job.assigned_players.len
	mercenary_inventory[merc_index]["dispatched"] = cur_job.assigned_players.len

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
			merc.available_hires -= 1
			merc.total_positions += 1

			//update the console menu
			update_merc_listing_job(merc)

			//tell the user
			to_chat(usr,"\icon[src]<span class='info'>Successfully hired: [mercname]</span>")
		else

			//none left
			to_chat(usr,"\icon[src]<span class='warning'>None available: [mercname]</span>")
