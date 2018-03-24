
/obj/item/clothing/glasses/hud/tactical
	name = "Tactical Hud"
	desc = "Provides vital tactical information."
	icon = 'code/modules/halo/squads/hud_glasses.dmi'
	icon_state = "hud_visor"
	var/list/known_waypoints = list()
	var/list/waypoint_pointers = list()
	armor = list(melee = 5, bullet = 5, laser = 0, energy = 0, bomb = 5, bio = 0, rad = 0)

/obj/item/clothing/glasses/hud/tactical/proc/get_loc_used()
	if(!isturf(loc))
		return loc.loc
	else
		return loc

/obj/item/clothing/glasses/hud/tactical/proc/update_known_waypoints(var/list/new_waypoint_list)
	known_waypoints = new_waypoint_list.Copy()
	process_hud()

/obj/item/clothing/glasses/hud/tactical/proc/remove_all_pointers(var/mob/user)
	if(!user.client)
		return
	for(var/pointer in waypoint_pointers)
		waypoint_pointers -= pointer
		user.client.screen -= pointer
		qdel(pointer)

/obj/item/clothing/glasses/hud/tactical/proc/process_hud_pointers() //This is for directional pointers around the character, for waypoints off-screen.
	var/mob/user = loc
	if(!istype(user))
		return
	remove_all_pointers(user)
	for(var/obj/effect/waypoint_holder/waypoint in known_waypoints)
		if(waypoint in view(world.view,get_loc_used()))
			process_visible_marker(waypoint,user)
			continue
		var/dir_to_point = get_dir(get_loc_used(),waypoint)
		var/turf/waypoint_render_loc = get_step(get_loc_used(),dir_to_point)
		var/image/pointer = image(waypoint.icon,waypoint_render_loc,waypoint.waypoint_icon,,dir_to_point)
		pointer.name = waypoint.waypoint_name
		pointer.plane = HUD_PLANE
		pointer.layer = HUD_ABOVE_ITEM_LAYER
		waypoint_pointers += pointer
		user << pointer

/obj/item/clothing/glasses/hud/tactical/proc/process_visible_marker(var/obj/effect/waypoint_holder/waypoint,var/mob/user) //This is for waypoints the player can currently see on-screen
	var/image/pointer = image(waypoint.icon,waypoint.loc,"[waypoint.waypoint_icon]_onscreen")
	pointer.name = waypoint.waypoint_name
	pointer.plane = HUD_PLANE
	pointer.layer = HUD_ABOVE_ITEM_LAYER
	waypoint_pointers += pointer
	user << pointer

/obj/item/clothing/glasses/hud/tactical/process_hud()
	process_hud_pointers()
