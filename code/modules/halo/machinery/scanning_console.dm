/obj/machinery/overmap_weapon_console/ship_scanning_console
	name = "Scanning Console"
	desc = "Provides access to a suite of scanning equipment that can be used to obtain an overall readout of a vessel's superstructure strength, set a target for weapons fire and even launch a small recon drone!"
	icon = 'code/modules/halo/machinery/ship_scanning_console.dmi'
	icon_state = "base"
	fired_projectile = /obj/item/projectile/overmap/ship_scanner/targeting_projectile
	fire_sound = null
	var/list/modes_projs = list("target" = /obj/item/projectile/overmap/ship_scanner/targeting_projectile,"scan" = /obj/item/projectile/overmap/ship_scanner/scanner_projectile)
	var/curr_mode_index = 1

/obj/machinery/overmap_weapon_console/ship_scanning_console/aim_tool_attackself(var/mob/user,var/obj/item/weapon/gun/aim_tool/tool)
	curr_mode_index++
	if(curr_mode_index > modes_projs.len)
		curr_mode_index = 1
	var/mode_name = modes_projs[curr_mode_index]
	to_chat(user,"<span class = 'notice'>Mode now set to [mode_name] mode.</span>")
	fired_projectile = modes_projs[mode_name]

/obj/machinery/overmap_weapon_console/ship_scanning_console/examine(var/examiner)
	. = ..()
	to_chat(examiner,"<span class = 'notice'>Current mode: [modes_projs[curr_mode_index]]</span>")
	var/obj/effect/overmap/om_obj = map_sectors["[z]"]
	if(!isnull(om_obj))
		to_chat(examiner,"<span class = 'notice'>Current target location: [om_obj.targeting_datum.targeted_location]</span>")

//PROJECTILES//
/obj/item/projectile/overmap/ship_scanner
	invisibility = 101
	opacity = 0
	step_delay = 0

/obj/item/projectile/overmap/ship_scanner/targeting_projectile/on_impact(var/atom/impacted)
	var/obj/effect/overmap/om_obj = impacted
	if(isnull(om_obj) || isnull(console_fired_by))
		return
	to_chat(firer,"<span class = 'notice'>[om_obj] set as target. Select target area.</span>")
	overmap_fired_by.targeting_datum.current_target = om_obj
	var/target_area = input(firer,"Select target area.","Target Area Selection") in overmap_fired_by.targeting_datum.current_target.targeting_locations + list("Cancel")
	if(target_area == "Cancel")
		target_area = "no target"
	to_chat(firer,"<span class = 'notice'>Target area set to [target_area]</span>")
	overmap_fired_by.targeting_datum.targeted_location = target_area
	qdel(src)

/obj/item/projectile/overmap/ship_scanner/scanner_projectile/on_impact(var/atom/impacted)
	var/obj/effect/overmap/om_obj = impacted
	if(!istype(om_obj) || isnull(console_fired_by))
		return
	var/obj/effect/overmap/ship/npc_ship/npc = om_obj
	if(om_obj.hull_segments.len == 0 && !istype(npc))
		to_chat(firer,"<span class = 'notice'>No superstructure to scan.</span>")
		return
	var/superstructure_strength = om_obj.get_superstructure_strength() * 100
	if(istype(npc) && !npc.is_player_controlled())
		superstructure_strength = (npc.hull/initial(npc.hull)) * 100
	to_chat(firer,"<span class = 'notice'>Scanning superstructure...</span>")
	sleep(1 SECOND)
	to_chat(firer,"<span class = 'notice'>Superstructure integrity at [superstructure_strength]%.</span>")
	qdel(src)

/obj/machinery/overmap_weapon_console/ship_scanning_console/cov
	icon = 'code/modules/halo/icons/machinery/covenant/consoles.dmi'
	icon_state = "covie_console"
