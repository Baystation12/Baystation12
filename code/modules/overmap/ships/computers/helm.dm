/obj/machinery/computer/helm
	name = "helm control console"
	icon_state = "thick"
	icon_keyboard = "teleport_key"
	icon_screen = "helm"
	light_color = "#7faaff"
	circuit = /obj/item/weapon/circuitboard/helm
	var/obj/effect/overmap/ship/linked			//connected overmap object
	var/autopilot = 0
	var/manual_control = 0
	var/list/known_sectors = list()
	var/dx		//desitnation
	var/dy		//coordinates
	var/speedlimit = 2 //top speed for autopilot

/obj/machinery/computer/helm/Initialize()
	. = ..()
	linked = map_sectors["[z]"]
	get_known_sectors()

/obj/machinery/computer/helm/proc/get_known_sectors()
	var/area/overmap/map = locate() in world
	for(var/obj/effect/overmap/sector/S in map)
		if (S.known)
			var/datum/data/record/R = new()
			R.fields["name"] = S.name
			R.fields["x"] = S.x
			R.fields["y"] = S.y
			known_sectors[S.name] = R
	..()

/obj/machinery/computer/helm/process()
	..()
	if (autopilot && dx && dy)
		var/turf/T = locate(dx,dy,GLOB.using_map.overmap_z)
		if(linked.loc == T)
			if(linked.is_still())
				autopilot = 0
			else
				linked.decelerate()

		var/brake_path = linked.get_brake_path()

		if((!speedlimit || linked.get_speed() < speedlimit) && get_dist(linked.loc, T) > brake_path)
			linked.accelerate(get_dir(linked.loc, T))
		else
			linked.decelerate()

		return

/obj/machinery/computer/helm/relaymove(var/mob/user, direction)
	if(manual_control && linked)
		linked.relaymove(user,direction)
		return 1

/obj/machinery/computer/helm/check_eye(var/mob/user as mob)
	if (!manual_control)
		return -1
	if (!get_dist(user, src) > 1 || user.blinded || !linked )
		return -1
	return 0

/obj/machinery/computer/helm/attack_hand(var/mob/user as mob)
	if(..())
		user.unset_machine()
		manual_control = 0
		return

	if(!isAI(user))
		user.set_machine(src)
		if(linked)
			user.reset_view(linked)

	ui_interact(user)

/obj/machinery/computer/helm/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1)
	if(!linked)
		return

	var/data[0]

	var/turf/T = get_turf(linked)
	var/obj/effect/overmap/sector/current_sector = locate() in T

	data["sector"] = current_sector ? current_sector.name : "Deep Space"
	data["sector_info"] = current_sector ? current_sector.desc : "Not Available"
	data["s_x"] = linked.x
	data["s_y"] = linked.y
	data["dest"] = dy && dx
	data["d_x"] = dx
	data["d_y"] = dy
	data["speedlimit"] = speedlimit ? speedlimit : "None"
	data["speed"] = linked.get_speed()
	data["accel"] = linked.get_acceleration()
	data["heading"] = linked.get_heading() ? dir2angle(linked.get_heading()) : 0
	data["autopilot"] = autopilot
	data["manual_control"] = manual_control
	data["canburn"] = linked.can_burn()

	if(linked.get_speed())
		data["ETAnext"] = "[round(linked.ETA()/10)] seconds"
	else	
		data["ETAnext"] = "N/A"

	var/list/locations[0]
	for (var/key in known_sectors)
		var/datum/data/record/R = known_sectors[key]
		var/list/rdata[0]
		rdata["name"] = R.fields["name"]
		rdata["x"] = R.fields["x"]
		rdata["y"] = R.fields["y"]
		rdata["reference"] = "\ref[R]"
		locations.Add(list(rdata))

	data["locations"] = locations

	ui = GLOB.nanomanager.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "helm.tmpl", "[linked.name] Helm Control", 380, 530)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)

/obj/machinery/computer/helm/Topic(href, href_list, state)
	if(..())
		return 1

	if (!linked)
		return

	if (href_list["add"])
		var/datum/data/record/R = new()
		var/sec_name = input("Input naviation entry name", "New navigation entry", "Sector #[known_sectors.len]") as text
		if(!CanInteract(usr,state)) 
			return
		if(!sec_name)
			sec_name = "Sector #[known_sectors.len]"
		R.fields["name"] = sec_name
		if(sec_name in known_sectors)
			to_chat(usr, "<span class='warning'>Sector with that name already exists, please input a different name.</span>")
			return
		switch(href_list["add"])
			if("current")
				R.fields["x"] = linked.x
				R.fields["y"] = linked.y
			if("new")
				var/newx = input("Input new entry x coordinate", "Coordinate input", linked.x) as num
				if(!CanInteract(usr,state)) 
					return
				var/newy = input("Input new entry y coordinate", "Coordinate input", linked.y) as num
				if(!CanInteract(usr,state)) 
					return
				R.fields["x"] = Clamp(newx, 1, world.maxx)
				R.fields["y"] = Clamp(newy, 1, world.maxy)
		known_sectors[sec_name] = R

	if (href_list["remove"])
		var/datum/data/record/R = locate(href_list["remove"])
		if(R)
			known_sectors.Remove(R.fields["name"])
			qdel(R)

	if (href_list["setx"])
		var/newx = input("Input new destiniation x coordinate", "Coordinate input", dx) as num|null
		if(!CanInteract(usr,state)) 
			return
		if (newx)
			dx = Clamp(newx, 1, world.maxx)

	if (href_list["sety"])
		var/newy = input("Input new destiniation y coordinate", "Coordinate input", dy) as num|null
		if(!CanInteract(usr,state)) 
			return
		if (newy)
			dy = Clamp(newy, 1, world.maxy)

	if (href_list["x"] && href_list["y"])
		dx = text2num(href_list["x"])
		dy = text2num(href_list["y"])

	if (href_list["reset"])
		dx = 0
		dy = 0

	if (href_list["speedlimit"])
		var/newlimit = input("Input new speed limit for autopilot (0 to disable)", "Autopilot speed limit", speedlimit) as num|null
		if(newlimit)
			speedlimit = Clamp(newlimit, 0, 100)

	if (href_list["move"])
		var/ndir = text2num(href_list["move"])
		linked.relaymove(usr, ndir)

	if (href_list["brake"])
		linked.decelerate()

	if (href_list["apilot"])
		autopilot = !autopilot

	if (href_list["manual"])
		manual_control = !manual_control

	add_fingerprint(usr)
	updateUsrDialog()


/obj/machinery/computer/navigation
	name = "navigation console"
	circuit = /obj/item/weapon/circuitboard/nav
	var/viewing = 0
	var/obj/effect/overmap/ship/linked
	icon_keyboard = "generic_key"
	icon_screen = "helm"

/obj/machinery/computer/navigation/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1)
	if(!linked)
		return

	var/data[0]


	var/turf/T = get_turf(linked)
	var/obj/effect/overmap/sector/current_sector = locate() in T

	data["sector"] = current_sector ? current_sector.name : "Deep Space"
	data["sector_info"] = current_sector ? current_sector.desc : "Not Available"
	data["s_x"] = linked.x
	data["s_y"] = linked.y
	data["speed"] = linked.get_speed()
	data["accel"] = linked.get_acceleration()
	data["heading"] = linked.get_heading() ? dir2angle(linked.get_heading()) : 0
	data["viewing"] = viewing

	if(linked.get_speed())
		data["ETAnext"] = "[round(linked.ETA()/10)] seconds"
	else	
		data["ETAnext"] = "N/A"

	ui = GLOB.nanomanager.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "nav.tmpl", "[linked.name] Navigation Screen", 380, 530)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)

/obj/machinery/computer/navigation/check_eye(var/mob/user as mob)
	if (!viewing)
		return -1
	if (!get_dist(user, src) > 1 || user.blinded || !linked )
		viewing = 0
		return -1
	return 0

/obj/machinery/computer/navigation/attack_hand(var/mob/user as mob)
	if(..())
		user.unset_machine()
		viewing = 0
		return

	if(viewing && linked &&!isAI(user))
		user.set_machine(src)
		user.reset_view(linked)

	ui_interact(user)

/obj/machinery/computer/navigation/Topic(href, href_list)
	if(..())
		return 1

	if (!linked)
		return

	if (href_list["viewing"])
		viewing = !viewing
		if(viewing && !isAI(usr))
			var/mob/user = usr
			user.reset_view(linked)
		return 1
