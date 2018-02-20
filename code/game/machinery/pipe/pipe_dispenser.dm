/obj/machinery/pipedispenser
	name = "Pipe Dispenser"
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "pipe_d"
	density = 1
	anchored = 1
	var/unwrenched = 0
	var/wait = 0

/obj/machinery/pipedispenser/attack_hand(user as mob)
	if(..())
		return
///// Z-Level stuff
	var/dat = {"
<b>Regular pipes:</b><BR>
<A href='?src=\ref[src];make=0;dir=1'>Pipe</A><BR>
<A href='?src=\ref[src];make=1;dir=5'>Bent Pipe</A><BR>
<A href='?src=\ref[src];make=5;dir=1'>Manifold</A><BR>
<A href='?src=\ref[src];make=8;dir=1'>Manual Valve</A><BR>
<A href='?src=\ref[src];make=9;dir=1'>Digital Valve</A><BR>
<A href='?src=\ref[src];make=44;dir=1'>Automatic Shutoff Valve</A><BR>
<A href='?src=\ref[src];make=20;dir=1'>Pipe Cap</A><BR>
<A href='?src=\ref[src];make=19;dir=1'>4-Way Manifold</A><BR>
<A href='?src=\ref[src];make=18;dir=1'>Manual T-Valve</A><BR>
<A href='?src=\ref[src];make=43;dir=1'>Manual T-Valve - Mirrored</A><BR>
<A href='?src=\ref[src];make=21;dir=1'>Upward Pipe</A><BR>
<A href='?src=\ref[src];make=22;dir=1'>Downward Pipe</A><BR>
<b>Supply pipes:</b><BR>
<A href='?src=\ref[src];make=29;dir=1'>Pipe</A><BR>
<A href='?src=\ref[src];make=30;dir=5'>Bent Pipe</A><BR>
<A href='?src=\ref[src];make=33;dir=1'>Manifold</A><BR>
<A href='?src=\ref[src];make=41;dir=1'>Pipe Cap</A><BR>
<A href='?src=\ref[src];make=35;dir=1'>4-Way Manifold</A><BR>
<A href='?src=\ref[src];make=37;dir=1'>Upward Pipe</A><BR>
<A href='?src=\ref[src];make=39;dir=1'>Downward Pipe</A><BR>
<b>Scrubbers pipes:</b><BR>
<A href='?src=\ref[src];make=31;dir=1'>Pipe</A><BR>
<A href='?src=\ref[src];make=32;dir=5'>Bent Pipe</A><BR>
<A href='?src=\ref[src];make=34;dir=1'>Manifold</A><BR>
<A href='?src=\ref[src];make=42;dir=1'>Pipe Cap</A><BR>
<A href='?src=\ref[src];make=36;dir=1'>4-Way Manifold</A><BR>
<A href='?src=\ref[src];make=38;dir=1'>Upward Pipe</A><BR>
<A href='?src=\ref[src];make=40;dir=1'>Downward Pipe</A><BR>
<b>Fuel pipes:</b><BR>
<A href='?src=\ref[src];make=45;dir=1'>Pipe</A><BR>
<A href='?src=\ref[src];make=46;dir=5'>Bent Pipe</A><BR>
<A href='?src=\ref[src];make=47;dir=1'>Manifold</A><BR>
<A href='?src=\ref[src];make=51;dir=1'>Pipe Cap</A><BR>
<A href='?src=\ref[src];make=48;dir=1'>4-Way Manifold</A><BR>
<A href='?src=\ref[src];make=49;dir=1'>Upward Pipe</A><BR>
<A href='?src=\ref[src];make=50;dir=1'>Downward Pipe</A><BR>
<b>Devices:</b><BR>
<A href='?src=\ref[src];make=28;dir=1'>Universal pipe adapter</A><BR>
<A href='?src=\ref[src];make=4;dir=1'>Connector</A><BR>
<A href='?src=\ref[src];make=7;dir=1'>Unary Vent</A><BR>
<A href='?src=\ref[src];make=10;dir=1'>Gas Pump</A><BR>
<A href='?src=\ref[src];make=15;dir=1'>Pressure Regulator</A><BR>
<A href='?src=\ref[src];make=16;dir=1'>High Power Gas Pump</A><BR>
<A href='?src=\ref[src];make=11;dir=1'>Scrubber</A><BR>
<A href='?src=\ref[src];makemeter=1'>Meter</A><BR>
<A href='?src=\ref[src];make=13;dir=1'>Gas Filter</A><BR>
<A href='?src=\ref[src];make=23;dir=1'>Gas Filter - Mirrored</A><BR>
<A href='?src=\ref[src];make=14;dir=1'>Gas Mixer</A><BR>
<A href='?src=\ref[src];make=25;dir=1'>Gas Mixer - Mirrored</A><BR>
<A href='?src=\ref[src];make=24;dir=1'>Gas Mixer - T</A><BR>
<A href='?src=\ref[src];make=26;dir=1'>Omni Gas Mixer</A><BR>
<A href='?src=\ref[src];make=27;dir=1'>Omni Gas Filter</A><BR>
<b>Heat exchange:</b><BR>
<A href='?src=\ref[src];make=2;dir=1'>Pipe</A><BR>
<A href='?src=\ref[src];make=3;dir=5'>Bent Pipe</A><BR>
<A href='?src=\ref[src];make=6;dir=1'>Junction</A><BR>
<A href='?src=\ref[src];make=17;dir=1'>Heat Exchanger</A><BR>

"}
///// Z-Level stuff
//What number the make points to is in the define # at the top of construction.dm in same folder

	user << browse("<HEAD><TITLE>[src]</TITLE></HEAD><TT>[dat]</TT>", "window=pipedispenser")
	onclose(user, "pipedispenser")
	return

/obj/machinery/pipedispenser/Topic(href, href_list)
	if(..())
		return
	if(unwrenched || !usr.canmove || usr.stat || usr.restrained() || !in_range(loc, usr))
		usr << browse(null, "window=pipedispenser")
		return
	usr.set_machine(src)
	if(href_list["make"])
		if(!wait)
			var/p_type = text2num(href_list["make"])
			var/p_dir = text2num(href_list["dir"])
			var/obj/item/pipe/P = new (/*usr.loc*/ src.loc, pipe_type=p_type, dir=p_dir)
			P.update()
			wait = 1
			spawn(10)
				wait = 0
	if(href_list["makemeter"])
		if(!wait)
			new /obj/item/pipe_meter(/*usr.loc*/ src.loc)
			wait = 1
			spawn(15)
				wait = 0
	return

/obj/machinery/pipedispenser/attackby(var/obj/item/W as obj, var/mob/user as mob)
	if (istype(W, /obj/item/pipe) || istype(W, /obj/item/pipe_meter))
		to_chat(usr, "<span class='notice'>You put \the [W] back into \the [src].</span>")
		user.drop_item()
		add_fingerprint(usr)
		qdel(W)
		return
	else if(isWrench(W))
		add_fingerprint(usr)
		if (unwrenched==0)
			playsound(src.loc, 'sound/items/Ratchet.ogg', 50, 1)
			to_chat(user, "<span class='notice'>You begin to unfasten \the [src] from the floor...</span>")
			if (do_after(user, 40, src))
				user.visible_message( \
					"<span class='notice'>\The [user] unfastens \the [src].</span>", \
					"<span class='notice'>You have unfastened \the [src]. Now it can be pulled somewhere else.</span>", \
					"You hear ratchet.")
				src.anchored = 0
				src.stat |= MAINT
				src.unwrenched = 1
				if (usr.machine==src)
					usr << browse(null, "window=pipedispenser")
		else /*if (unwrenched==1)*/
			playsound(src.loc, 'sound/items/Ratchet.ogg', 50, 1)
			to_chat(user, "<span class='notice'>You begin to fasten \the [src] to the floor...</span>")
			if (do_after(user, 20, src))
				user.visible_message( \
					"<span class='notice'>\The [user] fastens \the [src].</span>", \
					"<span class='notice'>You have fastened \the [src]. Now it can dispense pipes.</span>", \
					"You hear ratchet.")
				src.anchored = 1
				src.stat &= ~MAINT
				src.unwrenched = 0
				power_change()
	else
		return ..()

/obj/machinery/pipedispenser/disposal
	name = "Disposal Pipe Dispenser"
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "pipe_d"
	density = 1
	anchored = 1.0

/*
//Allow you to push disposal pipes into it (for those with density 1)
/obj/machinery/pipedispenser/disposal/Crossed(var/obj/structure/disposalconstruct/pipe as obj)
	if(istype(pipe) && !pipe.anchored)
		qdel(pipe)

Nah
*/

//Allow you to drag-drop disposal pipes into it
/obj/machinery/pipedispenser/disposal/MouseDrop_T(var/obj/structure/disposalconstruct/pipe as obj, mob/usr as mob)
	if(!usr.canmove || usr.stat || usr.restrained())
		return

	if (!istype(pipe) || get_dist(usr, src) > 1 || get_dist(src,pipe) > 1 )
		return

	if (pipe.anchored)
		return

	qdel(pipe)

/obj/machinery/pipedispenser/disposal/attack_hand(user as mob)
	if(..())
		return

///// Z-Level stuff
	var/dat = {"<b>Disposal Pipes</b><br><br>
<A href='?src=\ref[src];dmake=0'>Pipe</A><BR>
<A href='?src=\ref[src];dmake=1'>Bent Pipe</A><BR>
<A href='?src=\ref[src];dmake=2'>Junction</A><BR>
<A href='?src=\ref[src];dmake=3'>Y-Junction</A><BR>
<A href='?src=\ref[src];dmake=4'>Trunk</A><BR>
<A href='?src=\ref[src];dmake=5'>Bin</A><BR>
<A href='?src=\ref[src];dmake=6'>Outlet</A><BR>
<A href='?src=\ref[src];dmake=7'>Chute</A><BR>
<A href='?src=\ref[src];dmake=21'>Upwards</A><BR>
<A href='?src=\ref[src];dmake=22'>Downwards</A><BR>
<A href='?src=\ref[src];dmake=8'>Sorting</A><BR>
<A href='?src=\ref[src];dmake=9'>Sorting (Wildcard)</A><BR>
<A href='?src=\ref[src];dmake=10'>Sorting (Untagged)</A><BR>
<A href='?src=\ref[src];dmake=11'>Tagger</A><BR>
<A href='?src=\ref[src];dmake=12'>Tagger (Partial)</A><BR>
<A href='?src=\ref[src];dmake=13'>Diversion</A><BR>
<A href='?src=\ref[src];dmake=14'>Diversion Switch</A><BR>
"}
///// Z-Level stuff

	user << browse("<HEAD><TITLE>[src]</TITLE></HEAD><TT>[dat]</TT>", "window=pipedispenser")
	return

// 0=straight, 1=bent, 2=junction-j1, 3=junction-j2, 4=junction-y, 5=trunk


/obj/machinery/pipedispenser/disposal/Topic(href, href_list)
	if(..())
		return
	usr.set_machine(src)
	if(href_list["dmake"])
		if(unwrenched || !usr.canmove || usr.stat || usr.restrained() || !in_range(loc, usr))
			usr << browse(null, "window=pipedispenser")
			return
		if(!wait)
			var/p_type = text2num(href_list["dmake"])
			if(p_type == 15)
				new /obj/machinery/disposal_switch (get_turf(src))
			else
				var/obj/structure/disposalconstruct/C = new (src.loc)
				switch(p_type)
					if(0)
						C.ptype = 0
					if(1)
						C.ptype = 1
					if(2)
						C.ptype = 2
					if(3)
						C.ptype = 4
					if(4)
						C.ptype = 5
					if(5)
						C.ptype = 6
						C.set_density(1)
					if(6)
						C.ptype = 7
						C.set_density(1)
					if(7)
						C.ptype = 8
						C.set_density(1)
					if(8)
						C.ptype = 9
						C.subtype = 0
					if(9)
						C.ptype = 9
						C.subtype = 1
					if(10)
						C.ptype = 9
						C.subtype = 2
					if(11)
						C.ptype = 13
					if(12)
						C.ptype = 14
					if(13)
						C.ptype = 15
///// Z-Level stuff
					if(21)
						C.ptype = 11
					if(22)
						C.ptype = 12
///// Z-Level stuff
				C.update()
			wait = 1
			spawn(15)
				wait = 0
	return

// adding a pipe dispensers that spawn unhooked from the ground
/obj/machinery/pipedispenser/orderable
	anchored = 0
	unwrenched = 1

/obj/machinery/pipedispenser/disposal/orderable
	anchored = 0
	unwrenched = 1
