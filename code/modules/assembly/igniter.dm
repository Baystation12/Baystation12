/obj/item/device/assembly/igniter
	name = "igniter"
	desc = "A small electronic device able to ignite combustable substances."
	icon_state = "igniter"
	origin_tech = list(TECH_MAGNET = 1)
	matter = list(DEFAULT_WALL_MATERIAL = 500, "glass" = 50, "waste" = 10)

	wires = WIRE_DIRECT_RECEIVE | WIRE_PROCESS_RECEIVE | WIRE_PROCESS_ACTIVATE
	wire_num = 3

	var/stage = 0

	activate()
		if(!..())	return 0//Cooldown check
		var/turf/location = get_turf(loc)
		if(location)
			location.hotspot_expose(1000,1000)
		if (istype(src.loc,/obj/item/device/assembly_holder))
			if (istype(src.loc.loc, /obj/structure/reagent_dispensers/fueltank/))
				var/obj/structure/reagent_dispensers/fueltank/tank = src.loc.loc
				if (tank && tank.modded)
					tank.explode()

/obj/item/device/assembly/igniter/process_signals(var/sent = 0)
	if(sent && active_wires & (WIRE_PROCESS_SEND))
		return 1
	else if(!sent && active_wires & (WIRE_PROCESS_RECEIVE))
		return 1
	else // Faulty wiring/mechanism. Those button spammers will get what they deserve..Eventually.
		if(prob(20) && holder)
			holder.visible_message("<span class='danger'>Bzzzt</span>")
			var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
			s.set_up(3, 1, src)
			s.start()
			spawn(20)
				holder.ex_act(rand(2, 3)) // Overheats the holder. Could just activate() but..That's no fun.

/obj/item/device/assembly/igniter/emp_act(severity)
	switch(severity)
		if(1)
			activate()
		if(2)
			if(prob(60))
				activate()
		if(3)
			if(prob(30))
				activate()

/*
/obj/item/device/assembly/igniter/attackby(var/obj/O as obj, mob/user as mob)
	if(istype(O, /obj/item/stack/cable_coil) && stage == 1)
		var/obj/item/stack/cable_coil/C = O
		if(C.amount < 6)
			user << "<span class='notice'>You need atleast 8 units of cable to do that!</span>"
			return
		user.visible_message("<span class='warning'>\The [user] begins to wire \the [src]!</span>", "<span class='notice'>You begin wiring up the explosive mechanism..</span>")
		if(!do_after(user, 60)) return
		user << "<span class='notice'>You wire up the explosive mechanism in \the [src]!</span>"
		C.use(6)
		stage = 2
		return
	if(istype(O, /obj/item/weapon/cell) && stage == 0)
		user.visible_message("<span class='warning'>\The [user] begins to install \the [src]..</span>", "<span class='notice'>You begin attaching an explosive mechanism to \the [src]..</span>")
		if(!do_after(user, 60)) return
		user << "<span class='notice'>You successfully install an explosive mechanism into \the [src]!</span>"
		user.drop_item()
		qdel(O)
		stage = 1
		name = "modified [initial(name)]"
		return
	if(istype(O, /obj/item/weapon/wrench) && stage == 3)
		user.visible_message("<span class='warning'>\The [user] starts securing \the [src]..</span>", "<span class='notice'>You start securing \the [src]..</span>")
		if(!do_after(user, 80)) return
		user << "<span class='notice'>You've made a makeshift explosive!</span>"
		stage = 4
		user.remove_from_mob(src)
		var/obj/item/device/assembly/explosive/E = new(get_turf(src))
		E.reliability = rand(50, 100)
		qdel(src)
		msg_admin_attack("[user.name] ([user.ckey]) assembled an explosive! (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[user.x];Y=[user.y];Z=[user.z]'>JMP</a>)")
		return
	if(istype(O, /obj/item/clothing/glasses) && stage == 2)
		user.visible_message("<span class='warning'>\The [user] begins to focus the explosive mechanism in \the [src]..</span>", "<span class='notice'>You begin focusing the ignition point in the explosive mechanism in \the [src]!</span>")
		if(!do_after(user, 50)) return
		user << "<span class='notice'>You focus the ignition on the explsive mechanism!</span>"
		user.drop_item()
		qdel(O)
		stage = 3
		return
	..()
*/


/obj/item/device/assembly/igniter/activate()
	if(holder)
		for(var/obj/item/device/assembly/O in get_connected_devices())
			O.igniter_act()
	else
		var/turf/location = get_turf(loc)
		if(location)
			location.hotspot_expose(1000,1000)
		if (istype(src.loc,/obj/item/device/assembly_holder))
			if (istype(src.loc.loc, /obj/structure/reagent_dispensers/fueltank/))
				var/obj/structure/reagent_dispensers/fueltank/tank = src.loc.loc
				if (tank && tank.modded)
					tank.explode()

		var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
		s.set_up(3, 1, src)
		s.start()

	return 1


/obj/item/device/assembly/igniter/attack_self(mob/user as mob)
	activate()
	add_fingerprint(user)
	return