/obj/machinery/computer/helm
	name = "helm control console"
	icon_keyboard = "teleport_key"
	icon_screen = "helm"
	circuit = /obj/item/weapon/circuitboard/helm
	var/obj/effect/overmap/ship/linked			//connected overmap object
	var/autopilot = 0
	var/manual_control = 0
	var/list/known_sectors = list()
	var/dx		//destnation
	var/dy		//coordinates
	ai_access_level = 4

/obj/machinery/computer/helm/Initialize()
	. = ..()
	linked = map_sectors["[z]"]

/obj/machinery/computer/helm/LateInitialize()
	get_known_sectors()

/obj/machinery/computer/helm/proc/get_known_sectors()
	known_sectors.Cut()
	if(linked && linked.nav_comp)
		known_sectors = linked.nav_comp.get_known_sectors()
		return
	//Original Code left to ensure backwards compatibility
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
	if(!linked)
		linked = map_sectors["[z]"]
	if(..())
		if (world.time >= ticker.mode.ship_lockdown_until && autopilot && dx && dy)
			var/turf/T = locate(dx,dy,GLOB.using_map.overmap_z)
			if(linked.loc == T)
				if(linked.is_still())
					autopilot = 0
				else
					linked.decelerate()

			var/brake_path = linked.get_brake_path()

			if(get_dist(linked.loc, T) > brake_path)
				linked.accelerate(get_dir(linked.loc, T))
			else
				linked.decelerate()

		return 1
	else
		return 0

/obj/machinery/computer/helm/relaymove(var/mob/user, direction)
	if(manual_control && linked)
		linked.relaymove(user,direction)
		return 1

/obj/machinery/computer/helm/check_eye(var/mob/user as mob)
	. = 0

	if (!manual_control)
		. = -1
	if (!get_dist(user, src) > 1 || user.blinded || !linked )
		. = -1

	//reset some custom view settings for ship control before resetting the view entirely
	if(. < 0)
		if(linked)
			linked.my_observers.Remove(user)
			//linked.hud_waypoint_controller.remove_hud_from_mob(user)
		if(user.client)
			user.client.pixel_x = 0
			user.client.pixel_y = 0
	else
		user.reset_view(linked, 0)
		linked.my_observers.Remove(user)		//so we can avoid doubleups
		linked.my_observers.Add(user)

/obj/machinery/computer/helm/attack_hand(var/mob/user as mob)
	if(!linked)
		linked = map_sectors["[z]"]
	get_known_sectors()
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
	data["speed"] = linked.get_speed()
	data["accel"] = linked.get_acceleration()
	data["heading"] = linked.get_heading()
	data["braking"] = linked.braking
	data["autopilot"] = autopilot
	data["manual_control"] = manual_control
	data["lock_thrust"] = linked.lock_thrust
	data["moving_dir"] = linked.moving_dir

	var/list/locations[0]
	for (var/key in known_sectors)
		var/datum/data/record/R = known_sectors[key]
		if(isnull(R))
			continue
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

/obj/machinery/computer/helm/Topic(href, href_list)
	if(..())
		return 1

	if (!linked)
		return

	if(!istype(usr,/mob/living/silicon) && get_dist(usr, src) > 1)
		to_chat(usr,"<span class = 'notice'>You need to be next to [src] to do that!</span>")
		return

	if (href_list["add"])
		var/datum/data/record/R = new()
		var/sec_name = input("Input naviation entry name", "New navigation entry", "Sector #[known_sectors.len]") as text
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
				R.fields["x"] = Clamp(newx, 1, world.maxx)
				var/newy = input("Input new entry y coordinate", "Coordinate input", linked.y) as num
				R.fields["y"] = Clamp(newy, 1, world.maxy)
		known_sectors[sec_name] = R

	if (href_list["remove"])
		var/datum/data/record/R = locate(href_list["remove"])
		if(R)
			known_sectors.Remove(R.fields["name"])
			qdel(R)

	if (href_list["setx"])
		var/newx = input("Input new destination x coordinate", "Coordinate input", dx) as num|null
		if (newx)
			dx = Clamp(newx, 1, world.maxx)

	if (href_list["sety"])
		var/newy = input("Input new destiniation y coordinate", "Coordinate input", dy) as num|null
		if (newy)
			dy = Clamp(newy, 1, world.maxy)

	if (href_list["x"] && href_list["y"])
		dx = text2num(href_list["x"])
		dy = text2num(href_list["y"])

	if (href_list["reset"])
		dx = 0
		dy = 0

	if (href_list["move"])
		var/ndir = text2num(href_list["move"])
		linked.relaymove(usr, ndir)

	if (href_list["brake"])
		linked.brake()

	if (href_list["apilot"])
		autopilot = !autopilot

	if (href_list["lock_thrust"])
		linked.lock_thrust = !linked.lock_thrust

	if (href_list["manual"])
		manual_control = !manual_control
		var/mob/living/user = usr
		if(istype(user))
			if(manual_control)
				linked.my_observers |= user
			else
				linked.my_observers -= user

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
		linked = map_sectors["[z]"]
		return

	var/data[0]

	data["viewing"] = viewing

	ui = GLOB.nanomanager.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "nav.tmpl", "[linked.name] Helm Control", 380, 530)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)

/obj/machinery/computer/navigation/check_eye(var/mob/user as mob)
	. = 0

	if(!user)
		. = -1
	else if(user.client && user.client.eye != linked)
		. = -1

	//reset some custom view settings for ship control before resetting the view entirely
	if(. < 0 && user)
		if(linked)
			linked.my_observers.Remove(user)
			//linked.hud_waypoint_controller.remove_hud_from_mob(user)
		if(user.client)
			user.client.pixel_x = 0
			user.client.pixel_y = 0

/obj/machinery/computer/navigation/attack_hand(var/mob/user as mob)
	if(..())
		user.unset_machine()
		viewing = 0
		return

	if(!isAI(user))
		user.set_machine(src)
		if(linked)
			user.reset_view(linked)

	ui_interact(user)


/obj/machinery/computer/navigation/Topic(href, href_list)
	if(..())
		return 1

	if (!linked)
		return

	if (href_list["move"])
		var/mob/user = usr
		user.unset_machine()
		viewing = 0
		return 1

	if (href_list["viewing"])
		viewing = !viewing
		return 1
