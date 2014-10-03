/obj/item/device/binoculars

	name = "binoculars"
	desc = "A pair of binoculars."
	icon_state = "binoculars"

	flags = FPRINT | TABLEPASS| CONDUCT
	force = 5.0
	w_class = 2.0
	throwforce = 5.0
	throw_range = 15
	throw_speed = 3

	//matter = list("metal" = 50,"glass" = 50)

	var/tileoffset = 11 //client view offset in the direction the user is facing
	var/viewsize = 12 //how far out this thing zooms. 7 is normal view

	var/zoom = 0

/obj/item/device/binoculars/dropped(mob/user)
	user.client.view = world.view
	user.client.pixel_x = 0
	user.client.pixel_y = 0



/*
This is called from
modules/mob/mob_movement.dm if you move you will be zoomed out
modules/mob/living/carbon/human/life.dm if you die, you will be zoomed out.
*/

/obj/item/device/binoculars/verb/zoom()
	set category = "Object"
	set name = "Use"
	set popup_menu = 0

	if(usr.stat || !(istype(usr,/mob/living/carbon/human)))
		usr << "You are unable to focus through the binoculars."
		return
	if(!zoom && global_hud.darkMask[1] in usr.client.screen)
		usr << "Your welding equipment gets in the way of you looking through the binoculars"
		return
	if(!zoom && usr.get_active_hand() != src)
		usr << "You are too distracted to look through the binoculars, perhaps if it was in your active hand this might work better"
		return

	if(usr.client.view == world.view)
		if(!usr.hud_used.hud_shown)
			usr.button_pressed_F12(1)	// If the user has already limited their HUD this avoids them having a HUD when they zoom in
		usr.button_pressed_F12(1)
		usr.client.view = viewsize
		zoom = 1

		var/tilesize = 32
		var/viewoffset = tilesize * tileoffset

		switch(usr.dir)
			if (NORTH)
				usr.client.pixel_x = 0
				usr.client.pixel_y = viewoffset
			if (SOUTH)
				usr.client.pixel_x = 0
				usr.client.pixel_y = -viewoffset
			if (EAST)
				usr.client.pixel_x = viewoffset
				usr.client.pixel_y = 0
			if (WEST)
				usr.client.pixel_x = -viewoffset
				usr.client.pixel_y = 0

		if(istype(usr,/mob/living/carbon/human/))
			var/mob/living/carbon/human/H = usr
			usr.visible_message("[usr] holds [src] up to [H.get_visible_gender() == MALE ? "his" : H.get_visible_gender() == FEMALE ? "her" : "their"] eyes.")
		else
			usr.visible_message("[usr] holds [src] up to its eyes.")

	else
		usr.client.view = world.view
		if(!usr.hud_used.hud_shown)
			usr.button_pressed_F12(1)
		zoom = 0

		usr.client.pixel_x = 0
		usr.client.pixel_y = 0

		usr.visible_message("[usr] lowers [src].")

	return


/obj/item/device/binoculars/attack_self(mob/user)
	zoom()