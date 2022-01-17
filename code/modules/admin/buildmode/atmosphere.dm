#define MODE_AREA "AREA"
#define MODE_SINGLE "SINGLE"

/datum/build_mode/atmosphere
	name = "Atmosphere Editor"
	icon_state = "buildmode13"
	var/area/env_area
	var/datum/gas_mixture/enviroment
	var/atom/selected_object
	var/list/valid_gases = list()
	var/mode = MODE_AREA
	var/simmed = TRUE
	var/help_text = {"\
	***** Build Mode: Atmosphere ******
	Left Click         - Open atmosphere editor

	Modes:
	AREA - Edits the atmosphere of all turfs in a selected a area.
	SINGLE - Edits the atmosphere of a single object or turf. Works with containers (tanks, canisters, etc...)

	************************************\
	"}

/datum/build_mode/atmosphere/New()
	. = ..()
	valid_gases = gas_data.gases.Copy()

/datum/build_mode/atmosphere/Help()
	to_chat(user, SPAN_NOTICE(help_text))

/datum/build_mode/atmosphere/ui_interact(mob/user, ui_key = "atmosphere_editor", datum/nanoui/ui = null, force_open = 1, var/master_ui = null, var/datum/topic_state/state = GLOB.default_state)
	. = ..()

	var/data[0]
	data["total_moles"] = enviroment.total_moles
	data["temperature"] = enviroment.temperature
	data["volume_total"] = enviroment.volume
	data["gases"] = enviroment.gas
	data["mode"] = mode

	var/title = ""
	switch (mode)
		if (MODE_AREA)
			title = "[env_area]"
		if (MODE_SINGLE)
			title = "[selected_object]"

			if (is_atmos_container(selected_object))
				title += "(CONTAINER)"

	data["title"] = title

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "atmosphere_editor.tmpl", src.name, 425, 600, master_ui = master_ui, state = state)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)

/datum/build_mode/atmosphere/CanUseTopic(mob/user)
	if (!isadmin(user))
		return STATUS_CLOSE
	return ..()

/datum/build_mode/atmosphere/Topic(user, href_list)
	var/list/atmospheres = list()

	switch (mode)
		if (MODE_AREA)
			if (ispath(env_area.base_turf, /turf/unsimulated))
				simmed = FALSE
			atmospheres = get_area_turfs(env_area)
		if (MODE_SINGLE)
			if (istype(selected_object.loc, /turf/unsimulated))
				simmed = FALSE
			atmospheres += selected_object

	if (href_list["change_mode"])
		var/new_mode = input("Change editor mode", "Change Mode") as null | anything in list(MODE_AREA, MODE_SINGLE)

		if (new_mode)
			mode = new_mode

		return TOPIC_HANDLED

	if (href_list["temperature"])
		var/temp = input("Set Temperature (Kelvin)", "Temperature") as num | null

		if (!simmed)
			for (var/turf/unsimulated/T in atmospheres)
				T.temperature = temp
			return

		if (!isnull(temp))
			for (var/turf/T in atmospheres)
				var/datum/gas_mixture/G = T.return_air()
				G.temperature = temp
				G.update_values()


		. = TOPIC_HANDLED

	if (href_list["moles_total"])
		var/moles = input("Add/Subtract Moles", "Moles") as num | null

		if (!simmed)
			for (var/turf/unsimulated/T in atmospheres)
				var/new_moles = T.initial_gas.len / moles

				for (var/gas in T.initial_gas)
					T.initial_gas[gas] = new_moles
			return

		if (!isnull(moles))
			for (var/turf/T in atmospheres)
				var/datum/gas_mixture/G = T.return_air()
				for (var/g in G.gas)
					G.adjust_gas(g, moles)

		. = TOPIC_HANDLED

	if (href_list["modify_gas"])
		var/gas_id = href_list["modify_gas"]
		var/moles = input("Set [gas_id]'s Mole Count]", "Moles") as num | null

		if (!simmed)
			for (var/turf/unsimulated/T in atmospheres)
				T.initial_gas[gas_id] = moles
			return

		if (!isnull(moles))
			for (var/turf/T in atmospheres)
				var/datum/gas_mixture/G = T.return_air()
				var/list/gases = G.gas

				gases[gas_id] = moles
				G.update_values()

		. = TOPIC_HANDLED

	if (href_list["add_gas"])
		var/gas = input("Add a gas", "Gas") as null | anything in valid_gases

		if (gas)
			var/moles = input("How many moles?", "Moles") as num | null

			if (!simmed)
				for (var/turf/unsimulated/T in atmospheres)
					T.initial_gas[gas] = moles
				return

			if (moles)
				for (var/turf/T in atmospheres)
					var/datum/gas_mixture/G = T.return_air()
					G.gas[gas] = moles
					G.update_values()

		. = TOPIC_HANDLED

	if (href_list["remove_gas"])
		var/gas = input("Remove a gas from the mix", "Remove Gas") as null | anything in enviroment.gas

		if (gas)
			if (!simmed)
				for (var/turf/unsimulated/T in atmospheres)
					T.initial_gas[gas] = 0
				return

			for (var/turf/T in atmospheres)
				var/datum/gas_mixture/G = T.return_air()
				G.gas[gas] = 0
				G.update_values()

		. = TOPIC_HANDLED

	if (href_list["set_predefined_atmos"])
		var/option = href_list["set_predefined_atmos"]
		var/list/gasses = list()
		var/temperature

		if (option == "o2n2_standard")
			gasses = list(GAS_OXYGEN = MOLES_O2STANDARD, GAS_NITROGEN = MOLES_N2STANDARD)
			temperature = 294

		if (!simmed)
			for (var/turf/unsimulated/T in atmospheres)
				T.initial_gas = gasses
				T.temperature = temperature
			return

		if (length(gasses))
			for (var/turf/T in atmospheres)
				var/datum/gas_mixture/G = T.return_air()
				for (var/gas in G.gas)
					G.gas[gas] = 0

			for (var/turf/T in atmospheres)
				var/datum/gas_mixture/G = T.return_air()
				for (var/new_gas in gasses)
					G.gas = gasses.Copy()
					G.adjust_gas_temp(new_gas, gasses[new_gas], temperature)

		. = TOPIC_HANDLED


	if (mode == MODE_AREA && env_area.planetary_surface)
		//exoplanets will slowly reset their atmosphere to default if we don't update it
		var/obj/effect/overmap/visitable/sector/exoplanet/E = map_sectors["[env_area.z]"]
		if (istype(E))
			E.atmosphere.gas = enviroment.gas.Copy()
			E.atmosphere.temperature = enviroment.temperature

/datum/build_mode/atmosphere/OnClick(atom/object, list/pa)
	selected_object = object
	env_area = get_area(object)

	switch (mode)
		if (MODE_AREA)
			var/turf/T = get_turf(object)
			enviroment = T.return_air()
		if (MODE_SINGLE)
			enviroment = object.return_air()

	ui_interact(user)

/datum/build_mode/atmosphere/proc/is_atmos_container(atom/object)
	var/list/container_types = list(
		/obj/item/tank,
		/obj/item/latexballon,
		/obj/machinery/portable_atmospherics,
		/obj/machinery/atmospherics/unary
	)

	for (var/type in container_types)
		if (istype(object, type))
			return TRUE

	return FALSE
