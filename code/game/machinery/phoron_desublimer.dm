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
/obj/machinery/phoron_desublimer/inductor
	name = "Hyperinductor"
	desc = "Gas goes into here to be superheated to prepare for crystalization."
	icon_state = "Pumped"
	var/datum/gas_mixture/air_contents = new
	var/heating_power = 500000
	active_power_usage = 500000
	var/set_temperature = 100000

	New()
		..()
		icon_state = "Pumped"

	process()
		..()

		air_contents.react()

		idle_power_usage = 0
		if( active & ready )
			icon_state = "Pumping"
			heat_gas()

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

		heat_transfer = min( heat_transfer , heating_power ) //limit by the power rating of the heater

		idle_power_usage = heat_transfer
		air_contents.add_thermal_energy(heat_transfer)

/*  //////// PHORON REACTANT VESSEL ////////
	Recieves superheated gas from the Hyperinductor, turns it into supermatter shards
*/
/obj/machinery/phoron_desublimer/vessel
	name = "Reactant Vessel"
	desc = "Created supermatter shards from high-temperature phoron."
	icon_state = "ProcessorEmpty"
	var/datum/gas_mixture/air_contents = new
	active_power_usage = 10000

	New()
		..()

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
		ready = 0
		var/list/machine = list( "inductor" = 0 )

		for( var/obj/machinery/phoron_desublimer/M in orange(src) )
			if( istype( M, /obj/machinery/phoron_desublimer/inductor ))
				machine["inductor"] = 1

		if( machine["inductor"] )
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
	var/total_power = 150
	var/obj/item/weapon/shard/supermatter/shard = null

	var/list/mat = list( "Osmium", "Phoron", "Diamonds", "Platinum", "Gold", "Uranium",  "Silver", "Steel",  )
	var/list/mat_mod = list(    "Steel" = 3,
								"Silver" = 2,
								"Uranium" = 2,
								"Gold" = 1,
								"Platinum" = 1,
								"Diamonds" = 1,
								"Phoron" = 1,
								"Osmium" = 1 ) // modifier for output amount

	var/list/mat_peak = list(   "Steel" = 30,
								"Silver" = 70,
								"Uranium" = 110,
								"Gold" = 150,
								"Platinum" = 190,
								"Diamonds" = 230,
								"Phoron" = 270,
								"Osmium" = 300 ) // cost per each mod # of bars

	var/list/obj/item/stack/sheet/mat_obj = list( 	"Diamonds" = /obj/item/stack/sheet/mineral/diamond,
													"Steel" = /obj/item/stack/sheet/metal,
													"Silver" = /obj/item/stack/sheet/mineral/silver,
													"Platinum" = /obj/item/stack/sheet/mineral/platinum,
													"Osmium" = /obj/item/stack/sheet/mineral/osmium,
													"Gold" = /obj/item/stack/sheet/mineral/gold,
													"Uranium" = /obj/item/stack/sheet/mineral/enruranium,
													"Phoron" = /obj/item/stack/sheet/mineral/phoron ) // cost per each mod # of bars

	New()
		..()

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

	proc/produce()
		if( !shard )
			src.visible_message("\icon[src] <b>[src]</b> beeps, \"Needs a supermatter shard to transmutate.\"")
			return
		active = 1

		var/remaining_power = total_power
		flick( "Active", src )

		var/amount = 0
		for( var/cur_mat in mat )
			if( mat_peak[cur_mat] <= neutron_flow ) // If the neutron flow is higher than the peak energy required, go ahead with the process
				amount = round( remaining_power/mat_peak[cur_mat] )

				if( amount > 0 ) // Will only do anything if any amount was actually created
					remaining_power = remaining_power - (amount*mat_peak[cur_mat]) // Using power to create materials
					var/obj/item/stack/sheet/T = mat_obj[cur_mat]
					var/obj/item/stack/sheet/I = new T
					I.amount = amount
					I.loc = src.loc

		eat_shard()
		src.visible_message("\icon[src] <b>[src]</b> beeps, \"Supermatter transmutation complete.\"")
		active = 0

	proc/eat_shard()
		if( !shard )
			return 0

		del(shard)

		update_icon()
		return 1

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

	var/list/machine = list( "inductor", "vessel", "furnace" )
	var/list/obj/machinery/phoron_desublimer/machine_ref = list( "inductor" = null, "vessel" = null, "furnace" = null )
	var/list/obj/machinery/phoron_desublimer/machine_obj = list( "inductor" = /obj/machinery/phoron_desublimer/inductor,
								 								 "vessel" = /obj/machinery/phoron_desublimer/vessel,
																 "furnace" = /obj/machinery/phoron_desublimer/furnace )

	New()
		..()

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
		if( !assembled )
			dat += "Unable to detect all parts!<BR>"
		else
			for( var/M in machine )
				var/list/obj/machinery/phoron_desublimer/type = machine_ref[M]
				dat += "<h4><center>[type.name]</center></h4>"
				if( type && type.ready )
					dat += "<BR>"
					if( istype( type, /obj/machinery/phoron_desublimer/furnace ))
						var/obj/machinery/phoron_desublimer/furnace/furnace = type
						dat += "<b>Neutron Flow:</b> [furnace.neutron_flow]<BR>"
						dat += "<A href='?src=\ref[src];furnace_n10=1'>---</A> "
						dat += "<A href='?src=\ref[src];furnace_n1=1'>--</A> "
						dat += "<A href='?src=\ref[src];furnace_n01=1'>-</A> "
						dat += "<A href='?src=\ref[src];furnace_01=1'>+</A> "
						dat += "<A href='?src=\ref[src];furnace_1=1'>++</A> "
						dat += "<A href='?src=\ref[src];furnace_10=1'>+++</A> <BR><BR>"
						if( furnace.shard )
							dat += "<b>Supermatter Shard Inserted</b> <BR>"
							if( furnace.active  )
								dat += "<b>Activate</b>"
							else
								dat += "<A href='?src=\ref[src];furnace_activate=1'>Activate</A><BR>"
						else
							dat += "<b>Supermatter Shard Needed</b> <BR>"
				else
					dat += "Not found!<BR>"
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