#include "errant_pisces_areas.dm"

/obj/effect/overmap/visitable/ship/errant_pisces
	name = "XCV Ahab's Harpoon"
	desc = "Sensors detect civilian vessel with unusual signs of life aboard."
	color = "#bd6100"
	max_speed = 1/(3 SECONDS)
	burn_delay = 15 SECONDS
	fore_dir = SOUTH

/datum/map_template/ruin/away_site/errant_pisces
	name = "Errant Pisces"
	id = "awaysite_errant_pisces"
	description = "Xynergy carp trawler"
	suffixes = list("errant_pisces/errant_pisces.dmm")
	spawn_cost = 1
	area_usage_test_exempted_root_areas = list(/area/errant_pisces)


/obj/structure/net//if you want to have fun, make them to be draggable as a whole unless at least one piece is attached to a non-space turf or anchored object
	name = "industrial net"
	desc = "A sturdy industrial net of synthetic belts reinforced with plasteel threads."
	icon = 'maps/away/errant_pisces/errant_pisces_sprites.dmi'
	icon_state = "net_f"
	anchored = TRUE
	layer = CATWALK_LAYER//probably? Should cover cables, pipes and the rest of objects that are secured on the floor
	health_max = 100
	health_min_damage = 10

/obj/structure/net/Initialize(mapload)
	. = ..()
	update_connections()
	if (!mapload)//if it's not mapped object but rather created during round, we should update visuals of adjacent net objects
		var/turf/T = get_turf(src)
		for (var/turf/AT in T.CardinalTurfs(FALSE))
			for (var/obj/structure/net/N in AT)
				if (type != N.type)//net-walls cause update for net-walls and floors for floors but not for each other
					continue
				N.update_connections()

/obj/structure/net/attackby(obj/item/W as obj, mob/user as mob)
	if (user.a_intent == I_HURT && istype(W, /obj/item/material)) //sharp objects can cut thorugh
		var/obj/item/material/SH = W
		if (!(SH.sharp) || (SH.sharp && SH.force < 10))//is not sharp enough or at all
			to_chat(user,SPAN_WARNING("You can't cut throught \the [src] with \the [W], it's too dull."))
			return TRUE
		visible_message(SPAN_WARNING("[user] starts to cut through \the [src] with \the [W]!"))
		while (!health_dead)
			if (!do_after(user, 2 SECONDS, src, DO_PUBLIC_UNIQUE))
				visible_message(SPAN_WARNING("[user] stops cutting through \the [src] with \the [W]!"))
				return TRUE
			damage_health(20 * (1 + (SH.force-10) / 10), W.damtype, DAMAGE_FLAG_SHARP)
		visible_message(SPAN_WARNING("[user] cuts through \the [src]!"))
		new /obj/item/stack/net(src.loc)
		qdel(src)
		return TRUE

	return ..()

/obj/structure/net/bullet_act(obj/item/projectile/P)
	. = PROJECTILE_CONTINUE //few cloth ribbons won't stop bullet or energy ray
	if (P.damage_type != DAMAGE_BURN)//beams, lasers, fire. Bullets won't make a lot of damage to the few hanging belts.
		return
	visible_message(SPAN_WARNING("\The [P] hits \the [src] and tears it!"))
	damage_health(P.damage, P.damage_type)

/obj/structure/net/update_connections()//maybe this should also be called when any of the walls nearby is removed but no idea how I can make it happen
	overlays.Cut()
	var/turf/T = get_turf(src)
	for (var/turf/AT in T.CardinalTurfs(FALSE))
		if ( (locate(/obj/structure/net) in AT) || (!istype(AT, /turf/simulated/open) && !istype(AT, /turf/space)) || (locate(/obj/structure/lattice) in AT) )//connects to another net objects or walls/floors or lattices
			var/image/I = image(icon,"[icon_state]_ol_[get_dir(src,AT)]")
			overlays += I

/obj/structure/net/net_wall
	icon_state = "net_w"
	density = TRUE
	layer = ABOVE_HUMAN_LAYER

/obj/structure/net/net_wall/Initialize(mapload)
	. = ..()
	if (mapload)//if it's pre-mapped, it should put floor-net below itself
		var/turf/T = get_turf(src)
		for (var/obj/structure/net/N in T)
			if (N.type != /obj/structure/net/net_wall)//if there's net that is not a net-wall, we don't need to spawn it
				return
		new /obj/structure/net(T)


/obj/structure/net/net_wall/update_connections()//this is different for net-walls because they only connect to walls and net-walls
	overlays.Cut()
	var/turf/T = get_turf(src)
	for (var/turf/AT in T.CardinalTurfs(FALSE))
		if ((locate(/obj/structure/net/net_wall) in AT) || istype(AT, /turf/simulated/wall)  || istype(AT, /turf/unsimulated/wall) || istype(AT, /turf/simulated/mineral))//connects to another net-wall objects or walls
			var/image/I = image(icon,"[icon_state]_ol_[get_dir(src,AT)]")
			overlays += I

/obj/item/stack/net
	name = "industrial net roll"
	desc = "Sturdy industrial net reinforced with plasteel threads."
	singular_name = "industrial net"
	icon = 'maps/away/errant_pisces/errant_pisces_sprites.dmi'
	icon_state = "net_roll"
	w_class = ITEM_SIZE_LARGE
	force = 3.0
	throwforce = 5.0
	throw_speed = 5
	throw_range = 10
	matter = list("cloth" = 1875, "plasteel" = 350)
	max_amount = 30
	attack_verb = list("hit", "bludgeoned", "whacked")
	lock_picking_level = 3

/obj/item/stack/net/Initialize()
	. = ..()
	update_icon()

/obj/item/stack/net/thirty
	amount = 30

/obj/item/stack/net/on_update_icon()
	if(amount == 1)
		icon_state = "net"
	else
		icon_state = "net_roll"

/obj/item/stack/net/proc/attach_wall_check()//checks if wall can be attached to something vertical such as walls or another net-wall
	var/area/A = get_area(src)
	if (!A.has_gravity)
		return 1
	var/turf/T = get_turf(src)
	for (var/turf/AT in T.CardinalTurfs(FALSE))
		if ((locate(/obj/structure/net/net_wall) in AT) || istype(AT, /turf/simulated/wall)  || istype(AT, /turf/unsimulated/wall) || istype(AT, /turf/simulated/mineral))//connects to another net-wall objects or walls
			return 1
	return 0

/obj/item/stack/net/attack_self(mob/user)//press while holding to lay one. If there's net already, place wall
	var/turf/T = get_turf(user)
	if (locate(/obj/structure/net/net_wall) in T)
		to_chat(user, SPAN_WARNING("Net wall is already placed here!"))
		return
	if (locate(/obj/structure/net) in T)//if there's already layed "floor" net
		if (!attach_wall_check())
			to_chat(user, SPAN_WARNING("You try to place net wall but it falls on the floor. Try to attach it to something vertical and stable."))
			return
		new /obj/structure/net/net_wall(T)
		//update_adjacent_nets(1)//since net-wall was added we also update adjacent wall-nets
	else
		new /obj/structure/net(T)
		//update_adjacent_nets(0)
	amount -= 1
	update_icon()
	if (amount < 1)
		qdel(src)

/obj/item/clothing/under/carp
	name = "space carp suit"
	desc = "A suit in a shape of a space carp. Usually worn by corporate interns who are sent to entertain children during HQ excursions."
	icon_state = "carp_suit"
	icon = 'maps/away/errant_pisces/errant_pisces_sprites.dmi'
	item_icons = list(slot_w_uniform_str = 'maps/away/errant_pisces/errant_pisces_sprites.dmi')

/obj/effect/landmark/corpse/carp_fisher
	name = "carp fisher"
	corpse_outfits = list(/singleton/hierarchy/outfit/corpse/carp_fisher)
	species = list(SPECIES_HUMAN = 70, SPECIES_IPC = 20, SPECIES_UNATHI = 10)

/singleton/hierarchy/outfit/corpse/carp_fisher
	name = "Dead carp fisher"
	uniform = /obj/item/clothing/under/color/green
	suit = /obj/item/clothing/suit/apron/overalls
	belt = /obj/item/material/knife/combat
	shoes = /obj/item/clothing/shoes/jackboots
	head = /obj/item/clothing/head/hardhat/dblue

/obj/effect/computer_file_creator/ahabs_harpoon01
	name = "ahab's harpoon file spawner - sensor dump"

/obj/effect/computer_file_creator/ahabs_harpoon01/Initialize()
	var/i_month = max(text2num(time2text(world.timeofday, "MM")) - 1, 1) // Prevent month from going below 1
	var/i_day = max(text2num(time2text(world.timeofday, "DD")) - 5, 1)
	file_name = "NETMON_SENSORDUMP-BLACKBOX"
	file_info = " \
		<h2>XCV Ahab's Harpoon Sensor Log - <i>[GLOB.using_map.game_year]-[i_month]-[i_day]</i></h2> \
		<hr> \
		\<08:33:07\> Space carp migration detected within 1 Gm.<br>\
		\<08:51:29\> Main net extended.<br>\
		\<09:00:00\> Hourly report. Security level: GREEN. Crew status: NOMINAL. SMES charge: NOMINAL.<br>\
		\<09:02:53\> Outflow cells opened.<br>\
		\<09:04:12\> Exterior airlock cycling: Port Solar Control.<br>\
		\<09:04:25\> <b>VITAL SIGNS ALERT:</b> C. BANCROFT, Retrieval Specialist, Port Solar Control<br>\
		\<09:04:33\> <b>BRAIN ACTIVITY FLATLINE:</b> C. BANCROFT, Retrieval Specialist, Port Solar Control<br>\
		\<09:04:39\> Unidentified lifesigns aboard.<br>\
		\<09:04:45\> Multiple unidentified lifesigns aboard.<br>\
		\<09:05:21\> <b>SECURITY LEVEL ALERT:</b> Elevated to RED.<br>\
		\<09:33:07\> <b>SECURITY LEVEL ALERT:</b> Logging flight and sensor data to ship black box.<br>\
		\<09:41:13\> <b>MULTIPLE VITAL SIGNS ALERTS</b><br>\
		\<09:47:03\> All vital signs alerts cleared.<br>\
		\<10:00:00\> Hourly report. Security level: RED. Crew status: CRITICAL. SMES charge: NOMINAL.<br>\
		\<11:00:00\> Hourly report. Security level: RED. Crew status: CRITICAL. SMES charge: NOMINAL.<br>\
		\<12:00:00\> Hourly report. Security level: RED. Crew status: CRITICAL. SMES charge: NOMINAL.<br>\
		\<13:00:00\> Hourly report. Security level: RED. Crew status: CRITICAL. SMES charge: NOMINAL.<br>\
		\<14:00:00\> Hourly report. Security level: RED. Crew status: CRITICAL. SMES charge: LOW.<br>\
		\<15:00:00\> Hourly report. Security level: RED. Crew status: CRITICAL. SMES charge: LOW.<br>\
		\<16:00:00\> Hourly report. Security level: RED. Crew status: CRITICAL. SMES charge: CRITICAL.<br>\
		\<17:00:00\> Hourly report. Security level: RED. Crew status: CRITICAL. SMES charge: CRITICAL.<br>\
		\<17:03:41\> Low power. Entering hibernation. Data dumped to local drive and stored in ship black box.<br>\
		\<17:03:41\> Black box data pushed to access terminal.<br>\
		\<17:03:42\> Shutting down.<br>\
	"
	. = ..()

/obj/effect/computer_file_creator/ahabs_harpoon02
	name = "ahab's harpoon file spawner - black box"
	file_name = "NETMON_BLACKBOX"
	file_info = "<p><i>This is the flight recorder data for the XCV Ahab's Harpoon. Its callsign and flight registration indicate that this is a medium size, long-haul commerical space carp fishing vessel, owned by Xynergy. The data recording here only includes hourly status reports, but they indicate that the ship went from nominal function at 09:00 to red alert and critical crew status by 10:00, before continuing at these levels for most of the day until SMES power failed.</i></p>\
	\
	<p><i>This data contains a wealth of information about the ship's records, manifest, and specifications, but nothing immediately useful about the events that happened on board. You may be able to glean further information if you could find more complete records.</i></p>"

/obj/effect/computer_file_creator/ahabs_harpoon03
	name = "ahab's harpoon file spawner - captain's log"
	file_name = "captainslog"

/obj/effect/computer_file_creator/ahabs_harpoon03/Initialize()
	var/captain_name = "[capitalize(pick(GLOB.first_names_male + GLOB.first_names_female))] [capitalize(pick(GLOB.last_names))]"
	file_info = "<p><i>This is the captain's log of the XCV Ahab's Harpoon, authored by Xynergy general manager [captain_name]. According to the log's contents, the ship embarked on its final voyage six months ago. All entries except the last one seem mundane - routine checks, inventory reports, flight path, and so on. The final entry seems to have been written in a hurry, with several typos that didn't get caught by the autocorrect:</i></p>\
	\
	<p>Had a major incident, have lost control f the ship. Hit a big shoal off Nine and scooped up a bunch but itr got the net tangled. Charlie went out to untangle it and a bunch got in. Big motherfuckers, got everywhere. Lkarger than pike. Got trhough doors. Gettim vital alerts for half the crew. Turning on distress but the emergency mode eats up a lot of powedr and it won't last forever. Solars might keep the lights on but it'll be brownouts/blackouts eventually. Going to make for engi where the blackbox comp is. Wish me luck. Please report to xyn/gov if you find this.</p>"
	. = ..()
