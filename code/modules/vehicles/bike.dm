/obj/vehicle/bike/
	name = "space-bike"
	desc = "Space wheelies! Woo!"
	icon = 'icons/obj/bike.dmi'
	icon_state = "bike_off"
	dir = SOUTH

	load_item_visible = 1
	buckle_pixel_shift = "x=0;y=0;z=5"
	health = 100
	maxhealth = 100

	locked = 0
	fire_dam_coeff = 0.6
	brute_dam_coeff = 0.5
	var/protection_percent = 40 //0 is no protection, 100 is full protection (afforded to the pilot) from projectiles fired at this vehicle

	var/land_speed = 10 //if 0 it can't go on turf
	var/space_speed = 2
	var/bike_icon = "bike"

	var/datum/effect/effect/system/trail/trail
	var/kickstand = 1
	var/obj/item/weapon/engine/engine = null
	var/engine_type
	var/prefilled = 0

/obj/vehicle/bike/New()
	..()
	if(engine_type)
		load_engine(new engine_type(src.loc))
		if(prefilled)
			engine.prefill()
	update_icon()

/obj/vehicle/bike/verb/toggle()
	set name = "Toggle Engine"
	set category = "Object"
	set src in view(0)

	if(usr.incapacitated()) return
	if(!engine)
		to_chat(usr, "<span class='warning'>\The [src] does not have an engine block installed...</span>")
		return

	if(!on)
		turn_on()
	else
		turn_off()

/obj/vehicle/bike/verb/kickstand()
	set name = "Toggle Kickstand"
	set category = "Object"
	set src in view(0)

	if(usr.incapacitated()) return

	if(kickstand)
		usr.visible_message("\The [usr] puts up \the [src]'s kickstand.")
	else
		if(istype(src.loc,/turf/space))
			to_chat(usr, "<span class='warning'> You don't think kickstands work in space...</span>")
			return
		usr.visible_message("\The [usr] puts down \the [src]'s kickstand.")
		if(pulledby)
			pulledby.stop_pulling()

	kickstand = !kickstand
	anchored = (kickstand || on)

/obj/vehicle/bike/proc/load_engine(var/obj/item/weapon/engine/E, var/mob/user)
	if(engine)
		return
	if(user && !user.unEquip(E))
		return
	engine = E
	engine.forceMove(src)
	if(trail)
		qdel(trail)
	trail = engine.get_trail()
	if(trail)
		trail.set_up(src)

/obj/vehicle/bike/proc/unload_engine()
	if(!engine)
		return
	engine.dropInto(loc)
	if(trail)
		trail.stop()
		qdel(trail)
	trail = null

/obj/vehicle/bike/load(var/atom/movable/C)
	var/mob/living/M = C
	if(!istype(M)) return 0
	if(M.buckled || M.restrained() || !Adjacent(M) || !M.Adjacent(src))
		return 0
	return ..(M)

/obj/vehicle/bike/emp_act(var/severity)
	if(engine)
		engine.emp_act(severity)
	..()

/obj/vehicle/bike/insert_cell(var/obj/item/weapon/cell/C, var/mob/living/carbon/human/H)
	return

/obj/vehicle/bike/attackby(obj/item/W as obj, mob/user as mob)
	if(open)
		if(istype(W, /obj/item/weapon/engine))
			if(engine)
				to_chat(user, "<span class='warning'>There is already an engine block in \the [src].</span>")
				return 1
			user.visible_message("<span class='warning'>\The [user] installs \the [W] into \the [src].</span>")
			load_engine(W)
			return
		else if(engine && engine.attackby(W,user))
			return 1
		else if(isCrowbar(W) && engine)
			to_chat(user, "You pop out \the [engine] from \the [src].")
			unload_engine()
			return 1
	return ..()

/obj/vehicle/bike/MouseDrop_T(var/atom/movable/C, mob/user as mob)
	if(!load(C))
		to_chat(user, "<span class='warning'> You were unable to load \the [C] onto \the [src].</span>")
		return

/obj/vehicle/bike/attack_hand(var/mob/user as mob)
	if(user == load)
		unload(load)
		to_chat(user, "You unbuckle yourself from \the [src]")

/obj/vehicle/bike/relaymove(mob/user, direction)
	if(user != load || !on)
		return
	if(user.incapacitated())
		unload(user)
		visible_message("<span class='warning'>\The [user] falls off \the [src]!</span>")
		return
	return Move(get_step(src, direction))

/obj/vehicle/bike/Move(var/turf/destination)
	if(kickstand || (world.time <= l_move_time + move_delay)) return
	//these things like space, not turf. Dragging shouldn't weigh you down.
	if(!pulledby)
		if(istype(destination,/turf/space) || pulledby)
			if(!space_speed)
				return 0
			move_delay = space_speed
		else
			if(!land_speed)
				return 0
			move_delay = land_speed
		if(!engine || !engine.use_power())
			turn_off()
			return 0
	return ..()

/obj/vehicle/bike/turn_on()
	if(!engine || on)
		return

	engine.rev_engine(src)
	if(trail)
		trail.start()
	anchored = 1

	update_icon()

	if(pulledby)
		pulledby.stop_pulling()
	..()

/obj/vehicle/bike/turn_off()
	if(!on)
		return
	if(engine)
		engine.putter(src)

	if(trail)
		trail.stop()

	anchored = kickstand

	update_icon()

	..()

/obj/vehicle/bike/bullet_act(var/obj/item/projectile/Proj)
	if(buckled_mob && prob((100-protection_percent)))
		buckled_mob.bullet_act(Proj)
		return
	..()

/obj/vehicle/bike/on_update_icon()
	overlays.Cut()

	if(on)
		icon_state = "[bike_icon]_on"
	else
		icon_state = "[bike_icon]_off"
	overlays += image('icons/obj/bike.dmi', "[icon_state]_overlay", MOB_LAYER + 1)
	..()


/obj/vehicle/bike/Destroy()
	qdel(trail)
	qdel(engine)
	..()


/obj/vehicle/bike/thermal
	engine_type = /obj/item/weapon/engine/thermal
	prefilled = 1

/obj/vehicle/bike/electric
	engine_type = /obj/item/weapon/engine/electric
	prefilled = 1

/obj/vehicle/bike/gyroscooter
	name = "gyroscooter"
	desc = "A fancy space scooter."
	icon_state = "gyroscooter_off"

	land_speed = 1.5
	space_speed = 0
	bike_icon = "gyroscooter"

	trail = null
	engine_type = /obj/item/weapon/engine/electric
	prefilled = 1
	protection_percent = 5