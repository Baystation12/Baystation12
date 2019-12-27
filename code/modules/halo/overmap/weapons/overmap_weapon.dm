
/obj/machinery/overmap_weapon_console
	icon = 'code/modules/halo/overmap/weapons/overmap_weapon_base.dmi'
	icon_state = "wep_base"
	anchored = 1
	density = 1
	var/direction_locked = 0 //Determines if this weapon can freely fire on the overmap or not.
	var/obj/item/projectile/overmap/fired_projectile = /obj/item/projectile/overmap
	var/sound/fire_sound = null
	var/requires_ammo = 0
	var/do_track_fired_proj = 1
	var/currently_tracked_proj = null
	var/list/loaded_ammo = list()
	var/list/linked_devices = list() //Handled on a weapon-by-weapon basis
	ai_access_level = 4

/obj/machinery/overmap_weapon_console/attack_ai(var/mob/living/silicon/ai/ai)
	if(!istype(ai))
		return
	if(!ai.console_operating)
		ai.console_operating = src
		ai.machine = src
		ai.reset_view(map_sectors["[z]"])
		to_chat(ai,"<span class = 'notice'>You are now operating a ship weapon. Use Cancel Camera View to leave, or use movement controls then click on an empty tile.</span>")

/obj/machinery/overmap_weapon_console/ex_act(var/severity)
	return

/obj/machinery/overmap_weapon_console/verb/toggle_projectile_tracking()
	set name = "Toggle Ordinance Visual Tracking"
	set desc = "Toggle the usage of long-range ordinance tracking sensors."
	set category = "Object"

	set src in view(1)

	var/mob/living/u = usr
	if(!istype(u))
		return

	visible_message("[u] switches [name]'s ordinance tracking systems to [do_track_fired_proj ? "off" : "on"].")

	do_track_fired_proj = !do_track_fired_proj
	currently_tracked_proj = null
	u.reset_view(null)

/obj/machinery/overmap_weapon_console/attack_hand(var/mob/user)
	scan_linked_devices()
	if(!powered())
		visible_message("<span class = 'notice'>[name] beeps a no-power warning.</span>")
		return
	equip_aim_tool(user)

/obj/machinery/overmap_weapon_console/proc/scan_linked_devices() //Overriden on a weapon-by-weapon basis

/obj/machinery/overmap_weapon_console/check_eye(var/mob/user)
	if(!istype(user,/mob/living/silicon/ai) && (!istype(user.l_hand,/obj/item/weapon/gun/aim_tool) && !istype(user.r_hand,/obj/item/weapon/gun/aim_tool)))
		user.machine = null
		user.reset_view(null)
		return -1
	if(!istype(user,/mob/living/silicon/ai) && get_dist(user,src) > 1)
		user.machine = null
		user.reset_view(null)
		return -1
	return 0

/obj/machinery/overmap_weapon_console/proc/equip_aim_tool(var/mob/living/carbon/human/user)
	scan_linked_devices()
	if(!user || !istype(user))
		return
	var/obj/item/aim_tool = new /obj/item/weapon/gun/aim_tool(src)
	if(!user.put_in_active_hand(aim_tool) && !user.put_in_inactive_hand(aim_tool))
		qdel(aim_tool)
		return
	user.machine = src
	user.reset_view(map_sectors["[z]"])

/obj/machinery/overmap_weapon_console/proc/aim_tool_attackself(var/mob/user,var/obj/item/weapon/gun/aim_tool/tool)

/obj/machinery/overmap_weapon_console/proc/consume_external_ammo()
	var/obj/ammo_to_remove = loaded_ammo[loaded_ammo.len]
	loaded_ammo -= ammo_to_remove
	qdel(ammo_to_remove)

/obj/machinery/overmap_weapon_console/proc/consume_loaded_ammo(var/mob/user)
	if(!requires_ammo)
		return 1
	if(loaded_ammo.len == 0)
		to_chat(user,"<span class = 'warning'>No ammunition loaded.</span>")
		return 0
	consume_external_ammo()
	return 1

/obj/machinery/overmap_weapon_console/proc/get_linked_device_damage_mod()//Defined on a weapon-by-weapon basis.
	return 0

/obj/machinery/overmap_weapon_console/proc/fire_projectile(var/atom/target,var/mob/user,var/directly_above = 0)
	var/obj/om_obj = map_sectors["[z]"]
	var/obj/item/projectile/overmap/new_projectile = new fired_projectile (om_obj.loc,src)
	new_projectile.damage += get_linked_device_damage_mod()
	new_projectile.permutated += om_obj //Ensuring we don't hit ourselves somehow
	new_projectile.firer = user
	new_projectile.overmap_fired_by = om_obj
	new_projectile.console_fired_by = src
	if(directly_above)
		new_projectile.on_impact(target)
		qdel(new_projectile)
	else
		new_projectile.launch(target,null)
	play_fire_sound(src)
	var/obj/effect/overmap/om_targ = target
	if(istype(om_targ) && om_targ.map_z.len > 0)
		for(var/z_level in om_targ)
			play_fire_sound(1,1,z_level)

/obj/machinery/overmap_weapon_console/proc/play_fire_sound(var/atom/loc_sound_origin)
	if(isnull(fire_sound))
		return

	playsound(loc_sound_origin, fire_sound, 25, 1, 5, 5,1)

/obj/machinery/overmap_weapon_console/proc/can_fire(var/atom/target,var/mob/living/user,var/click_params)
	scan_linked_devices()
	if(!user)
		return 0
	if(get_dist(user,src) > 1)
		to_chat(user,"<span class = 'notice'>You need to be next to the firing console to do that!</span>")
		return 0
	var/obj/overmap_sector = map_sectors["[z]"]
	if(!overmap_sector)
		return 0
	if(target == overmap_sector)
		to_chat(user,"<span class = 'warning'>You can't fire at yourself!</span>")
		return 0
	if(direction_locked && (get_dir(overmap_sector,target) != overmap_sector.dir)) //Direction lock check.
		to_chat(user,"<span class = 'warning'>Weapon is locked to direction of ship. Realign ship to fire.</span>")
		return 0
	if(!consume_loaded_ammo(user))
		return 0
	return 1

/obj/machinery/overmap_weapon_console/proc/fire(var/atom/target,var/mob/living/user,var/click_params)
	scan_linked_devices()
	if(!can_fire(target,user,click_params))
		return 0
	if(!powered())
		visible_message("<span class = 'notice'>[name] beeps a no-power warning.</span>")
		return
	var/obj/overmap_sector = map_sectors["[z]"]
	var/directly_above = 0
	if(target.loc == overmap_sector.loc)
		directly_above = 1

	fire_projectile(target,user,directly_above)
	return 1

//Overmap Weapon Aim Tool//

/obj/item/weapon/gun/aim_tool
	name = "Aiming Tool"
	desc = "Used for aiming a ship- or planet- board devices"
	w_class = ITEM_SIZE_LARGE
	can_rename = 0
	var/obj/machinery/overmap_weapon_console/creator_console

/obj/item/weapon/gun/aim_tool/New(var/console)
	. = ..()
	creator_console = console

/obj/item/weapon/gun/aim_tool/attack_self(var/mob/user)
	creator_console.aim_tool_attackself(user,src)

/obj/item/weapon/gun/aim_tool/afterattack(var/atom/target,var/mob/user,adjacent,var/clickparams)
	creator_console.fire(target,user,clickparams)

/obj/item/weapon/gun/aim_tool/dropped()
	qdel(src)
