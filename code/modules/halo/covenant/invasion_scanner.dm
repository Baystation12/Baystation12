
/obj/structure/invasion_scanner
	name = "Forerunner Scanning Device"
	desc = "Used to scan for forerunner facilities and artifacts. Destruction of a singular device greatly disrupts the scanning, and multiple scanners increase the scanning efficiency."
	icon = 'code/modules/halo/covenant/structures_machines/comms.dmi'
	icon_state = "comms"
	density = 1
	anchored = 0
	pixel_x = -16
	var/datum/game_mode/outer_colonies/gm

/obj/structure/invasion_scanner/Initialize()
	. = ..()
	gm = ticker.mode
	if(!istype(gm))
		gm = null
		loc = null
		qdel(src)

/obj/structure/invasion_scanner/examine(var/mob/user)
	. = ..()
	to_chat(user,"It is [anchored ? "active" : "inactive"]")

/obj/structure/invasion_scanner/attack_hand(var/mob/living/attacker)
	if(!istype(attacker))
		return
	if(!is_covenant_mob(attacker))
		to_chat(attacker, "<span class = 'notice'>You don't know how to toggle [src]...</span>")
		return
	visible_message("<span class = 'notice'>[attacker] toggles [src]</span>")
	toggle_scanner()

/obj/structure/invasion_scanner/proc/can_register()
	var/obj/effect/landmark/scanning_point/point = locate(/obj/effect/landmark/scanning_point) in range(2,src)
	if(isnull(point))
		visible_message("<span class = 'notice'>[src] quickly scans the area, realising nothing of interest is contained here. Relocate for proper scanning.</span>")
		return 0
	if(point.active_scanner)
		visible_message("<span class = 'notice'>[src] shuts down quickly, recognising the interference it would cause with this local area's scanning operations. Relocate to a different point-of-interest.</span>")
		return 0
	return 1

/obj/structure/invasion_scanner/proc/toggle_scanner()
	if(anchored)
		gm.unregister_scanner()
	else
		if(!can_register())
			return
		gm.register_scanner()
	anchored = !anchored

/obj/structure/invasion_scanner/Destroy()
	gm.register_scanner_destroy()
	. = ..()

/obj/effect/landmark/scanning_point
	name = "Invasion Scan Point"
	var/active_scanner = 0

/obj/item/weapon/pinpointer/scanpoint_locator
	name = "Scanning Point Locator"
	desc = "Seems to point towards points of scanning interest..."
	var/check_point_active = 0 //used for unsc variants
	var/obj/machinery/artifact/scanpoint = null
	var/list/scanpoints = list()
	var/index = 0

/obj/item/weapon/pinpointer/scanpoint_locator/attack_self(mob/user as mob)
	active = 1
	if(scanpoints.len == 0)
		for(var/obj/effect/landmark/scanning_point/point_find in world)
			scanpoints += point_find
			if(isnull(scanpoint) && (!check_point_active || point_find.active_scanner))
				scanpoint = point_find
	else
		var/oldpoint = scanpoint
		for(var/i = index+1 to scanpoints.len)
			var/obj/effect/landmark/scanning_point/point = scanpoints[i]
			if(!check_point_active || point.active_scanner)
				scanpoint = point
				index = i
		if(scanpoint == oldpoint)
			index = 1
		visible_message("<span class = 'notice'>[src] switches target.</span>")
	if(!workdisk())
		active = 0
		icon_state = "pinoff"
		to_chat(user, "<span class='notice'>You deactivate the pinpointer.</span>")


/obj/item/weapon/pinpointer/scanpoint_locator/workdisk()
	if(!active) return 0
	if(!scanpoint)
		icon_state = "pinonnull"
		return 0
	. = 1
	set_dir(get_dir(src,scanpoint))
	switch(get_dist(src,scanpoint))
		if(0)
			icon_state = "pinondirect"
		if(1 to 8)
			icon_state = "pinonclose"
		if(9 to 16)
			icon_state = "pinonmedium"
		if(16 to INFINITY)
			icon_state = "pinonfar"
	spawn(5) .()

/obj/item/weapon/pinpointer/scanpoint_locator/unsc
	name = "Covenant Signal Intercept Device"
	desc = "Intercepts high-powered Covenant scanning signals."
	check_point_active = 1
