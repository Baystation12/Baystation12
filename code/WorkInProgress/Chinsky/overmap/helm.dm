/obj/machinery/computer/helm
	name = "helm control console"
	icon_state = "id"
	var/obj/effect/mapinfo/linked			//connected overmap object

/obj/machinery/computer/helm/initialize()
	linked = map_sectors["[z]"]
	if (!linked)
		testing("Helm console at level [z] was unable to find a corresponding overmap object.")
	else
		testing("Helm console at level [z] found a corresponding overmap object '[linked.name]'.")

/obj/machinery/computer/helm/relaymove(var/mob/user, direction)
	if(linked)
		linked.relaymove(user,direction)
		return 1

/obj/machinery/computer/helm/check_eye(var/mob/user as mob)
	if (get_dist(user, src) > 1 || user.blinded || !linked )
		return null
	user.reset_view(linked)
	return 1

/obj/machinery/computer/helm/attack_hand(var/mob/user as mob)
	if(!linked)
		user << "<span class = 'warning'>Could not get navigation data!</span>"
		return

	if(stat & (NOPOWER|BROKEN))
		user.unset_machine()
		return

	if(!isAI(user))
		user.set_machine(src)

	return

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