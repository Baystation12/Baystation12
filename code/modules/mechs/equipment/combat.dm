/obj/item/mech_equipment/mounted_system/taser
	name = "mounted electrolaser carbine"
	desc = "A dual fire mode electrolaser system connected to the exosuit's targetting system."
	icon_state = "mech_taser"
	holding_type = /obj/item/weapon/gun/energy/taser/carbine/mounted/mech
	restricted_hardpoints = list(HARDPOINT_LEFT_HAND, HARDPOINT_RIGHT_HAND)
	restricted_software = list(MECH_SOFTWARE_WEAPONS)

/obj/item/mech_equipment/mounted_system/taser/ion
	name = "mounted ion rifle"
	desc = "An exosuit-mounted ion rifle. Handle with care."
	icon_state = "mech_ionrifle"
	holding_type = /obj/item/weapon/gun/energy/ionrifle/mounted/mech

/obj/item/mech_equipment/mounted_system/taser/laser
	name = "\improper CH-PS \"Immolator\" laser"
	desc = "An exosuit-mounted laser rifle. Handle with care."
	icon_state = "mech_lasercarbine"
	holding_type = /obj/item/weapon/gun/energy/laser/mounted/mech

/obj/item/weapon/gun/energy/taser/carbine/mounted/mech
	use_external_power = TRUE
	has_safety = FALSE
	self_recharge = TRUE

/obj/item/weapon/gun/energy/ionrifle/mounted/mech
	use_external_power = TRUE
	has_safety = FALSE
	self_recharge = TRUE

/obj/item/weapon/gun/energy/laser/mounted/mech
	name = "\improper CH-PS \"Immolator\" laser"
	use_external_power = TRUE
	has_safety = FALSE
	self_recharge = TRUE

/obj/item/weapon/gun/energy/get_hardpoint_maptext()
	return "[round(power_supply.charge / charge_cost)]/[max_shots]"

/obj/item/weapon/gun/energy/get_hardpoint_status_value()
	var/obj/item/weapon/cell/C = get_cell()
	if(istype(C))
		return C.charge/C.maxcharge
	return null

/obj/item/mech_equipment/shields
	name = "exosuit shield droid"
	desc = "The Hephaestus Armature system is a well liked energy deflector system designed to stop any projectile before it has a chance to become a threat."
	icon_state = "shield_droid"
	var/obj/aura/mechshield/aura = null
	var/max_charge = 150
	var/charge = 150
	var/last_recharge = 0
	var/charging_rate = 7500 * CELLRATE
	var/cooldown = 3.5 SECONDS //Time until we can recharge again after a blocked impact
	restricted_hardpoints = list(HARDPOINT_BACK)
	restricted_software = list(MECH_SOFTWARE_WEAPONS)

/obj/item/mech_equipment/shields/installed(var/mob/living/exosuit/_owner)
	. = ..()
	aura = new(owner, src)

/obj/item/mech_equipment/shields/uninstalled()
	QDEL_NULL(aura)
	. = ..()

/obj/item/mech_equipment/shields/attack_self(var/mob/user)
	. = ..()
	if(.)
		toggle()

/obj/item/mech_equipment/shields/proc/stop_damage(var/damage)
	var/difference = damage - charge
	charge = Clamp(charge - damage, 0, max_charge)

	last_recharge = world.time

	if(difference > 0)
		for(var/mob/pilot in owner.pilots)
			to_chat(pilot, SPAN_DANGER("Warning: Deflector shield failure detect, shutting down"))
		toggle()
		playsound(owner.loc,'sound/mecha/internaldmgalarm.ogg',35,1)
		return difference
	else return 0
		
/obj/item/mech_equipment/shields/proc/toggle()
	if(!aura)
		return
	aura.toggle()
	playsound(owner,'sound/weapons/flash.ogg',35,1)
	update_icon()
	if(aura.active)
		START_PROCESSING(SSobj, src)
	else 
		STOP_PROCESSING(SSobj, src)
	owner.update_icon()

/obj/item/mech_equipment/shields/on_update_icon()
	. = ..()
	if(!aura)
		return
	if(aura.active)
		icon_state = "shield_droid_a"
	else 
		icon_state = "shield_droid"

/obj/item/mech_equipment/shields/Process()
	if(charge >= max_charge)
		return
	if((world.time - last_recharge) < cooldown)
		return	
	var/obj/item/weapon/cell/cell = owner.get_cell()
	
	var/actual_required_power = Clamp(max_charge - charge, 0, charging_rate)

	charge += cell.use(actual_required_power)

/obj/item/mech_equipment/shields/get_hardpoint_status_value()
	return charge / max_charge

/obj/item/mech_equipment/shields/get_hardpoint_maptext()	
	return "[(aura && aura.active) ? "ONLINE" : "OFFLINE"]: [round((charge / max_charge) * 100)]%"

/obj/aura/mechshield
	icon = 'icons/mecha/shield.dmi'
	name = "mechshield"
	var/obj/item/mech_equipment/shields/shields = null
	var/active = 0
	layer = ABOVE_HUMAN_LAYER
	var/north_layer = MECH_UNDER_LAYER
	plane = DEFAULT_PLANE
	pixel_x = 8
	pixel_y = 4
	mouse_opacity = 0 

/obj/aura/mechshield/Initialize(var/maploading, var/obj/item/mech_equipment/shields/holder)
	. = ..()
	shields = holder
		
/obj/aura/mechshield/added_to(var/mob/living/target)
	. = ..()
	target.vis_contents += src
	set_dir()
	GLOB.dir_set_event.register(user, src, /obj/aura/mechshield/proc/update_dir)

/obj/aura/mechshield/proc/update_dir(var/user, var/old_dir, var/dir)
	set_dir(dir)

/obj/aura/mechshield/set_dir(new_dir)
	. = ..()
	if(dir == NORTH)
		layer = north_layer
	else layer = initial(layer)

/obj/aura/mechshield/Destroy()
	if(user)
		GLOB.dir_set_event.unregister(user, src, /obj/aura/mechshield/proc/update_dir)
		user.vis_contents -= src
	shields = null
	. = ..()
	
/obj/aura/mechshield/proc/toggle()
	active = !active

	update_icon()

	if(active)
		flick("shield_raise", src)
	else 
		flick("shield_drop", src)
	

/obj/aura/mechshield/on_update_icon()
	. = ..()
	if(active)
		icon_state = "shield"
	else 
		icon_state = "shield_null"

/obj/aura/mechshield/bullet_act(var/obj/item/projectile/P, var/def_zone)
	if(!active)
		return
	if(shields)
		if(shields.charge)
			P.damage = shields.stop_damage(P.damage)
			user.visible_message(SPAN_WARNING("\The [shields.owner]'s shields flash and crackle."))
			flick("shield_impact", src)
			playsound(user,'sound/effects/basscannon.ogg',35,1)
			//light up the night.
			new /obj/effect/effect/smoke/illumination(user.loc, 5, 4, 1, "#ffffff")
			if(P.damage <= 0)
				return AURA_FALSE|AURA_CANCEL

			var/datum/effect/effect/system/spark_spread/spark_system = new /datum/effect/effect/system/spark_spread()
			spark_system.set_up(5, 0, user)
			spark_system.start()
			playsound(loc, "sparks", 25, 1)

/obj/aura/mechshield/hitby(atom/movable/M, var/datum/thrownthing/TT)
	. = ..()
	if(!active)
		return
	if(shields.charge && TT.speed <= 5)
		user.visible_message(SPAN_WARNING("\The [shields.owner]'s shields flash briefly as they deflect \the [M]."))
		flick("shield_impact", src)
		playsound(user,'sound/effects/basscannon.ogg',10,1)
		return AURA_FALSE|AURA_CANCEL
	//Too fast!

//Melee! As a general rule I would recommend using regular objects and putting logic in them.
/obj/item/mech_equipment/mounted_system/melee
	restricted_hardpoints = list(HARDPOINT_LEFT_HAND, HARDPOINT_RIGHT_HAND)
	restricted_software = list(MECH_SOFTWARE_UTILITY)
/obj/item/weapon/material/hatchet/machete/mech
	name = "Mechete"
	desc = "That thing was too big to be called a machete. Too big, too thick, too heavy, and too rough, it was more like a large hunk of iron."
	w_class = ITEM_SIZE_GARGANTUAN
	slot_flags = 0
	default_material = MATERIAL_STEEL
	base_parry_chance = 0 //Irrelevant for exosuits, revise if this changes
	max_force = 50
	force_multiplier = 0.35 //21 with hardness 60 (steel)
	unbreakable = TRUE //Else we need a whole system for replacement blades

/obj/item/weapon/material/hatchet/machete/mech/apply_hit_effect(mob/living/target, mob/living/user, hit_zone)
	. = ..()
	if (.)
		do_attack_effect(target, "smash")
		if (target.mob_size < user.mob_size) //Damaging attacks overwhelm smaller mobs
			target.throw_at(get_edge_target_turf(target,get_dir(user, target)),1, 1)

/obj/item/weapon/material/hatchet/machete/mech/resolve_attackby(atom/A, mob/user, click_params)
	//Case 1: Default, you are hitting something that isn't a mob. Just do whatever, this isn't dangerous or op.
	if (!istype(A, /mob/living))
		return ..()

	if (user.a_intent == I_HURT)
		user.setClickCooldown(0.7 SECONDS)
		user.visible_message(SPAN_DANGER("\The [user] swings \the [src] at \the [A]!"))
		playsound(user, 'sound/mecha/mechmove03.ogg', 35, 1)
		if (do_after(user, 0.7 SECONDS, A, do_flags = DO_SHOW_PROGRESS | DO_TARGET_CAN_TURN | DO_PUBLIC_PROGRESS | DO_USER_UNIQUE_ACT))
			attack(A, user, user.zone_sel.selecting, TRUE)
			return TRUE

/obj/item/weapon/material/hatchet/machete/mech/attack_self(mob/living/user)
	. = ..()
	if (user.a_intent != I_HURT)
		return
	var/obj/item/mech_equipment/mounted_system/melee/mechete/MC = loc
	if (istype(MC))
		//SPIN BLADE ATTACK GO!
		var/mob/living/exosuit/E = MC.owner
		if (E)
			E.setClickCooldown(1.2 SECONDS)
			E.visible_message(SPAN_DANGER("\The [E] swings \the [src] back, preparing for an attack!"), blind_message = SPAN_DANGER("You hear the loud hissing of hydraulics!"))
			playsound(E, 'sound/mecha/mechmove03.ogg', 35, 1)
			if (do_after(E, 1.2 SECONDS, get_turf(user), do_flags = DO_SHOW_PROGRESS | DO_TARGET_CAN_TURN | DO_PUBLIC_PROGRESS | DO_USER_UNIQUE_ACT) && E && MC)
				for (var/mob/living/M in orange(1, E))
					attack(M, E, E.zone_sel.selecting, FALSE)
				E.spin(0.65 SECONDS, 0.125 SECONDS)
				playsound(E, 'sound/mecha/mechturn.ogg', 40, 1)

/obj/item/mech_equipment/mounted_system/melee/mechete
	icon_state = "mech_blade"
	holding_type = /obj/item/weapon/material/hatchet/machete/mech
