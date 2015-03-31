/obj/structure/undies_wardrobe
	name = "underwear wardrobe"
	desc = "Holds item of clothing you shouldn't be showing off in the hallways."
	icon = 'icons/obj/closet.dmi'
	icon_state = "cabinet_closed"
	density = 1

/obj/structure/undies_wardrobe/attack_hand(mob/user as mob)
	src.add_fingerprint(user)
	var/mob/living/carbon/human/H = user
	if(!ishuman(user) || (H.species && !(H.species.flags & HAS_UNDERWEAR)))
		user << "<span class='warning'>Sadly there's nothing in here for you to wear.</span>"
		return 0

	var/utype = alert("Which section do you want to pick from?",,"Male underwear", "Female underwear", "Undershirts")
	var/list/selection
	switch(utype)
		if("Male underwear")
			selection = underwear_m
		if("Female underwear")
			selection = underwear_f
		if("Undershirts")
			selection = undershirt_t
	var/pick = input("Select the style") as null|anything in selection
	if(pick)
		if(get_dist(src,user) > 1)
			return
		if(utype == "Undershirts")
			H.undershirt = undershirt_t[pick]
		else
			H.underwear = selection[pick]
		H.update_body(1)

	return 1