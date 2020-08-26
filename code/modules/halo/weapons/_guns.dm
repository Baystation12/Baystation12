
/obj/item/weapon/gun
	var/scope_zoom_amount = 0
	var/max_zoom_amount = 0
	var/is_scope_variable = 0 //If this is set to 1, the set_scope_zoom verb will be added to the list of usable verbs.

/obj/item/weapon/gun/New()
	. = ..()
	if(is_scope_variable)
		verbs += /obj/item/weapon/gun/proc/verb_set_scope_zoom
	if(max_zoom_amount == 0 && !scope_zoom_amount == 0)
		max_zoom_amount = scope_zoom_amount

/obj/item/weapon/gun/proc/verb_set_scope_zoom()
	set name = "Set Scope Zoom"
	set category = "Weapon"
	set popup_menu = 1

	if(istype(usr,/mob/living))
		var/setzoom = input(usr,"Set Scope Zoom?","Max Zoom: [max_zoom_amount]x") as num
		set_scope_zoom(setzoom,usr)

/obj/item/weapon/gun/proc/set_scope_zoom(var/setzoom,var/mob/user) //The set zoom amount on the weapon is
	if(setzoom < 1)
		to_chat(user,"<span class = 'notice'>Zoom must be greater than or equal to 1.</span>")
		scope_zoom_amount = 1
	else if(setzoom > max_zoom_amount)
		to_chat(user,"<span class = 'notice'>Zoom must be less than or equal to [max_zoom_amount]</span>")
		scope_zoom_amount = max_zoom_amount
	else
		scope_zoom_amount = setzoom
