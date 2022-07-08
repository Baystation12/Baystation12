/obj/item/mech_equipment/mounted_system/taser
	name = "mounted burst electrolaser carbine"
	desc = "A dual fire mode burst electrolaser system connected to the exosuit's targetting system."
	icon_state = "mech_taser"
	holding_type = /obj/item/gun/energy/taser/carbine/mounted/mech
	restricted_hardpoints = list(HARDPOINT_LEFT_HAND, HARDPOINT_RIGHT_HAND)
	restricted_software = list(MECH_SOFTWARE_WEAPONS)

/obj/item/mech_equipment/mounted_system/taser/MouseDragInteraction(src_object, over_object, src_location, over_location, src_control, over_control, params, var/mob/user)
	. = ..()

	if(over_object)
		var/obj/item/gun/gun = holding
		if(istype(gun) && gun.can_autofire())
			gun.Fire(get_turf(over_object), owner, params, (get_dist(over_object, owner) <= 1), FALSE)

/obj/item/mech_equipment/mounted_system/taser/ion
	name = "mounted ion rifle"
	desc = "An exosuit-mounted ion rifle. Handle with care."
	icon_state = "mech_ionrifle"
	holding_type = /obj/item/gun/energy/ionrifle/mounted/mech

/obj/item/mech_equipment/mounted_system/taser/laser
	name = "\improper CH-PS \"Immolator\" laser"
	desc = "An exosuit-mounted laser rifle. Handle with care."
	icon_state = "mech_lasercarbine"
	holding_type = /obj/item/gun/energy/lasercannon/mounted/mech

/obj/item/gun/energy/taser/carbine/mounted/mech
	use_external_power = TRUE
	has_safety = FALSE
	self_recharge = TRUE
	burst = 3
	burst_delay = 3

/obj/item/gun/energy/ionrifle/mounted/mech
	use_external_power = TRUE
	has_safety = FALSE
	self_recharge = TRUE

/obj/item/gun/energy/lasercannon/mounted/mech
	name = "\improper CH-PS \"Immolator\" laser"
	use_external_power = TRUE
	has_safety = FALSE
	self_recharge = TRUE
	fire_delay = 15
	accuracy = 2

/obj/item/gun/energy/get_hardpoint_maptext()
	if (charge_cost <= 0)
		return "INF"
	return "[round(power_supply.charge / charge_cost)]/[max_shots]"

/obj/item/gun/energy/get_hardpoint_status_value()
	var/obj/item/cell/C = get_cell()
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
	charge = clamp(charge - damage, 0, max_charge)

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
	active = aura.active
	passive_power_use = active ? 1 KILOWATTS : 0
	owner.update_icon()

/obj/item/mech_equipment/shields/deactivate()
	if(active)
		toggle()
	..()

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
	var/obj/item/cell/cell = owner.get_cell()

	var/actual_required_power = clamp(max_charge - charge, 0, charging_rate)

	if(cell)
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

/obj/item/material/hatchet/machete/mech
	name = "Mechete"
	desc = "That thing was too big to be called a machete. Too big, too thick, too heavy, and too rough, it was more like a large hunk of iron."
	w_class = ITEM_SIZE_GARGANTUAN
	slot_flags = 0
	default_material = MATERIAL_STEEL
	base_parry_chance = 0 //Irrelevant for exosuits, revise if this changes
	max_force = 25
	force_multiplier = 0.75 // Equals 20 AP with 25 force
	unbreakable = TRUE //Else we need a whole system for replacement blades
	attack_cooldown_modifier = 10

/obj/item/material/hatchet/machete/mech/apply_hit_effect(mob/living/target, mob/living/user, hit_zone)
	. = ..()
	if (.)
		do_attack_effect(target, "smash")
		if (target.mob_size < user.mob_size) //Damaging attacks overwhelm smaller mobs
			target.throw_at(get_edge_target_turf(target,get_dir(user, target)),1, 1)

/obj/item/material/hatchet/machete/mech/resolve_attackby(atom/A, mob/user, click_params)
	//Case 1: Default, you are hitting something that isn't a mob. Just do whatever, this isn't dangerous or op.
	if (!istype(A, /mob/living))
		return ..()

	if (user.a_intent == I_HURT)
		user.visible_message(SPAN_DANGER("\The [user] swings \the [src] at \the [A]!"))
		playsound(user, 'sound/mecha/mechmove03.ogg', 35, 1)
		return ..()

/obj/item/material/hatchet/machete/mech/attack_self(mob/living/user)
	. = ..()
	if (user.a_intent != I_HURT)
		return
	var/obj/item/mech_equipment/mounted_system/melee/mechete/MC = loc
	if (istype(MC))
		//SPIN BLADE ATTACK GO!
		var/mob/living/exosuit/E = MC.owner
		if (E)
			E.setClickCooldown(1.35 SECONDS)
			E.visible_message(SPAN_DANGER("\The [E] swings \the [src] back, preparing for an attack!"), blind_message = SPAN_DANGER("You hear the loud hissing of hydraulics!"))
			playsound(E, 'sound/mecha/mechmove03.ogg', 35, 1)
			if (do_after(E, 1.2 SECONDS, get_turf(user), DO_DEFAULT | DO_USER_UNIQUE_ACT | DO_PUBLIC_PROGRESS) && E && MC)
				for (var/mob/living/M in orange(1, E))
					attack(M, E, E.zone_sel.selecting, FALSE)
				E.spin(0.65 SECONDS, 0.125 SECONDS)
				playsound(E, 'sound/mecha/mechturn.ogg', 40, 1)

/obj/item/mech_equipment/mounted_system/melee/mechete
	icon_state = "mech_blade"
	holding_type = /obj/item/material/hatchet/machete/mech


//Ballistic shield
/obj/item/mech_equipment/ballistic_shield
	name = "exosuit ballistic shield"
	desc = "The Hephaestus Bulwark is a formidable line of defense that sees widespread use in planetary peacekeeping operations and military formations alike."
	icon_state = "mech_shield" //Rendering is handled by aura due to layering issues: TODO, figure out a better way to do this
	var/obj/aura/mech_ballistic/aura = null
	var/last_push = 0
	var/chance = 60 //For attacks from the front, diminishing returns
	var/last_max_block = 0 //Blocking during a perfect block window resets this, else there is an anti spam
	var/max_block = 60 // Should block most things
	var/blocking = FALSE
	restricted_hardpoints = list(HARDPOINT_LEFT_HAND, HARDPOINT_RIGHT_HAND)
	restricted_software = list(MECH_SOFTWARE_UTILITY)

/obj/item/mech_equipment/ballistic_shield/installed(mob/living/exosuit/_owner)
	. = ..()
	aura = new(owner, src)

/obj/item/mech_equipment/ballistic_shield/uninstalled()
	QDEL_NULL(aura)
	. = ..()

/obj/item/mech_equipment/ballistic_shield/afterattack(atom/target, mob/living/user, inrange, params)
	. = ..()
	if (.)
		if (user.a_intent == I_HURT )
			if (last_push + 1.6 SECONDS < world.time)
				owner.visible_message(SPAN_WARNING("\The [owner] retracts \the [src], preparing to push with it!"), blind_message = SPAN_WARNING("You hear the whine of hydraulics and feel a rush of air!"))
				owner.setClickCooldown(0.7 SECONDS)
				last_push = world.time
				if (do_after(owner, 0.5 SECONDS, get_turf(owner), DO_DEFAULT | DO_USER_UNIQUE_ACT | DO_PUBLIC_PROGRESS) && owner)
					owner.visible_message(SPAN_WARNING("\The [owner] slams the area in front \the [src]!"), blind_message = SPAN_WARNING("You hear a loud hiss and feel a strong gust of wind!"))
					playsound(src ,'sound/effects/bang.ogg',35,1)
					var/list/turfs = list()
					var/front = get_step(get_turf(owner), owner.dir)
					turfs += front
					turfs += get_step(front, turn(owner.dir, -90))
					turfs += get_step(front, turn(owner.dir,  90))
					for(var/turf/T in turfs)
						for(var/mob/living/M in T)
							if (!M.Adjacent(owner))
								continue
							M.attack_generic(owner, (owner.arms ? owner.arms.melee_damage * 1.2 : 0), "slammed")
							M.throw_at(get_edge_target_turf(owner ,owner.dir),5, 2)
						do_attack_effect(T, "smash")

/obj/item/mech_equipment/ballistic_shield/attack_self(mob/user)
	. = ..()
	if (.) //FORM A SHIELD WALL!
		if (last_max_block + 2 SECONDS < world.time)
			owner.visible_message(SPAN_WARNING("\The [owner] raises \the [src], locking it in place!"), blind_message = SPAN_WARNING("You hear the whir of motors and scratching metal!"))
			playsound(src ,'sound/effects/bamf.ogg',35,1)
			owner.setClickCooldown(0.8 SECONDS)
			blocking = TRUE
			last_max_block = world.time
			do_after(owner, 0.75 SECONDS, get_turf(user), DO_DEFAULT | DO_USER_UNIQUE_ACT | DO_PUBLIC_PROGRESS)
			blocking = FALSE
		else
			to_chat(user, SPAN_WARNING("You are not ready to block again!"))

/obj/item/mech_equipment/ballistic_shield/proc/block_chance(damage, pen, atom/source, mob/attacker)
	if (damage > max_block || pen > max_block)
		return 0
	else
		var/effective_block = blocking ? chance * 1.5 : chance

		var/conscious_pilot_exists = FALSE
		for (var/mob/living/pilot in owner.pilots)
			if (!pilot.incapacitated())
				conscious_pilot_exists = TRUE
				break

		if (!conscious_pilot_exists)
			effective_block *= 0.5 //Who is going to block anything?

		//Bit copypasta but I am doing something different from normal shields
		var/attack_dir = 0
		if (istype(source, /obj/item/projectile))
			var/obj/item/projectile/P = source
			attack_dir = get_dir(get_turf(src), P.starting)
		else if (attacker)
			attack_dir = get_dir(get_turf(src), get_turf(attacker))
		else if (source)
			attack_dir = get_dir(get_turf(src), get_turf(source))

		if (attack_dir == turn(owner.dir, -90) || attack_dir == turn(owner.dir, 90))
			effective_block *= 0.8
		else if (attack_dir == turn(owner.dir, 180))
			effective_block = 0

		return effective_block

/obj/item/mech_equipment/ballistic_shield/proc/on_block_attack()
	if (blocking)
		//Reset timer for maximum chainblocks
		last_max_block = 0

/obj/aura/mech_ballistic
	icon = 'icons/mecha/ballistic_shield.dmi'
	name = "mech_ballistic_shield"
	var/obj/item/mech_equipment/ballistic_shield/shield = null
	layer = MECH_UNDER_LAYER
	plane = DEFAULT_PLANE
	mouse_opacity = 0

/obj/aura/mech_ballistic/Initialize(maploading, obj/item/mech_equipment/ballistic_shield/holder)
	. = ..()
	shield = holder

	//Get where we are attached so we know what icon to use
	if (holder && holder.owner)
		var/mob/living/exosuit/E = holder.owner
		for (var/hardpoint in E.hardpoints)
			var/obj/item/mech_equipment/hardpoint_object = E.hardpoints[hardpoint]
			if (holder == hardpoint_object)
				icon_state = "mech_shield_[hardpoint]"
				var/image/I = image(icon, "[icon_state]_over")
				I.layer = ABOVE_HUMAN_LAYER
				overlays.Add(I)

/obj/aura/mech_ballistic/added_to(mob/living/target)
	. = ..()
	target.vis_contents += src
	set_dir()
	GLOB.dir_set_event.register(user, src, /obj/aura/mech_ballistic/proc/update_dir)

/obj/aura/mech_ballistic/proc/update_dir(user, old_dir, dir)
	set_dir(dir)

/obj/aura/mech_ballistic/Destroy()
	if (user)
		GLOB.dir_set_event.unregister(user, src, /obj/aura/mech_ballistic/proc/update_dir)
		user.vis_contents -= src
	shield = null
	. = ..()

/obj/aura/mech_ballistic/bullet_act(obj/item/projectile/P, def_zone)
	. = ..()
	if (shield)
		if (prob(shield.block_chance(P.damage, P.armor_penetration, source = P)))
			user.visible_message(SPAN_WARNING("\The [P] is blocked by \the [user]'s [shield]."))
			user.bullet_impact_visuals(P, def_zone, 0)
			return AURA_FALSE|AURA_CANCEL

/obj/aura/mech_ballistic/hitby(atom/movable/M, datum/thrownthing/TT)
	. = ..()
	if (shield)
		var/throw_damage = 0
		if (isobj(M))
			var/obj/O = M
			throw_damage = O.throwforce*(TT.speed/THROWFORCE_SPEED_DIVISOR)

		if (prob(shield.block_chance(throw_damage, 0, source = M, attacker = TT.thrower)))
			user.visible_message(SPAN_WARNING("\The [M] bounces off \the [user]'s [shield]."))
			playsound(user.loc, 'sound/weapons/Genhit.ogg', 50, 1)
			return AURA_FALSE|AURA_CANCEL

/obj/aura/mech_ballistic/attackby(obj/item/I, mob/user)
	. = ..()
	if (shield)
		if (prob(shield.block_chance(I.force, I.armor_penetration, source = I, attacker = user)))
			user.visible_message(SPAN_WARNING("\The [I] is blocked by \the [user]'s [shield]."))
			playsound(user.loc, 'sound/weapons/Genhit.ogg', 50, 1)
			return AURA_FALSE|AURA_CANCEL

/obj/item/mech_equipment/flash
	name = "exosuit flash"
	icon_state = "mech_flash"
	var/flash_min = 7
	var/flash_max = 9
	var/flash_range = 3
	restricted_hardpoints = list(HARDPOINT_LEFT_SHOULDER, HARDPOINT_RIGHT_SHOULDER)
	restricted_software = list(MECH_SOFTWARE_WEAPONS)
	active_power_use = 7 KILOWATTS
	var/next_use = 0
	origin_tech = list(TECH_MAGNET = 2, TECH_COMBAT = 2)

/obj/item/mech_equipment/flash/proc/area_flash()
	playsound(src.loc, 'sound/weapons/flash.ogg', 100, 1)
	var/flash_time = (rand(flash_min,flash_max) - 1)

	var/obj/item/cell/C = owner.get_cell()
	C.use(active_power_use * CELLRATE)

	for (var/mob/living/O in oviewers(flash_range, owner))
		if(istype(O))
			var/protection = O.eyecheck()
			if(protection >= FLASH_PROTECTION_MODERATE)
				return

			if(protection >= FLASH_PROTECTION_MINOR)
				flash_time /= 2

			if(ishuman(O))
				var/mob/living/carbon/human/H = O
				flash_time = round(H.getFlashMod() * flash_time)
				if(flash_time <= 0)
					return

			if(!O.blinded)
				O.flash_eyes(FLASH_PROTECTION_MODERATE - protection)
				O.eye_blurry += flash_time
				O.confused += (flash_time + 2)

/obj/item/mech_equipment/flash/attack_self(mob/user)
	. = ..()
	if(.)
		if(world.time < next_use)
			to_chat(user, SPAN_WARNING("\The [src] is recharging!"))
			return
		next_use = world.time + 20
		area_flash()
		owner.setClickCooldown(5)

/obj/item/mech_equipment/flash/afterattack(atom/target, mob/living/user, inrange, params)
	. = ..()
	if(.)
		if(world.time < next_use)
			to_chat(user, SPAN_WARNING("\The [src] is recharging!"))
			return
		var/mob/living/O = target
		owner.setClickCooldown(5)
		next_use = world.time + 15

		if(istype(O))

			playsound(src.loc, 'sound/weapons/flash.ogg', 100, 1)
			var/flash_time = (rand(flash_min,flash_max))

			var/obj/item/cell/C = owner.get_cell()
			C.use(active_power_use * CELLRATE)

			var/protection = O.eyecheck()
			if(protection >= FLASH_PROTECTION_MAJOR)
				return

			if(protection >= FLASH_PROTECTION_MODERATE)
				flash_time /= 2

			if(ishuman(O))
				var/mob/living/carbon/human/H = O
				flash_time = round(H.getFlashMod() * flash_time)
				if(flash_time <= 0)
					return

			if(!O.blinded)
				O.flash_eyes(FLASH_PROTECTION_MAJOR - protection)
				O.eye_blurry += flash_time
				O.confused += (flash_time + 2)

				if(isanimal(O)) //Hit animals a bit harder
					O.Stun(flash_time)
				else
					O.Stun(flash_time / 2)

				if(flash_time > 3)
					O.drop_l_hand()
					O.drop_r_hand()
				if(flash_time > 5)
					O.Weaken(3)

/obj/item/flamethrower/full/mech
	max_beaker = ITEM_SIZE_NORMAL
	range = 5
	desc = "A Hephaestus brand 'Prometheus' flamethrower. Bigger and better."

/obj/item/flamethrower/full/mech/Initialize()
	. = ..()
	beaker = new /obj/item/reagent_containers/chem_disp_cartridge(src)

/obj/item/flamethrower/full/mech/get_hardpoint_maptext()
	return beaker ? "[lit ? "ON" : "OFF"]-:-[beaker.reagents.total_volume]/[beaker.reagents.maximum_volume]" : "NO TANK"

/obj/item/flamethrower/full/mech/get_hardpoint_status_value()
	return beaker ? beaker.reagents.total_volume/beaker.reagents.maximum_volume : 0

/obj/item/mech_equipment/mounted_system/flamethrower
	icon_state = "mech_flamer"
	holding_type = /obj/item/flamethrower/full/mech
	restricted_hardpoints = list(HARDPOINT_LEFT_HAND, HARDPOINT_RIGHT_HAND)
	restricted_software = list(MECH_SOFTWARE_WEAPONS)

/obj/item/mech_equipment/mounted_system/flamethrower/attack_self(mob/user)
	. = ..()
	if(owner && holding)
		update_icon()

/obj/item/mech_equipment/mounted_system/flamethrower/attackby(obj/item/W as obj, mob/user as mob)
	if(!CanPhysicallyInteract(user))	return

	var/obj/item/flamethrower/full/mech/FM = holding
	if(istype(FM))
		if(isCrowbar(W) && FM.beaker)
			if(FM.beaker)
				user.visible_message(SPAN_NOTICE("\The [user] pries out \the [FM.beaker] using \the [W]."))
				FM.beaker.dropInto(get_turf(user))
				FM.beaker = null
			return

		if (istype(W, /obj/item/reagent_containers) && W.is_open_container() && (W.w_class <= FM.max_beaker))
			if(FM.beaker)
				to_chat(user, SPAN_NOTICE("There is already a tank inserted!"))
				return
			if(user.unEquip(W, FM))
				user.visible_message(SPAN_NOTICE("\The [user] inserts \the [W] inside \the [src]."))
				FM.beaker = W
			return
	..()

/obj/item/mech_equipment/mounted_system/flamethrower/on_update_icon()
	. = ..()
	if(owner && holding)
		var/obj/item/flamethrower/full/mech/FM = holding
		if(istype(FM))
			if(FM.lit)
				icon_state = "mech_flamer_lit"
			else icon_state = "mech_flamer"

			if(owner)
				owner.update_icon()
