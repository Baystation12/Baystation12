/obj/proc/analyze_gases(var/obj/A, var/mob/user)
	if(src != A)
		user.visible_message("<span class='notice'>\The [user] has used \an [src] on \the [A]</span>")

	A.add_fingerprint(user)
	var/list/result = A.atmosanalyze(user)
	if(result && result.len)
		user << "<span class='notice'>Results of the analysis[src == A ? "" : " of \the [A]"]</span>"
		for(var/line in result)
			user << "<span class='notice'>[line]</span>"
		return 1

	user << "<span class='warning'>Your [src] flashes a red light as it fails to analyze \the [A].</span>"
	return 0

/proc/atmosanalyzer_scan(var/obj/target, var/datum/gas_mixture/mixture, var/mob/user)
	var/pressure = mixture.return_pressure()
	var/total_moles = mixture.total_moles

	var/list/results = list()
	if (total_moles>0)
		results += "<span class='notice'>Pressure: [round(pressure,0.1)] kPa</span>"
		for(var/mix in mixture.gas)
			results += "<span class='notice'>[gas_data.name[mix]]: [round((mixture.gas[mix] / total_moles) * 100)]%</span>"
		results += "<span class='notice'>Temperature: [round(mixture.temperature-T0C)]&deg;C</span>"
	else
		results += "<span class='notice'>\The [target] is empty!</span>"

	return results

/obj/proc/atmosanalyze(var/mob/user)
	return

/obj/item/weapon/tank/atmosanalyze(var/mob/user)
	return atmosanalyzer_scan(src, src.air_contents, user)

/obj/machinery/portable_atmospherics/atmosanalyze(var/mob/user)
	return atmosanalyzer_scan(src, src.air_contents, user)

/obj/machinery/atmospherics/pipe/atmosanalyze(var/mob/user)
	return atmosanalyzer_scan(src, src.parent.air, user)

/obj/machinery/power/rad_collector/atmosanalyze(var/mob/user)
	if(P)	return atmosanalyzer_scan(src, src.P.air_contents, user)

/obj/item/weapon/flamethrower/atmosanalyze(var/mob/user)
	if(ptank)	return atmosanalyzer_scan(src, ptank.air_contents, user)
