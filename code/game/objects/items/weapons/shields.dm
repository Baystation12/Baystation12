//** Shield Helpers
//These are shared by various items that have shield-like behaviour

//bad_arc is the ABSOLUTE arc of directions from which we cannot block. If you want to fix it to e.g. the user's facing you will need to rotate the dirs yourself.
/proc/check_shield_arc(mob/user, bad_arc, atom/damage_source = null, mob/attacker = null)
	//check attack direction
	var/attack_dir = 0 //direction from the user to the source of the attack
	if(istype(damage_source, /obj/item/projectile))
		var/obj/item/projectile/P = damage_source
		attack_dir = get_dir(get_turf(user), P.starting)
	else if(attacker)
		attack_dir = get_dir(get_turf(user), get_turf(attacker))
	else if(damage_source)
		attack_dir = get_dir(get_turf(user), get_turf(damage_source))

	if(!(attack_dir && (attack_dir & bad_arc)))
		return 1
	return 0


/proc/default_parry_check(mob/user, mob/attacker, atom/damage_source)
	//parry only melee attacks
	if(istype(damage_source, /obj/item/projectile) || (attacker && get_dist(user, attacker) > 1) || user.incapacitated())
		return 0

	//block as long as they are not directly behind us
	var/bad_arc = reverse_direction(user.dir) //arc of directions from which we cannot block
	if(!check_shield_arc(user, bad_arc, damage_source, attacker))
		return 0

	return 1


/obj/item/shield
	name = "shield"
	var/base_block_chance = 60
	var/max_block = 0


/obj/item/shield/handle_shield(mob/user, damage, atom/damage_source = null, mob/attacker = null, def_zone = null, attack_text = "the attack")
	if(user.incapacitated())
		return 0

	//block as long as they are not directly behind us
	var/bad_arc = reverse_direction(user.dir) //arc of directions from which we cannot block
	if(check_shield_arc(user, bad_arc, damage_source, attacker))
		if(prob(get_block_chance(user, damage, damage_source, attacker)))
			user.visible_message(SPAN_DANGER("\The [user] blocks [attack_text] with \the [src]!"))
			return 1
	return 0

/obj/item/shield/proc/get_block_chance(mob/user, damage, atom/damage_source = null, mob/attacker = null)
	return base_block_chance


/obj/item/shield/riot
	name = "riot shield"
	desc = "A shield adept at blocking blunt objects from connecting with the torso of the shield wielder."
	icon = 'icons/obj/weapons/melee_physical.dmi'
	icon_state = "riot"
	item_state = "riot"
	obj_flags = OBJ_FLAG_CONDUCTIBLE
	slot_flags = SLOT_BACK
	force = 5.0
	throwforce = 5.0
	throw_speed = 1
	throw_range = 4
	w_class = ITEM_SIZE_HUGE
	origin_tech = list(TECH_MATERIAL = 2)
	matter = list(MATERIAL_GLASS = 7500, MATERIAL_STEEL = 1000)
	attack_verb = list("shoved", "bashed")
	var/cooldown = 0 //shield bash cooldown. based on world.time
	var/can_block_lasers = FALSE


/obj/item/shield/riot/handle_shield(mob/user)
	. = ..()
	if(.) playsound(user.loc, 'sound/weapons/Genhit.ogg', 50, 1)


/obj/item/shield/riot/get_block_chance(mob/user, damage, atom/damage_source = null, mob/attacker = null)
	if(istype(damage_source, /obj/item/projectile))
		var/obj/item/projectile/P = damage_source
		//plastic shields do not stop bullets or lasers, even in space. Will block beanbags, rubber bullets, and stunshots just fine though.
		if(is_sharp(P) && damage >= max_block)
			return 0
		if(istype(P, /obj/item/projectile/beam) && (!can_block_lasers || (P.armor_penetration >= max_block)))
			return 0
	return base_block_chance


/obj/item/shield/riot/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W, /obj/item/melee/baton))
		if(cooldown < world.time - 25)
			user.visible_message(SPAN_WARNING("[user] bashes [src] with [W]!"))
			playsound(user.loc, 'sound/effects/shieldbash.ogg', 50, 1)
			cooldown = world.time
	else
		..()


/obj/item/shield/riot/metal
	name = "plasteel combat shield"
	icon = 'icons/obj/weapons/melee_physical.dmi'
	icon_state = "metal"
	item_state = "metal"
	obj_flags = OBJ_FLAG_CONDUCTIBLE
	slot_flags = SLOT_BACK
	force = 6.0
	throwforce = 7.0
	throw_range = 3
	w_class = ITEM_SIZE_HUGE
	matter = list(MATERIAL_PLASTEEL = 8500)
	max_block = 50
	can_block_lasers = TRUE
	slowdown_general = 0.5

/obj/item/shield/buckler
	name = "buckler"
	desc = "A wooden buckler used to block sharp things from entering your body back in the day. Not very good at stopping projectiles, but still better than nothing."
	icon = 'icons/obj/weapons/melee_physical.dmi'
	icon_state = "buckler"
	item_state = "buckler"
	slot_flags = SLOT_BACK
	force = 8
	throwforce = 8
	base_block_chance = 50
	max_block = 15
	throw_speed = 6
	throw_range = 20
	w_class = ITEM_SIZE_HUGE
	origin_tech = list(TECH_MATERIAL = 1)
	matter = list(MATERIAL_STEEL = 1000, MATERIAL_WOOD = 1000)
	attack_verb = list("shoved", "bashed")


/obj/item/shield/buckler/handle_shield(mob/user)
	. = ..()
	if(.) playsound(user.loc, 'sound/weapons/Genhit.ogg', 50, 1)


/obj/item/shield/buckler/get_block_chance(mob/user, damage, atom/damage_source = null, mob/attacker = null)
	if (istype(damage_source, /obj/item/projectile))
		if (max_block && damage >= max_block)
			return 0
		else
			return (base_block_chance / 2)
	return base_block_chance


/obj/item/shield/energy
	name = "energy combat shield"
	desc = "A shield capable of stopping most projectile and melee attacks. It can be retracted, expanded, and stored anywhere."
	icon = 'icons/obj/weapons/melee_energy.dmi'
	icon_state = "eshield0"
	obj_flags = OBJ_FLAG_CONDUCTIBLE
	force = 3.0
	throwforce = 5.0
	throw_speed = 1
	throw_range = 4
	w_class = ITEM_SIZE_SMALL
	origin_tech = list(TECH_MATERIAL = 4, TECH_MAGNET = 3, TECH_ESOTERIC = 4)
	attack_verb = list("shoved", "bashed")
	var/active = FALSE
	var/next_action
	var/sound_token
	var/sound_id
	var/damaged = FALSE
	var/disabled
	var/datum/effect/spark_spread/sparks


/obj/item/shield/energy/Destroy()
	QDEL_NULL(sound_token)
	QDEL_NULL(sparks)
	return ..()


/obj/item/shield/energy/Initialize()
	. = ..()
	sound_id = "[sequential_id(/obj/item/shield/energy)]"
	sparks = new


/obj/item/shield/energy/on_update_icon()
	icon_state = "eshield[active]"
	if (active)
		set_light(1.5, 1.5, "#006aff")
	else
		set_light(0)


/obj/item/shield/energy/proc/activate(mob/living/user)
	var/time = world.time

	if (active)
		return

	if (time < next_action)
		return

	if (damaged)
		if (world.time < disabled)
			if (user)
				user.show_message(SPAN_WARNING("\The [src] sputters. It's not going to work right now!"))
			return
		user.visible_message(SPAN_NOTICE("\The [src] resonates perfectly, once again."))
		damaged = FALSE

	next_action = time + 3 SECONDS
	active = !active

	if (active)
		playsound(src, 'sound/obj/item/shield/energy/shield-start.ogg', 40)
		force = 10
		w_class = ITEM_SIZE_NO_CONTAINER

	if (istype(user,/mob/living/carbon/human))
		var/mob/living/carbon/human/H = user
		H.update_inv_l_hand()
		H.update_inv_r_hand()

	update_icon()
	addtimer(new Callback(src, /obj/item/shield/energy/proc/UpdateSoundLoop), 0.25 SECONDS)


/obj/item/shield/energy/proc/deactivate(mob/living/user)
	if (!active)
		return

	active = !active

	if (!active)
		playsound(src, 'sound/obj/item/shield/energy/shield-stop.ogg', 40)
		force = initial(force)
		w_class = initial(w_class)

	update_icon()

	if (istype(user,/mob/living/carbon/human))
		var/mob/living/carbon/human/H = user
		H.update_inv_l_hand()
		H.update_inv_r_hand()

	addtimer(new Callback(src, /obj/item/shield/energy/proc/UpdateSoundLoop), 0.1 SECONDS)


/obj/item/shield/energy/attack_self(mob/living/user)
	if (!active)
		activate(user)
	else
		deactivate(user)
	return


/obj/item/shield/energy/handle_shield(mob/living/user)
	if (!active && damaged)
		return FALSE
	. = ..()
	if (!.)
		return
	sparks.set_up(2, loca = user)
	sparks.start()


/obj/item/shield/energy/get_block_chance(mob/living/user, damage, atom/damage_source, mob/living/attacker)
	if (isprojectile(damage_source))
		if (damage > 10 && is_sharp(damage_source) || isbeam(damage_source))
			return base_block_chance - round(damage / 2.5)
	return base_block_chance


/obj/item/shield/energy/emp_act(severity)
	SHOULD_CALL_PARENT(FALSE)
	if (!active)
		return
	if (damaged)
		return
	var/disabletime = 30 SECONDS
	if (severity == EMP_ACT_HEAVY)
		disabletime = 1 MINUTES

	visible_message(SPAN_DANGER("\The [src] violently shudders!"))
	new /obj/overlay/self_deleting/emppulse(get_turf(src))

	disabled = world.time + disabletime
	damaged = TRUE
	var/mob/living/carbon/M = loc
	if (M)
		deactivate(M)
	else
		deactivate()
	update_icon()
	GLOB.empd_event.raise_event(src, severity)


/obj/item/shield/energy/proc/UpdateSoundLoop()
	if (!active)
		QDEL_NULL(sound_token)
		return
	sound_token = GLOB.sound_player.PlayLoopingSound(src, sound_id,'sound/obj/item/shield/energy/shield-loop.ogg', 10, 4)
