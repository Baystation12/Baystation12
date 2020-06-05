#define FACTION_CONVERSION_KITS list("UNSC" = list(/obj/item/conversion_contract/unsc,/obj/item/device/radio/headset/unsc),"Urf" = list(/obj/item/conversion_contract/innie,/obj/item/device/radio/headset/insurrection),"Covenant" = list(/obj/item/conversion_contract/cov,/obj/item/device/radio/headset/covenant))

/datum/admin_secret_item/fun_secret/convert_kit
	name = "Spawn Conversion Kit"

/datum/admin_secret_item/fun_secret/convert_kit/can_execute(var/mob/user)
	if(!ticker) return 0
	return ..()

/datum/admin_secret_item/fun_secret/convert_kit/execute(var/mob/user)

	var/kit_type = input(user, "Choose conversion kit faction","","Cancel") in FACTION_CONVERSION_KITS + list("Cancel")
	if(kit_type == "Cancel")
		return
	var/list/items_to_spawn = FACTION_CONVERSION_KITS[kit_type]
	for(var/item in items_to_spawn)
		new item (user.loc)