#define EDIT_SEE_INVIS 	0x1
#define EDIT_SIGHT		0x2

SUBSYSTEM_DEF(colormap)
	name = "Tonemap"
	init_order = INIT_ORDER_TONEMAP
	flags = SS_NO_FIRE
	var/decl/tone_map/current_map

//For the sake of consistency.
	var/animate_length = 5 SECONDS
	var/easing
	var/anim_flags

/datum/controller/subsystem/colormap/proc/animate_into_colormap_global(var/tonemap, animate_length, easing, anim_flags) //accepts the time, easing, and flags used in the animate proc. It's basically a wrapper for it anyways.
	if(isnull(tonemap) || !ispath(tonemap, /decl/tone_map))
		return
	current_map = decls_repository.get_decl(tonemap)
//Replace the subsystem vars with the supplied vars.
	SScolormap.animate_length = animate_length
	SScolormap.easing = easing
	SScolormap.anim_flags = anim_flags


	for(var/mob/M in GLOB.player_list)
		var/client/C = M.client
		animate(C, color = current_map.tone_map, time = animate_length, easing=easing, flags = anim_flags)
		if(!initial(C.tonemap_list))
			C.tonemap_list += current_map
	log_and_message_admins("Global tonemap set to [current_map.name].")


/client/
	var/list/tonemap_list = list(/decl/tone_map) //Keeps our tonemaps in an organized stack. //Always seems to be the same no matter what.

/mob/Login()
	..()
	if(SScolormap.current_map != initial(SScolormap.current_map))
		animate_into_colormap()

/mob/proc/animate_into_colormap(var/tonemap, animate_length, easing, anim_flags)
	var/decl/tone_map/tmap
	if(isnull(tonemap))
		tmap = SScolormap.current_map
		do_tonemap_edits(tmap)
		animate(client, color = SScolormap.current_map.tone_map, time = SScolormap.animate_length, easing = SScolormap.easing, flags = SScolormap.anim_flags)
		LAZYADD(client.tonemap_list, SScolormap.current_map) //this fails to add to the list.
	else if(ispath(tonemap, /decl/tone_map))
		tmap = decls_repository.get_decl(tonemap)
		do_tonemap_edits(tmap)
		animate(client, color = tmap.tone_map, time = animate_length, easing = easing, flags = anim_flags)
		LAZYADD(client.tonemap_list, tmap) //this fails to add to the list.

/mob/proc/animate_from_colormap(animate_length, easing, anim_flags, var/reset_to_base)
	var/decl/tone_map/final_color
	if(reset_to_base)
		final_color = decls_repository.get_decl(/decl/tone_map)
		client.tonemap_list = initial(client.tonemap_list)
	else
		client.tonemap_list.Cut(1,0)
		final_color = client.tonemap_list
		client.tonemap_list = client.color
	do_tonemap_edits(final_color)
	animate(client, color = final_color, time = animate_length, easing=easing, flags = anim_flags)

//This doesn't change anything for some reason.
/mob/proc/do_tonemap_edits(var/tonemap)
	if(!istype(tonemap, /decl/tone_map))
		return
	var/decl/tone_map/tmap = decls_repository.get_decl(tonemap)
	switch(tmap.sight_flag)
		if(EDIT_SEE_INVIS)
			see_invisible = tmap.set_to
		if(EDIT_SIGHT)
			sight = tmap.set_to
		if(null)
			see_invisible = initial(see_invisible)
			sight = initial(sight)

/decl/tone_map
	var/name = "default tonemap"
	var/tone_map = list(1,0,0,0, /**/ 0,1,0,0, /**/ 0,0,1,0, /**/ 0,0,0,1)
	var/sight_flag = null
	var/set_to = null

/decl/tone_map/sepia //Self explanitory. Slated for removal if it cannot be figured out.
	name = "sepia tonemap"
	tone_map = list(1.1,0.1,0,0, /**/ 1.1,0.1,0,0, /**/ 1.5,0.1,0,0, /**/ 0,0,0,1)

/decl/tone_map/desaturate/
	name = "low oxygen tonemap"
	tone_map = list(0.33,0.33,0.33,0, /**/ 0.33,0.33,0.33,0, /**/ 0.33,0.33,0.33,0, /**/ 0,0,0,1)

/decl/tone_map/desaturate/critical
	name = "critical oxygen tonemap"
	tone_map = list(0.33,0.11,0.33,0, /**/ 0.15,0.11,0.33,0, /**/ 0.15,0.11,0.11,0, /**/ 0,0,0,1)

/decl/tone_map/noir //Greyscale with accentuated blacks.
	name = "film-noir tonemap"
	tone_map = list(0.33,0.33,0.33,0, /**/ 0.33,0.33,0.33,0, /**/ 0.33,0.33,0.33,0, /**/ 0,0,0,1)
	sight_flag = EDIT_SEE_INVIS
	set_to = SEE_INVISIBLE_NOIRE

/decl/tone_map/sin_city //Isolate reds.
	name = "\improper Sin City tonemap"
	tone_map = list(0.8, 0.22, 0.22, 0, 0.22, 0.22, 0.22, 0, 0.22, 0.22, 0.22, 0, 0, 0, 0, 1)

/decl/tone_map/sin_city/mad_world //Same as the parent, but uses binary black and white. Extremely high contrast. Probably looks like crap.
	name = "\improper MadWorld tonemap"
	tone_map = list(1,0,0,0, /**/ 0.33,0,0.0,0, /**/ 0.33,0,0,0, /**/ 0, 0, 0, 1)

/decl/tone_map/vibrance //Saturates all colors.
	name = "vibrance tonemap"

/decl/tone_map/vibrance/red //Accentuates the reds.
	name = "accentuate-red tonemap"
	tone_map = list(1.1,1,1,0, /**/ 1.1,1,1,0, /**/ 1.1,1,1,0, /**/ 0,0,0,1)

/decl/tone_map/vibrance/green //ditto, but green.
	name = "accentuate-green tonemap"
	tone_map = list(1,1.1,1,0, /**/ 1.1,1.1,1.1,0, /**/ 1,1.1,1,0, /**/ 0,0,0,1)

/decl/tone_map/vibrance/blue //ditto, but blue.
	name = "accentuate-blue tonemap"
	tone_map = list(1,1,1.1,0, /**/  1,1,1.1,0, /**/ 1.1,1.1,1.1,0, /**/ 0,0,0,1)

/decl/tone_map/rose_glasses //Literally rose tinted glasses. Makes everything vaguely pink. Slated for removal.

/decl/tone_map/anger //World EXPLODES with red-pink.
	name = "anger tonemap"
	tone_map = list(1,0.33,0.33,0, /**/ 0.33,0.33,0.33,0, /**/ 0.33,0.33,0.33,0, /**/ 0,0,0,1)


/obj/item/tonemap_debugger
	name = "tonemap debugger"
	icon = 'icons/effects/blood.dmi'
	icon_state = "clown"

	attack_self()
		SScolormap.animate_into_colormap_global(pick(subtypesof(/decl/tone_map)), 8 SECONDS, SINE_EASING)