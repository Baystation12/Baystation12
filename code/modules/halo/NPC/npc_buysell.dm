
/mob/living/simple_animal/npc/proc/player_sell(var/obj/O, var/mob/M, var/worth, var/resell = 1)
	if(!worth)
		to_chat(M,"<span class='warning'>It's not worth your time to do that.</span>")
		return

	if(istype(O, /obj/item/weapon/storage))
		var/obj/item/weapon/storage/S = O
		for(var/obj/I in S.contents)
			S.remove_from_storage(I, src)
			if(resell)
				try_list_for_sale(I)
			else
				qdel(I)
	else
		M.drop_from_inventory(O, src)

		//add it to the trader inventory
		if(resell)
			try_list_for_sale(O)
		else
			qdel(O)

	M.visible_message("<span class='info'>[M] exchanges items with [src]</span>",\
		"<span class='info'>You give [O] to [src] who gives you a bundle of credits worth cR-[worth].</span>")
	spawn_money(worth, M.loc, M)
	src.playsound_local(src.loc, "rustle", 100, 1)

/mob/living/simple_animal/npc/proc/try_list_for_sale(var/obj/O)
	var/datum/trade_item/T = trade_items_inventory_by_type[O.type]
	if(T)
		T.quantity += 1
		T.value = round(T.value * 0.95)		//price goes down a little
		update_trade_item_ui(T)
		return 1
	return 0

/mob/living/simple_animal/npc/proc/player_buy(var/item_name, var/mob/M)
	var/datum/trade_item/D = trade_items_inventory_by_name[item_name]
	var/value = D.value
	var/obj/item/weapon/spacecash/bundle/B = M.l_hand
	if(!B || !istype(B))
		B = M.r_hand

	if(!B || !istype(B) || B.worth < value)
		var/money_phrases = list("Show me the cR-[value].","Where is the cash? cR-[value]","That's not enough, you'd be out of pocket cR-[value]","I don't do credit. That's cR-[value]")
		var/user_msg = "<span class='game say'><span class='name'>[src.name]</span> whispers to you, <span class='message emote'><span class='body'>\"[pick(money_phrases)]\"</span></span></span>"
		M.visible_message("<span class='info'>[src] whispers something to [M].</span>", user_msg)
	else
		//take the cash
		var/obj/item/weapon/spacecash/bundle/payment = B.split_off(value, M)
		payment.loc = src
		qdel(payment)

		//create the object and pass it over
		var/obj/O = new D.item_type(M.loc)
		M.put_in_hands(O)

		//update the inventory
		D.quantity -= 1
		D.value = round(D.value * 1.05)		//price goes up a little
		update_trade_item_ui(D)

		//tell the user
		M.visible_message("<span class='info'>[M] exchanges items with [src]</span>",\
			"<span class='info'>You split off cR-[value] to [src] who hands you [O].</span>")
		src.playsound_local(src.loc, "rustle", 100, 1)
