
/datum/armourspecials/overshield

/datum/armourspecials/overshield/New(var/obj/item/clothing/suit/armor/special/armour)
	. = ..()

	//check if the shield has been created
	var/datum/armourspecials/shields/shields = locate() in armour.specials
	if(!shields)
		//check if it is going to be created
		var/list/specials_list = armour.specials
		var/shield_type
		var/index = specials_list.Find(/datum/armourspecials/shields)
		if(index)
			shield_type = specials_list[index]
		else
			//if its not there, just pick basic shields
			shield_type = /datum/armourspecials/shields

		//create it now
		specials_list -= shield_type
		specials_list += new shield_type(armour)

	//give it double strength or 100, whichever is greater
	if(shields)
		shields.totalshields = max(shields.totalshields * 2, 100)

	//begin recharging
	shields.reset_recharge()
