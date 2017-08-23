/obj/proc/analyze_gases(var/obj/A, var/mob/user, advanced)
	user.visible_message("<span class='notice'>\The [user] has used \an [src] on \the [A].</span>")
	A.add_fingerprint(user)

	var/air_contents = A.return_air()
	if(!air_contents)
		to_chat(user, "<span class='warning'>Your [src] flashes a red light as it fails to analyze \the [A].</span>")
		return 0

	var/list/result = atmosanalyzer_scan(A, air_contents, advanced)
	print_atmos_analysis(user, result)
	return 1

/proc/print_atmos_analysis(user, var/list/result)
	for(var/line in result)
		to_chat(user, "<span class='notice'>[line]</span>")

/proc/atmosanalyzer_scan(var/atom/target, var/datum/gas_mixture/mixture, advanced)
	. = list()
	. += "<span class='notice'>Results of the analysis of \the [target]:</span>"
	if(!mixture)
		mixture = target.return_air()

	if(mixture)
		var/pressure = mixture.return_pressure()
		var/total_moles = mixture.total_moles

		if (total_moles>0)
			if(abs(pressure - ONE_ATMOSPHERE) < 10)
				. += "<span class='notice'>Pressure: [round(pressure,0.1)] kPa</span>"
			else
				. += "<span class='warning'>Pressure: [round(pressure,0.1)] kPa</span>"
			for(var/mix in mixture.gas)
				var/percentage = round(mixture.gas[mix]/total_moles * 100, advanced ? 0.01 : 1)
				. += "<span class='notice'>[gas_data.name[mix]]: [percentage]%</span>"
				if(advanced)
					var/list/traits = list()
					if(gas_data.flags[mix] & XGM_GAS_FUEL)
						traits += "can be used as combustion fuel" 
					if(gas_data.flags[mix] & XGM_GAS_OXIDIZER)
						traits += "can be used as oxidizer" 
					if(gas_data.flags[mix] & XGM_GAS_CONTAMINANT)
						traits += "contaminates clothing with toxic residue" 
					if(gas_data.flags[mix] & XGM_GAS_FUSION_FUEL)
						traits += "can be used to fuel fusion reaction" 
					. += "\t<span class='notice'>Specific heat: [gas_data.specific_heat[mix]] J/(mol*K), Molar mass: [gas_data.molar_mass[mix]] kg/mol.[traits.len ? "\n\tThis gas [english_list(traits)]" : ""]</span>"
			. += "<span class='notice'>Temperature: [round(mixture.temperature-T0C)]&deg;C / [round(mixture.temperature)]K</span>"
			return
	. += "<span class='warning'>\The [target] has no gases!</span>"
