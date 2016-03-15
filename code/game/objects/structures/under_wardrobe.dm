/obj/structure/undies_wardrobe
	name = "underwear wardrobe"
	desc = "Holds item of clothing you shouldn't be showing off in the hallways."
	icon = 'icons/obj/closet.dmi'
	icon_state = "cabinet_closed"
	density = 1

/obj/structure/undies_wardrobe/attack_hand(var/mob/user)
	if(!human_who_can_use_underwear(user))
		user << "<span class='warning'>Sadly there's nothing in here for you to wear.</span>"
		return
	interact(user)

/obj/structure/undies_wardrobe/interact(var/mob/living/carbon/human/H)
	var/dat = list()
	dat += "<b>Underwear:</b><br>"
	for(var/datum/category_group/underwear/UWC in global_underwear.categories)
		var/datum/category_item/underwear/UWI = H.all_underwear[UWC.name]
		var/item_name = UWI ? UWI.name : "None"
		dat += "[UWC.name]: <a href='?src=\ref[src];change_underwear=[UWC.name]'>[item_name]</a> <a href='?src=\ref[src];remove_underwear=[UWC.name]'>(Remove)</a><br>"

	dat = jointext(dat)
	H << browse(dat, "window=wardrobe;size=400x200")

/obj/structure/undies_wardrobe/proc/human_who_can_use_underwear(var/mob/living/carbon/human/H)
	if(!istype(H) || !H.species || !(H.species.appearance_flags & HAS_UNDERWEAR))
		return FALSE
	return TRUE

/obj/structure/undies_wardrobe/CanUseTopic(var/user)
	if(!human_who_can_use_underwear(user))
		return STATUS_CLOSE

	return ..()

/obj/structure/undies_wardrobe/Topic(href, href_list, state)
	if(..())
		return TRUE

	var/mob/living/carbon/human/H = usr
	if(href_list["remove_underwear"])
		if(href_list["remove_underwear"] in H.all_underwear)
			H.all_underwear -= href_list["remove_underwear"]
			. = TRUE
	else if(href_list["change_underwear"])
		var/datum/category_group/underwear/UWC = global_underwear.categories_by_name[href_list["change_underwear"]]
		if(!UWC)
			return
		var/datum/category_item/underwear/selected_underwear = input(H, "Choose underwear:", "Choose underwear", H.all_underwear[UWC.name]) as null|anything in UWC.items
		if(selected_underwear && CanUseTopic(H, default_state))
			H.all_underwear[UWC.name] = selected_underwear
			. = TRUE
	if(.)
		H.update_body(1)
		interact(H)
