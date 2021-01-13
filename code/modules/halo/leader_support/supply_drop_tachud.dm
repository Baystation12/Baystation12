
/obj/item/clothing/glasses/hud/tactical
	var/support_pad_type = /obj/item/support_pad

/obj/item/clothing/glasses/hud/tactical/proc/access_support_uplink(var/mob/user)
	var/obj/item/support_pad/p = null
	if(user in GLOB.support_pads_global)
		p = GLOB.support_pads_global[user]
	else
		p = new support_pad_type
		GLOB.support_pads_global[user] = p
	p.loc = user.loc
	p.ui_interact(user)

/obj/item/clothing/glasses/hud/tactical/attack_hand(var/mob/user)
	var/mob/living/carbon/human/h = loc
	if(istype(h))
		if(h.glasses == src)
			access_support_uplink(user)
		return
	. = ..()

/obj/item/clothing/glasses/hud/tactical/covenant
	support_pad_type = /obj/item/support_pad/covenant
	
/obj/item/clothing/glasses/hud/tactical/kigyar_nv
	support_pad_type = /obj/item/support_pad/covenant