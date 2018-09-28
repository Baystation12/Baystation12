
/datum/armourspecials/dispenseitems
	var/stored_items[0]
	var/expendedmessage //String for the message displayed when no items are left in the suit.
	var/dispensemessage //String to display when dispensing items.
	var/failmessage //String to display when dispensing fails.

/datum/armourspecials/dispenseitems/try_item_action()
	if(stored_items.len > 0)
		var/nextitem = pick(stored_items)
		if(user.put_in_active_hand(new nextitem))
			stored_items.Remove(nextitem)
			to_chat(user,"<span class ='notice'>[dispensemessage] [stored_items.len] left.</span>")
			return 1
		else if(user.put_in_inactive_hand(new nextitem))
			stored_items.Remove(nextitem)
			to_chat(user,"<span class ='notice'>[dispensemessage] [stored_items.len] left.</span>")
			return 1
		else
			to_chat(user,"<span class ='notice'>[failmessage]</span>")
			return 0
	else
		to_chat(user,"<span class = 'notice'>[expendedmessage]</span>")
		return 0

/datum/armourspecials/dispenseitems/spartanmeds
	expendedmessage = "Emergency medical supplies exhausted."
	dispensemessage = "Dispensing medical supplies..."
	failmessage = "No space in user's hands available for medical support."
	stored_items = list(/obj/item/weapon/reagent_containers/syringe/ld50_syringe/spartan,
	/obj/item/weapon/reagent_containers/syringe/ld50_syringe/spartan,
	/obj/item/weapon/reagent_containers/syringe/ld50_syringe/spartan,
	/obj/item/weapon/reagent_containers/syringe/ld50_syringe/spartan,
	/obj/item/weapon/reagent_containers/syringe/ld50_syringe/spartan,
	/obj/item/weapon/reagent_containers/syringe/ld50_syringe/spartan)
