/obj/item/weapon/flamethrower
	name = "flamethrower"
	desc = "You are a firestarter!"
	icon = 'icons/obj/flamethrower.dmi'
	icon_state = "flamethrowerbase"
	item_state = "flamethrower_0"
	flags = CONDUCT
	force = 3.0
	throwforce = 10.0
	throw_speed = 1
	throw_range = 5
	w_class = ITEM_SIZE_LARGE
	origin_tech = list(TECH_COMBAT = 1, TECH_PHORON = 1)
	matter = list(DEFAULT_WALL_MATERIAL = 500)
	var/status = 0
	var/max_release_pressure = 40
	var/pressure_per_tile = 6.6
	var/lit = 0	//on or off
	var/operating = 0//cooldown
	var/turf/previousturf = null
	var/obj/item/weapon/weldingtool/weldtool = null
	var/obj/item/device/assembly/igniter/igniter = null
	var/obj/item/weapon/tank/phoron/ptank = null


/obj/item/weapon/flamethrower/Destroy()
	QDEL_NULL(weldtool)
	QDEL_NULL(igniter)
	QDEL_NULL(ptank)
	. = ..()

/obj/item/weapon/flamethrower/process()
	if(!lit)
		GLOB.processing_objects.Remove(src)
		return null
	var/turf/location = loc
	if(istype(location, /mob/))
		var/mob/M = location
		if(M.l_hand == src || M.r_hand == src)
			location = M.loc
	if(isturf(location)) //start a fire if possible
		location.hotspot_expose(700, 2)
	return


/obj/item/weapon/flamethrower/update_icon()
	overlays.Cut()
	if(igniter)
		overlays += "+igniter[status]"
	if(ptank)
		overlays += "+ptank"
	if(lit)
		overlays += "+lit"
		item_state = "flamethrower_1"
	else
		item_state = "flamethrower_0"
	return

/obj/item/weapon/flamethrower/afterattack(atom/target, mob/user, proximity)
	//if(!proximity) return
	// Make sure our user is still holding us
	if(user && user.get_active_hand() == src)
		var/turf/target_turf = get_turf(target)
		if(target_turf)
			var/turf/start_turf = get_turf(src)
			if(target_turf == start_turf)
				to_chat(user, "<span class='warning'>You cannot target your own turf!</span>")
			else
				//get the turfs to flame (note: for
				var/turflist = get_turf_line(start_turf, target_turf)

				//dont flame our own turf
				turflist -= start_turf

				//flame the calculated turfs
				flame_turfs(turflist)

/obj/item/weapon/flamethrower/proc/get_turf_line(var/turf/start, var/turf/end)
	var/list/turfline = list(start)
	if(start != end)
		var/turf/cur_turf = start
		for(var/i=0,i<(max_release_pressure / pressure_per_tile),i++)
			var/turf/next_turf = get_step(cur_turf, get_dir(cur_turf, end))

			//check if there is air flow so our fuel spray can reach this turf
			var/blocked_result = cur_turf.c_airblock(next_turf)
			if(!blocked_result || blocked_result == ZONE_BLOCKED)
				turfline += next_turf
			else
				break

			cur_turf = next_turf

			if(cur_turf == end)
				break

	return turfline

/obj/item/weapon/flamethrower/attackby(obj/item/W as obj, mob/user as mob)
	if(user.stat || user.restrained() || user.lying)	return
	if(iswrench(W) && !status)//Taking this apart
		var/turf/T = get_turf(src)
		if(weldtool)
			weldtool.loc = T
			weldtool = null
		if(igniter)
			igniter.loc = T
			igniter = null
		if(ptank)
			ptank.loc = T
			ptank = null
		new /obj/item/stack/rods(T)
		qdel(src)
		return

	if(isscrewdriver(W) && igniter && !lit)
		status = !status
		to_chat(user, "<span class='notice'>[igniter] is now [status ? "secured" : "unsecured"]!</span>")
		update_icon()
		return

	if(isigniter(W))
		var/obj/item/device/assembly/igniter/I = W
		if(I.secured)	return
		if(igniter)		return
		user.drop_item()
		I.loc = src
		igniter = I
		update_icon()
		return

	if(istype(W,/obj/item/weapon/tank/phoron))
		if(ptank)
			to_chat(user, "<span class='notice'>There appears to already be a phoron tank loaded in [src]!</span>")
			return
		user.drop_item()
		ptank = W
		W.loc = src
		update_icon()
		return

	if(istype(W, /obj/item/device/analyzer))
		var/obj/item/device/analyzer/A = W
		A.analyze_gases(src, user)
		return
	..()
	return


/obj/item/weapon/flamethrower/attack_self(mob/user as mob)
	if(user.stat || user.restrained() || user.lying)	return
	user.set_machine(src)
	if(!ptank)
		to_chat(user, "<span class='notice'>Attach a phoron tank first!</span>")
		return
	var/dat = text("\n<B>Flamethrower (<A HREF='?src=\ref[src];light=1'>[lit ? "<font color='red'>Lit</font>" : "Unlit"]</a>)</B><BR>\
		\nTank Pressure: [ptank.air_contents.return_pressure()] kPa<BR>\
		\nRelease pressure: <A HREF='?src=\ref[src];amount=-10'>--</A> <A HREF='?src=\ref[src];amount=-1'>-</A> [max_release_pressure < 10 ? " " : ""][max_release_pressure] <A HREF='?src=\ref[src];amount=1'>+</A> <A HREF='?src=\ref[src];amount=10'>++</A> kPa<BR>\
		\nNote: approx 7 kPa pressure required for each tile of spray distance.<BR>\
		\n<A HREF='?src=\ref[src];remove=1'>Remove phorontank</A> - <A HREF='?src=\ref[src];close=1'>Close</A>")
	user << browse(dat, "window=flamethrower;size=600x300")
	onclose(user, "flamethrower")
	return

/obj/item/weapon/flamethrower/return_air()
	if(ptank)
		return ptank.return_air()

/obj/item/weapon/flamethrower/Topic(href,href_list[])
	if(href_list["close"])
		usr.unset_machine()
		usr << browse(null, "window=flamethrower")
		return
	if(usr.stat || usr.restrained() || usr.lying)	return
	usr.set_machine(src)
	if(href_list["light"])
		if(!ptank)	return
		if(ptank.air_contents.gas["phoron"] < 1)	return
		if(!status)	return
		lit = !lit
		if(lit)
			GLOB.processing_objects.Add(src)
	if(href_list["amount"])
		max_release_pressure = max_release_pressure + text2num(href_list["amount"])
		max_release_pressure = max(1, min(40, max_release_pressure))
	if(href_list["remove"])
		if(!ptank)	return
		usr.put_in_hands(ptank)
		ptank = null
		lit = 0
		usr.unset_machine()
		usr << browse(null, "window=flamethrower")
	for(var/mob/M in viewers(1, loc))
		if((M.client && M.machine == src))
			attack_self(M)
	update_icon()
	return


/obj/item/weapon/flamethrower/proc/flame_turfs(var/list/turflist)
	if(!lit || operating || !turflist.len)	return
	operating = 1

	//work out the release amount
	var/release_pressure = min(max_release_pressure, pressure_per_tile * turflist.len)
	var/tank_pressure = ptank.air_contents.return_pressure()
	var/out_of_fuel = 0
	if(tank_pressure > 0)
		var/release_ratio = release_pressure / tank_pressure

		//remove it from the tank
		var/datum/gas_mixture/air_transfer = ptank.air_contents.remove_ratio(release_ratio)
		var/total_fuel = air_transfer.gas["phoron"] / LIQUIDFUEL_AMOUNT_TO_MOL
		air_transfer.gas["phoron"] = 0

		//vent any excess gas into the local environment
		var/turf/simulated/source_turf = get_turf(src)
		source_turf.assume_air(air_transfer)

		//how much fuel per turf?
		var/fuel_per_turf = total_fuel / turflist.len

		for(var/turf/T in turflist)
			if(T.density)
				continue

			if(fuel_per_turf <= 0)
				out_of_fuel = 1
				break

			//create the fuel then the fire
			new /obj/effect/decal/cleanable/liquid_fuel/flamethrower_fuel(T,fuel_per_turf,get_dir(source_turf,T))
			new /obj/effect/fire(T)

			total_fuel -= fuel_per_turf

			sleep(1)
	else
		out_of_fuel = 1

	operating = 0
	if(out_of_fuel)
		src.visible_message("\icon[src]<span class='warning'>[src] hisses as it runs out of fuel!</span>")
	for(var/mob/M in viewers(1, loc))
		if((M.client && M.machine == src))
			attack_self(M)
	return


/obj/item/weapon/flamethrower/full/New(var/loc)
	..()
	weldtool = new /obj/item/weapon/weldingtool(src)
	weldtool.status = 0
	igniter = new /obj/item/device/assembly/igniter(src)
	igniter.secured = 0
	status = 1
	ptank = new(src)
	update_icon()
	return
