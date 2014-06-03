//These lists are populated in /datum/shuttle_controller/New()
//Shuttle controller is instantiated in master_controller.dm.

var/global/datum/shuttle_controller/shuttles

/datum/shuttle_controller //This isn't really a controller...
	var/list/locations = list()
	var/list/delays = list()
	var/list/moving = list()
	var/list/areas_offsite = list()
	var/list/areas_station = list()

	//Shuttles with multiple destinations don't quite behave in the same way as ferries.
	var/list/multi_shuttles = list()

/datum/shuttle_controller/New()

	..()

	// Admin shuttles.
	locations["Centcom"] = 1
	delays["Centcom"] = 0
	moving["Centcom"] = 0
	areas_offsite["Centcom"] = locate(/area/shuttle/transport1/centcom)
	areas_station["Centcom"] = locate(/area/shuttle/transport1/station)

	locations["Administration"] = 1
	delays["Administration"] = 0
	moving["Administration"] = 0
	areas_offsite["Administration"] = locate(/area/shuttle/administration/centcom)
	areas_station["Administration"] = locate(/area/shuttle/administration/station)

	locations["Alien"] = 0
	delays["Alien"] = 0
	moving["Alien"] = 0
	areas_offsite["Alien"] = locate(/area/shuttle/alien/base)
	areas_station["Alien"] = locate(/area/shuttle/alien/mine)

	// Public shuttles.
	locations["Engineering"] = 1
	delays["Engineering"] = 10
	moving["Engineering"] = 0
	areas_offsite["Engineering"] = locate(/area/shuttle/constructionsite/site)
	areas_station["Engineering"] =  locate(/area/shuttle/constructionsite/station)

	locations["Mining"] = 0
	delays["Mining"] = 10
	moving["Mining"] = 0
	areas_offsite["Mining"] = locate(/area/shuttle/mining/outpost)
	areas_station["Mining"] = locate(/area/shuttle/mining/station)

	locations["Research"] = 0
	delays["Research"] = 10
	moving["Research"] = 0
	areas_offsite["Research"] = locate(/area/shuttle/research/outpost)
	areas_station["Research"] = locate(/area/shuttle/research/station)

	//Vox Shuttle.
	var/datum/multi_shuttle/VS = new
	VS.origin = /area/shuttle/vox/station

	VS.destinations = list(
		"Fore Starboard Solars" = /area/vox_station/northeast_solars,
		"Fore Port Solars" = /area/vox_station/northwest_solars,
		"Aft Starboard Solars" = /area/vox_station/southeast_solars,
		"Aft Port Solars" = /area/vox_station/southwest_solars,
		"Mining asteroid" = /area/vox_station/mining
		)

	VS.announcer = "NSV Icarus"
	VS.arrival_message = "Attention, Exodus, we just tracked a small target bypassing our defensive perimeter. Can't fire on it without hitting the station - you've got incoming visitors, like it or not."
	VS.departure_message = "Your guests are pulling away, Exodus - moving too fast for us to draw a bead on them. Looks like they're heading out of the system at a rapid clip."
	VS.interim = /area/vox_station/transit

	multi_shuttles["Vox Skipjack"] = VS
	locations["Vox Skipjack"] = 1
	delays["Vox Skipjack"] = 10
	moving["Vox Skipjack"] = 0

	//Nuke Ops shuttle.
	var/datum/multi_shuttle/MS = new
	MS.origin = /area/syndicate_station/start

	MS.destinations = list(
		"Northwest of the station" = /area/syndicate_station/northwest,
		"North of the station" = /area/syndicate_station/north,
		"Northeast of the station" = /area/syndicate_station/northeast,
		"Southwest of the station" = /area/syndicate_station/southwest,
		"South of the station" = /area/syndicate_station/south,
		"Southeast of the station" = /area/syndicate_station/southeast,
		"Telecomms Satellite" = /area/syndicate_station/commssat,
		"Mining Asteroid" = /area/syndicate_station/mining
		)

	MS.announcer = "NSV Icarus"
	MS.arrival_message = "Attention, Exodus, you have a large signature approaching the station - looks unarmed to surface scans. We're too far out to intercept - brace for visitors."
	MS.departure_message = "Your visitors are on their way out of the system, Exodus, burning delta-v like it's nothing. Good riddance."
	MS.interim = /area/syndicate_station/transit

	multi_shuttles["Syndicate"] = MS
	locations["Syndicate"] = 1
	delays["Syndicate"] = 10
	moving["Syndicate"] = 0

/datum/shuttle_controller/proc/move_shuttle(var/shuttle_tag,var/area/origin,var/area/destination)

	world << "move_shuttle() called for [shuttle_tag] leaving [origin] en route to [destination]."
	if(!shuttle_tag || isnull(locations[shuttle_tag]))
		return

	if(moving[shuttle_tag] == 1) return
	moving[shuttle_tag] = 1

	spawn(delays[shuttle_tag]*10)

		var/area/area_going_to
		if(destination)
			world << "Using supplied destination [destination]."
			area_going_to = destination
		else
			world << "Using controller value [(locations[shuttle_tag] == 1 ? areas_station[shuttle_tag] : areas_offsite[shuttle_tag])]."
			area_going_to = (locations[shuttle_tag] == 1 ? areas_station[shuttle_tag] : areas_offsite[shuttle_tag])

		var/area/area_coming_from
		if(origin)
			world << "Using supplied origin [origin]."
			area_coming_from = origin
		else
			world << "Using controller value [(locations[shuttle_tag] == 1 ? areas_offsite[shuttle_tag] : areas_station[shuttle_tag])]."
			area_coming_from = (locations[shuttle_tag] == 1 ? areas_offsite[shuttle_tag] : areas_station[shuttle_tag])

		world << "area_coming_from: [area_coming_from]"
		world << "area_going_to: [area_going_to]"

		if(area_coming_from == area_going_to)
			world << "cancelling move, shuttle will overlap."
			moving[shuttle_tag] = 0
			return

		var/list/dstturfs = list()
		var/throwy = world.maxy

		for(var/turf/T in area_going_to)
			dstturfs += T
			if(T.y < throwy)
				throwy = T.y

		for(var/turf/T in dstturfs)
			var/turf/D = locate(T.x, throwy - 1, 1)
			for(var/atom/movable/AM as mob|obj in T)
				AM.Move(D)
			if(istype(T, /turf/simulated))
				del(T)

		for(var/mob/living/carbon/bug in area_going_to)
			bug.gib()

		for(var/mob/living/simple_animal/pest in area_going_to)
			pest.gib()

		area_coming_from.move_contents_to(area_going_to)

		locations[shuttle_tag] = !locations[shuttle_tag]

		for(var/mob/M in area_going_to)
			if(M.client)
				spawn(0)
					if(M.buckled)
						M << "\red Sudden acceleration presses you into your chair!"
						shake_camera(M, 3, 1)
					else
						M << "\red The ship lurches beneath you!"
						shake_camera(M, 10, 1)
			if(istype(M, /mob/living/carbon))
				if(!M.buckled)
					M.Weaken(3)

		moving[shuttle_tag] = 0
	return

//This is for shuttles with a timer before arrival such as the vox skipjack and the escape shuttle.
/datum/shuttle_controller/proc/move_shuttle_long(var/shuttle_tag,var/area/departing,var/area/destination,var/area/interim,var/delay)

	move_shuttle(shuttle_tag,locate(departing),locate(interim))

	spawn(1)
		moving[shuttle_tag] = 1 //So they can't jump out by messing with the console.

	sleep(delay)

	moving[shuttle_tag] = 0
	move_shuttle(shuttle_tag,locate(interim),locate(destination))

	return

/obj/machinery/computer/shuttle_control
	name = "shuttle console"
	icon = 'icons/obj/computer.dmi'
	icon_state = "shuttle"
	req_access = list(access_engine)
	circuit = "/obj/item/weapon/circuitboard/engineering_shuttle"

	var/shuttle_tag  // Used to coordinate data in shuttle controller.
	var/hacked = 0   // Has been emagged, no access restrictions.

/obj/machinery/computer/shuttle_control/attack_hand(user as mob)

	if(..(user))
		return
	src.add_fingerprint(user)
	var/dat

	dat = "<center>[shuttle_tag] Shuttle Control<hr>"

	if(shuttles.moving[shuttle_tag])
		dat += "Location: <font color='red'>Moving</font> <br>"
	else
		dat += "Location: [shuttles.locations[shuttle_tag] ? "Offsite" : "Station"] <br>"

	dat += "<b><A href='?src=\ref[src];move=[1]'>Send</A></b></center>"


	user << browse("[dat]", "window=[shuttle_tag]shuttlecontrol;size=200x150")

/obj/machinery/computer/shuttle_control/Topic(href, href_list)
	if(..())
		return
	usr.set_machine(src)
	src.add_fingerprint(usr)

	if(href_list["move"])
		if (!shuttles.moving[shuttle_tag])
			usr << "\blue [shuttle_tag] Shuttle recieved message and will be sent shortly."
			shuttles.move_shuttle(shuttle_tag)
		else
			usr << "\blue [shuttle_tag] Shuttle is already moving."


/obj/machinery/computer/shuttle_control/attackby(obj/item/weapon/W as obj, mob/user as mob)

	if (istype(W, /obj/item/weapon/card/emag))
		src.req_access = list()
		hacked = 1
		usr << "You short out the console's ID checking system. It's now available to everyone!"
	else
		..()

/obj/machinery/computer/shuttle_control/bullet_act(var/obj/item/projectile/Proj)
	visible_message("[Proj] ricochets off [src]!")