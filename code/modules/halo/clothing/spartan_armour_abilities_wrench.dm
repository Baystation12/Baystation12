
/obj/item/weapon/wrench/mjolnir
	name = "Mjolnir wrench"
	desc = "For uninstalling ability upgrades from Mjolnir armour."

/obj/item/weapon/wrench/mjolnir/afterattack(var/atom/target,var/mob/user,adjacent,var/clickparams)
	var/obj/item/clothing/suit/armor/special/target_armour = target
	if(istype(target_armour))
		if(target_armour.installed_upgrade)
			if(do_after(user, 30))
				to_chat(user,"<span class='info'>You remove \icon[target_armour.installed_upgrade] [target_armour.installed_upgrade] from \icon[target_armour] [target_armour].</span>")
				var/datum/armourspecials/oldarmourspecials = target_armour.installed_upgrade.armourspecials
				oldarmourspecials.on_drop(target_armour.installed_upgrade.armourspecials)
				target_armour.installed_upgrade.loc = get_turf(src)
				target_armour.specials.Remove(target_armour.installed_upgrade.armourspecials)
				qdel(target_armour.installed_upgrade.armourspecials)
				target_armour.installed_upgrade = null
		else
			to_chat(user, "<span class='notice'>There is no ability upgrades installed in \icon[target_armour] [target_armour].</span>")
