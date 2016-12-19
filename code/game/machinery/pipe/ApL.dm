/obj/machinery/ApL

	name = "Automatic Pipe Layer"
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "pipe_d"
	density = 1
	var/turf/old_turf
	var/old_dir
	var/on = 0
	var/a_dis = 0
	var/P_type = 0
	var/P_type_t = ""
	var/max_metal = 1000
	var/obj/item/stack/sheet/metal/metal

	New()
		metal = new(src)
		metal.amount = 100
		..()

	Move(new_turf,M_Dir)
		..()

		if(a_dis)
			dismantleFloor(new_turf)
		layPipe(old_turf,M_Dir,old_dir)

		old_turf = new_turf
		old_dir = turn(M_Dir,180)

	attack_hand(mob/user as mob)
		on=!on
		for(var/mob/O in hearers(src, null))
			O.show_message("[src] [!on?"dea":"a"]ctivated.")
		return

	attackby(var/obj/item/W as obj, var/mob/user as mob)
		..()
		if (istype(W, /obj/item/weapon/wrench))
			switch(P_type)
				if(31)
					P_type = 0
					P_type_t = "Regular pipes"
				if(29)
					P_type = 31
					P_type_t = "Scrubbers pipes"
				if(2)
					P_type = 29
					P_type_t = "Supply pipes"
				if(0)
					P_type = 2
					P_type_t = "Heat exchange"

			usr << "You set [src] to [P_type_t]"

		if(istype(W, /obj/item/weapon/crowbar))
			a_dis=!a_dis
			for(var/mob/O in hearers(src, null))
				O.show_message("[src] auto dismantle [!on?"dea":"a"]ctivated.")
			return

		if(istype(W, /obj/item/stack/sheet/metal))

			var/result = load_metal(W)
			var/message
			if(isnull(result))
				message = "<font color='red'>Unable to load [W] - no metal found.</font>"
			else if(!result)
				message = "Stack is full."
			else
				message = "[result] scheets of metal successfully loaded."

			user << "<span class='notice'>[message]</span>"
			return

		if(istype(W, /obj/item/weapon/screwdriver))
			if(metal && metal.amount)
				var/m = round(input(usr,"Please specify the amount of metal to detasch","Detasch metal",min(metal.amount,50)) as num, 1)
				m = min(m, metal.amount)
				if(m)
					use_metal(m)
					var/obj/item/stack/sheet/metal/MM = new (get_turf(src))
					MM.amount = m
			else
				usr << "There's no more metal on the stack."

	examine(mob/user)
		..()
		user << "[src] setted to [P_type_t], and auto dismantle [!on?"dea":"a"]ctivated."

	proc/reset()
		return

	proc/load_metal(var/obj/item/stack/sheet/metal/MM)
		if(istype(MM) && MM.amount)
			var/cur_amount = metal? metal.amount : 0
			var/to_load = max(max_metal - cur_amount,0)
			if(to_load)
				to_load = min(MM.amount, to_load)
				if(!metal)
					metal = new(src)
					metal.amount = 0
				metal.amount += to_load
				MM.use(to_load)
				return to_load
			else
				return 0
		return

	proc/use_metal(amount)
		if(!metal || metal.amount<1)
			for(var/mob/O in hearers(src, null))
				O.show_message("Metal depleted, [src] deactivated.")
			return
		if(metal.amount < amount)
			for(var/mob/O in hearers(src, null))
				O.show_message("No enough Metal to finish the task.")
			return
		metal.use(amount)
		return 1

	proc/dismantleFloor(var/turf/new_turf)
		if(istype(new_turf, /turf/simulated/floor))
			var/turf/simulated/floor/T = new_turf
			if(!T.is_plating())
				if(!T.broken && !T.burnt)
					new T.floor_type(T)
				T.make_plating()
		return !new_turf.intact

	proc/layPipe(var/turf/w_turf,var/M_Dir,var/old_dir)
		if(!on)
			return reset()
		if(!use_metal(1))
			return reset()
		var/fdirn = turn(M_Dir,180)
		var/p_type
		var/p_dir

		if (fdirn!=old_dir)
			p_type=1+P_type
			p_dir=old_dir+M_Dir
	//	else if (M_Dir==old_dir)
	//		p_type=20
	//		p_dir=old_dir
		else
			p_type=0+P_type
			p_dir=M_Dir

		var/obj/item/pipe/P = new (/*usr.loc*/ w_turf, pipe_type=p_type, dir=p_dir)
		P.attackby(new/obj/item/weapon/wrench , src)

		return 1
