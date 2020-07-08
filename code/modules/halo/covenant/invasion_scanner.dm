#define HIT_REGEN_TIME 5 MINUTES

/obj/structure/invasion_scanner
	name = "Forerunner Scanning Device"
	desc = "Used to scan for forerunner facilities and artifacts. Destruction of a singular device greatly disrupts the scanning, and multiple scanners increase the scanning efficiency."
	icon = 'code/modules/halo/covenant/structures_machines/scanner.dmi'
	icon_state = "scan"
	density = 1
	anchored = 0
	var/datum/game_mode/outer_colonies/gm
	var/explosive_hits = 5
	var/regen_at = 0

/obj/structure/invasion_scanner/ex_act(var/severity)
	explosive_hits -= (round(3/severity))
	if(explosive_hits <= 0)
		qdel(src)
	else
		if(regen_at == 0)
			GLOB.processing_objects += src
		regen_at = world.time + HIT_REGEN_TIME

/obj/structure/invasion_scanner/process()
	if(world.time >= regen_at)
		explosive_hits = initial(explosive_hits)
		regen_at = 0
		GLOB.processing_objects -= src

/obj/structure/invasion_scanner/examine(var/mob/user)
	. = ..()
	to_chat(user,"It is [anchored ? "active" : "inactive"]")

/obj/structure/invasion_scanner/attack_hand(var/mob/living/attacker)
	if(!istype(attacker))
		return
	if(!is_covenant_mob(attacker))
		to_chat(attacker, "<span class = 'notice'>You don't know how to toggle [src]...</span>")
		return
	if(gm)
		visible_message("<span class = 'notice'>[attacker] toggles [src]</span>")
		toggle_scanner()
	else
		gm = ticker.mode

/obj/structure/invasion_scanner/proc/can_register()
	var/obj/effect/landmark/scanning_point/point = locate(/obj/effect/landmark/scanning_point) in range(2,src)
	if(isnull(point))
		visible_message("<span class = 'notice'>[src] quickly scans the area, realising nothing of interest is contained here. Relocate for proper scanning.</span>")
		return 0
	if(point.active_scanner)
		visible_message("<span class = 'notice'>[src] shuts down quickly, recognising the interference it would cause with this local area's scanning operations. Relocate to a different point-of-interest.</span>")
		return 0
	point.active_scanner = src
	return 1

/obj/structure/invasion_scanner/proc/toggle_scanner()
	if(anchored)
		gm.unregister_scanner()
		var/obj/effect/landmark/scanning_point/point = locate(/obj/effect/landmark/scanning_point) in range(2,src)
		if(point.active_scanner == src)
			point.active_scanner = null
	else
		if(!can_register())
			return
		gm.register_scanner()
	anchored = !anchored

/obj/structure/invasion_scanner/Destroy()
	gm = ticker.mode
	if(gm)
		gm.register_scanner_destroy()
	. = ..()