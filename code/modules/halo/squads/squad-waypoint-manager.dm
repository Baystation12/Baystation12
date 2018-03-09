#define SQUAD_MANAGEMENT_OPTIONS list("Change Squad Name","Modify Waypoint Name","Modify Waypoint Icon","Delete Waypoint","Remove Squad Members","Reset Manager")
#define WAYPOINT_ICONS list("waypoint","waypointred","waypointgreen","waypointorange","waypointyellow")

/obj/item/squad_manager

	name = "Squad Waypoint Manager"
	icon = 'code/modules/halo/squads/waypoint_manager.dmi'
	icon_state = "waypoint_manager"
	w_class = ITEM_SIZE_SMALL
	var/datum/waypoint_controller/linked_controller
	var/waypoint_limit = 5

/obj/item/squad_manager/New()
	if(!linked_controller)
		linked_controller = new(src)

/obj/item/squad_manager/proc/process_waypoint_selection(var/mob/user)
	var/selected_waypoint_by_name = input(user,"Pick a waypoint to modify","Waypoint Modification Selection",null) in linked_controller.get_waypoints()
	if(isnull(selected_waypoint_by_name))
		return
	else
		return linked_controller.get_waypoint_from_name(selected_waypoint_by_name)

/obj/item/squad_manager/proc/process_squad_management_option(var/option,var/mob/user)
	var/new_value
	if(option == "Change Squad Name")
		new_value = input(user,"Enter the new squad name.","Squad name selection",linked_controller.squad_name)
		linked_controller.squad_name = new_value
	else if(option == "Modify Waypoint Name")
		var/obj/effect/waypoint_holder/selected_waypoint = process_waypoint_selection(user)
		if(isnull(selected_waypoint))
			return
		new_value = input(user,"Enter the new waypoint name.","Waypoint Name Selection",selected_waypoint.waypoint_name)
		linked_controller.inform_waypoint_modification(selected_waypoint,0,new_value)
		selected_waypoint.waypoint_name = new_value
	else if(option == "Modify Waypoint Icon")
		var/obj/effect/waypoint_holder/selected_waypoint = process_waypoint_selection(user)
		if(isnull(selected_waypoint))
			return
		new_value = input(user,"Choose a new waypoint icon","Waypoint Icon Selection",selected_waypoint.waypoint_icon) in WAYPOINT_ICONS
		selected_waypoint.waypoint_icon = new_value
	else if(option == "Delete Waypoint")
		new_value = input(user,"Select a waypoint to delete","Waypoint Deletion",null) in linked_controller.get_waypoints() + list("Cancel")
		if(isnull(new_value) || new_value == "Cancel")
			return
		else
			var/obj/effect/waypoint_holder/waypoint_to_delete = linked_controller.get_waypoint_from_name(new_value)
			to_chat(user,"<span class = 'warning'>Waypoint [waypoint_to_delete.waypoint_name] deleted.</span>")
			linked_controller.delete_waypoint(waypoint_to_delete)
	else if(option == "Remove Squad Members")
		var/list/devices = linked_controller.linked_devices.Copy()
		var/list/device_wearers = list()
		for(var/obj/item/device in devices)
			if(ismob(device.loc))
				device_wearers += device.loc
			else
				devices -= device
		new_value = input(user,"Select a squad member to remove","Squad member removal") in device_wearers + list("Cancel")
		if(isnull(new_value) || new_value == "Cancel")
			return
		to_chat(new_value,"<span class = 'warning'>You have been removed from [linked_controller.squad_name].</span>")
		var/obj/item/clothing/glasses/hud/tactical/device = devices[device_wearers.Find(new_value)]
		linked_controller.linked_devices -= device
		device.update_known_waypoints(list())
	else if(option == "Reset Manager")
		if(linked_controller.controller_manager_device == src)
			linked_controller.cole_protocol()
		linked_controller = new(src)

/obj/item/squad_manager/proc/squad_management_options(var/mob/user)
	var/management_option = input(user,"Pick a squad management option.","Squad Management","Cancel") in SQUAD_MANAGEMENT_OPTIONS + list("Cancel")
	if(management_option != "Cancel")
		process_squad_management_option(management_option,user)

/obj/item/squad_manager/attack_self(var/mob/user)
	squad_management_options(user)

/obj/item/squad_manager/afterattack(var/atom/A,var/mob/user,var/is_adjacent)
	if(!linked_controller)
		to_chat(user,"<span class = 'warning'>Internally linked waypoint manager absent. Please report this to the coders.</span>")
		return
	var/list/waypoint_names_list = linked_controller.get_waypoints()
	if(waypoint_names_list.len >= waypoint_limit)
		to_chat(user,"<span class = 'warning'>Maximum waypoint count reached.</span>")
		return
	if(is_adjacent && (ishuman(A) || istype(A,/obj/item/clothing/glasses/hud/tactical) || istype(A, /obj/item/squad_manager)))
		if(ishuman(A))
			var/mob/living/carbon/human/h = A
			var/obj/item/clothing/glasses/hud/tactical/glasses = h.glasses
			if(istype(glasses))
				linked_controller.linked_devices += glasses
				to_chat(h,"<span class = 'notice'>You have been added to [linked_controller.squad_name]</span>")
		else if(istype(A,/obj/item/clothing/glasses/hud/tactical))
			linked_controller.linked_devices += A
			to_chat(user,"<span class = 'notice'>[A.name] added to linker.</span>")
		else if(istype(A,/obj/item/squad_manager) && (A != src))
			var/obj/item/squad_manager/manager = A
			linked_controller.cole_protocol()
			linked_controller = manager.linked_controller
			to_chat(user,"<span class = 'notice'>[name] linked to [manager.name]'s internal controller.</span>")
	else
		var/turf/turf_to_use
		if(isturf(A))
			turf_to_use = A
		else
			turf_to_use = A.loc
		linked_controller.create_waypoint(turf_to_use,user)
		linked_controller.update_linked_waypoint_locations()
