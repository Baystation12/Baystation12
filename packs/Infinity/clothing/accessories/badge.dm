/obj/item/clothing/accessory/badge/dog_tags // non-solgov variant
	name = "dog tags"
	desc = "Plain identification tags made from a durable metal. They are stamped with a variety of informational details."
	gender = PLURAL
	icon_state = "tags"
	icon = 'maps/torch/icons/obj/obj_accessories_solgov.dmi'
	accessory_icons = list(slot_w_uniform_str = 'maps/torch/icons/mob/onmob_accessories_solgov.dmi', slot_wear_suit_str = 'maps/torch/icons/mob/onmob_accessories_solgov.dmi')
	badge_string = null
	slot_flags = SLOT_MASK | SLOT_TIE

/obj/item/clothing/accessory/badge/dog_tags/Initialize()
	. = ..()
	var/mob/living/carbon/human/H
	H = get_holder_of_type(src, /mob/living/carbon/human)
	if(H)
		set_name(H.real_name)
		set_desc(H)

/obj/item/clothing/accessory/badge/dog_tags/attack_self(mob/living/carbon/human/user as mob)
	.=..()
	if(!badge_string)
		var/confirm = alert("Set badges's faction as your own faction?", "Badge Choice", "Yes", "No")
		if(confirm == "No")
			var/choice = input(usr,"Choose your badge's faction","Badge Choice","") as text|null
			if(!choice)
				return
			badge_string = choice
		if(confirm == "Yes")
			var/singleton/cultural_info/faction = user.get_cultural_value(TAG_FACTION)
			badge_string = faction.name
		to_chat(user, "<span class='notice'>[src]'s faction now is '[badge_string]'.</span>")

/obj/item/clothing/accessory/badge/dog_tags/set_desc(var/mob/living/carbon/human/H)
	if(!istype(H))
		return
	var/singleton/cultural_info/culture = H.get_cultural_value(TAG_RELIGION)
	var/religion = culture ? culture.name : "Unset"
	desc = "[initial(desc)]\nName: [H.real_name] ([H.get_species()])\nReligion: [religion]\nBlood type: [H.b_type]"

/obj/item/clothing/accessory/badge/dog_tags/proc/loadout_setup(mob/M)
	set_name(M.real_name)
	set_desc(M)
