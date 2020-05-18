//these are probably broken

/obj/machinery/floodlight
	name = "Emergency Floodlight"
	icon = 'icons/obj/machines/floodlight.dmi'
	icon_state = "flood00"
	density = 1
	var/on = 0
	var/cell_type = /obj/item/weapon/cell/crap
	var/obj/item/weapon/cell/cell = null
	var/use = 200 // 200W light
	var/unlocked = 0
	var/open = 0
	var/brightness_on = 8		//can't remember what the maxed out value is
	var/health = 100

/obj/machinery/floodlight/New()
	cell = new cell_type(src)
	..()

	if(on)
		turn_on()

/obj/machinery/floodlight/update_icon()
	overlays.Cut()
	icon_state = "flood[open ? "o" : ""][open && cell ? "b" : ""]0[on]"

/obj/machinery/floodlight/process()
	if(!on)
		return

	if(!cell || (cell.charge < (use * CELLRATE)))
		turn_off(1)
		return

	// If the cell is almost empty rarely "flicker" the light. Aesthetic only.
	if((cell.percent() < 10) && prob(5))
		set_light(brightness_on/2, brightness_on/4)
		spawn(20)
			if(on)
				set_light(brightness_on, brightness_on/2)

	cell.use(use*CELLRATE)


// Returns 0 on failure and 1 on success
/obj/machinery/floodlight/proc/turn_on(var/loud = 0)
	if(!cell)
		return 0
	if(cell.charge < (use * CELLRATE))
		return 0

	on = 1
	set_light(brightness_on, brightness_on / 2)
	update_icon()
	if(loud)
		visible_message("\The [src] turns on.")
	return 1

/obj/machinery/floodlight/proc/turn_off(var/loud = 0)
	on = 0
	set_light(0, 0)
	update_icon()
	if(loud)
		visible_message("\The [src] shuts down.")

/obj/machinery/floodlight/attack_ai(mob/user as mob)
	if(istype(user, /mob/living/silicon/robot) && Adjacent(user))
		return attack_hand(user)

	if(on)
		turn_off(1)
	else
		if(!turn_on(1))
			to_chat(user, "You try to turn on \the [src] but it does not work.")


/obj/machinery/floodlight/attack_hand(mob/user as mob)
	if(open && cell)
		if(ishuman(user))
			if(!user.get_active_hand())
				user.put_in_hands(cell)
				cell.loc = user.loc
		else
			cell.loc = loc

		cell.add_fingerprint(user)
		cell.update_icon()

		src.cell = null
		on = 0
		set_light(0)
		to_chat(user, "You remove the power cell")
		update_icon()
		return

	if(on)
		turn_off(1)
	else
		if(!turn_on(1))
			to_chat(user, "You try to turn on \the [src] but it does not work.")

	update_icon()


/obj/machinery/floodlight/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if (istype(W, /obj/item/weapon/screwdriver))
		if (!open)
			if(unlocked)
				unlocked = 0
				to_chat(user, "You screw the battery panel in place.")
			else
				unlocked = 1
				to_chat(user, "You unscrew the battery panel.")

	else if (istype(W, /obj/item/weapon/crowbar))
		if(unlocked)
			if(open)
				open = 0
				overlays = null
				to_chat(user, "You crowbar the battery panel in place.")
			else
				if(unlocked)
					open = 1
					to_chat(user, "You remove the battery panel.")

	else if (istype(W, /obj/item/weapon/cell))
		if(open)
			if(cell)
				to_chat(user, "There is a power cell already installed.")
			else
				user.drop_item()
				W.loc = src
				cell = W
				to_chat(user, "You insert the power cell.")
	else
		. = ..()
		take_damage(W.force)

	update_icon()

/obj/machinery/floodlight/bullet_act(obj/item/projectile/Proj)
	playsound(loc, 'sound/weapons/tablehit1.ogg', 50, 1)
	take_damage(Proj.damage)

/obj/machinery/floodlight/attack_generic(var/mob/living/attacker, var/damage, var/attacktext)
	if(damage > 0)
		src.visible_message("<span class='danger'>[attacker] bashes the [src]!</span>")
		playsound(src.loc, 'sound/weapons/bite.ogg', 50, 0, 0)
		take_damage(health/2)

/obj/machinery/floodlight/ex_act(var/severity)
	take_damage(severity * health / 3)

/obj/machinery/floodlight/proc/take_damage(var/amount)
	health -= amount
	if(health <= 0)
		if(on)
			var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread()
			s.set_up(3, 1, src)
			s.start()
			turn_off()
		var/loot_types = list(/obj/item/salvage/metal,\
			/obj/item/salvage/plastic,\
			/obj/item/stack/material/plastic,\
			/obj/item/stack/material/steel)
		var/spawn_type = pick(loot_types)
		if(prob(50))
			new spawn_type(src.loc)
		spawn_type = pick(loot_types)
		if(prob(50))
			new spawn_type(src.loc)
		qdel(src)

/obj/machinery/floodlight/active
	on = 1
	icon_state = "flood01"


/obj/machinery/floodlight/active/standard_cell
	cell_type = /obj/item/weapon/cell/standard

/obj/machinery/floodlight/active/hi_cap
	cell_type = /obj/item/weapon/cell/high