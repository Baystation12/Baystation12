
/obj/item/clothing/suit/armor/special
	var/specials = list()
	var/totalshields

/obj/item/clothing/suit/armor/special/New()
	..()
	for(var/i in specials)
		specials -= i
		specials += new i (src)


/obj/item/clothing/suit/armor/special/handle_shield(mob/user, var/damage, atom/damage_source = null, mob/attacker = null, var/def_zone = null, var/attack_text = "the attack")
	for(var/datum/armourspecials/i in specials)
		return i.handle_shield(user,damage,damage_source)


/obj/item/clothing/suit/armor/special/equipped(mob/user)
	for(var/datum/armourspecials/i in specials)
		i.user = user

/obj/item/clothing/suit/armor/special/emp_act(severity)
	for(var/datum/armourspecials/i in specials)
		i.tryemp(severity)

/obj/item/clothing/suit/armor/special/dropped()
	for(var/datum/armourspecials/i in specials)
		i.user = null

/obj/item/clothing/suit/armor/special/Destroy()
	GLOB.processing_objects -= src
	for(var/item in specials)
		qdel(item)
	..()
