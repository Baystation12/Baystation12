/obj/machinery/pipelayer

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
	var/metal = 100
	var/obj/item/weapon/wrench/W

/obj/machinery/pipelayer/New()
	W = new(src)
	..()

/obj/machinery/pipelayer/Move(new_turf,M_Dir)
	..()

	if(a_dis)
		dismantleFloor(new_turf)
	layPipe(old_turf,M_Dir,old_dir)

	old_turf = new_turf
	old_dir = turn(M_Dir,180)

/obj/machinery/pipelayer/attack_hand(mob/user as mob)
	on=!on
	visible_message("[src] [!on?"dea":"a"]ctivated.", "[user] [!on?"dea":"a"]ctivate [src].")
	return

/obj/machinery/pipelayer/attackby(var/obj/item/W as obj, var/mob/user as mob)

	if (istype(W, /obj/item/weapon/wrench))
		switch(P_type)
			if(31)
				P_type = 0
				P_type_t = "regular pipes"
			if(29)
				P_type = 31
				P_type_t = "rcrubbers pipes"
			if(2)
				P_type = 29
				P_type_t = "supply pipes"
			if(0)
				P_type = 2
				P_type_t = "heat exchange"

		user.visible_message("[user] set [src] to [P_type_t] making", "You set [src] to [P_type_t] making")
		return

	if(istype(W, /obj/item/weapon/crowbar))
		a_dis=!a_dis
		visible_message("[src] auto dismantle [!on?"dea":"a"]ctivated.")
		return

	if(istype(W, /obj/item/stack/sheet/metal))

		var/result = load_metal(W)
		var/message
		if(isnull(result))
			message = "Unable to load [W] - no metal found."
		else if(!result)
			message = "Stack is full."
		else
			message = "[result] scheets of metal successfully loaded."

		visible_message("[message]")
		return

	if(istype(W, /obj/item/weapon/screwdriver))
		if(metal)
			var/m = round(input(usr,"Please specify the amount of metal to remove","Remove metal",min(metal,50)) as num, 1)
			m = min(m, 50)
			m = min(m, metal)
			if(m)
				use_metal(m)
				var/obj/item/stack/sheet/metal/MM = new (get_turf(src))
				MM.amount = m
		else
			user.visible_message("There's no more metal on the stack.")
		return
	..()

/obj/machinery/pipelayer/examine(mob/user)
	..()
	user.visible_message("[src] have [metal] in stack, setted to [P_type_t], and auto dismantle [!on?"dea":"a"]ctivated.")

/obj/machinery/pipelayer/proc/reset()
	return

/obj/machinery/pipelayer/proc/load_metal(var/obj/item/stack/sheet/metal/MM)
	if(istype(MM) && MM.get_amount())
		var/cur_amount = metal
		var/to_load = max(max_metal - cur_amount,0)
		if(to_load)
			to_load = min(MM.get_amount(), to_load)
			metal += to_load
			MM.use(to_load)
			return to_load
		else
			return 0
	return

/obj/machinery/pipelayer/proc/use_metal(amount)
	if(!metal || metal<amount)
		visible_message("Metal depleted, [src] deactivated.")
		return
	if(metal < amount)
		visible_message("No enough Metal to finish the task.")
		return
	metal-=amount
	return 1

/obj/machinery/pipelayer/proc/dismantleFloor(var/turf/new_turf)
	if(istype(new_turf, /turf/simulated/floor))
		var/turf/simulated/floor/T = new_turf
		if(!T.is_plating())
			if(!T.broken && !T.burnt)
				new T.floor_type(T)
			T.make_plating()
	return !new_turf.intact

/obj/machinery/pipelayer/proc/layPipe(var/turf/w_turf,var/M_Dir,var/old_dir)
	if(!on)
		return reset()
	if(!(M_Dir in list(1, 2, 4, 8)))
		return reset()
	if(!use_metal(0.25))
		return reset()
	var/fdirn = turn(M_Dir,180)
	var/p_type
	var/p_dir

	if (fdirn!=old_dir)
		p_type=1+P_type
		p_dir=old_dir+M_Dir
	else
		p_type=0+P_type
		p_dir=M_Dir

	var/obj/item/pipe/P = new (w_turf, pipe_type=p_type, dir=p_dir)
	P.attackby(W , src)

	return 1
