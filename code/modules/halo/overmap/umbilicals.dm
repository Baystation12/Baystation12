#define UMBI_CROSS_DELAY 3 SECONDS

/obj/docking_umbilical
	name = "Docking Umbilical"
	desc = "Connects to nearby ships"

	icon = 'code/modules/halo/icons/overmap/umbilical_full.dmi'
	icon_state = "umbi_contracted"
	plane = ABOVE_HUMAN_PLANE
	layer = ABOVE_HUMAN_LAYER

	opacity = 1
	density = 1
	anchored = 1
	pixel_x = -32
	var/side = null //NORTH SOUTH EAST WEST are valid values for this. Setting this causes side-restrictions to apply
	var/obj/effect/overmap/our_ship
	var/broke = -1 //Use -1 to stop breaking.
	//var/id = "CHANGE ME OR SUFFER!" //ID currently not used?
	var/obj/docking_umbilical/current_connected

/obj/docking_umbilical/New()
	. = ..()
	if(initial(broke) == -1)
		broke = FALSE
	GLOB.processing_objects += src

/obj/docking_umbilical/proc/ship_setup()
	our_ship = map_sectors["[z]"]
	if(!isnull(our_ship))
		our_ship.connectors += src

/obj/docking_umbilical/LateInitialize()
	. = ..()
	if(!GLOB.using_map.use_overmap)
		return INITIALIZE_HINT_QDEL

/obj/docking_umbilical/process()
	if(isnull(our_ship))
		ship_setup()
		GLOB.processing_objects -= src

/obj/docking_umbilical/proc/visual_umbi_change(var/contract = 0,var/no_message = 0)
	if(contract == 1)
		icon_state = "umbi_contracted"
		flick("umbi_contract",src)
		if(!no_message)
			visible_message("<span class = 'notice'>[src] disconnects from [current_connected.our_ship.name] and starts contracting.</span>")
	else
		icon_state = "umbi_extended"
		flick("umbi_extend",src)
		if(!no_message)
			visible_message("<span class = 'notice'>[src] starts extending towards [current_connected.our_ship.name].</span>")

/obj/docking_umbilical/verb/cross_umbilical_verb()
	set name = "Cross Umbilical"
	set category = "Object"
	set src in view(1)

	cross_umbilical(usr)

/obj/docking_umbilical/proc/cross_umbilical(var/mob/user,var/mob/loader = null)
	if(!istype(user))
		return

	if(!current_connected)
		to_chat(user,"<span class = 'notice'>[src] is not connected to anything.</span>")
		return
	if(!isturf(loc))
		return
	if(!isturf(current_connected.loc))
		return
	user.forceMove(loc)
	if(loader)
		loader.visible_message("<span class = 'notice'>[loader] starts pushing [user] through [src]\'s airlock.</span>")
	else
		user.visible_message("<span class = 'notice'>[user] starts climbing through [src]\'s airlock...</span>")
	if(loader)
		if(!do_after(loader,UMBI_CROSS_DELAY,user))
			return
	else
		if(!do_after(user,UMBI_CROSS_DELAY,src))
			return
	if(!src.Adjacent(user) || !(user.loc = loc))
		return
	if(loader)
		loader.visible_message("<span class = 'notice'>[loader] pushes [user] through [src]\'s airlock.</span>")
	else
		user.visible_message("<span class = 'notice'>[user] climbs through [src]\'s airlock.</span>")
	translate_obj(user)

/obj/docking_umbilical/proc/translate_obj(var/obj/to_move)
	if(!isturf(current_connected.loc))
		return
	to_move.forceMove(current_connected.loc)

/obj/docking_umbilical/MouseDrop(var/obj/over_object)
	var/mob/user = usr
	if(!istype(over_object,/obj)) return
	if(istype(over_object,/obj/vehicles) || istype(over_object,/obj/mecha)) return //Yeah no vehicles-through-umbilical thanks. use a dropship.
	if(over_object.anchored) return
	if(!Adjacent(user) || !user.Adjacent(over_object)) return
	user.visible_message("<span class = 'notice'>[user] starts loading [over_object] through [src]\'s airlock.</span>")
	if(!do_after(user,UMBI_CROSS_DELAY,over_object))
		return
	user.visible_message("<span class = 'notice'>[user] loads [over_object] into [src].</span>")
	translate_obj(over_object)

/obj/docking_umbilical/attackby(var/obj/item/grab/I, var/mob/user)
	if(!istype(I))
		return
	cross_umbilical(I.affecting,user)

/obj/docking_umbilical/proc/check_dir_compatible(var/obj/docking_umbilical/umbi)
	if(isnull(side) || isnull(umbi.side)) //Null value means either we or they don't care about sides.
		return 1
	if((side == NORTH && umbi.side == SOUTH) || (side == SOUTH && umbi.side == NORTH))
		return 1
	if((side == EAST && umbi.side == WEST) || (side == WEST && umbi.side == EAST)) //Splitting these up for the sake of readability.
		return 1
	return 0

/obj/docking_umbilical/proc/get_all_umbis(var/obj/effect/overmap/connect_to)
	var/list/valid_umbis = list()
	for(var/obj/docking_umbilical/other_umbi in connect_to.connectors)
		if(isnull(other_umbi.current_connected) && (!other_umbi.broke) && check_dir_compatible(other_umbi))
			valid_umbis += other_umbi
	return valid_umbis

/obj/docking_umbilical/proc/get_player_picked_umbi(var/obj/effect/overmap/connect_to,var/mob/user)
	var/list/umbi_name_assoc = list()
	for(var/obj/umbi in get_all_umbis(connect_to))
		umbi_name_assoc += "[umbi.name]"
		umbi_name_assoc["[umbi.name]"] = umbi
	var/umbi_name_picked = input(user,"Attachment point selection.","Select an attachment point","Cancel") in umbi_name_assoc + list("Cancel")
	if(umbi_name_picked == "Cancel")
		return null
	return umbi_name_assoc[umbi_name_picked]

/obj/docking_umbilical/proc/connect(var/obj/effect/overmap/connect_to,var/mob/user,var/random_connect = 0)
	if(istype(connect_to,/obj/effect/overmap/ship/npc_ship))
		var/obj/effect/overmap/ship/npc_ship/ship = connect_to
		if(!ship.can_board())
			to_chat(user,"<span class = 'notice'>[ship] is too functional to force a umbilical connection.</span>")
			return
		ship.load_mapfile()
	var/obj/docking_umbilical/umbi //This will be the umbilical we connect to.
	if(random_connect)
		umbi = pick(get_all_umbis(connect_to))
	else
		umbi = get_player_picked_umbi(connect_to,user)
		if(isnull(umbi))
			to_chat(user,"<span class = 'notice'>Connection point selection cancelled.</span>")
			return
	if(umbi)
		current_connected = umbi
		visual_umbi_change()
		umbi.current_connected = src
		umbi.visual_umbi_change()
	else
		visible_message("<span class = 'notice'>[src] beeps a message: \"No valid connection points. Repositioning may reveal more connection points.\"</span>")

/obj/docking_umbilical/proc/disconnect(var/mob/user)
	if(isnull(current_connected))
		return
	var/confirm = alert(user,"Are you sure you want to disconnect from [current_connected.name] on [current_connected.our_ship.name]?",,"Yes","No")
	if(isnull(confirm) || (confirm != "Yes"))
		return
	current_connected.visual_umbi_change(1)
	current_connected.current_connected = null
	visual_umbi_change(1)
	current_connected = null

/obj/docking_umbilical/proc/pick_entity_connect_disconnect(var/mob/user)
	if(broke)
		to_chat(user,"<span class = 'warning'>[src] is broken!</span>")
		return
	if(current_connected)
		disconnect(user)
	else
		var/obj/effect/overmap/entity_connect = get_player_connect_to_choice(user)
		if(!entity_connect)
			return
		connect(entity_connect,user)

/obj/docking_umbilical/proc/get_player_connect_to_choice(var/mob/user)
	var/list/overmap_name_assoc = list()
	var/list/objs_in_view = view(1,our_ship) - our_ship
	if(!objs_in_view || !objs_in_view.len)
		to_chat(user,"<span class = 'notice'>No entities in view.</span>")
		return
	for(var/obj/effect/overmap/obj in objs_in_view) //We should probably remove our ship from this selection.
		overmap_name_assoc += "[obj.name]"
		overmap_name_assoc["[obj.name]"] = obj
	var/overmap_name_picked = input(user,"Entity connection selection.","Select an entity to connect to.","Cancel") in overmap_name_assoc + list("Cancel")
	if(overmap_name_picked == "Cancel")
		to_chat(user,"<span class = 'notice'>Cancelled.</span>")
		return
	return overmap_name_assoc[overmap_name_picked]

/obj/docking_umbilical/attack_hand(var/mob/user)
	if(!our_ship)
		ship_setup()
	pick_entity_connect_disconnect(user)

/obj/docking_umbilical/proc/umbi_rip()
	if(isnull(current_connected))
		return
	if(initial(broke) == -1)
		current_connected.visual_umbi_change(1)
		current_connected.current_connected = null
		visual_umbi_change(1)
		current_connected = null
		return
	broke = TRUE
	icon_state = "umbi_broken"
	visible_message("<span class = 'warning'>[src] flexes and strains from movement. </span>")
	visible_message("<span class = 'danger'>-SNAP-</span>")
	current_connected.current_connected = null
	current_connected = null

/obj/docking_umbilical/north
	dir = NORTH

/obj/docking_umbilical/south
	dir = SOUTH
	pixel_y = -96

/obj/docking_umbilical/east
	dir = EAST

/obj/docking_umbilical/west
	dir = WEST
	pixel_x = -96

/obj/docking_umbilical/covenant
	icon = 'code/modules/halo/icons/overmap/umbilical_covenant.dmi'

/obj/docking_umbilical/covenant/north
	dir = NORTH

/obj/docking_umbilical/covenant/south
	dir = SOUTH
	pixel_y = -96

/obj/docking_umbilical/covenant/east
	dir = EAST

/obj/docking_umbilical/covenant/west
	dir = WEST
	pixel_x = -96

#undef UMBI_CROSS_DELAY
