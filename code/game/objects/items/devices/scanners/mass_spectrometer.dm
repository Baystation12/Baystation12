/obj/item/device/scanner/spectrometer
	name = "mass spectrometer"
	desc = "A hand-held mass spectrometer which identifies trace chemicals in a blood sample or analyzes unusual chemicals."
	icon_state = "spectrometer"
	item_state = "analyzer"

	atom_flags = ATOM_FLAG_NO_TEMP_CHANGE | ATOM_FLAG_OPEN_CONTAINER
	origin_tech = list(TECH_MAGNET = 2, TECH_BIO = 2)
	window_width = 550
	window_height = 300
	scan_sound = 'sound/effects/scanbeep.ogg'
	var/details = 0

/obj/item/device/scanner/spectrometer/Initialize()
	. = ..()
	create_reagents(5)

/obj/item/device/scanner/spectrometer/on_reagent_change()
	update_icon()

/obj/item/device/scanner/spectrometer/on_update_icon()
	icon_state = initial(icon_state)
	if(reagents.total_volume)
		icon_state += "_s"

/obj/item/device/scanner/spectrometer/is_valid_scan_target(atom/O)
	if(!O.reagents || !O.reagents.total_volume)
		return FALSE
	return (O.atom_flags & ATOM_FLAG_OPEN_CONTAINER) || istype(O, /obj/item/weapon/reagent_containers/syringe)

/obj/item/device/scanner/spectrometer/scan(atom/A, mob/user)
	if(A != src)
		to_chat(user, "<span class='notice'>\The [src] takes a sample out of \the [A]</span>")
		reagents.clear_reagents()
		A.reagents.trans_to(src, 5)
	scan_title = "Spectrometer scan - [A]"
	scan_data = mass_spectrometer_scan(reagents, user, details)
	reagents.clear_reagents()
	user.show_message(scan_data)

/obj/item/device/scanner/spectrometer/attack_self(mob/user)
	if(!can_use(user))
		return
	if(reagents.total_volume)
		scan(src, user)
	else
		..()

/proc/mass_spectrometer_scan(var/datum/reagents/reagents, mob/user, var/details)
	if(!reagents || !reagents.total_volume)
		return "<span class='warning'>No sample to scan.</span>"
	var/list/blood_traces = list()
	var/list/blood_doses = list()
	for(var/datum/reagent/R in reagents.reagent_list)
		if(length(reagents.reagent_list) == 1)
			var/datum/reagent/random/random = R
			if(istype(random))
				return random.get_scan_data(user)
				
		if(R.type != /datum/reagent/blood)
			return "<span class='warning'>The sample was contaminated! Please insert another sample</span>"
		else
			blood_traces = R.data["trace_chem"]
			blood_doses = R.data["dose_chem"]
			break

	var/list/dat = list("Trace Chemicals Found: ")
	for(var/T in blood_traces)
		var/datum/reagent/R = T
		if(details)
			dat += "[initial(R.name)] ([blood_traces[T]] units) "
		else
			dat += "[initial(R.name)] "
	if(details)
		dat += "Metabolism Products of Chemicals Found:"
		for(var/T in blood_doses)
			var/datum/reagent/R = T
			dat += "[initial(R.name)] ([blood_doses[T]] units) "

	return jointext(dat, "<br>")

/obj/item/device/scanner/spectrometer/adv
	name = "advanced mass spectrometer"
	icon_state = "adv_spectrometer"
	details = 1
	origin_tech = list(TECH_MAGNET = 4, TECH_BIO = 2)