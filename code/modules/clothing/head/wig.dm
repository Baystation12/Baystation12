/obj/item/clothing/head/wig
	name = "wig"
	desc = "A stylish hairstyle, in case you don't have your own hair."
	icon = 'icons/obj/clothing/obj_head.dmi'
	icon_state = "wig"
	sprite_sheets = null
	flags_inv = BLOCKHEADHAIR
	var/datum/sprite_accessory/hair/hairstyle

/obj/item/clothing/head/wig/proc/set_hairstyle(datum/sprite_accessory/hair/new_hairstyle)
	hairstyle = new_hairstyle
	item_icons[slot_head_str] = hairstyle.icon
	item_state_slots[slot_head_str] = "[hairstyle.icon_state]_s"
	desc = "[initial(desc)] This one is mimicking a [hairstyle.name]."
	update_clothing_icon()

/obj/item/clothing/head/wig/get_mob_overlay(mob/user_mob, slot)
	var/image/ret = ..()
	if ((hairstyle.do_coloration & DO_COLORATION_USER))
		var/icon/hair_icon = icon(hairstyle.icon, "[hairstyle.icon_state]_s")
		hair_icon.Blend(color, hairstyle.blend)
		ret.AddOverlays(hair_icon)
	return ret

/obj/item/clothing/head/wig/use_tool(obj/item/tool, mob/living/user, list/click_params)
	if (istype(tool, /obj/item/haircomb))
		var/singleton/species/H = GLOB.species_by_name[SPECIES_HUMAN]
		var/list/valid_hairstyles = H.get_hair_styles()
		var/datum/sprite_accessory/hair/selected_hair = valid_hairstyles[input(user, "Choose new hair style:", "Wig") as null|anything in valid_hairstyles - "Bald"]
		if (!selected_hair)
			return TRUE
		set_hairstyle(selected_hair)
		return TRUE
	return ..()

/obj/item/clothing/head/wig/proc/loadout_setup(mob/living/carbon/human/H)
	var/singleton/species/human_species = GLOB.species_by_name[SPECIES_HUMAN]
	var/list/valid_hairstyles = human_species.get_hair_styles()
	valid_hairstyles -= "Bald"
	var/datum/sprite_accessory/hair/loadout_hairstyle = valid_hairstyles[desc]
	if (!loadout_hairstyle)
		loadout_hairstyle = valid_hairstyles[pick(valid_hairstyles)]
	if (loadout_hairstyle)
		set_hairstyle(loadout_hairstyle)
