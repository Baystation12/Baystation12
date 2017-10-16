/mob/living/deity/instantiate_hud(var/datum/hud/HUD)
	HUD.deity_hud()

/datum/hud/proc/deity_hud(ui_style = 'icons/mob/screen1_Midnight.dmi')
	src.adding = list()
	src.other = list()

	var/obj/screen/intent/deity/D = new()

	src.adding += D
	action_intent = D

	mymob.client.screen = list()
	mymob.client.screen += src.adding
	D.sync_to_mob(mymob)


/obj/screen/intent/deity
	var/list/desc_screens = list()
	screen_loc = "EAST-5:122,SOUTH:8"

/obj/screen/intent/deity/New()
	..()
	overlays += image('icons/mob/screen_phenomena.dmi', icon_state = "hud", pixel_x = -138, pixel_y = -1)

/obj/screen/intent/deity/proc/sync_to_mob(var/mob)
	var/mob/living/deity/D = mob
	for(var/i in 1 to D.control_types.len)
		var/obj/screen/S = new()
		S.name = null //Don't want them to be able to actually right click it.
		S.mouse_opacity = 0
		S.icon_state = "blank"
		desc_screens[D.control_types[i]] = S
		S.maptext_width = 128
		S.screen_loc = screen_loc
		//This sets it up right. Trust me.
		S.maptext_y = 33/2*i - i*i/2 - 10
		D.client.screen += S
		S.maptext_x = -125

	update_text()

/obj/screen/intent/deity/proc/update_text()
	if(!istype(usr, /mob/living/deity))
		return
	var/mob/living/deity/D = usr
	for(var/i in D.control_types)
		var/obj/screen/S = desc_screens[i]
		var/datum/phenomena/P = D.intent_phenomenas[intent][i]
		if(P)
			S.maptext = "<span style='font-size:7pt;font-family:Impact'><font color='#3C3612'>[P.name]</font></span>"
		else
			S.maptext = null

/obj/screen/intent/deity/Click(var/location, var/control, var/params)
	..()
	update_text()