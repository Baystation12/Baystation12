
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

/obj/item/clothing/suit/armor/special/attackby(atom/A, mob/user, var/click_params)
	if(istype(A,/obj/item/device/armour_ability))
		var/obj/item/device/armour_ability/upgrade = A
		if(src.type in upgrade.accepted_armour_types)
			var/do_install = 0
			if(!installed_upgrade)
				do_install = 1
			else
				if(alert("[src] already has installed [installed_upgrade]","Armour upgrade conflict","Replace","Cancel") == "Replace")
					if(do_after(user, 30))
						to_chat(user,"<span class='notice'>You remove \icon[installed_upgrade] [installed_upgrade] from \icon[src] [src]</span>")
						var/datum/armourspecials/oldarmourspecials = installed_upgrade.armourspecials
						oldarmourspecials.on_drop(src)
						installed_upgrade.loc = get_turf(src)
						specials.Remove(installed_upgrade.armourspecials)
						qdel(installed_upgrade.armourspecials)
						do_install = 1

			if(do_install && do_after(user, 30))
				var/datum/armourspecials/newarmourspecials = new upgrade.armourspecials_type(src)
				specials.Add(newarmourspecials)
				if(istype(src.loc, /mob))
					newarmourspecials.on_equip(src)
				user.drop_from_inventory(upgrade, src)
				installed_upgrade = upgrade
				installed_upgrade.armourspecials = newarmourspecials
				to_chat(user,"<span class='info'>You install \icon[upgrade] [upgrade] into \icon[src] [src]!</span>")
		else
			to_chat(user,"<span class='warning'>Your armour cannot accept this upgrade!</span>")
	else
		. = ..()

/obj/item/clothing/suit/armor/special/examine(var/mob/examiner)
	. = ..()
	if(installed_upgrade)
		to_chat(examiner,"<span class = 'info'>It has [installed_upgrade] installed.</span>")

/obj/item/device/armour_ability/spartan
	accepted_armour_types = list(/obj/item/clothing/suit/armor/special/spartan)

/obj/item/device/armour_ability/spartan/holo
	name = "Mjolnir Holo Decoy"
	icon_state = "ability_blue"
	armourspecials_type = /datum/armourspecials/holo_decoy

/obj/item/device/armour_ability/spartan/cloak
	name = "Mjolnir Cloaking"
	icon_state = "ability_black"
	armourspecials_type = /datum/armourspecials/cloaking/limited

/obj/item/device/armour_ability/spartan/regen
	name = "Mjolnir Regeneration"
	icon_state = "ability_green"
	armourspecials_type = /datum/armourspecials/regeneration

/obj/item/device/armour_ability/spartan/overshield
	name = "Mjolnir Overshield"
	icon_state = "ability_yellow"
	armourspecials_type = /datum/armourspecials/overshield

/obj/item/device/armour_ability/spartan/strength
	name = "Mjolnir Strength"
	icon_state = "ability_red"
	armourspecials_type = /datum/armourspecials/superstrength

/obj/item/device/armour_ability/spartan/speed
	name = "Mjolnir Speed"
	icon_state = "ability_orange"
	armourspecials_type = /datum/armourspecials/superspeed
