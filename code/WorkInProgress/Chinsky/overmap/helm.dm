/obj/machinery/computer/helm
	name = "helm control console"
	icon_state = "id"
	var/obj/effect/map/ship/linked			//connected overmap object
	var/autopilot = 0
	var/manual_control = 0
	var/dx		//desitnation
	var/dy		//coordinates
	var/ship_last_move = 0
	var/ship_move_delay = 10


/obj/machinery/computer/helm/initialize()
	linked = map_sectors["[z]"]
	if (!linked)
		testing("Helm console at level [z] was unable to find a corresponding overmap object.")
	else
		testing("Helm console at level [z] found a corresponding overmap object '[linked.name]'.")

/obj/machinery/computer/helm/process()
	..()
	if (autopilot && dx && dy && world.time > ship_last_move + ship_move_delay)
		ship_last_move = world.time
		var/turf/T = locate(dx,dy,1)
		if (T)
			step_towards(linked,T)
		return

/obj/machinery/computer/helm/relaymove(var/mob/user, direction)
	if(manual_control && linked)
		if (world.time > ship_last_move + ship_move_delay)
			linked.relaymove(user,direction)
			ship_last_move = world.time
		return 1

/obj/machinery/computer/helm/check_eye(var/mob/user as mob)
	if (!manual_control)
		return null
	if (!get_dist(user, src) > 1 || user.blinded || !linked )
		return null
	user.reset_view(linked)
	return 1

/obj/machinery/computer/helm/attack_hand(var/mob/user as mob)
	if(..())
		user.unset_machine()
		manual_control = 0
		return

	if(!isAI(user))
		user.set_machine(src)

	var/dat = ""
	if(!linked)
		dat = "<center><span class = 'warning'>Could not get navigation data!</span><center>"
	else
		dat += "<table>"
		dat += "<tr><td>Current sector:</td><td>[linked.current_sector ? linked.current_sector.name : "Deep Space"]"
		dat += "</td></tr><tr><td>Sector information:</td><td>[linked.current_sector ? linked.current_sector.desc : "Not Available"]"
		dat += "</td></tr><tr><td>Current coordinates:</td><td>\[[linked.x], [linked.y]\]"
		dat += "</td></tr><tr><td>Current destination:</td><td>"
		if (dx && dy)
			dat += "\[<a href='?src=\ref[src];setx=1'>[dx]</a>, "
			dat += "<a href='?src=\ref[src];sety=1'>[dy]</a>\]"
		else
			dat += "<a href='?src=\ref[src];sety=1;setx=1'>None</a>"
		dat += "</td></tr></table>"

		dat += "<br><hr><br>"

		dat += "Known locations:<br>"
		dat += "<table>"
		for (var/lvl in map_sectors)
			var/obj/effect/map/sector/S = map_sectors[lvl]
			if (istype(S))
				dat += "<tr><td>[S.name]:</td><td>\[[S.x], [S.y]\]</td><td><a href='?src=\ref[src];x=[S.x];y=[S.y]'>Plot course</a></td></tr>"
		dat += "</table>"

		dat += "<br><br><hr><br>"

		dat += "<table>"
		dat += "<tr><td>Autopilot:</td><td><a href='?src=\ref[src];apilot=1'>[autopilot ? "Engaged" : "Disengaged"]</a></td><td><a href='?src=\ref[src];reset=1'>Reset desetination</a>"
		dat += "</td></tr><tr><td>Manual control:</td><td><a href='?src=\ref[src];manual=1'>[manual_control ? "Engaged" : "Disengaged"]</a>"
		dat += "</td></tr></table>"
	user << browse("<HEAD><TITLE>Helm Control</TITLE></HEAD><TT>[dat]</TT>", "window=helm")
	onclose(user, "helm")
	return


/obj/machinery/computer/helm/Topic(href, href_list)
	if(..())
		return

	if (!linked)
		return

	if (href_list["setx"])
		var/newx = input("Input new destiniation x coordinate", "Coordinate input", dx) as num|null
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

	if (href_list["apilot"])
		autopilot = !autopilot

	if (href_list["manual"])
		manual_control = !manual_control
		autopilot = 0

	add_fingerprint(usr)
	updateUsrDialog()

//Shuttle controller computer for shuttles going from ship to sectors

/obj/machinery/computer/shuttle_control/explore
	name = "exploration shuttle console"
	shuttle_tag = "Exploration"
	req_access = list()
	var/landing_type	//area for shuttle ship-side

/obj/machinery/computer/shuttle_control/explore/initialize()
	..()
	shuttle_tag = "[shuttle_tag]-[z]"
	if(!shuttle_controller.shuttles[shuttle_tag])
		var/datum/shuttle/ferry/shuttle = new()
		shuttle.warmup_time = 10
		shuttle.area_station = locate(landing_type)
		shuttle.area_offsite = shuttle.area_station
		shuttle_controller.shuttles[shuttle_tag] = shuttle
		shuttle_controller.process_shuttles += shuttle
		testing("Exploration shuttle '[shuttle_tag]' at zlevel [z] successfully added.")

/obj/machinery/computer/shuttle_control/explore/proc/update_destination()
	if(shuttle_controller.shuttles[shuttle_tag])
		var/obj/effect/map/ship/S = map_sectors["[z]"]
		if (!istype(S))
			return
		var/datum/shuttle/ferry/shuttle = shuttle_controller.shuttles[shuttle_tag]
		if(S && S.current_sector)
			var/obj/effect/map/M = S.current_sector
			shuttle.area_offsite = M.shuttle_landing
			testing("Shuttle controller now sends shuttle to [M]")
		else
			shuttle.area_offsite = shuttle.area_station
		shuttle_controller.shuttles[shuttle_tag] = shuttle

/obj/machinery/computer/shuttle_control/explore/attack_hand(user as mob)
	update_destination()
	..()