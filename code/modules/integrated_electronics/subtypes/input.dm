/obj/item/integrated_circuit/input
	category_text = "Input"
	power_draw_per_use = 5

/obj/item/integrated_circuit/input/external_examine(mob/user)
	var/initial_name = initial(name)
	var/message
	if(initial_name == name)
		message = "There is \a [src]."
	else
		message = "There is \a ["\improper[initial_name]"] labeled '[name]'."
	to_chat(user, message)


/obj/item/integrated_circuit/input/button
	name = "button"
	desc = "This tiny button must do something, right?"
	icon_state = "button"
	complexity = 1
	inputs = list()
	outputs = list()
	activators = list("on pressed" = IC_PINTYPE_PULSE_OUT)
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH

/obj/item/integrated_circuit/input/button/get_topic_data(mob/user)
	return list("Press" = "press=1")

/obj/item/integrated_circuit/input/button/OnICTopic(href_list, user)
	if(href_list["press"])
		to_chat(user, "<span class='notice'>You press the button labeled '[src.displayed_name]'.</span>")
		activate_pin(1)
		return IC_TOPIC_REFRESH

/obj/item/integrated_circuit/input/toggle_button
	name = "toggle button"
	desc = "It toggles on, off, on, off..."
	icon_state = "toggle_button"
	complexity = 1
	inputs = list()
	outputs = list("on" = IC_PINTYPE_BOOLEAN)
	activators = list("on toggle" = IC_PINTYPE_PULSE_OUT)
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH

/obj/item/integrated_circuit/input/toggle_button/emp_act()
	return // This is a mainly physical thing, not affected by electricity

/obj/item/integrated_circuit/input/toggle_button/get_topic_data(mob/user)
	return list("Toggle [get_pin_data(IC_OUTPUT, 1) ? "Off" : "On"]" = "toggle=1")

/obj/item/integrated_circuit/input/toggle_button/OnICTopic(href_list, user)
	if(href_list["toggle"])
		set_pin_data(IC_OUTPUT, 1, !get_pin_data(IC_OUTPUT, 1))
		push_data()
		activate_pin(1)
		to_chat(user, "<span class='notice'>You toggle the button labeled '[src.name]' [get_pin_data(IC_OUTPUT, 1) ? "on" : "off"].</span>")
		return IC_TOPIC_REFRESH

/obj/item/integrated_circuit/input/numberpad
	name = "number pad"
	desc = "This small number pad allows someone to input a number into the system."
	icon_state = "numberpad"
	complexity = 2
	inputs = list()
	outputs = list("number entered" = IC_PINTYPE_NUMBER)
	activators = list("on entered" = IC_PINTYPE_PULSE_OUT)
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH
	power_draw_per_use = 4

/obj/item/integrated_circuit/input/numberpad/get_topic_data(mob/user)
	return list("Enter Number" = "enter_number=1")

/obj/item/integrated_circuit/input/numberpad/OnICTopic(href_list, user)
	if(href_list["enter_number"])
		var/new_input = input(user, "Enter a number, please.","Number pad") as null|num
		if(isnum(new_input) && CanInteract(user, GLOB.physical_state))
			set_pin_data(IC_OUTPUT, 1, new_input)
			push_data()
			activate_pin(1)
		return IC_TOPIC_REFRESH

/obj/item/integrated_circuit/input/textpad
	name = "text pad"
	desc = "This small text pad allows someone to input a string into the system."
	icon_state = "textpad"
	complexity = 2
	inputs = list()
	outputs = list("string entered" = IC_PINTYPE_STRING)
	activators = list("on entered" = IC_PINTYPE_PULSE_OUT)
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH
	power_draw_per_use = 4

/obj/item/integrated_circuit/input/textpad/get_topic_data(mob/user)
	return list("Enter Words" = "enter_words=1")

/obj/item/integrated_circuit/input/textpad/OnICTopic(href_list, user)
	if(href_list["enter_words"])
		var/new_input = input(user, "Enter some words, please.","Number pad") as null|text
		if(istext(new_input) && CanInteract(user, GLOB.physical_state))
			set_pin_data(IC_OUTPUT, 1, new_input)
			push_data()
			activate_pin(1)
			return IC_TOPIC_REFRESH

/obj/item/integrated_circuit/input/colorpad
	name = "color pad"
	desc = "This small color pad allows someone to input a hexadecimal color into the system."
	icon_state = "colorpad"
	complexity = 2
	inputs = list()
	outputs = list("color entered" = IC_PINTYPE_STRING)
	activators = list("on entered" = IC_PINTYPE_PULSE_OUT)
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH
	power_draw_per_use = 4

/obj/item/integrated_circuit/input/colorpad/get_topic_data(mob/user)
	return list("Enter Color" = "enter_color=1")

/obj/item/integrated_circuit/input/colorpad/OnICTopic(href_list, user)
	if(href_list["enter_color"])
		var/new_color = input(user, "Enter a color, please.", "Color", "#ffffff") as color|null
		if(new_color)
			set_pin_data(IC_OUTPUT, 1, new_color)
			push_data()
			activate_pin(1)
			return IC_TOPIC_REFRESH

/obj/item/integrated_circuit/input/med_scanner
	name = "integrated medical analyser"
	desc = "A very small version of the common medical analyser. This allows the machine to track some vital signs."
	icon_state = "medscan"
	complexity = 4
	inputs = list("target" = IC_PINTYPE_REF)
	outputs = list(
		"brain activity" = IC_PINTYPE_BOOLEAN,
		"pulse" = IC_PINTYPE_NUMBER,
		"is conscious" = IC_PINTYPE_BOOLEAN
		)
	activators = list("scan" = IC_PINTYPE_PULSE_IN, "on scanned" = IC_PINTYPE_PULSE_OUT)
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH
	power_draw_per_use = 40

/obj/item/integrated_circuit/input/med_scanner/do_work()
	var/mob/living/carbon/human/H = get_pin_data_as_type(IC_INPUT, 1, /mob/living)
	if(!istype(H)) //Invalid input
		return
	if(H.Adjacent(get_turf(src))) // Like normal analysers, it can't be used at range.
		var/obj/item/organ/internal/brain/brain = H.internal_organs_by_name[BP_BRAIN]
		set_pin_data(IC_OUTPUT, 1, (brain && H.stat != DEAD))
		set_pin_data(IC_OUTPUT, 2, H.get_pulse_as_number())
		set_pin_data(IC_OUTPUT, 3, (H.stat == 0))

	push_data()
	activate_pin(2)

/obj/item/integrated_circuit/input/adv_med_scanner
	name = "integrated adv. medical analyser"
	desc = "A very small version of the medbot's medical analyser. This allows the machine to know how healthy someone is. \
	This type is much more precise, allowing the machine to know much more about the target than a normal analyzer."
	extended_desc = "Values for damage and pain are 0 to 5 marking severity of the damage"
	icon_state = "medscan_adv"
	complexity = 12
	inputs = list("target" = IC_PINTYPE_REF)
	outputs = list(
		"brain activity"		= IC_PINTYPE_BOOLEAN,
		"is conscious"	        = IC_PINTYPE_BOOLEAN,
		"brute damage"			= IC_PINTYPE_NUMBER,
		"burn damage"			= IC_PINTYPE_NUMBER,
		"tox damage"			= IC_PINTYPE_NUMBER,
		"oxy damage"			= IC_PINTYPE_NUMBER,
		"clone damage"			= IC_PINTYPE_NUMBER,
		"pulse"                 = IC_PINTYPE_NUMBER,
		"oxygenation level"     = IC_PINTYPE_NUMBER,
		"pain level"            = IC_PINTYPE_NUMBER,
		"radiation"             = IC_PINTYPE_NUMBER
	)
	activators = list("scan" = IC_PINTYPE_PULSE_IN, "on scanned" = IC_PINTYPE_PULSE_OUT)
	spawn_flags = IC_SPAWN_RESEARCH
	power_draw_per_use = 80

/obj/item/integrated_circuit/input/adv_med_scanner/proc/damage_to_severity(var/value)
	if(value < 1)
		return 0
	if(value < 25)
		return 1
	if(value < 50)
		return 2
	if(value < 75)
		return 3
	if(value < 100)
		return 4
	return 5


/obj/item/integrated_circuit/input/adv_med_scanner/do_work()
	var/mob/living/carbon/human/H = get_pin_data_as_type(IC_INPUT, 1, /mob/living)
	if(!istype(H)) //Invalid input
		return
	if(H in view(get_turf(src))) // Like medbot's analyzer it can be used in range..


		var/obj/item/organ/internal/brain/brain = H.internal_organs_by_name[BP_BRAIN]
		set_pin_data(IC_OUTPUT, 1, (brain && H.stat != DEAD))
		set_pin_data(IC_OUTPUT, 2, (H.stat == 0))
		set_pin_data(IC_OUTPUT, 3, damage_to_severity(100 * H.getBruteLoss() / H.maxHealth))
		set_pin_data(IC_OUTPUT, 4, damage_to_severity(100 * H.getFireLoss() / H.maxHealth))
		set_pin_data(IC_OUTPUT, 5, damage_to_severity(100 * H.getToxLoss() / H.maxHealth))
		set_pin_data(IC_OUTPUT, 6, damage_to_severity(100 * H.getOxyLoss() / H.maxHealth))
		set_pin_data(IC_OUTPUT, 7, damage_to_severity(100 * H.getCloneLoss() / H.maxHealth))
		set_pin_data(IC_OUTPUT, 8, H.get_pulse_as_number())
		set_pin_data(IC_OUTPUT, 9, H.get_blood_oxygenation())
		set_pin_data(IC_OUTPUT, 10, damage_to_severity(H.get_shock()))
		set_pin_data(IC_OUTPUT, 11, H.radiation)

	push_data()
	activate_pin(2)

//please delete at a later date after people stop using the old named circuit
/obj/item/integrated_circuit/input/adv_med_scanner/old
	name = "integrated advanced medical analyser"
	spawn_flags = 0

/obj/item/integrated_circuit/input/slime_scanner
	name = "slime_scanner"
	desc = "A very small version of the xenobio analyser. This allows the machine to know every needed properties of slime. Output mutation list is non-associative."
	icon_state = "medscan_adv"
	complexity = 12
	inputs = list("target" = IC_PINTYPE_REF)
	outputs = list(
		"colour"				= IC_PINTYPE_STRING,
		"adult"					= IC_PINTYPE_BOOLEAN,
		"nutrition"				= IC_PINTYPE_NUMBER,
		"charge"				= IC_PINTYPE_NUMBER,
		"health"				= IC_PINTYPE_NUMBER,
		"possible mutation"		= IC_PINTYPE_LIST,
		"genetic destability"	= IC_PINTYPE_NUMBER,
		"slime core amount"		= IC_PINTYPE_NUMBER,
		"Growth progress"		= IC_PINTYPE_NUMBER,
	)
	activators = list("scan" = IC_PINTYPE_PULSE_IN, "on scanned" = IC_PINTYPE_PULSE_OUT)
	spawn_flags = IC_SPAWN_RESEARCH
	power_draw_per_use = 80

/obj/item/integrated_circuit/input/slime_scanner/do_work()
	var/mob/living/carbon/slime/T = get_pin_data_as_type(IC_INPUT, 1, /mob/living/carbon/slime)
	if(!isslime(T)) //Invalid input
		return
	if(T in view(get_turf(src))) // Like medbot's analyzer it can be used in range..

		set_pin_data(IC_OUTPUT, 1, T.colour)
		set_pin_data(IC_OUTPUT, 2, T.is_adult)
		set_pin_data(IC_OUTPUT, 3, T.nutrition/T.get_max_nutrition())
		set_pin_data(IC_OUTPUT, 4, T.powerlevel)
		set_pin_data(IC_OUTPUT, 5, round(T.health/T.maxHealth,0.01)*100)
		set_pin_data(IC_OUTPUT, 6, T.GetMutations())
		set_pin_data(IC_OUTPUT, 7, T.mutation_chance)
		set_pin_data(IC_OUTPUT, 8, T.cores)
		set_pin_data(IC_OUTPUT, 9, T.amount_grown/SLIME_EVOLUTION_THRESHOLD)


	push_data()
	activate_pin(2)



/obj/item/integrated_circuit/input/plant_scanner
	name = "integrated plant analyzer"
	desc = "A very small version of the plant analyser. This allows the machine to know all valuable parameters of plants in trays. \
			It can only scan plants, not seeds or fruits."
	icon_state = "medscan_adv"
	complexity = 12
	inputs = list("target" = IC_PINTYPE_REF)
	outputs = list(
		"plant type"		= IC_PINTYPE_STRING,
		"age"		= IC_PINTYPE_NUMBER,
		"potency"	= IC_PINTYPE_NUMBER,
		"yield"			= IC_PINTYPE_NUMBER,
		"Maturation speed"			= IC_PINTYPE_NUMBER,
		"Production speed"			= IC_PINTYPE_NUMBER,
		"Endurance"			= IC_PINTYPE_NUMBER,
		"Lifespan"			= IC_PINTYPE_NUMBER,
		"Weed Resistance"	= IC_PINTYPE_NUMBER,
		"Weed level"			= IC_PINTYPE_NUMBER,
		"Pest level"			= IC_PINTYPE_NUMBER,
		"Water level"			= IC_PINTYPE_NUMBER,
		"Nutrition level"			= IC_PINTYPE_NUMBER,
		"harvest"			= IC_PINTYPE_NUMBER,
		"dead"			= IC_PINTYPE_NUMBER,
		"plant health"			= IC_PINTYPE_NUMBER,
	)
	activators = list("scan" = IC_PINTYPE_PULSE_IN, "on scanned" = IC_PINTYPE_PULSE_OUT)
	spawn_flags = IC_SPAWN_RESEARCH
	power_draw_per_use = 10

/obj/item/integrated_circuit/input/plant_scanner/do_work()
	var/obj/machinery/portable_atmospherics/hydroponics/H = get_pin_data_as_type(IC_INPUT, 1, /obj/machinery/portable_atmospherics/hydroponics)
	if(!istype(H)) //Invalid input
		return
	for(var/i=1, i<=outputs.len, i++)
		set_pin_data(IC_OUTPUT, i, null)
	if(H in view(get_turf(src))) // Like medbot's analyzer it can be used in range..
		if(H.seed)
			set_pin_data(IC_OUTPUT, 1, H.seed.seed_name)
			set_pin_data(IC_OUTPUT, 2, H.age)
			set_pin_data(IC_OUTPUT, 3, H.seed.get_trait(TRAIT_POTENCY))
			set_pin_data(IC_OUTPUT, 4, H.seed.get_trait(TRAIT_YIELD))
			set_pin_data(IC_OUTPUT, 5, H.seed.get_trait(TRAIT_MATURATION))
			set_pin_data(IC_OUTPUT, 6, H.seed.get_trait(TRAIT_PRODUCTION))
			set_pin_data(IC_OUTPUT, 7, H.seed.get_trait(TRAIT_ENDURANCE))
			set_pin_data(IC_OUTPUT, 8, !!H.seed.get_trait(TRAIT_HARVEST_REPEAT))
			set_pin_data(IC_OUTPUT, 9, H.seed.get_trait(TRAIT_WEED_TOLERANCE))
		set_pin_data(IC_OUTPUT, 10, H.weedlevel)
		set_pin_data(IC_OUTPUT, 11, H.pestlevel)
		set_pin_data(IC_OUTPUT, 12, H.waterlevel)
		set_pin_data(IC_OUTPUT, 13, H.nutrilevel)
		set_pin_data(IC_OUTPUT, 14, H.harvest)
		set_pin_data(IC_OUTPUT, 15, H.dead)
		set_pin_data(IC_OUTPUT, 16, H.health)
	push_data()
	activate_pin(2)

/obj/item/integrated_circuit/input/gene_scanner
	name = "gene scanner"
	desc = "This circuit will scan the target plant for traits and reagent genes. Output is non-associative."
	extended_desc = "This allows the machine to scan plants in trays for reagent and trait genes. \
			It can only scan plants, not seeds or fruits."
	inputs = list(
		"target" = IC_PINTYPE_REF
	)
	outputs = list(
		"reagents" = IC_PINTYPE_LIST
	)
	activators = list("scan" = IC_PINTYPE_PULSE_IN, "on scanned" = IC_PINTYPE_PULSE_OUT)
	icon_state = "medscan_adv"
	spawn_flags = IC_SPAWN_RESEARCH

/obj/item/integrated_circuit/input/gene_scanner/do_work()
	var/list/greagents = list()
	var/obj/machinery/portable_atmospherics/hydroponics/H = get_pin_data_as_type(IC_INPUT, 1, /obj/machinery/portable_atmospherics/hydroponics)
	if(!istype(H)) //Invalid input
		return
	for(var/i=1, i<=outputs.len, i++)
		set_pin_data(IC_OUTPUT, i, null)
	if(H in view(get_turf(src))) // Like medbot's analyzer it can be used in range..
		if(H.seed)
			for(var/chem_path in H.seed.chems)
				var/datum/reagent/R = chem_path
				greagents.Add(initial(R.name))

	set_pin_data(IC_OUTPUT, 1, greagents)
	push_data()
	activate_pin(2)


/obj/item/integrated_circuit/input/examiner
	name = "examiner"
	desc = "It's a little machine vision system. It can return the name, description, distance, \
	relative coordinates, total amount of reagents, maximum amount of reagents, density, and opacity of the referenced object."
	icon_state = "video_camera"
	complexity = 6
	inputs = list(
		"target" = IC_PINTYPE_REF
		)
	outputs = list(
		"name"				 	= IC_PINTYPE_STRING,
		"description"			= IC_PINTYPE_STRING,
		"X"						= IC_PINTYPE_NUMBER,
		"Y"						= IC_PINTYPE_NUMBER,
		"distance"				= IC_PINTYPE_NUMBER,
		"max reagents"			= IC_PINTYPE_NUMBER,
		"amount of reagents"	= IC_PINTYPE_NUMBER,
		"density"				= IC_PINTYPE_BOOLEAN,
		"opacity"				= IC_PINTYPE_BOOLEAN,
		"occupied turf"			= IC_PINTYPE_REF
		)
	activators = list(
		"scan" = IC_PINTYPE_PULSE_IN,
		"on scanned" = IC_PINTYPE_PULSE_OUT,
		"not scanned" = IC_PINTYPE_PULSE_OUT
		)
	spawn_flags = IC_SPAWN_RESEARCH
	power_draw_per_use = 80

/obj/item/integrated_circuit/input/examiner/do_work()
	var/atom/H = get_pin_data_as_type(IC_INPUT, 1, /atom)
	var/turf/T = get_turf(src)

	if(!istype(H) || !(H in view(T)))
		activate_pin(3)
	else
		set_pin_data(IC_OUTPUT, 1, H.name)
		set_pin_data(IC_OUTPUT, 2, H.desc)
		set_pin_data(IC_OUTPUT, 3, H.x-T.x)
		set_pin_data(IC_OUTPUT, 4, H.y-T.y)
		set_pin_data(IC_OUTPUT, 5, sqrt((H.x-T.x)*(H.x-T.x)+ (H.y-T.y)*(H.y-T.y)))
		var/mr = 0
		var/tr = 0
		if(H.reagents)
			mr = H.reagents.maximum_volume
			tr = H.reagents.total_volume
		set_pin_data(IC_OUTPUT, 6, mr)
		set_pin_data(IC_OUTPUT, 7, tr)
		set_pin_data(IC_OUTPUT, 8, H.density)
		set_pin_data(IC_OUTPUT, 9, H.opacity)
		set_pin_data(IC_OUTPUT, 10, get_turf(H))
		push_data()
		activate_pin(2)

/obj/item/integrated_circuit/input/turfpoint
	name = "Tile pointer"
	desc = "This circuit will get a tile ref with the provided absolute coordinates."
	extended_desc = "If the machine	cannot see the target, it will not be able to calculate the correct direction.\
	This circuit only works while inside an assembly."
	icon_state = "numberpad"
	complexity = 5
	inputs = list("X" = IC_PINTYPE_NUMBER,"Y" = IC_PINTYPE_NUMBER)
	outputs = list("tile" = IC_PINTYPE_REF)
	activators = list("calculate dir" = IC_PINTYPE_PULSE_IN, "on calculated" = IC_PINTYPE_PULSE_OUT,"not calculated" = IC_PINTYPE_PULSE_OUT)
	spawn_flags = IC_SPAWN_RESEARCH
	power_draw_per_use = 40

/obj/item/integrated_circuit/input/turfpoint/do_work()
	if(!assembly)
		activate_pin(3)
		return
	var/turf/T = get_turf(assembly)
	var/target_x = clamp(get_pin_data(IC_INPUT, 1), 0, world.maxx)
	var/target_y = clamp(get_pin_data(IC_INPUT, 2), 0, world.maxy)
	var/turf/A = locate(target_x, target_y, T.z)
	set_pin_data(IC_OUTPUT, 1, null)
	if(!A || !(A in view(T)))
		activate_pin(3)
		return
	else
		set_pin_data(IC_OUTPUT, 1, weakref(A))
	push_data()
	activate_pin(2)

/obj/item/integrated_circuit/input/turfscan
	name = "tile analyzer"
	desc = "This circuit can analyze the contents of the scanned turf, and can read letters on the turf."
	icon_state = "video_camera"
	complexity = 5
	inputs = list(
		"target" = IC_PINTYPE_REF
		)
	outputs = list(
		"located ref" 		= IC_PINTYPE_LIST,
		"Written letters" 	= IC_PINTYPE_STRING,
		"area"				= IC_PINTYPE_STRING
		)
	activators = list(
		"scan" = IC_PINTYPE_PULSE_IN,
		"on scanned" = IC_PINTYPE_PULSE_OUT,
		"not scanned" = IC_PINTYPE_PULSE_OUT
		)
	spawn_flags = IC_SPAWN_RESEARCH
	power_draw_per_use = 40
	cooldown_per_use = 10

/obj/item/integrated_circuit/input/turfscan/do_work()
	var/turf/scanned_turf = get_pin_data_as_type(IC_INPUT, 1, /turf)
	var/turf/circuit_turf = get_turf(src)
	var/area_name = get_area_name(scanned_turf)
	if(!istype(scanned_turf)) //Invalid input
		activate_pin(3)
		return

	if(scanned_turf in view(circuit_turf)) // This is a camera. It can't examine things that it can't see.
		var/list/turf_contents = new()
		for(var/obj/U in scanned_turf)
			turf_contents += weakref(U)
		for(var/mob/U in scanned_turf)
			turf_contents += weakref(U)
		set_pin_data(IC_OUTPUT, 1, turf_contents)
		set_pin_data(IC_OUTPUT, 3, area_name)
		var/list/St = new()
		for(var/obj/effect/decal/cleanable/crayon/I in scanned_turf)
			St.Add(I.icon_state)
		if(St.len)
			set_pin_data(IC_OUTPUT, 2, jointext(St, ",", 1, 0))
		push_data()
		activate_pin(2)
	else
		activate_pin(3)

/obj/item/integrated_circuit/input/local_locator
	name = "local locator"
	desc = "This is needed for certain devices that demand a reference for a target to act upon. This type only locates something \
	that is holding the machine containing it."
	inputs = list()
	outputs = list("located ref"		= IC_PINTYPE_REF,
					"is ground"			= IC_PINTYPE_BOOLEAN,
					"is creature"		= IC_PINTYPE_BOOLEAN)
	activators = list("locate" = IC_PINTYPE_PULSE_IN,
		"on scanned" = IC_PINTYPE_PULSE_OUT
		)
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH
	power_draw_per_use = 20

/obj/item/integrated_circuit/input/local_locator/do_work()
	var/datum/integrated_io/O = outputs[1]
	O.data = null
	if(assembly)
		O.data = weakref(assembly.loc)
	set_pin_data(IC_OUTPUT, 2, isturf(assembly.loc))
	set_pin_data(IC_OUTPUT, 3, ismob(assembly.loc))
	push_data()
	activate_pin(2)

/obj/item/integrated_circuit/input/adjacent_locator
	name = "adjacent locator"
	desc = "This is needed for certain devices that demand a reference for a target to act upon. This type only locates something \
	that is standing up to a meter away from the machine."
	extended_desc = "The first pin requires a ref to the kind of object that you want the locator to acquire. This means that it will \
	give refs to nearby objects that are similar. If more than one valid object is found nearby, it will choose one of them at \
	random."
	inputs = list("desired type ref" = IC_PINTYPE_REF)
	outputs = list("located ref" = IC_PINTYPE_REF)
	activators = list("locate" = IC_PINTYPE_PULSE_IN,"found" = IC_PINTYPE_PULSE_OUT,
		"not found" = IC_PINTYPE_PULSE_OUT)
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH
	power_draw_per_use = 30

/obj/item/integrated_circuit/input/adjacent_locator/do_work()
	var/datum/integrated_io/I = inputs[1]
	var/datum/integrated_io/O = outputs[1]
	O.data = null

	if(!isweakref(I.data))
		return
	var/atom/A = I.data.resolve()
	if(!A)
		return
	var/desired_type = A.type

	var/list/nearby_things = range(1, get_turf(src))
	var/list/valid_things = list()
	for(var/atom/thing in nearby_things)
		if(thing.type != desired_type)
			continue
		valid_things.Add(thing)
	if(valid_things.len)
		O.data = weakref(pick(valid_things))
		activate_pin(2)
	else
		activate_pin(3)
	O.push_data()

/obj/item/integrated_circuit/input/advanced_locator_list
	complexity = 6
	name = "list advanced locator"
	desc = "This is needed for certain devices that demand list of names for a target to act upon. This type locates something \
	that is standing in given radius of up to 8 meters. Output is non-associative. Input will only consider keys if associative."
	extended_desc = "The first pin requires a list of the kinds of objects that you want the locator to acquire. It will locate nearby objects by name and description, \
	and will then provide a list of all found objects which are similar. \
	The second pin is a radius."
	inputs = list("desired type ref" = IC_PINTYPE_LIST, "radius" = IC_PINTYPE_NUMBER)
	outputs = list("located ref" = IC_PINTYPE_LIST)
	activators = list("locate" = IC_PINTYPE_PULSE_IN,"found" = IC_PINTYPE_PULSE_OUT,"not found" = IC_PINTYPE_PULSE_OUT)
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH
	power_draw_per_use = 30
	var/radius = 1
	cooldown_per_use = 10

/obj/item/integrated_circuit/input/advanced_locator_list/on_data_written()
	var/rad = get_pin_data(IC_INPUT, 2)

	if(isnum(rad))
		rad = clamp(rad, 0, 8)
		radius = rad

/obj/item/integrated_circuit/input/advanced_locator_list/do_work()
	var/datum/integrated_io/I = inputs[1]
	var/datum/integrated_io/O = outputs[1]
	O.data = null
	var/list/input_list = list()
	input_list = I.data
	if(length(input_list))	//if there is no input don't do anything.
		var/turf/T = get_turf(src)
		var/list/nearby_things = view(radius,T)
		var/list/valid_things = list()
		for(var/item in input_list)
			if(!isnull(item) && !isnum(item))
				if(istext(item))
					for(var/i in nearby_things)
						var/atom/thing = i
						if(ismob(thing) && !isliving(thing))
							continue
						if(findtext(addtext(thing.name," ",thing.desc), item, 1, 0) )
							valid_things.Add(weakref(thing))
				else
					var/atom/A = item
					var/desired_type = A.type
					for(var/i in nearby_things)
						var/atom/thing = i
						if(thing.type != desired_type)
							continue
						if(ismob(thing) && !isliving(thing))
							continue
						valid_things.Add(weakref(thing))
		if(valid_things.len)
			O.data = valid_things
			O.push_data()
			activate_pin(2)
		else
			O.push_data()
			activate_pin(3)
	else
		O.push_data()
		activate_pin(3)

/obj/item/integrated_circuit/input/advanced_locator
	complexity = 6
	name = "advanced locator"
	desc = "This is needed for certain devices that demand a reference for a target to act upon. This type locates something \
	that is standing in given radius of up to 8 meters"
	extended_desc = "The first pin requires a ref to the kind of object that you want the locator to acquire. This means that it will \
	give refs to nearby objects which are similar. If this pin is a string, the locator will search for an \
	item matching the desired text in its name and description. If more than one valid object is found nearby, it will choose one of them at \
	random. The second pin is a radius."
	inputs = list("desired type" = IC_PINTYPE_ANY, "radius" = IC_PINTYPE_NUMBER)
	outputs = list("located ref" = IC_PINTYPE_REF)
	activators = list("locate" = IC_PINTYPE_PULSE_IN,"found" = IC_PINTYPE_PULSE_OUT,"not found" = IC_PINTYPE_PULSE_OUT)
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH
	power_draw_per_use = 30
	var/radius = 1

/obj/item/integrated_circuit/input/advanced_locator/on_data_written()
	var/rad = get_pin_data(IC_INPUT, 2)
	if(isnum(rad))
		rad = clamp(rad, 0, 8)
		radius = rad

/obj/item/integrated_circuit/input/advanced_locator/do_work()
	var/datum/integrated_io/I = inputs[1]
	var/datum/integrated_io/O = outputs[1]
	O.data = null
	var/turf/T = get_turf(src)
	var/list/nearby_things =  view(radius,T)
	var/list/valid_things = list()
	if(isweakref(I.data))
		var/atom/A = I.data.resolve()
		var/desired_type = A.type
		if(desired_type)
			for(var/i in nearby_things)
				var/atom/thing = i
				if(ismob(thing) && !isliving(thing))
					continue
				if(thing.type == desired_type)
					valid_things.Add(thing)
	else if(istext(I.data))
		var/DT = I.data
		for(var/i in nearby_things)
			var/atom/thing = i
			if(ismob(thing) && !isliving(thing))
				continue
			if(findtext(addtext(thing.name," ",thing.desc), DT, 1, 0) )
				valid_things.Add(thing)
	if(valid_things.len)
		O.data = weakref(pick(valid_things))
		O.push_data()
		activate_pin(2)
	else
		O.push_data()
		activate_pin(3)

/obj/item/integrated_circuit/input/signaler
	name = "integrated signaler"
	desc = "Signals from a signaler can be received with this, allowing for remote control. It can also send signals."
	extended_desc = "When a signal is received from another signaler, the 'on signal received' activator pin will be pulsed. \
	The two input pins are to configure the integrated signaler's settings. Note that the frequency should not have a decimal in it, \
	meaning the default frequency is expressed as 1457, not 145.7. To send a signal, pulse the 'send signal' activator pin."
	icon_state = "signal"
	complexity = 4
	inputs = list("frequency" = IC_PINTYPE_NUMBER,"code" = IC_PINTYPE_NUMBER)
	outputs = list()
	activators = list(
		"send signal" = IC_PINTYPE_PULSE_IN,
		"on signal sent" = IC_PINTYPE_PULSE_OUT,
		"on signal received" = IC_PINTYPE_PULSE_OUT)
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH
	action_flags = IC_ACTION_LONG_RANGE
	power_draw_idle = 5
	power_draw_per_use = 40
	cooldown_per_use = 5
	var/frequency = 1357
	var/code = 30
	var/datum/radio_frequency/radio_connection

/obj/item/integrated_circuit/input/signaler/Initialize()
	. = ..()
	set_pin_data(IC_INPUT, 1, frequency)
	set_pin_data(IC_INPUT, 2, code)

/obj/item/integrated_circuit/input/signaler/Destroy()
	radio_controller.remove_object(src,frequency)
	QDEL_NULL(radio_connection)
	frequency = 0
	return ..()

/obj/item/integrated_circuit/input/signaler/on_data_written()
	var/new_freq = get_pin_data(IC_INPUT, 1)
	var/new_code = get_pin_data(IC_INPUT, 2)
	if(isnum(new_freq) && new_freq > 0)
		set_frequency(new_freq)
	code = new_code


/obj/item/integrated_circuit/input/signaler/do_work(var/ord) // Sends a signal.
	if(!radio_connection || ord != 1)
		return

	radio_connection.post_signal(src, create_signal())
	activate_pin(2)

/obj/item/integrated_circuit/input/signaler/proc/signal_good(var/datum/signal/signal)
	if(!signal || signal.source == src)
		return FALSE
	if(code)
		var/real_code = 0
		if(isnum(code))
			real_code = code
		var/rec = 0
		if(signal.encryption)
			rec = signal.encryption
		if(real_code != rec)
			return FALSE
	return TRUE

/obj/item/integrated_circuit/input/signaler/proc/create_signal()
	var/datum/signal/signal = new()
	signal.transmission_method = 1
	signal.source = src
	if(isnum(code))
		signal.encryption = code
	signal.data["message"] = "ACTIVATE"
	return signal

/obj/item/integrated_circuit/input/signaler/proc/set_frequency(new_frequency)
	if(!frequency)
		return
	radio_controller.remove_object(src, frequency)
	frequency = new_frequency
	radio_connection = radio_controller.add_object(src, frequency, RADIO_CHAT)

/obj/item/integrated_circuit/input/signaler/receive_signal(datum/signal/signal)
	if(!signal_good(signal))
		return 0
	treat_signal(signal)
	return 1

//This only procs when a signal is valid.
/obj/item/integrated_circuit/input/signaler/proc/treat_signal(var/datum/signal/signal)
	activate_pin(3)

/obj/item/integrated_circuit/input/signaler/advanced
	name = "advanced integrated signaler"
	icon_state = "signal_advanced"
	desc = "Signals from a signaler can be received with this, allowing for remote control.  Additionally, it can send signals as well."
	extended_desc = "When a signal is received from another signaler with the right id tag, the 'on signal received' activator pin will be pulsed and the command output is updated.  \
	The two input pins are to configure the integrated signaler's settings.  Note that the frequency should not have a decimal in it.  \
	Meaning the default frequency is expressed as 1457, not 145.7.  To send a signal, pulse the 'send signal' activator pin. Set the command output to set the message received."
	complexity = 8
	inputs = list("frequency" = IC_PINTYPE_NUMBER, "id tag" = IC_PINTYPE_STRING, "command" = IC_PINTYPE_STRING)
	outputs = list("received command" = IC_PINTYPE_STRING)
	var/command
	code = "Integrated_Circuits"

/obj/item/integrated_circuit/input/signaler/advanced/on_data_written()
	..()
	command = get_pin_data(IC_INPUT,3)

/obj/item/integrated_circuit/input/signaler/advanced/signal_good(var/datum/signal/signal)
	if(!..() || signal.data["tag"] != code)
		return FALSE
	return TRUE

/obj/item/integrated_circuit/input/signaler/advanced/create_signal()
	var/datum/signal/signal = new()
	signal.transmission_method = 1
	signal.data["tag"] = code
	signal.data["command"] = command
	signal.encryption = 0
	return signal

/obj/item/integrated_circuit/input/signaler/advanced/treat_signal(var/datum/signal/signal)
	set_pin_data(IC_OUTPUT,1,signal.data["command"])
	push_data()
	..()

/obj/item/integrated_circuit/input/teleporter_locator
	name = "teleporter locator"
	desc = "This circuit can locate and allow for selection of teleporter computers."
	icon_state = "gps"
	complexity = 5
	inputs = list()
	outputs = list("teleporter" = IC_PINTYPE_REF)
	activators = list("on selected" = IC_PINTYPE_PULSE_OUT)
	spawn_flags = IC_SPAWN_RESEARCH
	action_flags = IC_ACTION_LONG_RANGE

/obj/item/integrated_circuit/input/teleporter_locator/get_topic_data(mob/user)
	var/datum/integrated_io/O = outputs[1]
	var/obj/machinery/computer/teleporter/current_console = O.data_as_type(/obj/machinery/computer/teleporter)

	. = list()
	. += "Current selection: [(current_console && current_console.id) || "None"]"
	. += "Please select a teleporter to lock in on:"
	for (var/obj/machinery/computer/teleporter/computer in SSmachines.machinery)
		if (computer.target && computer.operable() && AreConnectedZLevels(get_z(src), get_z(computer)))
			.["[computer.id] ([computer.active ? "Active" : "Inactive"])"] = "tport=[any2ref(computer)]"
	.["None (Dangerous)"] = "tport=random"

/obj/item/integrated_circuit/input/teleporter_locator/OnICTopic(href_list, user)
	if(href_list["tport"])
		var/output = href_list["tport"] == "random" ? null : locate(href_list["tport"])
		set_pin_data(IC_OUTPUT, 1, output && weakref(output))
		push_data()
		activate_pin(1)
		return IC_TOPIC_REFRESH

//This circuit gives information on where the machine is.
/obj/item/integrated_circuit/input/gps
	name = "global positioning system"
	desc = "This allows you to easily know the position of a machine containing this device."
	extended_desc = "The coordinates that the GPS outputs are absolute, not relative."
	icon_state = "gps"
	complexity = 4
	inputs = list()
	outputs = list("X"= IC_PINTYPE_NUMBER, "Y" = IC_PINTYPE_NUMBER, "Z" = IC_PINTYPE_NUMBER)
	activators = list("get coordinates" = IC_PINTYPE_PULSE_IN, "on get coordinates" = IC_PINTYPE_PULSE_OUT)
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH
	power_draw_per_use = 30

/obj/item/integrated_circuit/input/gps/do_work()
	var/turf/T = get_turf(src)

	set_pin_data(IC_OUTPUT, 1, null)
	set_pin_data(IC_OUTPUT, 2, null)
	set_pin_data(IC_OUTPUT, 3, null)
	if(!T)
		return

	set_pin_data(IC_OUTPUT, 1, T.x)
	set_pin_data(IC_OUTPUT, 2, T.y)
	set_pin_data(IC_OUTPUT, 3, T.z)

	push_data()
	activate_pin(2)

/obj/item/integrated_circuit/input/microphone
	name = "microphone"
	desc = "Useful for spying on people, or for voice-activated machines."
	extended_desc = "This will automatically translate most human languages to Zurich Accord Common. \
	The first activation pin is always pulsed when the circuit hears someone talk, while the second one \
	is only triggered if it successfully translated another language."
	icon_state = "recorder"
	complexity = 8
	inputs = list()
	obj_flags = OBJ_FLAG_CONDUCTIBLE
	outputs = list(
	"speaker" = IC_PINTYPE_STRING,
	"message" = IC_PINTYPE_STRING
	)
	activators = list("on message received" = IC_PINTYPE_PULSE_OUT, "on translation" = IC_PINTYPE_PULSE_OUT)
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH
	power_draw_per_use = 5

	var/language_preferred = LANGUAGE_HUMAN_EURO
	var/languages_understood = list(LANGUAGE_HUMAN_EURO, LANGUAGE_HUMAN_CHINESE, LANGUAGE_HUMAN_ARABIC, LANGUAGE_HUMAN_INDIAN, LANGUAGE_HUMAN_IBERIAN, LANGUAGE_HUMAN_RUSSIAN, LANGUAGE_HUMAN_SELENIAN, LANGUAGE_SPACER, LANGUAGE_HUMAN_LORRIMAN)
	var/invalid_flags = NONVERBAL | SIGNLANG | HIVEMIND | ALT_TRANSMIT

/obj/item/integrated_circuit/input/microphone/Initialize()
	. = ..()
	GLOB.listening_objects += src

/obj/item/integrated_circuit/input/microphone/Destroy()
	GLOB.listening_objects -= src
	. = ..()

/obj/item/integrated_circuit/input/microphone/hear_talk(var/mob/living/M as mob, text, verb, datum/language/speaking)
	var/translated = FALSE
	if(M && text && speaking)
		if(!(speaking.flags & invalid_flags))
			if(speaking.name in languages_understood)
				translated = TRUE
			else
				text = speaking.scramble(text)

			set_pin_data(IC_OUTPUT, 1, M.GetVoice())
			set_pin_data(IC_OUTPUT, 2, text)

			push_data()
			activate_pin(1)
			if(translated && !(speaking.name == language_preferred))
				activate_pin(2)


/obj/item/integrated_circuit/input/microphone/modem
	name = "machine modulating microphone"
	languages_understood = list(LANGUAGE_HUMAN_EURO, LANGUAGE_EAL)
	spawn_flags = IC_SPAWN_RESEARCH
	extended_desc = "A microphone combined with repurposed fax machine circuitry, this will translate Encoded Audio Language used by some synthetics into ZAC."

/obj/item/integrated_circuit/input/microphone/exo
	name = "interspecies exchange microphone"
	languages_understood = list(LANGUAGE_HUMAN_EURO, LANGUAGE_HUMAN_SELENIAN, LANGUAGE_HUMAN_LORRIMAN, LANGUAGE_UNATHI_SINTA, LANGUAGE_SKRELLIAN)
	spawn_flags = IC_SPAWN_RESEARCH
	extended_desc = "A microphone with a xenolinguistic database to facilitate EXO missions with mixed species. It translates the most common Skrellian and Unathi dialects to ZAC."
	//Selenian is an in-character undocumented feature demanded by a corp exec

/obj/item/integrated_circuit/input/microphone/fringe
	name = "gray market microphone"
	languages_understood = list(LANGUAGE_SPACER, LANGUAGE_GUTTER, LANGUAGE_HUMAN_CHINESE, LANGUAGE_HUMAN_ARABIC, LANGUAGE_HUMAN_INDIAN, LANGUAGE_HUMAN_IBERIAN, LANGUAGE_HUMAN_RUSSIAN)
	language_preferred = LANGUAGE_HUMAN_RUSSIAN
	spawn_flags = 0
	extended_desc = "This microphone did not come with any documentation."


/obj/item/integrated_circuit/input/sensor
	name = "sensor"
	desc = "Scans and obtains a reference for any objects or persons near you. All you need to do is shove the machine in their face."
	extended_desc = "If the 'ignore storage' pin is set to true, the sensor will disregard scanning various storage containers such as backpacks."
	icon_state = "recorder"
	complexity = 12
	inputs = list("ignore storage" = IC_PINTYPE_BOOLEAN)
	outputs = list("scanned" = IC_PINTYPE_REF)
	activators = list("on scanned" = IC_PINTYPE_PULSE_OUT)
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH
	power_draw_per_use = 120

/obj/item/integrated_circuit/input/sensor/sense(atom/A, mob/user, prox)
	if(!prox || !A || (ismob(A) && !isliving(A)))
		return FALSE
	if(!check_then_do_work())
		return FALSE
	var/ignore_bags = get_pin_data(IC_INPUT, 1)
	if(ignore_bags && istype(A, /obj/item/storage))
		return FALSE
	set_pin_data(IC_OUTPUT, 1, weakref(A))
	push_data()
	to_chat(user, "<span class='notice'>You scan [A] with [assembly].</span>")
	activate_pin(1)
	return TRUE

/obj/item/integrated_circuit/input/sensor/ranged
	name = "ranged sensor"
	desc = "Scans and obtains a reference for any objects or persons in range. All you need to do is point the machine towards the target."
	extended_desc = "If the 'ignore storage' pin is set to true, the sensor will disregard scanning various storage containers such as backpacks."
	icon_state = "recorder"
	complexity = 36
	inputs = list("ignore storage" = IC_PINTYPE_BOOLEAN)
	outputs = list("scanned" = IC_PINTYPE_REF)
	activators = list("on scanned" = IC_PINTYPE_PULSE_OUT)
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH
	power_draw_per_use = 120

/obj/item/integrated_circuit/input/sensor/ranged/sense(atom/A, mob/user)
	if(!user || !A || (ismob(A) && !isliving(A)))
		return FALSE
	if(user.client)
		if(!(A in view(user.client)))
			return FALSE
	else
		if(!(A in view(user)))
			return FALSE
	if(!check_then_do_work())
		return FALSE
	var/ignore_bags = get_pin_data(IC_INPUT, 1)
	if(ignore_bags && istype(A, /obj/item/storage))
		return FALSE
	set_pin_data(IC_OUTPUT, 1, weakref(A))
	push_data()
	to_chat(user, "<span class='notice'>You scan [A] with [assembly].</span>")
	activate_pin(1)
	return TRUE

/obj/item/integrated_circuit/input/obj_scanner
	name = "scanner"
	desc = "Scans and obtains a reference for any objects you use on the assembly."
	extended_desc = "If the 'put down' pin is set to true, the assembly will take the scanned object from your hands to its location. \
	Useful for interaction with the grabber. The scanner only works using the help intent."
	icon_state = "recorder"
	complexity = 4
	inputs = list("put down" = IC_PINTYPE_BOOLEAN)
	outputs = list("scanned" = IC_PINTYPE_REF)
	activators = list("on scanned" = IC_PINTYPE_PULSE_OUT)
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH
	power_draw_per_use = 20

/obj/item/integrated_circuit/input/obj_scanner/attackby_react(var/atom/A,var/mob/user,intent)
	if(intent!=I_HELP)
		return FALSE
	if(!check_then_do_work())
		return FALSE
	var/pu = get_pin_data(IC_INPUT, 1)
	if(pu && !user.unEquip(A,get_turf(src)))
		return FALSE
	set_pin_data(IC_OUTPUT, 1, weakref(A))
	push_data()
	to_chat(user, "<span class='notice'>You let [assembly] scan [A].</span>")
	activate_pin(1)
	return TRUE

/obj/item/integrated_circuit/input/internalbm
	name = "internal battery monitor"
	desc = "This monitors the charge level of an internal battery."
	icon_state = "internalbm"
	extended_desc = "This circuit will give you the values of charge, max charge, and the current percentage of the internal battery on demand."
	w_class = ITEM_SIZE_TINY
	complexity = 1
	inputs = list()
	outputs = list(
		"cell charge" = IC_PINTYPE_NUMBER,
		"max charge" = IC_PINTYPE_NUMBER,
		"percentage" = IC_PINTYPE_NUMBER,
		"refference to assembly" = IC_PINTYPE_REF,
		"refference to cell" = IC_PINTYPE_REF
		)
	activators = list("read" = IC_PINTYPE_PULSE_IN, "on read" = IC_PINTYPE_PULSE_OUT)
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH
	power_draw_per_use = 1

/obj/item/integrated_circuit/input/internalbm/do_work()
	set_pin_data(IC_OUTPUT, 1, null)
	set_pin_data(IC_OUTPUT, 2, null)
	set_pin_data(IC_OUTPUT, 3, null)
	set_pin_data(IC_OUTPUT, 4, null)
	set_pin_data(IC_OUTPUT, 5, null)
	if(assembly)
		set_pin_data(IC_OUTPUT, 4, weakref(assembly))
		if(assembly.battery)
			set_pin_data(IC_OUTPUT, 1, assembly.battery.charge)
			set_pin_data(IC_OUTPUT, 2, assembly.battery.maxcharge)
			set_pin_data(IC_OUTPUT, 3, 100*assembly.battery.charge/assembly.battery.maxcharge)
			set_pin_data(IC_OUTPUT, 5, weakref(assembly.battery))
	push_data()
	activate_pin(2)

/obj/item/integrated_circuit/input/externalbm
	name = "external battery monitor"
	desc = "This can read the battery state of any device in view."
	icon_state = "externalbm"
	extended_desc = "This circuit will give you the charge, max charge, and the current percentage values of any device or battery in view."
	w_class = ITEM_SIZE_TINY
	complexity = 2
	inputs = list("target" = IC_PINTYPE_REF)
	outputs = list(
		"cell charge" = IC_PINTYPE_NUMBER,
		"max charge" = IC_PINTYPE_NUMBER,
		"percentage" = IC_PINTYPE_NUMBER
		)
	activators = list("read" = IC_PINTYPE_PULSE_IN, "on read" = IC_PINTYPE_PULSE_OUT)
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH
	power_draw_per_use = 1

/obj/item/integrated_circuit/input/externalbm/do_work()

	var/obj/O = get_pin_data_as_type(IC_INPUT, 1, /obj)
	set_pin_data(IC_OUTPUT, 1, null)
	set_pin_data(IC_OUTPUT, 2, null)
	set_pin_data(IC_OUTPUT, 3, null)
	if(O)
		var/obj/item/cell/C = O.get_cell()
		if(C)
			var/turf/A = get_turf(src)
			if(get_turf(O) in view(A))
				set_pin_data(IC_OUTPUT, 1, C.charge)
				set_pin_data(IC_OUTPUT, 2, C.maxcharge)
				set_pin_data(IC_OUTPUT, 3, C.percent())
	push_data()
	activate_pin(2)
	return

/obj/item/integrated_circuit/input/matscan
	name = "material scanner"
	desc = "This special module is designed to get information about material containers of different machinery, \
			like ORM, lathes, etc."
	icon_state = "video_camera"
	complexity = 6
	inputs = list(
		"target" = IC_PINTYPE_REF
		)
	outputs = list(
		"Steel"				 	= IC_PINTYPE_NUMBER,
		"Glass"					= IC_PINTYPE_NUMBER,
		"Silver"				= IC_PINTYPE_NUMBER,
		"Gold"					= IC_PINTYPE_NUMBER,
		"Diamond"				= IC_PINTYPE_NUMBER,
		"Solid Phoron"			= IC_PINTYPE_NUMBER,
		"Uranium"				= IC_PINTYPE_NUMBER,
		"Plasteel"				= IC_PINTYPE_NUMBER,
		"Titanium"				= IC_PINTYPE_NUMBER,
		"Glass"					= IC_PINTYPE_NUMBER,
		"Plastic"				= IC_PINTYPE_NUMBER,
		)
	activators = list(
		"scan" = IC_PINTYPE_PULSE_IN,
		"on scanned" = IC_PINTYPE_PULSE_OUT,
		"not scanned" = IC_PINTYPE_PULSE_OUT
		)
	spawn_flags = IC_SPAWN_RESEARCH
	power_draw_per_use = 40
	var/list/mtypes = list("steel", "glass", "silver", "gold", "diamond", "phoron", "uranium", "plasteel", "titanium", "glass", "plastic")

/obj/item/integrated_circuit/input/matscan/do_work()
	var/obj/O = get_pin_data_as_type(IC_INPUT, 1, /obj)
	if(!O || !O.matter) //Invalid input
		return
	var/turf/T = get_turf(src)
	if(O in view(T)) // This is a camera. It can't examine thngs,that it can't see.
		for(var/I in 1 to mtypes.len)
			var/amount = O.matter[mtypes[I]]
			if(amount)
				set_pin_data(IC_OUTPUT, I, amount)
			else
				set_pin_data(IC_OUTPUT, I, null)
		push_data()
		activate_pin(2)
	else
		activate_pin(3)

/obj/item/integrated_circuit/input/atmospheric_analyzer
	name = "atmospheric analyzer"
	desc = "A miniaturized analyzer which can scan anything that contains gases. Leave target as NULL to scan the air around the assembly."
	extended_desc = "The nth element of gas amounts is the number of moles of the \
					nth gas in gas list. \
					Pressure is in kPa, temperature is in Kelvin. \
					Due to programming limitations, scanning an object that does \
					not contain a gas will return the air around it instead."
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH
	inputs = list(
			"target" = IC_PINTYPE_REF
			)
	outputs = list(
			"gas list" = IC_PINTYPE_LIST,
			"gas amounts" = IC_PINTYPE_LIST,
			"total moles" = IC_PINTYPE_NUMBER,
			"pressure" = IC_PINTYPE_NUMBER,
			"temperature" = IC_PINTYPE_NUMBER,
			"volume" = IC_PINTYPE_NUMBER
			)
	activators = list(
			"scan" = IC_PINTYPE_PULSE_IN,
			"on success" = IC_PINTYPE_PULSE_OUT,
			"on failure" = IC_PINTYPE_PULSE_OUT
			)
	power_draw_per_use = 5

/obj/item/integrated_circuit/input/atmospheric_analyzer/do_work()
	for(var/i=1 to 6)
		set_pin_data(IC_OUTPUT, i, null)
	var/atom/target = get_pin_data_as_type(IC_INPUT, 1, /atom)
	var/atom/movable/acting_object = get_object()
	if(!target)
		target = acting_object.loc
	if(!target.Adjacent(acting_object))
		activate_pin(3)
		return

	var/datum/gas_mixture/air_contents = target.return_air()
	if(!air_contents)
		activate_pin(3)
		return

	var/list/gases = air_contents.gas
	var/list/gas_names = list()
	var/list/gas_amounts = list()
	for(var/id in gases)
		var/name = gas_data.name[id]
		var/amt = round(gases[id], 0.001)
		gas_names.Add(name)
		gas_amounts.Add(amt)

	set_pin_data(IC_OUTPUT, 1, gas_names)
	set_pin_data(IC_OUTPUT, 2, gas_amounts)
	set_pin_data(IC_OUTPUT, 3, round(air_contents.get_total_moles(), 0.001))
	set_pin_data(IC_OUTPUT, 4, round(air_contents.return_pressure(), 0.001))
	set_pin_data(IC_OUTPUT, 5, round(air_contents.temperature, 0.001))
	set_pin_data(IC_OUTPUT, 6, round(air_contents.volume, 0.001))
	push_data()
	activate_pin(2)

/obj/item/integrated_circuit/input/data_card_reader
	name = "data card reader"
	desc = "A circuit that can read from and write to data cards."
	extended_desc = "Setting the \"write mode\" boolean to true will cause any data cards that are used on the assembly to replace\
 their existing function and data strings with the given strings, if it is set to false then using a data card on the assembly will cause\
 the function and data strings stored on the card to be written to the output pins."
	icon_state = "card_reader"
	complexity = 4
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH
	inputs = list(
		"function" = IC_PINTYPE_STRING,
		"data to store" = IC_PINTYPE_STRING,
		"write mode" = IC_PINTYPE_BOOLEAN
	)
	outputs = list(
		"function" = IC_PINTYPE_STRING,
		"stored data" = IC_PINTYPE_STRING
	)
	activators = list(
		"on write" = IC_PINTYPE_PULSE_OUT,
		"on read" = IC_PINTYPE_PULSE_OUT
	)

/obj/item/integrated_circuit/input/data_card_reader/attackby_react(obj/item/I, mob/living/user, intent)
	var/obj/item/card/data/card = I
	var/write_mode = get_pin_data(IC_INPUT, 3)
	if(istype(card))
		if(write_mode == TRUE)
			card.function = get_pin_data(IC_INPUT, 1)
			card.data = get_pin_data(IC_INPUT, 2)
			push_data()
			activate_pin(1)
		else
			set_pin_data(IC_OUTPUT, 1, card.function)
			set_pin_data(IC_OUTPUT, 2, card.data)
			push_data()
			activate_pin(2)
	else
		return FALSE
	return TRUE
