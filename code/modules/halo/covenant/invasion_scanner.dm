
/obj/structure/invasion_scanner
	name = "Forerunner Scanning Device"
	desc = "Used to scan for forerunner facilities and artifacts. Destruction of a singular device greatly disrupts the scanning, and multiple scanners increase the scanning efficiency."
	icon = 'code/modules/halo/covenant/structures_machines/scanner.dmi'
	icon_state = "scan"
	density = 1
	anchored = 0
	pixel_x = -16
	var/datum/game_mode/outer_colonies/gm

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
	if(gm)
		gm.register_scanner_destroy()
	. = ..()