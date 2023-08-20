/mob
	//thou shall always be able to see the Geometer of Blood
	var/image/narsimage = null
	var/image/narglow = null

/mob/proc/cultify()
	return

/mob/observer/ghost/cultify()
	if(icon_state != "ghost-narsie")
		icon = 'icons/mob/mob.dmi'
		icon_state = "ghost-narsie"
		ClearOverlays()
		set_invisibility(0)
		to_chat(src, SPAN_CLASS("sinister", "Even as a non-corporal being, you can feel Nar-Sie's presence altering you. You are now visible to everyone."))

/mob/living/cultify()
	if(iscultist(src) && client)
		var/mob/living/simple_animal/construct/harvester/C = new(get_turf(src))
		mind.transfer_to(C)
		to_chat(C, SPAN_CLASS("sinister", "The Geometer of Blood is overjoyed to be reunited with its followers, and accepts your body in sacrifice. As reward, you have been gifted with the shell of an Harvester.<br>Your tendrils can use and draw runes without need for a tome, your eyes can see beings through walls, and your mind can open any door. Use these assets to serve Nar-Sie and bring him any remaining living human in the world.<br>You can teleport yourself back to Nar-Sie along with any being under yourself at any time using your \"Harvest\" spell."))
		dust()
	else if(client)
		var/mob/observer/ghost/G = (ghostize())
		G.icon = 'icons/mob/mob.dmi'
		G.icon_state = "ghost-narsie"
		G.ClearOverlays()
		G.set_invisibility(0)
		to_chat(G, SPAN_CLASS("sinister", "You feel relieved as what's left of your soul finally escapes its prison of flesh."))
	else
		dust()

/mob/proc/see_narsie(obj/singularity/narsie/large/N, dir)
	if(N.chained)
		if(narsimage)
			qdel(narsimage)
			qdel(narglow)
		return
	if((N.z == src.z)&&(get_dist(N,src) <= (N.consume_range+10)) && !(N in view(src)))
		if(!narsimage) //Create narsimage
			narsimage = image('icons/obj/narsie.dmi',src.loc,"narsie",9,1)
			narsimage.mouse_opacity = 0
		if(!narglow) //Create narglow
			narglow = image('icons/obj/narsie.dmi',narsimage.loc,"glow-narsie",12,1)
			narglow.mouse_opacity = 0
		//Else if no dir is given, simply send them the image of narsie
		var/new_x = 32 * (N.x - src.x) + N.pixel_x
		var/new_y = 32 * (N.y - src.y) + N.pixel_y
		narsimage.pixel_x = new_x
		narsimage.pixel_y = new_y
		narglow.pixel_x = new_x
		narglow.pixel_y = new_y
		narsimage.loc = src.loc
		narglow.loc = src.loc
		//Display the new narsimage to the player
		image_to(src, narsimage)
		image_to(src, narglow)

	else
		if(narsimage)
			QDEL_NULL(narsimage)
			QDEL_NULL(narglow)
