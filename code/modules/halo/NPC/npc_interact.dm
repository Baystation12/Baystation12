
/mob/living/simple_animal/npc/verb/interact()
	set src in view(1)
	set name = "Interact with NPC"
	set category = "NPC"

	attack_hand(usr)

/mob/living/simple_animal/npc/attack_hand(var/mob/living/user)
	if(user && istype(user) && can_use(user))
		if(interacting_mob && !can_use(interacting_mob))
			interacting_mob = null
		if(interacting_mob && interacting_mob != user)
			to_chat(user, "[src] is already dealing with [interacting_mob]!")
		else
			add_fingerprint(user)
			user.set_machine(src)
			interacting_mob = user
			ui_interact(user)

/mob/living/simple_animal/npc/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1)

	if(!can_use(user))
		if(ui)
			ui.close()
			interacting_mob = null
		return

	wander = 0
	/*spawn(600)
		wander = 1
		interacting_mob = null*/
	src.dir = get_dir(src, user)

	var/data[0]
	data["npc_name"] = src.name
	data["interact_icon"] = interact_icon

	data["interact_inventory"] = interact_inventory

	var/mob/living/carbon/M = user

	if(M.l_hand)
		data["l_hand"] = M.l_hand
		data["l_hand_icon"] = getFlatIcon(M.l_hand)
		data["l_hand_worth"] = round(get_trade_value(M.l_hand) * 0.9)	//always rebuy for less due to depreciation
		if(check_tradeable(M.l_hand))
			data["l_sellable"] = 1
		else
			data["l_sellable"] = -1
	else
		data["l_hand"] = "empty"
		data["l_hand_icon"] = ""
		data["l_hand_worth"] = "0"
		data["l_sellable"] = 0

	if(M.r_hand)
		data["r_hand"] = M.r_hand
		data["r_hand_icon"] = getFlatIcon(M.r_hand)
		data["r_hand_worth"] = round(get_trade_value(M.r_hand) * 0.9)	//always rebuy for less due to depreciation
		if(check_tradeable(M.r_hand))
			data["r_sellable"] = 1
		else
			data["r_sellable"] = -1
	else
		data["r_hand"] = "empty"
		data["r_hand_icon"] = ""
		data["r_hand_worth"] = "0"
		data["r_sellable"] = 0

	data["l_is_bag"] = 0
	if(istype(M.l_hand, /obj/item/weapon/storage))
		data["l_is_bag"] = 1
	data["r_is_bag"] = 0
	if(istype(M.r_hand, /obj/item/weapon/storage))
		data["r_is_bag"] = 1

	data["user"] = "\ref[user]"

	ui = GLOB.nanomanager.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "npc.tmpl", "Talking to [src.name]", 800, 600)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)

/mob/living/simple_animal/npc/Topic(href, href_list)
	if(href_list["sell_item_l"])
		var/mob/living/carbon/M = locate(href_list["user"])
		if(M && istype(M))
			var/obj/O = M.l_hand
			var/worth = text2num(href_list["worth"])
			player_sell(O, M, worth)

	if(href_list["sell_item_r"])
		var/mob/living/carbon/M = locate(href_list["user"])
		if(M && istype(M))
			var/obj/O = M.r_hand
			var/worth = text2num(href_list["worth"])
			player_sell(O, M, worth)

	if(href_list["buy_item"])
		var/mob/living/carbon/M = locate(href_list["user"])
		if(M && istype(M))
			var/item_name = href_list["buy_item"]
			player_buy(item_name, M)
