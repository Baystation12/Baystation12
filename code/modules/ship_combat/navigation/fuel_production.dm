#define BASE_FUEL_PROCESSING_TIME 300

/obj/machinery/space_battle/fuel_gen
	name = "fuel refinery"
	desc = "Refines phoron into usable rocket fuel."
	icon_state = "fuel_refinery"

	var/sheets = 0
	var/max_sheets = 50
	var/obj/machinery/fuel_port/fuel_port
	var/last_processed = 0

	New()
		..()
		fuel_port = locate() in orange(1)

/obj/machinery/space_battle/fuel_gen/attackby(var/obj/item/O as obj, var/mob/user as mob)
	if(istype(O, /obj/item/stack/material/phoron))
		var/obj/item/stack/addstack = O
		var/amount = min((max_sheets - sheets), addstack.amount)
		if(amount < 1)
			user << "\blue The [src.name] is full!"
			return
		user << "\blue You add [amount] sheet\s to the [src.name]."
		sheets += amount
		addstack.use(amount)
		return
	..()

/obj/machinery/space_battle/fuel_gen/examine(var/mob/user)
	..()
	if(sheets)
		user << "<span class='notice'>It contains [sheets] sheets of phoron!</span>"

/obj/machinery/space_battle/fuel_gen/process()
	if(sheets && fuel_port && !stat & (BROKEN|NOPOWER) && last_processed <= world.timeofday)
		var/obj/structure/reagent_dispensers/fueltank/rocketfuel/F = locate() in get_turf(fuel_port)
		if(F && F.reagents.get_reagent_amount("rocketfuel" < 1000))
			F.reagents.add_reagent("rocketfuel", 100)
			last_processed = world.timeofday + BASE_FUEL_PROCESSING_TIME*get_efficiency(-1,1)
	..()