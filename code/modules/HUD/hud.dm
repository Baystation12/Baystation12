/mob
	var/hud_type = /datum/mob_hud
	var/datum/mob_hud/hud

/mob/Login()
	..()
	if(hud)
		qdel(hud)
	hud = new hud_type(src)

/datum/mob_hud
	var/mob/my_mob

	var/list/obj/screen/hud_image/hud_images = list()

/datum/mob_hud/New(var/mob/master)
	my_mob = master
	set_up()

/datum/mob_hud/Destroy()
	for(var/H in hud_images)
		qdel(H)
	..()

/datum/mob_hud/proc/set_up()
	if(!my_mob.client)
		return

	var/ui_style = ui_style2icon(my_mob.client.prefs.UI_style)
	var/ui_color = my_mob.client.prefs.UI_style_color
	var/ui_alpha = my_mob.client.prefs.UI_style_alpha

	prepare(ui_style, ui_color, ui_alpha)
	update()
	show_to_mob()

/datum/mob_hud/proc/prepare(var/ui_style, var/ui_color, var/ui_alpha)
	return

/datum/mob_hud/proc/update()
	for(var/H in hud_images)
		var/obj/screen/hud_image/hud_image = H
		hud_image.update(my_mob)
	return

/datum/mob_hud/proc/show_to_mob()
	for(var/H in hud_images)
		my_mob.client.screen += H
	return
