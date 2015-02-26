/*
///////////// PHORON DESUBLIMER ////////////////
	~~Created by Kwask, sprites by Founded1992~~
Desc: This is a machine which will take gaseous phoron and turns it into various materials
The process works like this:
	1.) Gaseous phoron is pumped into the Hyperinductor. This machine is basically a super heater, as it can heat gas up to 500,000 kelvin
	2.) Gas is heated up to the optimal temperature for crystalization, which is randomly determined at round start.
	3.) After the gas is hot enough, it is injected into the reaction chamber. The reaction chamber must be at a specific pressure.
		If it is too low, then there is waste product, and if it is too high, you risk breaking the machine.
	4.) The supermatter shard is then formed and extracted from the machine and taken to the Neutron Furnace

	NEUTRON FURNACE
	5.) Place the supermatter shard inside and set the neutron flow. The neutron flow represents the desired focus point.
		Each of the different materials has a "focus peak" where you produce a maximum output of that material.
		Setting the neutron flow between two peaks creates a smaller amount of both materials.
		Some materials, such as osmium and phoron, produce so little amount that you may get nothing unless the neutron flow matches the peak.
	6.) Activate the machine.
	7.) Congrats, you now have some bars!
*/

/obj/machinery/phoron_desublimer
	icon = 'icons/obj/machines/phoron_compressor.dmi'
	density = 1
	anchored = 1
	use_power = 1
	idle_power_usage = 0
	var/ready = 0
	var/active = 0

	process()
		if( stat & ( BROKEN|NOPOWER ))
			ready = 0

	proc/report_ready()
		if( stat & ( BROKEN|NOPOWER ))
			ready = 0


/*  //////// HYPERINDUCTOR ////////
	Superheats gas sent into it, up to 500,000 K
*/
/obj/machinery/atmospherics/unary/heater/inductor
	name = "Hyperinductor"
	desc = "Gas goes into here to be superheated to prepare for crystalization."
	icon = 'icons/obj/machines/phoron_compressor.dmi'
	icon_state = "Inactive"

	set_temperature = T20C	//thermostat
	max_temperature = T20C + 500000
	internal_volume = 1000	//L

	use_power = 0
	idle_power_usage = 5			//5 Watts for thermostat related circuitry

	max_power_rating = 500000	//power rating when the usage is turned up to 100
	power_setting = 100

	New()
		..()

		component_parts = list()
		component_parts += new /obj/item/weapon/stock_parts/matter_bin(src)
		component_parts += new /obj/item/weapon/stock_parts/capacitor(src)
		component_parts += new /obj/item/weapon/stock_parts/capacitor(src)
		component_parts += new /obj/item/weapon/stock_parts/capacitor(src)
		component_parts += new /obj/item/weapon/stock_parts/capacitor(src)

	update_icon()
		if(src.node)
			if(src.use_power && src.heating)
				icon_state = "Active"
			else
				icon_state = "Inactive"
		else
			icon_state = "Inactive"
		return

/*
	New()
		..()
		icon_state = "Inactive"
		air_contents.volume = internal_volume

		component_parts = list()
		component_parts += new /obj/item/weapon/stock_parts/matter_bin(src)
		component_parts += new /obj/item/weapon/stock_parts/capacitor(src)
		component_parts += new /obj/item/weapon/stock_parts/capacitor(src)
		component_parts += new /obj/item/weapon/stock_parts/capacitor(src)
		component_parts += new /obj/item/weapon/stock_parts/capacitor(src)

	update_icon()
		..()

		if(src.heating)
			icon_state = "Active"
		else
			icon_state = "Inactive"

		return

	process()
		..()

		idle_power_usage = 5
		if( active & ready )
			icon_state = "Heating"
			heat_gas()

		if(stat & (NOPOWER|BROKEN) || !use_power)
			heating = 0
			update_icon()
			return

		if (network && air_contents.total_moles && air_contents.temperature < set_temperature)
			air_contents.add_thermal_energy( heat_power )
			use_power(power_rating)

			heating = 1
			network.update = 1
		else
			heating = 0

		update_icon()

	report_ready()
		ready = 0

		var/list/machine = list( "vessel" = 0 )
		for( var/obj/machinery/phoron_desublimer/M in orange(src) )
			if( istype( M, /obj/machinery/phoron_desublimer/vessel ))
				machine["vessel"] = 1

		if( machine["vessel"] )
			ready = 1

		..()

		return ready

	proc/heat_gas() // Heating the contained gas
		var/heat_transfer = air_contents.get_thermal_energy_change(set_temperature)
		heat_transfer = min( heat_transfer, heating_power ) //limit by the power rating of the heater
		air_contents.add_thermal_energy(heat_transfer)

		idle_power_usage = heat_transfer

	proc/change_temperature( var/change )
		set_temperature += change

		if( set_temperature < 0 )
			set_temperature = 0
		else if( set_temperature > max_temperature )
			set_temperature = max_temperature
*/

/*  //////// PHORON REACTANT VESSEL ////////
	Recieves superheated gas from the Hyperinductor, turns it into supermatter shards
*/


/obj/machinery/portable_atmospherics/react_vessel
	name = "Reactant Vessel"
	desc = "Created supermatter shards from high-temperature phoron."
	icon_state = "ProcessorEmpty"
	active_power_usage = 10000

	density = 1
	var/health = 100.0
	flags = CONDUCT

	var/valve_open = 0


	var/canister_color = "yellow"
	var/can_label = 1
	start_pressure = 45 * ONE_ATMOSPHERE
	pressure_resistance = 1000 * ONE_ATMOSPHERE
	var/temperature_resistance = 1000 + T0C
	volume = 1000
	use_power = 0
	var/release_log = ""
	var/update_flag = 0

/obj/machinery/phoron_desublimer/vessel
	name = "Reactant Vessel"
	desc = "Created supermatter shards from high-temperature phoron."
	icon_state = "ProcessorEmpty"
	var/datum/gas_mixture/air_contents = new
	active_power_usage = 10000

	New()
		..()

		component_parts = list()
		component_parts += new /obj/item/weapon/stock_parts/matter_bin(src)
		component_parts += new /obj/item/weapon/stock_parts/matter_bin(src)
		component_parts += new /obj/item/weapon/stock_parts/capacitor(src)
		component_parts += new /obj/item/weapon/stock_parts/capacitor(src)
		component_parts += new /obj/item/weapon/stock_parts/capacitor(src)

	process()
		..()

		if( active & ready )
			icon_state = "ProcessorFull"

	proc/start_fill()
		flick("ProcessorFill", src)
		active = 1

	proc/crystalize()
		flick("ProcessorCrystalize", src)
		active = 0

	report_ready()
		ready = 1

		..()

		return ready


/*  //////// NEUTRON FURNACE /////////
	Put a supermatter shard inside of it, set neutron flow to specific level, get materials out
*/
/obj/machinery/phoron_desublimer/furnace
	name = "Neutron Furnace"
	desc = "A modern day alchemist's best friend."
	icon_state = "Open"

	var/neutron_flow = 25
	var/max_neutron_flow = 300
	var/obj/item/weapon/shard/supermatter/shard = null

	var/list/mat = list( "Osmium", "Phoron", "Diamonds", "Platinum", "Gold", "Uranium",  "Silver", "Steel",  )
	var/list/mat_mod = list(    "Steel" = 3.5,
								"Silver" = 2.5,
								"Uranium" = 2.5,
								"Gold" = 1.5,
								"Platinum" = 1.5,
								"Diamonds" = 1.5,
								"Phoron" = 1.5,
								"Osmium" = 1.3 ) // modifier for output amount

	var/list/mat_peak = list(   "Steel" = 30,
								"Silver" = 70,
								"Uranium" = 110,
								"Gold" = 150,
								"Platinum" = 190,
								"Diamonds" = 230,
								"Phoron" = 270,
								"Osmium" = 300 ) // Standard peak locations

	var/list/obj/item/stack/sheet/mat_obj = list( 	"Diamonds" = /obj/item/stack/sheet/mineral/diamond,
													"Steel" = /obj/item/stack/sheet/metal,
													"Silver" = /obj/item/stack/sheet/mineral/silver,
													"Platinum" = /obj/item/stack/sheet/mineral/platinum,
													"Osmium" = /obj/item/stack/sheet/mineral/osmium,
													"Gold" = /obj/item/stack/sheet/mineral/gold,
													"Uranium" = /obj/item/stack/sheet/mineral/uranium,
													"Phoron" = /obj/item/stack/sheet/mineral/phoron ) // cost per each mod # of bars

	New()
		..()
		component_parts = list()
		component_parts += new /obj/item/weapon/stock_parts/matter_bin(src)
		component_parts += new /obj/item/weapon/stock_parts/matter_bin(src)
		component_parts += new /obj/item/weapon/stock_parts/capacitor(src)
		component_parts += new /obj/item/weapon/stock_parts/capacitor(src)


		/*
		for( var/i = 1, i <= output_peak.len, i++ )
			var/peak = output_peak[i]
			peak += -rand(0,1)*rand(1,3) // adding a bit of randomness to the process
			output_peak[i] = peak

		*/

	process()
		..()

	proc/modify_flow(var/change)
		neutron_flow += change
		if( neutron_flow > max_neutron_flow )
			neutron_flow = max_neutron_flow

		if( neutron_flow < 0 )
			neutron_flow = 0

	// Produces the resultant material
	proc/produce()
		if( !shard )
			src.visible_message("\icon[src] <b>[src]</b> buzzes, \"Needs a supermatter shard to transmutate.\"")
			return
		var/list/peak_distances = list()
		peak_distances = get_peak_distances( neutron_flow )
		var/max_distance = 50.0 // Max peak distance from neutron flow which will still produce materials

		active = 1
		flick( "Active", src )

		var/amount = 0
		for( var/cur_mat in mat )
			var/distance = peak_distances[cur_mat]
			if( distance <= max_distance )
				amount = round((( max_distance-distance )/max_distance )*mat_mod[cur_mat] ) // Produces amount based on distance from flow and modifier

				if( amount > 0 ) // Will only do anything if any amount was actually created
					var/obj/item/stack/sheet/T = mat_obj[cur_mat]
					var/obj/item/stack/sheet/I = new T
					I.amount = amount
					I.loc = src.loc

		eat_shard()
		src.visible_message("\icon[src] <b>[src]</b> beeps, \"Supermatter transmutation complete.\"")
		active = 0

	// This sorts a list of peaks within max_distance units of the given flow and returns a sorted list of the nearest ones
	proc/get_peak_distances( var/flow )
		var/list/peak_distances = new/list()

		for( var/cur_mat in mat_peak )
			var/peak = mat_peak[cur_mat]
			var/peak_distance = abs( peak-flow )
			peak_distances[cur_mat] = peak_distance
		return peak_distances

	// Eats the shard, duh
	proc/eat_shard()
		if( !shard )
			return 0

		del(shard)

		update_icon()
		return 1

	// Returns true if the machine is ready to perform
	report_ready()
		ready = 1

		..()

		return ready


	attackby(var/obj/item/weapon/shard/B as obj, var/mob/user as mob)
		if(isrobot(user))
			return
		if(istype(B, /obj/item/weapon/shard/supermatter))
			if( !shard )
				user.drop_item()
				B.loc = src
				shard = B
				user << "You put [B] into the machine."
			else
				user << "There is already a shard in the machine."
		else
			user << "<span class='notice'>This machine only accepts supermatter shards</span>"

		update_icon()
		return


	update_icon()
		..()

		if( shard )
			icon_state = "OpenCrystal"
		else
			icon_state = "Open"



/obj/machinery/computer/phoron_desublimer_control
	name = "Phoron Desublimation Control"
	desc = "Controls the phoron desublimation process."
	icon = 'icons/obj/machines/phoron_compressor.dmi'
	icon_state = "Ready"

	idle_power_usage = 500
	active_power_usage = 70000 //70 kW per unit of strength
	var/active = 0
	var/assembled = 0

	var/list/machine = list( "vessel", "furnace" )
	var/list/obj/machinery/phoron_desublimer/machine_ref = list( "vessel" = null, "furnace" = null )
	var/list/obj/machinery/phoron_desublimer/machine_obj = list( "vessel" = /obj/machinery/phoron_desublimer/vessel,
																 "furnace" = /obj/machinery/phoron_desublimer/furnace )

	New()
		..()

		src.check_parts()

	proc/find_parts()
		for( var/M in machine_ref )
			M = null

		var/area/main_area = get_area(src)

		for(var/area/related_area in main_area.related)
			for( var/obj/machinery/phoron_desublimer/PD in related_area.contents )
				if(PD.report_ready())
					for( var/type in machine_obj )
						if( istype( PD, machine_obj[type] ))
							machine_ref[type] = PD // Gettinng the machines sorted out
		return

	proc/check_parts()
		assembled = 0
		find_parts()

		var/count = 0
		for( var/type in machine )
			if( machine_ref[type] )
				count++

		if( count == 3 )
			assembled = 1

		return

	attack_hand(mob/user as mob)
		interact(user)

	interact(mob/user)
		if((get_dist(src, user) > 1) || (stat & (BROKEN|NOPOWER)))
			if(!istype(user, /mob/living/silicon))
				user.unset_machine()
				user << browse(null, "window=pacontrol")
				return
		user.set_machine(src)

		var/dat = ""
		dat += "<h3><b>Phoron Desublimer Controller</b></h3><BR>"
		dat += "<A href='?src=\ref[src];close=1'>Close</A><BR>"
		dat += "<A href='?src=\ref[src];scan=1'>Run Scan</A><BR><BR>"

		dat += "<b>Status:</b><BR>"
		for( var/M in machine_ref )
			if( machine_ref[M] )
				var/list/obj/machinery/phoron_desublimer/type = machine_ref[M]
				dat += "<h4><center>[type.name]</center></h4>"
				if( type && type.ready )
					dat += "<BR>"
					if( istype( type, /obj/machinery/phoron_desublimer/furnace ))
						var/obj/machinery/phoron_desublimer/furnace/furnace = type
						dat += "<b>Neutron Flow:</b><BR>"
						dat += "<A href='?src=\ref[src];furnace_n10=1'>---</A> "
						dat += "<A href='?src=\ref[src];furnace_n1=1'>--</A> "
						dat += "<A href='?src=\ref[src];furnace_n01=1'>-</A> "
						dat += "   [furnace.neutron_flow]   "
						dat += "<A href='?src=\ref[src];furnace_01=1'>+</A> "
						dat += "<A href='?src=\ref[src];furnace_1=1'>++</A> "
						dat += "<A href='?src=\ref[src];furnace_10=1'>+++</A> <BR><BR>"
						if( furnace.shard )
							dat += "<b>Supermatter Shard Inserted</b> <BR>"
							if( furnace.active )
								dat += "<b>Active</b>"
							else
								dat += "<A href='?src=\ref[src];furnace_activate=1'>Activate</A><BR>"
						else
							dat += "<b>Supermatter Shard Needed</b> <BR>"
				else
					dat += "ERROR: Incrreoctly set up!<BR>"
				dat += "<BR><HR>"

		user << browse(dat, "window=pdcontrol;size=420x500")
		onclose(user, "pdcontrol")
		return

	Topic(href, href_list)
		..()
		//Ignore input if we are broken, !silicon guy cant touch us, or nonai controlling from super far away
		if(stat & (BROKEN|NOPOWER) || (get_dist(src, usr) > 1 && !istype(usr, /mob/living/silicon)) || (get_dist(src, usr) > 8 && !istype(usr, /mob/living/silicon/ai)))
			usr << browse(null, "window=pdcontrol")
			usr.unset_machine()
			return

		if( href_list["close"] )
			usr << browse(null, "window=pdcontrol")
			usr.unset_machine()
			return
		else if(href_list["scan"])
			src.check_parts()
		else if(href_list["furnace_10"])
			var/obj/machinery/phoron_desublimer/furnace/furnace = machine_ref["furnace"]
			furnace.modify_flow( 10 )
		else if(href_list["furnace_1"])
			var/obj/machinery/phoron_desublimer/furnace/furnace = machine_ref["furnace"]
			furnace.modify_flow( 1 )
		else if(href_list["furnace_01"])
			var/obj/machinery/phoron_desublimer/furnace/furnace = machine_ref["furnace"]
			furnace.modify_flow( 0.1 )
		else if(href_list["furnace_n01"])
			var/obj/machinery/phoron_desublimer/furnace/furnace = machine_ref["furnace"]
			furnace.modify_flow( -0.1 )
		else if(href_list["furnace_n1"])
			var/obj/machinery/phoron_desublimer/furnace/furnace = machine_ref["furnace"]
			furnace.modify_flow( -1 )
		else if(href_list["furnace_n10"])
			var/obj/machinery/phoron_desublimer/furnace/furnace = machine_ref["furnace"]
			furnace.modify_flow( -10 )
		else if(href_list["furnace_activate"])
			var/obj/machinery/phoron_desublimer/furnace/furnace = machine_ref["furnace"]
			if( furnace.ready & !furnace.active )
				furnace.produce()

		src.updateDialog()
		src.update_icon()
		return