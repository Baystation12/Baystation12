/obj/item/weapon/gun/composite/proc/get_external_power_supply()
	return chamber.get_external_power_supply()

/obj/item/weapon/gun/composite/attack_hand(var/mob/user)
	if((src in usr) && user.get_inactive_hand() == src)
		chamber.unload_ammo(user)
	else
		return ..()
