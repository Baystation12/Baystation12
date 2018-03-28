
/obj/item/weapon_attachment
	name = "debug attachment"
	desc = "Oh boy something broke"

	w_class = ITEM_SIZE_NORMAL

	var/weapon_slot = null
	var/can_remove = 1 //Can this attachment be removed completely?

/obj/item/weapon_attachment/proc/check_attach_valid(var/obj/item/weapon/gun/gun,var/mob/user)
	if(!(weapon_slot in gun.attachment_slots))
		to_chat(user,"<span class = 'notice'>[gun.name] doesn't have a [weapon_slot] attachment point.</span>")
		return 0
	for(var/obj/item/weapon_attachment/attachment in gun.get_attachments())
		if(attachment.weapon_slot == weapon_slot)
			gun.attachment_removal(attachment)
			to_chat(user,"<span class = 'notice'>You replace [attachment.name].</span>")
			return 1
	return 1

/obj/item/weapon_attachment/proc/attach_to(var/obj/item/weapon/gun)
	gun.contents += src
	apply_attachment_effects(gun)
	gun.update_icon()

/obj/item/weapon_attachment/proc/on_attachment(var/obj/item/weapon/gun/gun,var/mob/living/carbon/human/user)
	if(!istype(user))
		return
	if(!check_attach_valid(gun,user))
		return
	to_chat(user,"<span class = 'notice'>You attach [src.name] to [gun.name]'s [weapon_slot]</span>")
	user.drop_from_inventory(src)
	attach_to(gun)

/obj/item/weapon_attachment/proc/apply_attachment_effects(var/obj/item/weapon/gun/gun)
	var/datum/attachment_profile/profile = get_attachment_profile(gun)
	var/list/attribute_mods = profile.attribute_modifications["[name]"]
	gun.slowdown_general += attribute_mods[3]

/obj/item/weapon_attachment/proc/remove_attachment_effects(var/obj/item/weapon/gun/gun)
	var/datum/attachment_profile/profile = get_attachment_profile(gun)
	var/list/attribute_mods = profile.attribute_modifications["[name]"]
	gun.slowdown_general -= attribute_mods[3]

/obj/item/weapon_attachment/proc/on_removal(var/obj/item/weapon/gun/gun)
	remove_attachment_effects(gun)
	gun.overlays.Cut()
	gun.update_icon()

/obj/item/weapon_attachment/proc/get_attachment_profile(var/obj/gun)
	for(var/p in (typesof(/datum/attachment_profile) - /datum/attachment_profile))
		var/datum/attachment_profile/profile = new p
		if(!istype(profile))
			return
		if(profile.weapon_name == initial(gun.name))
			return profile
		else
			qdel(profile)

/obj/item/weapon_attachment/proc/attachment_sprite_modify(var/obj/gun) //This proc handles all attachment sprite modification.
	var/datum/attachment_profile/profile = get_attachment_profile(gun)
	if(isnull(profile))
		return 0
	var/attachment_icon_state = profile.on_item_icon_states["[name]"]
	var/list/offsets = profile.weapon_pixel_offsets["[weapon_slot]"]
	if(isnull(attachment_icon_state) || isnull(offsets))
		return 0
	var/image/to_add = image(initial(icon),attachment_icon_state)
	to_add.pixel_x = offsets[1]
	to_add.pixel_y = offsets[2]
	gun.overlays += to_add
	return 1

#undef ATTACHMENT_BARREL
#undef ATTACHMENT_SIGHT
#undef ATTACHMENT_STOCK