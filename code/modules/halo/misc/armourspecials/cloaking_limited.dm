
/datum/armourspecials/cloaking/limited
	var/max_charge = 100			//deciseconds
	var/current_charge = 100		//deciseconds
	var/recharge_rate = 0.4			//per decisecond
	var/last_process_time = 0		//deciseconds

/datum/armourspecials/cloaking/limited/New(var/obj/item/source_item)
	source_item.action_button_name = "Toggle Active Camouflage"

/datum/armourspecials/cloaking/limited/activate_cloak(var/voluntary = 1)
	if(current_charge >= max_charge * 0.25)
		last_process_time = world.time
		GLOB.processing_objects += src
		to_chat(usr,"<span class='notice'>Current cloak charge: [100*current_charge/max_charge]%.</span>")
		return ..()
	else
		to_chat(usr,"<span class='notice'>Your cloak charge is to low to activate (recharge time: [(max_charge/recharge_rate)/10] seconds).</span>")

/datum/armourspecials/cloaking/limited/deactivate_cloak(var/voluntary = 1)
	. = ..()
	to_chat(usr,"<span class='notice'>Current cloak charge: [100*current_charge/max_charge]%.</span>")

/datum/armourspecials/cloaking/limited/process()
	//grab delta time
	var/delta_time = world.time - last_process_time
	last_process_time = world.time

	if(cloak_active)
		//use a bit of charge while active
		current_charge -= delta_time
		if(current_charge <= 0)
			to_chat(usr,"<span class='info'>Your cloak is out of charge (recharge time: [(max_charge/recharge_rate)/10] seconds)</span>")
			deactivate_cloak(0)

	else if(!cloak_disrupted)
		//do not recharge while disrupted

		//add some extra charge
		if(current_charge < max_charge)
			var/new_charge = delta_time * recharge_rate
			current_charge += new_charge
			to_chat(usr,"<span class='info'>Current cloak charge: [100*current_charge/max_charge]%.</span>")

	//finished charging
	if(current_charge >= max_charge)
		current_charge = max_charge
		GLOB.processing_objects -= src
		to_chat(usr,"<span class='info'>Current cloak charge: [100*current_charge/max_charge]%.</span>")

/datum/armourspecials/cloaking/limited/tryemp(severity)
	current_charge = 0
	return ..()
