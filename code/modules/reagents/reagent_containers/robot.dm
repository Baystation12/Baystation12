/obj/item/weapon/reagent_containers/robot
	var/charge_cost = 50 // Energy cell cost for each recharge cycle
	var/charge_tick = 0 // Counter for the recharge timer
	var/recharge_time = 5 // Time between recharge cycles (In ticks/seconds)
	var/recharge_amount = 5 // Amount of reagent to recharge per cycle

	var/list/reagent_ids = list()
	var/list/reagent_volumes = list()
	var/list/reagent_names = list()

/obj/item/weapon/reagent_containers/robot/Process() // Every [recharge_time] seconds, recharge some reagents for the cyborg+
	if(++charge_tick < recharge_time)
		return 0
	charge_tick = 0

	if(isrobot(loc))
		var/mob/living/silicon/robot/R = loc
		if(R && R.cell)
			for(var/T in reagent_ids)
				if(reagent_volumes[T] < volume)
					R.cell.use(charge_cost)
					reagent_volumes[T] = min(reagent_volumes[T] + recharge_amount, volume)

	return 1
