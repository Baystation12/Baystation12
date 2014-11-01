/mob/living/carbon/human/Login()
	..()
	update_hud()
	var/mob/living/carbon/human/H = usr
	if(jobban_isbanned(usr, species))
		H.set_species("Human")
		get_id_photo(H)
	ticker.mode.update_all_synd_icons()	//This proc only sounds CPU-expensive on paper. It is O(n^2), but the outer for-loop only iterates through syndicates, which are only prsenet in nuke rounds and even when they exist, there's usually 6 of them.
	if(species) species.handle_login_special(src)
	return