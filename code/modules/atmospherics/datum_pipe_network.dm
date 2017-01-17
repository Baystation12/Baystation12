var/global/list/datum/pipe_network/pipe_networks = list()

datum/pipe_network
	var/list/datum/gas_mixture/gases = list() //All of the gas_mixtures continuously connected in this network
	var/volume = 0	//caches the total volume for atmos machines to use in gas calculations

	var/list/obj/machinery/atmospherics/normal_members = list()
	var/list/datum/pipeline/line_members = list()
		//membership roster to go through for updates and what not

	var/update = 1
	//var/datum/gas_mixture/air_transient = null

	New()
		//air_transient = new()

		..()

	proc/process()
		//Equalize gases amongst pipe if called for
		if(update)
			update = 0
			reconcile_air() //equalize_gases(gases)

		//Give pipelines their process call for pressure checking and what not. Have to remove pressure checks for the time being as pipes dont radiate heat - Mport
		//for(var/datum/pipeline/line_member in line_members)
		//	line_member.process()

	proc/build_network(obj/machinery/atmospherics/start_normal, obj/machinery/atmospherics/reference)
		//Purpose: Generate membership roster
		//Notes: Assuming that members will add themselves to appropriate roster in network_expand()

		if(!start_normal)
			qdel(src)

		start_normal.network_expand(src, reference)

		update_network_gases()

		if((normal_members.len>0)||(line_members.len>0))
			pipe_networks += src
		else
			qdel(src)

	proc/merge(datum/pipe_network/giver)
		if(giver==src) return 0

		normal_members |= giver.normal_members

		line_members |= giver.line_members

		for(var/obj/machinery/atmospherics/normal_member in giver.normal_members)
			normal_member.reassign_network(giver, src)

		for(var/datum/pipeline/line_member in giver.line_members)
			line_member.network = src

		update_network_gases()
		return 1

	proc/update_network_gases()
		//Go through membership roster and make sure gases is up to date

		gases = list()
		volume = 0

		for(var/obj/machinery/atmospherics/normal_member in normal_members)
			var/result = normal_member.return_network_air(src)
			if(result) gases += result

		for(var/datum/pipeline/line_member in line_members)
			gases += line_member.air
		
		for(var/datum/gas_mixture/air in gases)
			volume += air.volume

	proc/reconcile_air()
		equalize_gases(gases)
