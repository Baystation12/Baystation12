
/obj/item/device/armour_ability
	name = "Armour ability upgrade"
	desc = "Insert this module into certain types of armour to gain an upgraded ability."
	icon = 'spartan_gear.dmi'
	icon_state = "ability_blue"
	var/list/accepted_armour_types = list()
	var/armourspecials_type
	var/datum/armourspecials/armourspecials

/obj/item/clothing/suit/armor/special
	var/obj/item/device/armour_ability/installed_upgrade

/obj/item/device/armour_ability/afterattack(var/atom/target,var/mob/user,adjacent,var/clickparams)
	if(target.type in accepted_armour_types)
		var/do_install = 0
		var/obj/item/clothing/suit/armor/special/target_armour = target
		if(!target_armour.installed_upgrade)
			do_install = 1
		else
			to_chat(user,"<span class='notice'>\icon[target_armour] [target_armour] already has \icon[target_armour.installed_upgrade] [target_armour.installed_upgrade] installed!</span>")
			//uncomment this to allow ability hotswapping
			/*
			if(alert("[src] already has installed [installed_upgrade]","Armour upgrade conflict","Replace","Cancel") == "Replace")
				if(do_after(user, 30))
					to_chat(user,"<span class='notice'>You remove \icon[installed_upgrade] [installed_upgrade] from \icon[src] [src]</span>")
					var/datum/armourspecials/oldarmourspecials = installed_upgrade.armourspecials
					oldarmourspecials.on_drop(src)
					installed_upgrade.loc = get_turf(src)
					specials.Remove(installed_upgrade.armourspecials)
					qdel(installed_upgrade.armourspecials)
					do_install = 1
					*/

		if(do_install && do_after(user, 30))
			var/datum/armourspecials/newarmourspecials = new armourspecials_type(target_armour)
			target_armour.specials.Add(newarmourspecials)
			if(istype(target_armour.loc, /mob))
				newarmourspecials.on_equip(target_armour)
			user.drop_from_inventory(src, target_armour)
			target_armour.installed_upgrade = src
			target_armour.installed_upgrade.armourspecials = newarmourspecials
			to_chat(user,"<span class='info'>You install \icon[src] [src] into \icon[target_armour] [target_armour]!</span>")
	else
		to_chat(user,"<span class='warning'>Your armour cannot accept this upgrade!</span>")


/obj/item/clothing/suit/armor/special/examine(var/mob/examiner)
	. = ..()
	if(installed_upgrade)
		to_chat(examiner,"<span class = 'info'>It has \icon[installed_upgrade] [installed_upgrade] installed.</span>")
