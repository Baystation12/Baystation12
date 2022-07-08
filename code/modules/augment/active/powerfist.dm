/obj/item/powerfist
	icon_state = "powerfist"
	item_state = "powerfist"
	name = "pneumatic powerfist"
	icon = 'icons/obj/augment.dmi'
	desc = "A strong, pneumatic powerfist. Packs quite the punch with other utility uses."
	base_parry_chance = 12
	force = 5
	attack_cooldown = 1.5 * DEFAULT_WEAPON_COOLDOWN
	hitsound = 'sound/effects/bamf.ogg'
	attack_verb = list("smashed", "bludgeoned", "hammered", "battered")

	var/obj/item/tank/tank
	var/pressure_setting
	var/list/possible_pressure_amounts = list(10, 20, 30, 50)


/obj/item/powerfist/Initialize()
	. = ..()
	if (ispath(tank))
		tank = new tank (src)
	if (!pressure_setting)
		pressure_setting = possible_pressure_amounts[1]
	update_force()


/obj/item/organ/internal/augment/active/item/powerfist
	name = "pneumatic power gauntlet"
	desc = "An armoured powered gauntlet for the arm. Your very own pneumatic doom machine."
	action_button_name = "Deploy powerfist"
	icon_state = "powerfist"
	deploy_sound = 'sound/machines/suitstorage_cycledoor.ogg'
	retract_sound = 'sound/machines/suitstorage_cycledoor.ogg'
	augment_slots = AUGMENT_ARM
	item = /obj/item/powerfist
	augment_flags = AUGMENT_MECHANICAL | AUGMENT_SCANNABLE


/obj/item/powerfist/attackby(obj/item/item, mob/user)
	if (!istype(item, /obj/item/tank))
		return
	var/obj/item/tank/other = item
	if (other.tank_size > TANK_SIZE_SMALL)
		to_chat(user, SPAN_WARNING("\The [other] is too big. Find a smaller tank."))
		return
	if (tank)
		to_chat(user, SPAN_WARNING("\The [src] already has \a [tank] installed."))
		return
	user.visible_message(
		SPAN_ITALIC("\The [user] starts connecting \a [item] to \his [src]."),
		SPAN_ITALIC("You start connecting \the [item] to \the [src]."),
		range = 5
	)
	if (!do_after(user, 3 SECONDS, item, DO_PUBLIC_UNIQUE))
		return
	if (!user.unEquip(item, src))
		return
	user.visible_message(
		SPAN_ITALIC("\The [user] finishes connecting \a [item] to \his [src]."),
		SPAN_NOTICE("You finish connecting \the [item] to \the [src]."),
		range = 5
	)
	playsound(user, 'sound/effects/refill.ogg', 50, 1, -6)
	tank = item
	update_force()
	update_icon()


/obj/item/powerfist/proc/update_force()
	var/pressure = tank?.air_contents?.return_pressure()
	if (pressure > 210)
		force = (pressure * pressure_setting * 0.01) * (tank.volume / 425)
	else
		force = 5


/obj/item/powerfist/verb/set_pressure_verb()
	set name = "Set Powerfist Pressure"
	set desc = "Set the powerfist's tank output pressure."
	set category = "Object"
	set src in range(0)
	set_pressure()


/obj/item/powerfist/proc/set_pressure()
	var/N = input("Percentage of tank used per hit:", "[src]") as null | anything in possible_pressure_amounts
	if (isnull(N))
		return
	pressure_setting = N
	to_chat(usr, SPAN_NOTICE("You dial \the [src]'s pressure valve to [pressure_setting]%."))
	update_force()


/obj/item/powerfist/attack_self(mob/living/carbon/human/user)
	set_pressure()


/obj/item/powerfist/attack_hand(mob/living/user)
	if (!tank)
		to_chat(user, SPAN_WARNING("There's no tank in \the [src]."))
		return
	user.visible_message(
		SPAN_ITALIC("\The [user] starts disconnecting \a [tank] from \his [src]."),
		SPAN_ITALIC("You start disconnecting \the [tank] from \the [src]."),
		range = 5
	)
	if (!do_after(user, 3 SECONDS, src, DO_PUBLIC_UNIQUE))
		return
	user.visible_message(
		SPAN_ITALIC("\The [user] finishes disconnecting \a [tank] from \his [src]."),
		SPAN_NOTICE("You finish disconnecting \the [tank] from \the [src]."),
		range = 5
	)
	user.put_in_hands(tank)
	playsound(loc, 'sound/effects/spray3.ogg', 50)
	tank = null
	update_icon()
	update_force()


/obj/item/powerfist/on_update_icon()
	..()
	if (tank)
		overlays += image(icon, "powerfist_tank")
	else
		overlays -= image(icon,"powerfist_tank")


/obj/item/powerfist/examine(mob/living/user, distance)
	. = ..()
	if (distance > 2)
		return
	to_chat(user, "The valve is dialed to [pressure_setting]%.")
	if (tank)
		to_chat(user, "\A [tank] is fitted in \the [src]'s tank valve.")
		to_chat(user, "The tank dial reads [tank.air_contents.return_pressure()] kPa.")
	else
		to_chat(user, "Nothing is attached to the tank valve!")


/obj/item/powerfist/proc/gas_loss()
	if (tank?.air_contents)
		var/lost_gas = tank.air_contents.total_moles * pressure_setting * 0.01
		tank.remove_air(lost_gas)


/obj/item/powerfist/proc/no_pressure()
	if (tank && tank.air_contents?.return_pressure() < 210)
		playsound(usr, 'sound/machines/ekg_alert.ogg', 50)
		to_chat(usr, SPAN_WARNING("\The pressure dial on \the [src] flashes a warning: it's out of gas!"))
		update_force()


/obj/item/powerfist/afterattack(atom/target, mob/living/user, inrange, params)
	if (!inrange || user.a_intent == I_HELP)
		return
	if (tank && tank.air_contents.return_pressure() > 210 && pressure_setting > 20 && inrange)
		playsound(user, 'sound/effects/bamf.ogg', pressure_setting*2, 1) //louder the more pressure is used
		gas_loss()
		no_pressure()
		if (istype(target, /obj/machinery/door/airlock) && pressure_setting > 30) //tearing open airlocks
			var/obj/machinery/door/airlock/A = target
			if (!A.operating && !A.locked)
				if (A.welded)
					A.visible_message(SPAN_DANGER("\The [user] forces the fingers of \the [src] in through the welded metal, beginning to pry \the [A] open!"))
					if (do_after(user, 13 SECONDS, A, DO_DEFAULT | DO_USER_UNIQUE_ACT | DO_PUBLIC_PROGRESS) && !A.locked)
						A.welded = FALSE
						A.update_icon()
						playsound(A, 'sound/effects/meteorimpact.ogg', 100, 1)
						playsound(A, 'sound/machines/airlock_creaking.ogg', 100, 1)
						A.visible_message(SPAN_DANGER("\The [user] tears \the [A] open with \a [src]!"))
						addtimer(CALLBACK(A, /obj/machinery/door/airlock/.proc/open, TRUE), 0)
						A.set_broken(TRUE)
						return
				else
					A.visible_message(SPAN_DANGER("\The [user] pries the fingers of \a [src] in, beginning to force \the [A]!"))
					if ((A.is_broken(NOPOWER) || do_after(user, 10 SECONDS, A, DO_DEFAULT | DO_USER_UNIQUE_ACT | DO_PUBLIC_PROGRESS)) && !(A.operating || A.welded || A.locked))
						playsound(A, 'sound/machines/airlock_creaking.ogg', 100, 1)
						if (A.density)
							addtimer(CALLBACK(A, /obj/machinery/door/airlock/.proc/open, TRUE), 0)
							if(!A.is_broken(NOPOWER))
								A.set_broken(TRUE)
							A.visible_message(SPAN_DANGER("\The [user] forces \the [A] open with \a [src]!"))
						else
							addtimer(CALLBACK(A, /obj/machinery/door/airlock/.proc/close, TRUE), 0)
							if (!A.is_broken(NOPOWER))
								A.set_broken(TRUE)
							A.visible_message(SPAN_DANGER("\The [user] forces \the [A] closed with \a [src]!"))
			if (A.locked)
				to_chat(user, SPAN_WARNING("The airlock's bolts prevent it from being forced."))


/obj/item/powerfist/apply_hit_effect(atom/target, mob/living/user)
	if (tank)
		gas_loss()
		no_pressure()
		if (istype(target, /mob/living))
			if (pressure_setting == 50 && tank.air_contents.return_pressure() > 210)
				var/mob/living/A = target
				A.throw_at(get_edge_target_turf(user, user.dir), pressure_setting/10, pressure_setting/10) //penultimate/ultimate settings yeets people
				user.visible_message(
					SPAN_DANGER("\The [user] batters \the [A] with \a [src], sending them flying!"),
					SPAN_WARNING("You batter \the [A] with \the [src], sending them flying!")
				)
	return ..()

/obj/item/powerfist/prepared
	tank = /obj/item/tank/oxygen_emergency_extended

/obj/item/organ/internal/augment/active/item/powerfist/prepared
	item = /obj/item/powerfist/prepared
