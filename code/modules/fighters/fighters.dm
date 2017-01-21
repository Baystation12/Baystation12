/obj/fighter
	name = "fighter"
	desc = "An advanced fightercraft, capable of dogfighting in space"
	icon = 'icons/obj/fighter.dmi'//TODO
	icon_state = "fighter" //TODO
	density = 1
	anchored = 1
	var/mob/living/carbon/human/pilot = null
	var/list/components = list(
		"engine" = /obj/fightercomponent/engine,
		"cockpit" = /obj/fightercomponent/cockpit,
		"sensors" = /obj/fightercomponent/sensors,
		"weapon" = /obj/item/mecha_parts/mecha_equipment/weapon/energy/laser/fightertype,
		"shield" = /obj/fightercomponent/shield
		)

	var/hullhpmax = 200
	var/hullhpcurrent = 200
	var/hulldamage = 0
	var/screen = "main"
	var/fighterspeed = 8 //lower == faster
	var/faction = 0
	var/obj/item/mecha_parts/mecha_equipment/weapon/energy/laser/fightertype/weapon
	var/movement_dir = 0
	var/facing = 0

/obj/fighter/New(d=SOUTH)
	..()
	if(d)
		set_dir(d)

	for(var/component_name in components)
		var/component_type = components[component_name]
		components[component_name] = new component_type(src)

	weapon = components["weapon"]

/obj/fighter/Destroy()
	for(var/component_name in components)
		qdel(components[component_name])
	components = null
	return ..()

/obj/fighter/attack_hand(var/mob/user)
	to_chat(user, "You push against the starfighter, but it doesn't budge")

//taking components out
/obj/fighter/attackby(var/obj/item/I, var/mob/user)
	add_fingerprint(user)
	if(istype(I, /obj/item/weapon/wrench))
		input(user, "Which component do you wish to remove?", "Starfighter maintenance") as null|anything in components

	if(istype(I, /obj/item/weapon/storage/box/survival))
		ui_interact(user)

	else
		playsound(src, 'sound/weapons/Genhit.ogg', 50, 1)

//getting in
/obj/fighter/verb/get_in(var/mob/M, var/mob/user)
	set category = "Object"
	set name = "Enter Fighter"
	set src in oview(1)
	if(!M)
		return
	if(pilot)
		to_chat(user, "<span class='warning'>\The [src] is already occupied.</span>")
		return
	if(M == user)
		visible_message("\The [user] starts climbing into \the [src].")
	if(do_after(user, 20, src))
		if(pilot)
			to_chat(user, "<span class='warning'>\The [src] is already occupied.</span>")
			return
		M.stop_pulling()
		if(M.client)
			M.client.perspective = EYE_PERSPECTIVE
			M.client.eye = src
		M.loc = src
		pilot = M
		M.show_fighter_hud(M)
		update_icon()

//getting out
/obj/fighter/proc/get_out(var/mob/user)
	if(!pilot)
		return
	if(pilot.client)
		pilot.client.eye = pilot.client.mob
		pilot.client.perspective = MOB_PERSPECTIVE
	pilot.loc = loc
	pilot = null
	update_icon()

//Movement
/obj/fighter/Move()
	. = ..()
	src.dir = facing //Without this, the fighter keeps spinning back to it's movement direction on every new turf
	return

/obj/fighter/relaymove(mob/user,direction)
	facing = direction
	return do_move(direction)


/obj/fighter/proc/do_move(direction)
	var/move_result = flying(direction)
	if(move_result)
		return 1

/obj/fighter/proc/flying(direction)
	if(src.dir!=direction)// If we turn, keep moving in the old direction, just rotate the ship
		set_dir(direction)
		return 1
	else if(src.dir==turn(movement_dir,180)) //If we point in the opposite direction of our movement, stop
		walk(src,0)
		movement_dir = direction
		return 1
	else
		walk(src,direction,fighterspeed) //if we move in the direction we're looking, start flying
		movement_dir = direction
		return 1

//shooting forwards
/obj/fighter/proc/pewpew()
	var/target
	switch(dir)
		if(1)//north
			target = locate(src.x,src.y+3,src.z)
		if(2)//south
			target = locate(src.x,src.y-3,src.z)
		if(4)//east
			target = locate(src.x+3,src.y,src.z)
		if(8)//west
			target = locate(src.x-3,src.y,src.z)
	if(weapon)
		var/P = new weapon.projectile(usr.loc)
		weapon.Fire(P, target)
		playsound (src,'sound/weapons/Laser.ogg', 40.1)

//getting shot
/obj/fighter/bullet_act(var/obj/item/projectile/Proj)
	hulldamage += Proj.damage
	hullhpcurrent -= Proj.damage
	if(hullhpcurrent < 0)
		Destroy()