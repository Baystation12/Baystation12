/obj/effect/landmark/scanning_point
	name = "Invasion Scan Point"
	invisibility = 61
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
		if(scanpoint == oldpoint || index == scanpoints.len)
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
