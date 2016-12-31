// Base type, do not use.
/obj/structure/lift
	name = "turbolift control component"
	icon = 'icons/obj/turbolift.dmi'
	anchored = 1
	density = 0
	plane = OBJ_PLANE
	layer = ABOVE_OBJ_LAYER

	var/datum/turbolift/lift

/obj/structure/lift/set_dir(var/newdir)
	. = ..()
	pixel_x = 0
	pixel_y = 0
	if(dir & NORTH)
		pixel_y = -32
	else if(dir & SOUTH)
		pixel_y = 32
	else if(dir & EAST)
		pixel_x = -32
	else if(dir & WEST)
		pixel_x = 32

/obj/structure/lift/proc/pressed(var/mob/user)
	if(!istype(user, /mob/living/silicon))
		if(user.a_intent == I_HURT)
			user.visible_message("<span class='danger'>\The [user] hammers on the lift button!</span>")
		else
			user.visible_message("<span class='notice'>\The [user] presses the lift button.</span>")


/obj/structure/lift/New(var/newloc, var/datum/turbolift/_lift)
	lift = _lift
	return ..(newloc)

/obj/structure/lift/attack_ai(var/mob/user)
	return attack_hand(user)

/obj/structure/lift/attack_generic(var/mob/user)
	return attack_hand(user)

/obj/structure/lift/attack_hand(var/mob/user)
	return interact(user)

/obj/structure/lift/interact(var/mob/user)
	if(!lift.is_functional())
		return 0
	return 1
// End base.

// Button. No HTML interface, just calls the associated lift to its floor.
/obj/structure/lift/button
	name = "elevator button"
	desc = "A call button for an elevator. Be sure to hit it three hundred times."
	icon_state = "button"
	var/light_up = FALSE
	var/datum/turbolift_floor/floor

/obj/structure/lift/button/proc/reset()
	light_up = FALSE
	update_icon()

/obj/structure/lift/button/interact(var/mob/user)
	if(!..())
		return
	light_up()
	pressed(user)
	if(floor == lift.current_floor)
		spawn(3)
			reset()
		return
	lift.queue_move_to(floor)

/obj/structure/lift/button/proc/light_up()
	light_up = TRUE
	update_icon()

/obj/structure/lift/button/update_icon()
	if(light_up)
		icon_state = "button_lit"
	else
		icon_state = initial(icon_state)

// End button.

// Panel. Lists floors (HTML), moves with the elevator, schedules a move to a given floor.
/obj/structure/lift/panel
	name = "elevator control panel"
	icon_state = "panel"


/obj/structure/lift/panel/attack_ghost(var/mob/user)
	return interact(user)

/obj/structure/lift/panel/interact(var/mob/user)
	if(!..())
		return

	var/dat = list()
	dat += "<html><body><hr><b>Lift panel</b><hr>"

	//the floors list stores levels in order of increasing Z
	//therefore, to display upper levels at the top of the menu and
	//lower levels at the bottom, we need to go through the list in reverse
	for(var/i in lift.floors.len to 1 step -1)
		var/datum/turbolift_floor/floor = lift.floors[i]
		var/area/A = locate(floor.area_ref)
		dat += "<font color = '[(floor in lift.queued_floors) ? COLOR_YELLOW : COLOR_WHITE]'>"
		dat += "<a href='?src=\ref[src];move_to_floor=["\ref[floor]"]'>Level #[i]</a>: [A.name]</font><br>"

	dat += "<hr>"
	if(lift.doors_are_open())
		dat += "<a href='?src=\ref[src];close_doors=1'>Close Doors</a><br>"
	else
		dat += "<a href='?src=\ref[src];open_doors=1'>Open Doors</a><br>"
	dat += "<a href='?src=\ref[src];emergency_stop=1'>Emergency Stop</a>"
	dat += "<hr></body></html>"

	var/datum/browser/popup = new(user, "turbolift_panel", "Lift Panel", 200, 260)
	popup.set_content(jointext(dat, null))
	popup.open()
	return

/obj/structure/lift/panel/Topic(href, href_list)
	. = ..()
	if(.)
		return

	var/panel_interact
	if(href_list["move_to_floor"])
		lift.queue_move_to(locate(href_list["move_to_floor"]))
		panel_interact = 1
	if(href_list["open_doors"])
		panel_interact = 1
		lift.open_doors()
	if(href_list["close_doors"])
		panel_interact = 1
		lift.close_doors()
	if(href_list["emergency_stop"])
		panel_interact = 1
		lift.emergency_stop()

	if(panel_interact)
		pressed(usr)

	return 0

// End panel.