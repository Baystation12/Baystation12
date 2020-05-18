/*
	Unit tests for ATMOSPHERICS primitives
*/
#define ALL_GASIDS gas_data.gases

/datum/unit_test/atmos_machinery
	template = /datum/unit_test/atmos_machinery
	var/list/test_cases = list()

/datum/unit_test/atmos_machinery/proc/create_gas_mixes(gas_mix_data)
	var/list/gas_mixes = list()
	for(var/mix_name in gas_mix_data)
		var/list/mix_data = gas_mix_data[mix_name]

		var/datum/gas_mixture/gas_mix = new (CELL_VOLUME, mix_data["temperature"])

		var/list/initial_gas = mix_data["initial_gas"]
		if(initial_gas.len)
			var/list/gas_args = list()
			for(var/gasid in initial_gas)
				gas_args += gasid
				gas_args += initial_gas[gasid]
			gas_mix.adjust_multi(arglist(gas_args))

		gas_mixes[mix_name] = gas_mix
	return gas_mixes

/datum/unit_test/atmos_machinery/proc/gas_amount_changes(var/list/before_gas_mixes, var/list/after_gas_mixes)
	var/list/result = list()
	for(var/mix_name in before_gas_mixes & after_gas_mixes)
		var/change = list()

		var/datum/gas_mixture/before = before_gas_mixes[mix_name]
		var/datum/gas_mixture/after = after_gas_mixes[mix_name]

		var/list/all_gases = before.gas | after.gas
		for(var/gasid in all_gases)
			change[gasid] = after.get_gas(gasid) - before.get_gas(gasid)

		result[mix_name] = change

	return result

/datum/unit_test/atmos_machinery/proc/check_moles_conserved(var/case_name, var/list/before_gas_mixes, var/list/after_gas_mixes)
	var/failed = FALSE
	for(var/gasid in gas_data.gases)
		var/before = 0
		for(var/gasmix in before_gas_mixes)
			var/datum/gas_mixture/G = before_gas_mixes[gasmix]
			before += G.get_gas(gasid)

		var/after = 0
		for(var/gasmix in after_gas_mixes)
			var/datum/gas_mixture/G = after_gas_mixes[gasmix]
			after += G.get_gas(gasid)

		if(abs(before - after) > ATMOS_PRECISION)
			fail("[case_name]: expected [before] moles of [gasid], found [after] moles.")
			failed |= TRUE

	if(!failed)
		pass("[case_name]: conserved moles of each gas ID.")

/datum/unit_test/atmos_machinery/conserve_moles
	template = /datum/unit_test/atmos_machinery/conserve_moles
	test_cases = list(
		uphill = list(
			source = list(
				initial_gas = list(
					GAS_OXYGEN         = 5,
					GAS_NITROGEN       = 10,
					GAS_CO2 = 5,
					GAS_PHORON         = 10,
					GAS_N2O = 5,
				),
				temperature = T20C - 5,
			),
			sink = list(
				initial_gas = list(
					GAS_OXYGEN         = 10,
					GAS_NITROGEN       = 20,
					GAS_CO2 = 10,
					GAS_PHORON         = 20,
					GAS_N2O = 10,
				),
				temperature = T20C + 5,
			)
		),
		downhill = list(
			source = list(
				initial_gas = list(
					GAS_OXYGEN         = 10,
					GAS_NITROGEN       = 20,
					GAS_CO2 = 10,
					GAS_PHORON         = 20,
					GAS_N2O = 10,
				),
				temperature = T20C + 5,
			),
			sink = list(
				initial_gas = list(
					GAS_OXYGEN         = 5,
					GAS_NITROGEN       = 10,
					GAS_CO2 = 5,
					GAS_PHORON         = 10,
					GAS_N2O = 5,
				),
				temperature = T20C - 5,
			),
		),
		flat = list(
			source = list(
				initial_gas = list(
					GAS_OXYGEN         = 10,
					GAS_NITROGEN       = 20,
					GAS_CO2 = 10,
					GAS_PHORON         = 20,
					GAS_N2O = 10,
				),
				temperature = T20C,
			),
			sink = list(
				initial_gas = list(
					GAS_OXYGEN         = 10,
					GAS_NITROGEN       = 20,
					GAS_CO2 = 10,
					GAS_PHORON         = 20,
					GAS_N2O = 10,
				),
				temperature = T20C,
			),
		),
		vacuum_sink = list(
			source = list(
				initial_gas = list(
					GAS_OXYGEN         = 10,
					GAS_NITROGEN       = 20,
					GAS_CO2 = 10,
					GAS_PHORON         = 20,
					GAS_N2O = 10,
				),
				temperature = T20C,
			),
			sink = list(
				initial_gas = list(),
				temperature = 0,
			),
		),
		vacuum_source = list(
			source = list(
				initial_gas = list(),
				temperature = 0,
			),
			sink = list(
				initial_gas = list(
					GAS_OXYGEN         = 10,
					GAS_NITROGEN       = 20,
					GAS_CO2 = 10,
					GAS_PHORON         = 20,
					GAS_N2O = 10,
				),
				temperature = T20C,
			),
		),
	)


/datum/unit_test/atmos_machinery/conserve_moles/pump_gas
	name = "ATMOS MACHINERY: pump_gas() Conserves Moles"

/datum/unit_test/atmos_machinery/conserve_moles/pump_gas/start_test()
	for(var/case_name in test_cases)
		var/gas_mix_data = test_cases[case_name]
		var/list/before_gas_mixes = create_gas_mixes(gas_mix_data)
		var/list/after_gas_mixes = create_gas_mixes(gas_mix_data)

		pump_gas(null, after_gas_mixes["source"], after_gas_mixes["sink"], null, INFINITY)

		check_moles_conserved(case_name, before_gas_mixes, after_gas_mixes)

	return 1

/datum/unit_test/atmos_machinery/conserve_moles/pump_gas_passive
	name = "ATMOS MACHINERY: pump_gas_passive() Conserves Moles"

/datum/unit_test/atmos_machinery/conserve_moles/pump_gas_passive/start_test()
	for(var/case_name in test_cases)
		var/gas_mix_data = test_cases[case_name]
		var/list/before_gas_mixes = create_gas_mixes(gas_mix_data)
		var/list/after_gas_mixes = create_gas_mixes(gas_mix_data)

		pump_gas_passive(null, after_gas_mixes["source"], after_gas_mixes["sink"], null)

		check_moles_conserved(case_name, before_gas_mixes, after_gas_mixes)

	return 1

/datum/unit_test/atmos_machinery/conserve_moles/scrub_gas
	name = "ATMOS MACHINERY: scrub_gas() Conserves Moles"

/datum/unit_test/atmos_machinery/conserve_moles/scrub_gas/start_test()
	var/list/filtering = gas_data.gases

	for(var/case_name in test_cases)
		var/gas_mix_data = test_cases[case_name]
		var/list/before_gas_mixes = create_gas_mixes(gas_mix_data)
		var/list/after_gas_mixes = create_gas_mixes(gas_mix_data)

		scrub_gas(null, filtering, after_gas_mixes["source"], after_gas_mixes["sink"], null, INFINITY)

		check_moles_conserved(case_name, before_gas_mixes, after_gas_mixes)

	return 1

/datum/unit_test/atmos_machinery/conserve_moles/filter_gas
	name = "ATMOS MACHINERY: filter_gas() Conserves Moles"

/datum/unit_test/atmos_machinery/conserve_moles/filter_gas/start_test()
	var/list/filtering = gas_data.gases

	for(var/case_name in test_cases)
		var/gas_mix_data = test_cases[case_name]
		var/list/before_gas_mixes = create_gas_mixes(gas_mix_data)
		var/list/after_gas_mixes = create_gas_mixes(gas_mix_data)

		filter_gas(null, filtering, after_gas_mixes["source"], after_gas_mixes["sink"], after_gas_mixes["source"], null, INFINITY)

		check_moles_conserved(case_name, before_gas_mixes, after_gas_mixes)

	return 1

/datum/unit_test/atmos_machinery/conserve_moles/filter_gas_multi
	name = "ATMOS MACHINERY: filter_gas_multi() Conserves Moles"

/datum/unit_test/atmos_machinery/conserve_moles/filter_gas_multi/start_test()
	for(var/case_name in test_cases)
		var/gas_mix_data = test_cases[case_name]
		var/list/before_gas_mixes = create_gas_mixes(gas_mix_data)
		var/list/after_gas_mixes = create_gas_mixes(gas_mix_data)

		var/list/filtering = list()
		for(var/gasid in gas_data.gases)
			filtering[gasid] = after_gas_mixes["sink"] //just filter everything to sink

		filter_gas_multi(null, filtering, after_gas_mixes["source"], after_gas_mixes["sink"], null, INFINITY)

		check_moles_conserved(case_name, before_gas_mixes, after_gas_mixes)

	return 1

/datum/unit_test/atmos_machinery/conserve_moles/mix_gas
	name = "ATMOS MACHINERY: mix_gas() Conserves Moles"

/datum/unit_test/atmos_machinery/conserve_moles/mix_gas/start_test()
	for(var/case_name in test_cases)
		var/gas_mix_data = test_cases[case_name]
		var/list/before_gas_mixes = create_gas_mixes(gas_mix_data)
		var/list/after_gas_mixes = create_gas_mixes(gas_mix_data)

		var/list/mix_sources = list()
		for(var/gasid in ALL_GASIDS)
			var/datum/gas_mixture/mix_source = after_gas_mixes["sink"]
			mix_sources[mix_source] = 1.0/gas_data.gases.len //doesn't work as a macro for some reason

		mix_gas(null, mix_sources, after_gas_mixes["sink"], null, INFINITY)

		check_moles_conserved(case_name, before_gas_mixes, after_gas_mixes)

	return 1

/datum/unit_test/pipes_shall_belong_to_unique_pipelines
	name = "ATMOS MACHINERY: all pipes shall belong to a unique pipeline"

/datum/unit_test/pipes_shall_belong_to_unique_pipelines/start_test()
	var/list/checked_pipes = list()
	var/list/bad_pipelines = list()
	for(var/datum/pipeline/P)
		for(var/thing in P.members)
			var/obj/machinery/atmospherics/pipe/pipe = thing
			if(!checked_pipes[thing])
				checked_pipes[thing] = P
				continue
			LAZYDISTINCTADD(bad_pipelines[P], pipe)
			LAZYDISTINCTADD(bad_pipelines[checked_pipes[thing]], pipe) // Missed it the first time; thought it was good.

	if(length(bad_pipelines))
		for(var/datum/pipeline/badboy in bad_pipelines)
			var/info = list()
			for(var/bad_pipe in bad_pipelines[badboy])
				info += log_info_line(bad_pipe)
			log_bad("A pipeline with overlapping members contained the following overlapping pipes: [english_list(info)]")
		fail("Some pipes were in multiple pipelines at once.")
	else
		pass("All pipes belonged to a unique pipeline.")
	return 1

/datum/unit_test/atmos_machinery_shall_not_have_conflicting_connections
	name = "ATMOS MACHINERY: all mapped atmos machinery shall not have more than one connection of each type per dir."

/datum/unit_test/atmos_machinery_shall_not_have_conflicting_connections/start_test()
	var/fail = FALSE
	for(var/obj/machinery/atmospherics/machine in SSmachines.machinery)
		for(var/obj/machinery/atmospherics/M in machine.loc)
			if(M == machine)
				continue
			if(!machine.check_connect_types(M, machine))
				continue
			if(M.initialize_directions & machine.initialize_directions)
				log_bad("[log_info_line(machine)] has conflicting connections.")
				fail = TRUE

	if(fail)
		fail("Some pipes had conflicting connections.")
	else
		pass("All pipes were mapped properly.")
	return 1

#undef ALL_GASIDS