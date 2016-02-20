// the power cell
// charge from 0 to 100%
// fits in APC to provide backup power

/obj/item/weapon/cell/New()
	..()
	charge = maxcharge

	switch(maxcharge)
		if(20001 to INFINITY)
			desc = "This is a top grade NT-brand power cell. Shines with high polish."
		if(10001 to 20000)
			desc = "This is an advanced NT-brand power cell used in various heavy duty applications."
		if(2501 to 10000)
			desc = "This is a standard NT-brand power cell used in various systems around the station."
		else
			desc = "This is a standard NT-brand power cell used in various systems around the station. This one seems to be quite old and rusty."

	desc += "It's rating is [maxcharge]."

/obj/item/weapon/cell/initialize()
	..()
	update_icon()

/obj/item/weapon/cell/drain_power(var/drain_check, var/surge, var/power = 0)

	if(drain_check)
		return 1

	if(charge <= 0)
		return 0

	var/cell_amt = power * CELLRATE

	return use(cell_amt) / CELLRATE

/obj/item/weapon/cell/update_icon()
	overlays.Cut()

	if(charge < 0.01)
		return
	else if(charge/maxcharge >=0.995)
		overlays += image('icons/obj/power.dmi', "cell-o2")
	else
		overlays += image('icons/obj/power.dmi', "cell-o1")

/obj/item/weapon/cell/proc/percent()		// return % charge of cell
	return 100.0*charge/maxcharge

/obj/item/weapon/cell/proc/fully_charged()
	return (charge == maxcharge)

// checks if the power cell is able to provide the specified amount of charge
/obj/item/weapon/cell/proc/check_charge(var/amount)
	return (charge >= amount)

// use power from a cell, returns the amount actually used
/obj/item/weapon/cell/proc/use(var/amount)
	if(rigged && amount > 0)
		explode()
		return 0
	var/used = min(charge, amount)
	charge -= used
	return used

// Checks if the specified amount can be provided. If it can, it removes the amount
// from the cell and returns 1. Otherwise does nothing and returns 0.
/obj/item/weapon/cell/proc/checked_use(var/amount)
	if(!check_charge(amount))
		return 0
	use(amount)
	return 1

// recharge the cell
/obj/item/weapon/cell/proc/give(var/amount)
	if(rigged && amount > 0)
		explode()
		return 0

	if(maxcharge < amount)	return 0
	var/amount_used = min(maxcharge-charge,amount)
	charge += amount_used
	return amount_used


/obj/item/weapon/cell/examine(mob/user)
	..()
	user << "The charge meter shows [round(percent())]%"

/obj/item/weapon/cell/attackby(obj/item/W, mob/user)
	..()
	if(istype(W, /obj/item/weapon/reagent_containers/syringe))
		var/obj/item/weapon/reagent_containers/syringe/S = W

		user << "You inject the solution into the power cell."

		if(S.reagents.has_reagent("phoron", 5))

			rigged = 1

			log_admin("LOG: [user.name] ([user.ckey]) injected a power cell with phoron, rigging it to explode.")
			message_admins("LOG: [user.name] ([user.ckey]) injected a power cell with phoron, rigging it to explode.")

		S.reagents.clear_reagents()


/obj/item/weapon/cell/proc/explode()
	var/turf/T = get_turf(src.loc)
/*
 * 1000-cell	explosion(T, -1, 0, 1, 1)
 * 2500-cell	explosion(T, -1, 0, 1, 1)
 * 10000-cell	explosion(T, -1, 1, 3, 3)
 * 15000-cell	explosion(T, -1, 2, 4, 4)
 * */
	if (charge==0)
		return
	var/devastation_range = -1 //round(charge/11000)
	var/heavy_impact_range = round(sqrt(charge)/60)
	var/light_impact_range = round(sqrt(charge)/30)
	var/flash_range = light_impact_range
	if (light_impact_range==0)
		rigged = 0
		corrupt()
		return
	//explosion(T, 0, 1, 2, 2)

	log_admin("LOG: Rigged power cell explosion, last touched by [fingerprintslast]")
	message_admins("LOG: Rigged power cell explosion, last touched by [fingerprintslast]")

	explosion(T, devastation_range, heavy_impact_range, light_impact_range, flash_range)

	qdel(src)

/obj/item/weapon/cell/proc/corrupt()
	charge /= 2
	maxcharge /= 4

/obj/item/weapon/cell/emp_act(var/severity)
	// EMP causes the cell to lose relatively small amount of power. This will be quite notable with low grade cell, but not as serious as we get to higher cell capacities.
	charge -= rand(min(maxcharge/8 ,1000), min(maxcharge/4 ,2000)) / severity
	// Cells that are not part of a machine or something are hit more seriously, losing some maximal capacity permanently, to simulate the EMP affecting electronics of the cell.
	// This prevents EMPs from screwing up synthetics, APCs and similar things too much, while still keeping them as a threat.
	if(istype(loc, /turf/))
		maxcharge -= (rand(maxcharge/8, maxcharge/16) / severity)
	charge = between(0, charge, maxcharge)
	..()



/obj/item/weapon/cell/proc/get_electrocute_damage()
	switch (charge)
		if (1000000 to INFINITY)
			return min(rand(50,160),rand(50,160))
		if (200000 to 1000000-1)
			return min(rand(25,80),rand(25,80))
		if (100000 to 200000-1)//Ave powernet
			return min(rand(20,60),rand(20,60))
		if (50000 to 100000-1)
			return min(rand(15,40),rand(15,40))
		if (1000 to 50000-1)
			return min(rand(10,20),rand(10,20))
		else
			return 0
