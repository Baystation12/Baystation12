//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:33

#define SOLAR_MAX_DIST 40
#define SOLARGENRATE 1500

var/list/solars_list = list()

// This will choose whether to get the solar list from the powernet or the powernet nodes,
// depending on the size of the nodes.
/obj/machinery/power/proc/get_solars_powernet()
	if(!powernet)
		return list()
	if(solars_list.len < powernet.nodes)
		return solars_list
	else
		return powernet.nodes

/obj/machinery/power/solar
	name = "solar panel"
	desc = "A solar electrical generator."
	icon = 'icons/obj/power.dmi'
	icon_state = "sp_base"
	anchored = 1
	density = 1
	directwired = 1
	use_power = 0
	idle_power_usage = 0
	active_power_usage = 0
	var/id = 0
	var/health = 10
	var/obscured = 0
	var/sunfrac = 0
	var/adir = SOUTH
	var/ndir = SOUTH
	var/turn_angle = 0
	var/obj/machinery/power/solar_control/control = null

/obj/machinery/power/solar/New(var/turf/loc, var/obj/item/solar_assembly/S, var/process = 1)
	..(loc)
	Make(S)
	connect_to_network(process)


/obj/machinery/power/solar/disconnect_from_network()
	..()
	solars_list.Remove(src)

/obj/machinery/power/solar/connect_to_network(var/process)
	..()
	if(process)
		solars_list.Add(src)


/obj/machinery/power/solar/proc/Make(var/obj/item/solar_assembly/S)
	if(!S)
		S = new /obj/item/solar_assembly(src)
		S.glass_type = /obj/item/stack/sheet/glass
		S.anchored = 1
	S.loc = src
	update_icon()



/obj/machinery/power/solar/attackby(obj/item/weapon/W, mob/user)

	if(iscrowbar(W))
		playsound(src.loc, 'sound/machines/click.ogg', 50, 1)
		if(do_after(user, 50))
			var/obj/item/solar_assembly/S = locate() in src
			if(S)
				S.loc = src.loc
				S.give_glass()
			playsound(src.loc, 'sound/items/Deconstruct.ogg', 50, 1)
			user.visible_message("<span class='notice'>[user] takes the glass off the solar panel.</span>")
			del(src)
		return
	else if (W)
		src.add_fingerprint(user)
		src.health -= W.force
		src.healthcheck()
	..()


/obj/machinery/power/solar/blob_act()
	src.health--
	src.healthcheck()
	return


/obj/machinery/power/solar/proc/healthcheck()
	if (src.health <= 0)
		if(!(stat & BROKEN))
			broken()
		else
			new /obj/item/weapon/shard(src.loc)
			new /obj/item/weapon/shard(src.loc)
			del(src)
			return
	return


/obj/machinery/power/solar/update_icon()
	..()
	overlays.Cut()
	if(stat & BROKEN)
		overlays += image('icons/obj/power.dmi', icon_state = "solar_panel-b", layer = FLY_LAYER)
	else
		overlays += image('icons/obj/power.dmi', icon_state = "solar_panel", layer = FLY_LAYER)
		src.dir = angle2dir(adir)
	return


/obj/machinery/power/solar/proc/update_solar_exposure()
	if(!sun)
		return
	if(obscured)
		sunfrac = 0
		return
	var/p_angle = abs((360+adir)%360 - (360+sun.angle)%360)
	if(p_angle > 90)			// if facing more than 90deg from sun, zero output
		sunfrac = 0
		return
	sunfrac = cos(p_angle) ** 2


/obj/machinery/power/solar/process()//TODO: remove/add this from machines to save on processing as needed ~Carn PRIORITY
	if(stat & BROKEN)	return
	if(!control)	return

	if(adir != ndir)
		adir = (360+adir+dd_range(-10,10,ndir-adir))%360
		update_icon()
		update_solar_exposure()

	if(obscured)	return

	var/sgen = SOLARGENRATE * sunfrac
	add_avail(sgen)
	if(powernet && control)
		if(powernet.nodes[control])
			control.gen += sgen


/obj/machinery/power/solar/proc/broken()
	stat |= BROKEN
	update_icon()
	return


/obj/machinery/power/solar/meteorhit()
	if(stat & !BROKEN)
		broken()
	else
		del(src)


/obj/machinery/power/solar/ex_act(severity)
	switch(severity)
		if(1.0)
			del(src)
			if(prob(15))
				new /obj/item/weapon/shard( src.loc )
			return
		if(2.0)
			if (prob(25))
				new /obj/item/weapon/shard( src.loc )
				del(src)
				return
			if (prob(50))
				broken()
		if(3.0)
			if (prob(25))
				broken()
	return


/obj/machinery/power/solar/blob_act()
	if(prob(75))
		broken()
		src.density = 0


/obj/machinery/power/solar/fake/New(var/turf/loc, var/obj/item/solar_assembly/S)
	..(loc, S, 0)

/obj/machinery/power/solar/fake/process()
	. = PROCESS_KILL
	return


//
// Solar Assembly - For construction of solar arrays.
//

/obj/item/solar_assembly
	name = "solar panel assembly"
	desc = "A solar panel assembly kit, allows constructions of a solar panel, or with a tracking circuit board, a solar tracker"
	icon = 'icons/obj/power.dmi'
	icon_state = "sp_base"
	item_state = "electropack"
	w_class = 4 // Pretty big!
	anchored = 0
	var/tracker = 0
	var/glass_type = null

/obj/item/solar_assembly/attack_hand(var/mob/user)
	if(!anchored && isturf(loc)) // You can't pick it up
		..()

// Give back the glass type we were supplied with
/obj/item/solar_assembly/proc/give_glass()
	if(glass_type)
		var/obj/item/stack/sheet/S = new glass_type(src.loc)
		S.amount = 2
		glass_type = null


/obj/item/solar_assembly/attackby(var/obj/item/weapon/W, var/mob/user)

	if(!anchored && isturf(loc))
		if(iswrench(W))
			anchored = 1
			user.visible_message("<span class='notice'>[user] wrenches the solar assembly into place.</span>")
			playsound(src.loc, 'sound/items/Ratchet.ogg', 75, 1)
			return 1
	else
		if(iswrench(W))
			anchored = 0
			user.visible_message("<span class='notice'>[user] unwrenches the solar assembly from it's place.</span>")
			playsound(src.loc, 'sound/items/Ratchet.ogg', 75, 1)
			return 1

		if(istype(W, /obj/item/stack/sheet/glass) || istype(W, /obj/item/stack/sheet/rglass))
			var/obj/item/stack/sheet/S = W
			if(S.amount >= 2)
				glass_type = W.type
				S.use(2)
				playsound(src.loc, 'sound/machines/click.ogg', 50, 1)
				user.visible_message("<span class='notice'>[user] places the glass on the solar assembly.</span>")
				if(tracker)
					new /obj/machinery/power/tracker(get_turf(src), src)
				else
					new /obj/machinery/power/solar(get_turf(src), src)
			return 1

	if(!tracker)
		if(istype(W, /obj/item/weapon/tracker_electronics))
			tracker = 1
			user.drop_item()
			del(W)
			user.visible_message("<span class='notice'>[user] inserts the electronics into the solar assembly.</span>")
			return 1
	else
		if(iscrowbar(W))
			new /obj/item/weapon/tracker_electronics(src.loc)
			tracker = 0
			user.visible_message("<span class='notice'>[user] takes out the electronics from the solar assembly.</span>")
			return 1
	..()

//
// Solar Control Computer
//

/obj/machinery/power/solar_control
	name = "solar panel control"
	desc = "A controller for solar panel arrays."
	icon = 'icons/obj/computer.dmi'
	icon_state = "solar"
	anchored = 1
	density = 1
	directwired = 1
	use_power = 1
	idle_power_usage = 5
	active_power_usage = 20
	var/id = 0
	var/cdir = 0
	var/gen = 0
	var/lastgen = 0
	var/track = 0			// 0=off  1=manual  2=automatic
	var/trackrate = 60		// Measured in tenths of degree per minute (i.e. defaults to 6.0 deg/min)
	var/trackdir = 1		// -1=CCW, 1=CW
	var/nexttime = 0		// Next clock time that manual tracking will move the array


/obj/machinery/power/solar_control/New()
	..()
	if(ticker)
		initialize()
	connect_to_network()

/obj/machinery/power/solar_control/disconnect_from_network()
	..()
	solars_list.Remove(src)

/obj/machinery/power/solar_control/connect_to_network()
	..()
	if(powernet)
		solars_list.Add(src)

/obj/machinery/power/solar_control/initialize()
	..()
	if(!powernet) return
	set_panels(cdir)

/obj/machinery/power/solar_control/update_icon()
	if(stat & BROKEN)
		icon_state = "broken"
		overlays.Cut()
		return
	if(stat & NOPOWER)
		icon_state = "c_unpowered"
		overlays.Cut()
		return
	icon_state = "solar"
	overlays.Cut()
	if(cdir > 0)
		overlays += image('icons/obj/computer.dmi', "solcon-o", FLY_LAYER, angle2dir(cdir))
	return


/obj/machinery/power/solar_control/attack_ai(mob/user)
	add_fingerprint(user)
	if(stat & (BROKEN | NOPOWER)) return
	interact(user)


/obj/machinery/power/solar_control/attack_hand(mob/user)
	add_fingerprint(user)
	if(stat & (BROKEN | NOPOWER)) return
	interact(user)


/obj/machinery/power/solar_control/attackby(I as obj, user as mob)
	if(istype(I, /obj/item/weapon/screwdriver))
		playsound(src.loc, 'sound/items/Screwdriver.ogg', 50, 1)
		if(do_after(user, 20))
			if (src.stat & BROKEN)
				user << "\blue The broken glass falls out."
				var/obj/structure/computerframe/A = new /obj/structure/computerframe( src.loc )
				new /obj/item/weapon/shard( src.loc )
				var/obj/item/weapon/circuitboard/solar_control/M = new /obj/item/weapon/circuitboard/solar_control( A )
				for (var/obj/C in src)
					C.loc = src.loc
				A.circuit = M
				A.state = 3
				A.icon_state = "3"
				A.anchored = 1
				del(src)
			else
				user << "\blue You disconnect the monitor."
				var/obj/structure/computerframe/A = new /obj/structure/computerframe( src.loc )
				var/obj/item/weapon/circuitboard/solar_control/M = new /obj/item/weapon/circuitboard/solar_control( A )
				for (var/obj/C in src)
					C.loc = src.loc
				A.circuit = M
				A.state = 4
				A.icon_state = "4"
				A.anchored = 1
				del(src)
	else
		src.attack_hand(user)
	return


/obj/machinery/power/solar_control/process()
	lastgen = gen
	gen = 0

	if(stat & (NOPOWER | BROKEN))
		return

	use_power(250)
	if(track==1 && nexttime < world.time && trackdir*trackrate)
		// Increments nexttime using itself and not world.time to prevent drift
		nexttime = nexttime + 6000/trackrate
		// Nudges array 1 degree in desired direction
		cdir = (cdir+trackdir+360)%360
		set_panels(cdir)
		update_icon()

	src.updateDialog()


// called by solar tracker when sun position changes
/obj/machinery/power/solar_control/proc/tracker_update(var/angle)
	if(track != 2 || stat & (NOPOWER | BROKEN))
		return
	cdir = angle
	set_panels(cdir)
	update_icon()
	src.updateDialog()


/obj/machinery/power/solar_control/interact(mob/user)
	if(stat & (BROKEN | NOPOWER)) return
	if ( (get_dist(src, user) > 1 ))
		if (!istype(user, /mob/living/silicon))
			user.unset_machine()
			user << browse(null, "window=solcon")
			return

	add_fingerprint(user)
	user.set_machine(src)

	var/t = "<TT><B>Solar Generator Control</B><HR><PRE>"
	t += "<B>Generated power</B> : [round(lastgen)] W<BR>"
	t += "Station Rotational Period: [60/abs(sun.rate)] minutes<BR>"
	t += "Station Rotational Direction: [sun.rate<0 ? "CCW" : "CW"]<BR>"
	t += "Star Orientation: [sun.angle]&deg ([angle2text(sun.angle)])<BR>"
	t += "Array Orientation: [rate_control(src,"cdir","[cdir]&deg",1,10,60)] ([angle2text(cdir)])<BR>"
	t += "<BR><HR><BR>"
	t += "Tracking: "
	switch(track)
		if(0)
			t += "<B>Off</B> <A href='?src=\ref[src];track=1'>Manual</A> <A href='?src=\ref[src];track=2'>Automatic</A><BR>"
		if(1)
			t += "<A href='?src=\ref[src];track=0'>Off</A> <B>Manual</B> <A href='?src=\ref[src];track=2'>Automatic</A><BR>"
		if(2)
			t += "<A href='?src=\ref[src];track=0'>Off</A> <A href='?src=\ref[src];track=1'>Manual</A> <B>Automatic</B><BR>"

	t += "Manual Tracking Rate: [rate_control(src,"tdir","[trackrate/10]&deg/min ([trackdir<0 ? "CCW" : "CW"])",1,10)]<BR>"
	t += "Manual Tracking Direction: "
	switch(trackdir)
		if(-1)
			t += "<A href='?src=\ref[src];trackdir=1'>CW</A> <B>CCW</B><BR>"
		if(1)
			t += "<B>CW</B> <A href='?src=\ref[src];trackdir=-1'>CCW</A><BR>"
	t += "<A href='?src=\ref[src];close=1'>Close</A></TT>"
	user << browse(t, "window=solcon")
	onclose(user, "solcon")
	return


/obj/machinery/power/solar_control/Topic(href, href_list)
	if(..())
		usr << browse(null, "window=solcon")
		usr.unset_machine()
		return
	if(href_list["close"] )
		usr << browse(null, "window=solcon")
		usr.unset_machine()
		return

	if(href_list["dir"])
		cdir = text2num(href_list["dir"])
		set_panels(cdir)
		update_icon()

	if(href_list["rate control"])
		if(href_list["cdir"])
			src.cdir = dd_range(0,359,(360+src.cdir+text2num(href_list["cdir"]))%360)
			spawn(1)
				set_panels(cdir)
				update_icon()
		if(href_list["tdir"])
			src.trackrate = dd_range(0,360,src.trackrate+text2num(href_list["tdir"]))
			if(src.trackrate) nexttime = world.time + 6000/trackrate

	if(href_list["track"])
		if(src.trackrate) nexttime = world.time + 6000/trackrate
		track = text2num(href_list["track"])
		if(powernet && (track == 2))
			if(!solars_list.Find(src,1,0))
				solars_list.Add(src)
			for(var/obj/machinery/power/tracker/T in get_solars_powernet())
				if(powernet.nodes[T])
					cdir = T.sun_angle
					break

	if(href_list["trackdir"])
		trackdir = text2num(href_list["trackdir"])

	set_panels(cdir)
	update_icon()
	src.updateUsrDialog()
	return


/obj/machinery/power/solar_control/proc/set_panels(var/cdir)
	if(!powernet) return
	for(var/obj/machinery/power/solar/S in get_solars_powernet())
		if(powernet.nodes[S])
			if(get_dist(S, src) < SOLAR_MAX_DIST)
				if(!S.control)
					S.control = src
				S.ndir = cdir


/obj/machinery/power/solar_control/power_change()
	if(powered())
		stat &= ~NOPOWER
		update_icon()
	else
		spawn(rand(0, 15))
			stat |= NOPOWER
			update_icon()


/obj/machinery/power/solar_control/proc/broken()
	stat |= BROKEN
	update_icon()


/obj/machinery/power/solar_control/meteorhit()
	broken()
	return


/obj/machinery/power/solar_control/ex_act(severity)
	switch(severity)
		if(1.0)
			//SN src = null
			del(src)
			return
		if(2.0)
			if (prob(50))
				broken()
		if(3.0)
			if (prob(25))
				broken()
	return


/obj/machinery/power/solar_control/blob_act()
	if (prob(75))
		broken()
		src.density = 0


//
// MISC
//

/obj/item/weapon/paper/solar
	name = "paper- 'Going green! Setup your own solar array instructions.'"
	info = "<h1>Welcome</h1><p>At greencorps we love the environment, and space. With this package you are able to help mother nature and produce energy without any usage of fossil fuel or plasma! Singularity energy is dangerous while solar energy is safe, which is why it's better. Now here is how you setup your own solar array.</p><p>You can make a solar panel by wrenching the solar assembly onto a cable node. Adding a glass panel, reinforced or regular glass will do, will finish the construction of your solar panel. It is that easy!.</p><p>Now after setting up 19 more of these solar panels you will want to create a solar tracker to keep track of our mother nature's gift, the sun. These are the same steps as before except you insert the tracker equipment circuit into the assembly before performing the final step of adding the glass. You now have a tracker! Now the last step is to add a computer to calculate the sun's movements and to send commands to the solar panels to change direction with the sun. Setting up the solar computer is the same as setting up any computer, so you should have no trouble in doing that. You do need to put a wire node under the computer, and the wire needs to be connected to the tracker.</p><p>Congratulations, you should have a working solar array. If you are having trouble, here are some tips. Make sure all solar equipment are on a cable node, even the computer. You can always deconstruct your creations if you make a mistake.</p><p>That's all to it, be safe, be green!</p>"
