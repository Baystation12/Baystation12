#define IC_SMOKE_REAGENTS_MINIMUM_UNITS 10
#define IC_REAGENTS_DRAW 0
#define IC_REAGENTS_INJECT 1
#define IC_HEATER_MODE_HEAT         "heat"
#define IC_HEATER_MODE_COOL         "cool"

/obj/item/integrated_circuit/reagent
	category_text = "Reagent"
	unacidable = TRUE
	cooldown_per_use = 10
	var/volume = 0

/obj/item/integrated_circuit/reagent/Initialize()
	. = ..()
	if(volume)
		create_reagents(volume)
		push_vol()

/obj/item/integrated_circuit/reagent/proc/push_vol()
	set_pin_data(IC_OUTPUT, 1, reagents.total_volume)
	push_data()

/obj/item/integrated_circuit/reagent/smoke
	name = "smoke generator"
	desc = "Unlike most electronics, creating smoke is completely intentional."
	icon_state = "smoke"
	extended_desc = "This smoke generator creates clouds of smoke on command. It can also hold liquids inside, which will go \
	into the smoke clouds when activated. The reagents are consumed when the smoke is made."
	ext_cooldown = 1
	atom_flags = ATOM_FLAG_OPEN_CONTAINER
	volume = 100

	complexity = 20
	cooldown_per_use = 1 SECONDS
	inputs = list()
	outputs = list(
		"volume used" = IC_PINTYPE_NUMBER,
		"self reference" = IC_PINTYPE_REF
		)
	activators = list(
		"create smoke" = IC_PINTYPE_PULSE_IN,
		"on smoked" = IC_PINTYPE_PULSE_OUT,
		"push ref" = IC_PINTYPE_PULSE_IN
		)
	spawn_flags = IC_SPAWN_RESEARCH
	power_draw_per_use = 20
	var/smoke_radius = 5
	var/notified = FALSE

/obj/item/integrated_circuit/reagent/smoke/on_reagent_change()
	push_vol()

/obj/item/integrated_circuit/reagent/smoke/do_work(ord)
	switch(ord)
		if(1)
			if(!reagents || (reagents.total_volume < IC_SMOKE_REAGENTS_MINIMUM_UNITS))
				return
			var/location = get_turf(src)
			var/datum/effect/effect/system/smoke_spread/chem/S = new
			S.attach(location)
			playsound(location, 'sound/effects/smoke.ogg', 50, 1, -3)
			if(S)
				S.set_up(reagents, smoke_radius, 0, location)
				if(!notified)
					notified = TRUE
				S.start()
			reagents.clear_reagents()
			activate_pin(2)
		if(3)
			set_pin_data(IC_OUTPUT, 2, weakref(src))
			push_data()

/obj/item/integrated_circuit/reagent/injector
	name = "integrated hypo-injector"
	desc = "This scary looking thing is able to pump liquids into, or suck liquids out of, whatever it's pointed at."
	icon_state = "injector"
	extended_desc = "This autoinjector can push up to 30 units of reagents into another container or someone else outside of the machine. The target \
	must be adjacent to the machine, and if it is a person, they cannot be wearing thick clothing. Negative given amounts makes the injector suck out reagents instead."

	atom_flags = ATOM_FLAG_OPEN_CONTAINER
	volume = 30

	complexity = 20
	cooldown_per_use = 6 SECONDS
	inputs = list(
		"target" = IC_PINTYPE_REF,
		"injection amount" = IC_PINTYPE_NUMBER
		)
	inputs_default = list(
		"2" = 5
		)
	outputs = list(
		"volume used" = IC_PINTYPE_NUMBER,
		"self reference" = IC_PINTYPE_REF
		)
	activators = list(
		"inject" = IC_PINTYPE_PULSE_IN,
		"on injected" = IC_PINTYPE_PULSE_OUT,
		"on fail" = IC_PINTYPE_PULSE_OUT,
		"push ref" = IC_PINTYPE_PULSE_IN

		)
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH
	power_draw_per_use = 15
	var/direction_mode = IC_REAGENTS_INJECT
	var/transfer_amount = 10
	var/busy = FALSE

/obj/item/integrated_circuit/reagent/injector/on_reagent_change(changetype)
	push_vol()

/obj/item/integrated_circuit/reagent/injector/on_data_written()
	var/new_amount = get_pin_data(IC_INPUT, 2)
	if(new_amount < 0)
		new_amount = -new_amount
		direction_mode = IC_REAGENTS_DRAW
	else
		direction_mode = IC_REAGENTS_INJECT
	if(isnum(new_amount))
		new_amount = clamp(new_amount, 0, volume)
		transfer_amount = new_amount


/obj/item/integrated_circuit/reagent/injector/do_work(ord)
	switch(ord)
		if(1)
			inject()
		if(4)
			set_pin_data(IC_OUTPUT, 2, weakref(src))
			push_data()

/obj/item/integrated_circuit/reagent/injector/proc/target_nearby(var/weakref/target)
	var/mob/living/L = target.resolve()
	if(!L || get_dist(src,L) > 1)
		return
	return L

/obj/item/integrated_circuit/reagent/injector/proc/inject_after(var/weakref/target)
	busy = FALSE
	var/mob/living/L = target_nearby(target)
	if(!L)
		activate_pin(3)
		return
	var/atom/movable/acting_object = get_object()
	log_admin("[key_name(L)] was successfully injected with " + reagents.get_reagents() + " by \the [acting_object]")
	L.visible_message("<span class='warning'>\The [acting_object] injects [L] with its needle!</span>", \
					"<span class='warning'>\The [acting_object] injects you with its needle!</span>")
	reagents.trans_to_mob(L, transfer_amount, CHEM_BLOOD)
	activate_pin(2)

/obj/item/integrated_circuit/reagent/injector/proc/draw_after(var/weakref/target, var/amount)
	busy = FALSE
	var/mob/living/carbon/C = target_nearby(target)
	if(!C)
		activate_pin(3)
		return
	var/atom/movable/acting_object = get_object()

	C.visible_message("<span class='warning'>\The [acting_object] draws blood from \the [C]</span>",
					"<span class='warning'>\The [acting_object] draws blood from you.</span>"
					)
	C.take_blood(src, amount)
	activate_pin(2)


/obj/item/integrated_circuit/reagent/injector/proc/inject()
	set waitfor = FALSE // Don't sleep in a proc that is called by a processor without this set, otherwise it'll delay the entire thing
	var/atom/movable/AM = get_pin_data_as_type(IC_INPUT, 1, /atom/movable)
	var/atom/movable/acting_object = get_object()

	if(busy || !check_target(AM))
		activate_pin(3)
		return

	if(!AM.reagents)
		activate_pin(3)
		return

	if(direction_mode == IC_REAGENTS_INJECT)
		if(!reagents.total_volume || !AM.reagents || !AM.reagents.get_free_space())
			activate_pin(3)
			return

		if(isliving(AM))
			var/mob/living/L = AM
			var/injection_status = L.can_inject(null, BP_CHEST)
			log_world("Injection status? [injection_status]")
			var/injection_delay = 3 SECONDS
			if(injection_status == INJECTION_PORT)
				injection_delay += INJECTION_PORT_DELAY
			if(!injection_status)
				activate_pin(3)
				return
			//Always log attemped injections for admins
			log_admin("[key_name(L)] is getting injected with " + reagents.get_reagents() + " by \the [acting_object]")
			L.visible_message("<span class='danger'>\The [acting_object] is trying to inject [L]!</span>", \
								"<span class='danger'>\The [acting_object] is trying to inject you!</span>")
			busy = TRUE
			addtimer(CALLBACK(src, .proc/inject_after, weakref(L)), injection_delay)
			return
		else
			if(!AM.is_open_container())
				activate_pin(3)
				return


			reagents.trans_to(AM, transfer_amount)

	else if(direction_mode == IC_REAGENTS_DRAW)
		if(reagents.total_volume >= reagents.maximum_volume)
			acting_object.visible_message("\The [acting_object] tries to draw from [AM], but the injector is full.")
			activate_pin(3)
			return

		var/tramount = abs(transfer_amount)

		if(istype(AM, /mob/living/carbon))
			var/mob/living/carbon/C = AM
			var/injection_status = C.can_inject(null, BP_CHEST)
			var/injection_delay = 3 SECONDS
			if(injection_status == INJECTION_PORT)
				injection_delay += INJECTION_PORT_DELAY
			if(istype(C, /mob/living/carbon/slime) || !C.dna || !injection_status)
				activate_pin(3)
				return
			C.visible_message("<span class='danger'>\The [acting_object] is trying to take a blood sample from [C]!</span>", \
								"<span class='danger'>\The [acting_object] is trying to take a blood sample from you!</span>")
			busy = TRUE
			addtimer(CALLBACK(src, .proc/draw_after, weakref(C), tramount), injection_delay)
			return

		else
			if(!AM.reagents.total_volume)
				acting_object.visible_message("<span class='notice'>\The [acting_object] tries to draw from [AM], but it is empty!</span>")
				activate_pin(3)
				return

			if(!AM.is_open_container())
				activate_pin(3)
				return
			tramount = min(tramount, AM.reagents.total_volume)
			AM.reagents.trans_to(src, tramount)
	activate_pin(2)



/obj/item/integrated_circuit/reagent/pump
	name = "reagent pump"
	desc = "Moves liquids safely inside a machine, or even nearby it."
	icon_state = "reagent_pump"
	extended_desc = "This is a pump which will move liquids from the source ref to the target ref. The third pin determines \
	how much liquid is moved per pulse, between 0 and 50. The pump can move reagents to any open container inside the machine, or \
	outside the machine if it is adjacent to the machine."

	complexity = 8
	inputs = list("source" = IC_PINTYPE_REF, "target" = IC_PINTYPE_REF, "injection amount" = IC_PINTYPE_NUMBER)
	inputs_default = list("3" = 5)
	outputs = list()
	activators = list("transfer reagents" = IC_PINTYPE_PULSE_IN, "on transfer" = IC_PINTYPE_PULSE_OUT)
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH
	var/transfer_amount = 10
	var/direction_mode = IC_REAGENTS_INJECT
	power_draw_per_use = 10

/obj/item/integrated_circuit/reagent/pump/on_data_written()
	var/new_amount = get_pin_data(IC_INPUT, 3)
	if(new_amount < 0)
		new_amount = -new_amount
		direction_mode = IC_REAGENTS_DRAW
	else
		direction_mode = IC_REAGENTS_INJECT
	if(isnum(new_amount))
		new_amount = clamp(new_amount, 0, 50)
		transfer_amount = new_amount

/obj/item/integrated_circuit/reagent/pump/do_work()
	var/atom/movable/source = get_pin_data_as_type(IC_INPUT, 1, /atom/movable)
	var/atom/movable/target = get_pin_data_as_type(IC_INPUT, 2, /atom/movable)

	// Check for invalid input.
	if(!check_target(source) || !check_target(target))
		return

	// If the pump is pumping backwards, swap target and source.
	if(!direction_mode)
		var/temp_source = source
		source = target
		target = temp_source

	if(!source.reagents)
		return

	if(!source.is_open_container())
		return

	source.reagents.trans_to(target, transfer_amount)
	activate_pin(2)

/obj/item/integrated_circuit/reagent/storage
	cooldown_per_use = 1
	name = "reagent storage"
	desc = "Stores liquid inside the device away from electrical components. It can store up to 60u."
	icon_state = "reagent_storage"
	extended_desc = "This is effectively an internal beaker."

	atom_flags = ATOM_FLAG_OPEN_CONTAINER
	volume = 60

	complexity = 4
	inputs = list()
	outputs = list(
		"volume used" = IC_PINTYPE_NUMBER,
		"self reference" = IC_PINTYPE_REF
		)
	activators = list("push ref" = IC_PINTYPE_PULSE_IN)
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH



/obj/item/integrated_circuit/reagent/storage/do_work()
	set_pin_data(IC_OUTPUT, 2, weakref(src))
	push_data()

/obj/item/integrated_circuit/reagent/storage/on_reagent_change(changetype)
	push_vol()

/obj/item/integrated_circuit/reagent/storage/big
	name = "big reagent storage"
	icon_state = "reagent_storage_big"
	desc = "Stores liquid inside the device away from electrical components. Can store up to 180u."

	volume = 180

	complexity = 16
	spawn_flags = IC_SPAWN_RESEARCH

/obj/item/integrated_circuit/reagent/storage/cryo
	name = "cryo reagent storage"
	desc = "Stores liquid inside the device away from electrical components. It can store up to 60u. This will also prevent reactions."
	icon_state = "reagent_storage_cryo"
	extended_desc = "This is effectively an internal cryo beaker."

	atom_flags = ATOM_FLAG_NO_TEMP_CHANGE | ATOM_FLAG_OPEN_CONTAINER | ATOM_FLAG_NO_REACT
	complexity = 8
	spawn_flags = IC_SPAWN_RESEARCH

/obj/item/integrated_circuit/reagent/storage/grinder
	name = "reagent grinder"
	desc = "This is a reagent grinder. It accepts a ref to something, and refines it into reagents. It cannot grind materials. It can store up to 100u."
	icon_state = "blender"
	extended_desc = ""
	inputs = list(
		"target" = IC_PINTYPE_REF,
		)
	outputs = list(
		"volume used" = IC_PINTYPE_NUMBER,
		"self reference" = IC_PINTYPE_REF
		)
	activators = list(
		"grind" = IC_PINTYPE_PULSE_IN,
		"on grind" = IC_PINTYPE_PULSE_OUT,
		"on fail" = IC_PINTYPE_PULSE_OUT,
		"push ref" = IC_PINTYPE_PULSE_IN
		)
	volume = 100
	power_draw_per_use = 150
	complexity = 16
	spawn_flags = IC_SPAWN_RESEARCH


/obj/item/integrated_circuit/reagent/storage/grinder/do_work(ord)
	switch(ord)
		if(1)
			grind()
		if(4)
			set_pin_data(IC_OUTPUT, 2, weakref(src))
			push_data()

/obj/item/integrated_circuit/reagent/storage/grinder/proc/grind()
	if(reagents.total_volume >= reagents.maximum_volume)
		activate_pin(3)
		return FALSE
	var/obj/item/I = get_pin_data_as_type(IC_INPUT, 1, /obj/item)

	if(isnull(I))
		return FALSE

	if(!I.reagents || !I.reagents.total_volume)
		activate_pin(3)
		return FALSE

	I.reagents.trans_to(src,I.reagents.total_volume)
	if(!I.reagents.total_volume)
		qdel(I)

	activate_pin(2)
	return FALSE



/obj/item/integrated_circuit/reagent/storage/scan
	name = "reagent scanner"
	desc = "Stores liquid inside the device away from electrical components. It can store up to 60u. On pulse this beaker will send list of contained reagents."
	icon_state = "reagent_scan"
	extended_desc = "Mostly useful for filtering reagents."

	complexity = 8
	outputs = list(
		"volume used" = IC_PINTYPE_NUMBER,
		"self reference" = IC_PINTYPE_REF,
		"list of reagents" = IC_PINTYPE_LIST
		)
	activators = list(
		"scan" = IC_PINTYPE_PULSE_IN,
		"push ref" = IC_PINTYPE_PULSE_IN
		)
	spawn_flags = IC_SPAWN_RESEARCH

/obj/item/integrated_circuit/reagent/storage/scan/do_work(ord)
	switch(ord)
		if(1)
			var/cont[0]
			for(var/datum/reagent/RE in reagents.reagent_list)
				cont += RE.name
			set_pin_data(IC_OUTPUT, 3, cont)
			push_data()
		if(2)
			set_pin_data(IC_OUTPUT, 2, weakref(src))
			push_data()

/obj/item/integrated_circuit/reagent/filter
	name = "reagent filter"
	desc = "Filters liquids by list of desired or unwanted reagents."
	icon_state = "reagent_filter"
	extended_desc = "This is a filter which will move liquids from the source to its target. \
	If the amount in the fourth pin is positive, it will move all reagents except those in the unwanted list. \
	If the amount in the fourth pin is negative, it will only move the reagents in the wanted list. \
	The third pin determines how many reagents are moved per pulse, between 0 and 50. Amount is given for each separate reagent."

	complexity = 8
	inputs = list(
		"source" = IC_PINTYPE_REF,
		"target" = IC_PINTYPE_REF,
		"injection amount" = IC_PINTYPE_NUMBER,
		"list of reagents" = IC_PINTYPE_LIST
		)
	inputs_default = list(
		"3" = 5
		)
	outputs = list()
	activators = list(
		"transfer reagents" = IC_PINTYPE_PULSE_IN,
		"on transfer" = IC_PINTYPE_PULSE_OUT
		)
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH
	var/transfer_amount = 10
	var/direction_mode = IC_REAGENTS_INJECT
	power_draw_per_use = 10

/obj/item/integrated_circuit/reagent/filter/on_data_written()
	var/new_amount = get_pin_data(IC_INPUT, 3)
	if(new_amount < 0)
		new_amount = -new_amount
		direction_mode = IC_REAGENTS_DRAW
	else
		direction_mode = IC_REAGENTS_INJECT
	if(isnum(new_amount))
		new_amount = clamp(new_amount, 0, 50)
		transfer_amount = new_amount

/obj/item/integrated_circuit/reagent/filter/do_work()
	var/atom/movable/source = get_pin_data_as_type(IC_INPUT, 1, /atom/movable)
	var/atom/movable/target = get_pin_data_as_type(IC_INPUT, 2, /atom/movable)
	var/list/demand = get_pin_data(IC_INPUT, 4)

	// Check for invalid input.
	if(!check_target(source) || !check_target(target))
		return

	if(!source.reagents || !target.reagents)
		return

	if(!source.is_open_container() || istype(source, /mob))
		return

	if(target.reagents.maximum_volume - target.reagents.total_volume <= 0)
		return

	for(var/datum/reagent/G in source.reagents.reagent_list)
		if(!direction_mode)
			if(G.name in demand)
				source.reagents.trans_type_to(target, G.type, transfer_amount)
		else
			if(!(G.name in demand))
				source.reagents.trans_type_to(target, G.type, transfer_amount)
	activate_pin(2)
	push_data()

// This is an input circuit because attackby_react is only called for input circuits
/obj/item/integrated_circuit/input/funnel
	category_text = "Reagent"
	name = "reagent funnel"
	desc = "A funnel with a small pump that lets you refill an internal reagent storage."
	icon_state = "reagent_funnel"

	inputs = list(
		"target" = IC_PINTYPE_REF
	)
	activators = list(
		"on transfer" = IC_PINTYPE_PULSE_OUT
	)

	unacidable = TRUE
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH
	complexity = 4
	power_draw_per_use = 5

/obj/item/integrated_circuit/input/funnel/attackby_react(obj/item/I, mob/living/user, intent)
	var/atom/movable/target = get_pin_data_as_type(IC_INPUT, 1, /atom/movable)
	var/obj/item/reagent_containers/container = I

	if(!check_target(target))
		return FALSE

	if(!istype(container))
		return FALSE

	// Messages are provided by standard_pour_into
	if(container.standard_pour_into(user, target))
		activate_pin(1)
		return TRUE

	return FALSE

// Most of this is just chemical heater code refitted for ICs
/obj/item/integrated_circuit/reagent/temp
	inputs = list(
		"target temperature" = IC_PINTYPE_NUMBER
	)
	outputs = list(
		"volume used" = IC_PINTYPE_NUMBER,
		"temperature" = IC_PINTYPE_NUMBER,
		"enabled" = IC_PINTYPE_BOOLEAN,
		"self reference" = IC_PINTYPE_REF
	)
	activators = list(
		"toggle" = IC_PINTYPE_PULSE_IN,
		"on toggle" = IC_PINTYPE_PULSE_OUT,
		"push ref" = IC_PINTYPE_PULSE_IN
	)

	atom_flags = ATOM_FLAG_OPEN_CONTAINER
	complexity = 12
	cooldown_per_use = 1
	power_draw_per_use = 50
	volume = 30

	var/active = 0
	var/min_temp = 40 CELSIUS
	var/max_temp = 200 CELSIUS
	var/heating_power = 5
	var/target_temp = T20C
	var/last_temperature = 0
	var/mode = IC_HEATER_MODE_HEAT

/obj/item/integrated_circuit/reagent/temp/Initialize()
	. = ..()

	set_pin_data(IC_OUTPUT, 2, temperature - T0C)
	push_data()

/obj/item/integrated_circuit/reagent/temp/do_work(ord)
	switch(ord)
		if(1)
			target_temp = get_pin_data(IC_INPUT, 1)
			if(isnull(target_temp))
				return

			// +/- T0C to convert to/from kelvin
			target_temp = clamp(target_temp + T0C, min_temp, max_temp)
			set_pin_data(IC_INPUT, 1, target_temp - T0C)

			active = !active
			set_pin_data(IC_OUTPUT, 3, active)
			push_data()
			activate_pin(2)

			// begin processing temperature
			if(active)
				QUEUE_TEMPERATURE_ATOMS(src)
		if(3)
			set_pin_data(IC_OUTPUT, 4, weakref(src))
			push_data()

/obj/item/integrated_circuit/reagent/temp/on_reagent_change()
	push_vol()

/obj/item/integrated_circuit/reagent/temp/power_fail()
	active = 0

/obj/item/integrated_circuit/reagent/temp/ProcessAtomTemperature()
	if(!active)
		return PROCESS_KILL

	last_temperature = temperature

	if(mode == IC_HEATER_MODE_HEAT && temperature < target_temp)
		temperature = min(temperature + heating_power, max_temp)
	else if(mode == IC_HEATER_MODE_COOL && temperature > target_temp)
		temperature = max(temperature - heating_power, min_temp)

	if(temperature != last_temperature)
		// Lost power
		if(!check_power())
			power_fail()
			return ..()

		set_pin_data(IC_OUTPUT, 2, temperature - T0C)
		push_data()

	return TRUE

/obj/item/integrated_circuit/reagent/temp/heater
	name = "reagent heater"
	desc = "A small reagent container capable of heating reagents. It can hold up to 30u."
	icon_state = "reagent_heater"
	extended_desc = "This is effectively an internal beaker. It has a heating coil wrapped around it, which allows it to heat the contents of the beaker. Temperature is given in celsius."

	spawn_flags = IC_SPAWN_RESEARCH

/obj/item/integrated_circuit/reagent/temp/cooler
	name = "reagent cooler"
	desc = "A small reagent container capable of cooling reagents. It can hold up to 30u."
	icon_state = "reagent_cooler"
	extended_desc = "This is effectively an internal beaker. It has a cooling mechanism wrapped around it, which allows it to cool the contents of the beaker. Temperature is given in celsius."

	spawn_flags = IC_SPAWN_RESEARCH

	min_temp = -80 CELSIUS
	max_temp = 30 CELSIUS
	mode = IC_HEATER_MODE_COOL

#undef IC_HEATER_MODE_HEAT
#undef IC_HEATER_MODE_COOL
#undef IC_REAGENTS_DRAW
#undef IC_REAGENTS_INJECT