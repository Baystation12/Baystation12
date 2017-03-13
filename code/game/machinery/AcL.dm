/obj/machinery/AcL
	name = "Automatic Cable Layer"

	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "pipe_d"
	density = 1
	var/obj/structure/cable/last_piece
	var/obj/item/stack/cable_coil/cable
	var/max_cable = 1000
	var/on = 0

	New()
		cable = new(src)
		cable.amount = 100
		..()

	Move(new_turf,M_Dir)
		..()
		layCable(new_turf,M_Dir)

	attack_hand(mob/user as mob)
		on=!on
		for(var/mob/O in hearers(src, null))
			O.show_message("[src] [!on?"dea":"a"]ctivated.")
		return

	attackby(var/obj/item/O as obj, var/mob/user as mob)
		if(istype(O, /obj/item/stack/cable_coil))

			var/result = load_cable(O)
			var/message
			if(isnull(result))
				message = "<font color='red'>Unable to load [O] - no cable found.</font>"
			else if(!result)
				message = "Reel is full."
			else
				message = "[result] meters of cable successfully loaded."

			user << "<span class='notice'>[message]</span>"
			return

		if(istype(O, /obj/item/weapon/screwdriver))
			if(cable && cable.amount)
				var/m = round(input(usr,"Please specify the length of cable to cut","Cut cable",min(cable.amount,30)) as num, 1)
				m = min(m, cable.amount)
				if(m)
					use_cable(m)
					var/obj/item/stack/cable_coil/CC = new (get_turf(src))
					CC.amount = m
			else
				usr << "There's no more cable on the reel."

	examine(mob/user)
		..()
		user << "\[Cable: [cable ? cable.amount : 0]]"

	proc/load_cable(var/obj/item/stack/cable_coil/CC)
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

	proc/use_cable(amount)
		if(!cable || cable.amount<1)
			for(var/mob/O in hearers(src, null))
				O.show_message("Cable depleted, [src] deactivated.")
			return
		if(cable.amount < amount)
			for(var/mob/O in hearers(src, null))
				O.show_message("No enough cable to finish the task.")
			return
		cable.use(amount)
		return 1

	proc/reset()
		last_piece = null

	proc/dismantleFloor(var/turf/new_turf)
		if(istype(new_turf, /turf/simulated/floor))
			var/turf/simulated/floor/T = new_turf
			if(!T.is_plating())
				if(!T.broken && !T.burnt)
					new T.floor_type(T)
				T.make_plating()
		return !new_turf.intact

	proc/layCable(var/turf/new_turf,var/M_Dir)
		if(!on)
			return reset()
//		else
//			dismantleFloor(new_turf)
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
		NC.updateicon()

		var/datum/powernet/PN
		if(last_piece && last_piece.d2 != M_Dir)
			last_piece.d1 = min(last_piece.d2, M_Dir)
			last_piece.d2 = max(last_piece.d2, M_Dir)
			last_piece.updateicon()
			PN = last_piece.powernet

		if(!PN)
			PN = new()
		PN.add_cable(NC)
		NC.mergeConnectedNetworks(NC.d2)

		//NC.mergeConnectedNetworksOnTurf()
		last_piece = NC
		return 1
