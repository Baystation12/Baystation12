/obj/machinery/cablelayer
	name = "automatic cable layer"

	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "pipe_d"
	density = 1
	var/obj/structure/cable/last_piece
	var/obj/item/stack/cable_coil/cable
	var/max_cable = 100
	var/on = 0

/obj/machinery/cablelayer/New()
	cable = new(src)
	cable.amount = 100
	..()

/obj/machinery/cablelayer/Move(new_turf,M_Dir)
	..()
	layCable(new_turf,M_Dir)

/obj/machinery/cablelayer/attack_hand(mob/user as mob)
	if(!cable&&!on)
		to_chat(user, "<span class='warning'>\The [src] doesn't have any cable loaded.</span>")
		return
	on=!on
	user.visible_message("\The [user] [!on?"dea":"a"]ctivates \the [src].", "You switch [src] [on? "on" : "off"]")
	return

/obj/machinery/cablelayer/attackby(var/obj/item/O as obj, var/mob/user as mob)
	if(istype(O, /obj/item/stack/cable_coil))

		var/result = load_cable(O)
		if(!result)
			to_chat(user, "<span class='warning'>\The [src]'s cable reel is full.</span>")
		else
			to_chat(user, "You load [result] lengths of cable into [src].")
		return

	if(isWirecutter(O))
		if(cable && cable.amount)
			var/m = round(input(usr,"Please specify the length of cable to cut","Cut cable",min(cable.amount,30)) as num, 1)
			m = min(m, cable.amount)
			m = min(m, 30)
			if(m)
				playsound(loc, 'sound/items/Wirecutter.ogg', 50, 1)
				use_cable(m)
				var/obj/item/stack/cable_coil/CC = new (get_turf(src))
				CC.amount = m
		else
			to_chat(usr, "<span class='warning'>There's no more cable on the reel.</span>")

/obj/machinery/cablelayer/examine(mob/user)
	. = ..()
	to_chat(user, "\The [src]'s cable reel has [cable.amount] length\s left.")

/obj/machinery/cablelayer/proc/load_cable(var/obj/item/stack/cable_coil/CC)
	if(istype(CC) && CC.amount)
		var/cur_amount = cable? cable.amount : 0
		var/to_load = max(max_cable - cur_amount,0)
		if(to_load)
			to_load = min(CC.amount, to_load)
			if(!cable)
				cable = new(src)
				cable.amount = 0
			cable.amount += to_load
			CC.use(to_load)
			return to_load
		else
			return 0
	return

/obj/machinery/cablelayer/proc/use_cable(amount)
	if(!cable || cable.amount<1)
		visible_message("A red light flashes on \the [src].")
		return
	cable.use(amount)
	if(QDELETED(cable))
		cable = null
	return 1

/obj/machinery/cablelayer/proc/reset()
	last_piece = null

/obj/machinery/cablelayer/proc/dismantleFloor(var/turf/new_turf)
	if(istype(new_turf, /turf/simulated/floor))
		var/turf/simulated/floor/T = new_turf
		if(!T.is_plating())
			T.make_plating(!(T.broken || T.burnt))
	return new_turf.is_plating()

/obj/machinery/cablelayer/proc/layCable(var/turf/new_turf,var/M_Dir)
	if(!on)
		return reset()
	else
		dismantleFloor(new_turf)
	if(!istype(new_turf) || !dismantleFloor(new_turf))
		return reset()
	var/fdirn = turn(M_Dir,180)
	for(var/obj/structure/cable/LC in new_turf)		// check to make sure there's not a cable there already
		if(LC.d1 == fdirn || LC.d2 == fdirn)
			return reset()
	if(!use_cable(1))
		return reset()
	var/obj/structure/cable/NC = new(new_turf)
	NC.cableColor("red")
	NC.d1 = 0
	NC.d2 = fdirn
	NC.update_icon()

	var/datum/powernet/PN
	if(last_piece && last_piece.d2 != M_Dir)
		last_piece.d1 = min(last_piece.d2, M_Dir)
		last_piece.d2 = max(last_piece.d2, M_Dir)
		last_piece.update_icon()
		PN = last_piece.powernet

	if(!PN)
		PN = new()
	PN.add_cable(NC)
	NC.mergeConnectedNetworks(NC.d2)

	//NC.mergeConnectedNetworksOnTurf()
	last_piece = NC
	return 1
