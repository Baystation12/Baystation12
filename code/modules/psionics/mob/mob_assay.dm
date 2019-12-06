/mob/living/proc/show_psi_assay(var/mob/viewer, var/obj/machinery/psi_meter/machine)

	if(!viewer) viewer = usr

	var/use_He_is =  "You are"
	var/use_He_has = "You have"
	if(istype(machine) || viewer != src)
		var/datum/gender/G = gender_datums[gender]
		use_He_is =  "[G.He] [G.is]"
		use_He_has = "[G.He] [G.has]"

	var/list/dat = list()

	dat += "<h2>Summary</h2>"
	dat += "<hr>"

	if(psi)

		// Hi Warhammer 40k rating system, how are you?
		// I hope you get along with the Galactic Milieu metapsychics.
		var/use_rating
		var/effective_rating = psi.rating
		if(effective_rating > 1 && psi.suppressed)
			effective_rating = max(0, psi.rating-2)
		var/rating_descriptor
		if(mind && !psi.suppressed)
			if(GLOB.paramounts.is_antagonist(mind))
				use_rating = "<font color = '#FF0000'><b>[effective_rating]-Alpha-Plus</b></font>"
				rating_descriptor = "This indicates a completely deviant psi complexus, either beyond or outside anything currently recorded. Approach with care."
			// This space intentionally left blank (for Omega-Minus psi vampires. todo)
			if(viewer != usr && GLOB.thralls.is_antagonist(mind) && ishuman(viewer))
				var/mob/living/H = viewer
				if(H.psi && H.psi.get_rank(PSI_REDACTION) >= PSI_RANK_GRANDMASTER)
					dat += "<font color='#FF0000'><b>Their mind has been cored like an apple, and enslaved by another operant psychic.</b></font>" // <A href='?src=\ref[H.psi];clear_thralldom=\ref[psi]'>>Attempt to remove</a>"

		if(!use_rating)
			switch(effective_rating)
				if(1)
					use_rating = "[effective_rating]-Epsilon"
					rating_descriptor = "This indicates the presence of minor latent psi potential with little or no operant capabilities."
				if(2)
					use_rating = "[effective_rating]-Gamma"
					rating_descriptor = "This indicates the presence of minor psi capabilities of the Operant rank or higher."
				if(3)
					use_rating = "<font color = '#F4F441'>[effective_rating]-Delta</font>"
					rating_descriptor = "This indicates the presence of psi capabilities of the Master rank or higher."
				if(4)
					use_rating = "<font color = '#F4BC42'>[effective_rating]-Beta</font>"
					rating_descriptor = "This indicates the presence of significant psi capabilities of the Grandmaster rank or higher."
				if(5)
					use_rating = "<font color = '#FF0000'>[effective_rating]-Alpha</font>"
					rating_descriptor = "This indicates the presence of major psi capabilities of the Paramount Grandmaster rank or higher."
				else
					use_rating = "[effective_rating]-Lambda"
					rating_descriptor = "This indicates the presence of trace latent psi capabilities."

		dat += "[use_He_has] an overall psi rating of [use_rating].<br><i>[rating_descriptor]</i><hr>"

		if(!istype(machine))

			dat += "[use_He_is] currently <b>[psi.suppressed ? "suppressing" : "not suppressing"]</b> your psychic operancy.<br>"
			dat += "[use_He_has] <b>[psi.stamina]/[psi.max_stamina]</b> psi stamina remaining.<br>"
			dat += "<hr>"

			for(var/faculty_id in psi.ranks)
				var/decl/psionic_faculty/faculty = SSpsi.get_faculty(faculty_id)
				if(psi.ranks[faculty.id] > 0)
					dat += "[use_He_is] assayed at the rank of <b>[GLOB.psychic_ranks_to_strings[psi.ranks[faculty.id]]]</b> for the <b>[faculty.name] faculty</b>.<br>"
				else
					dat += "[use_He_has] no notable power within the <b>[faculty.name] faculty</b>.<br>"
			dat += "<hr>"

			if(viewer == usr)
				dat += "<table width = 100% border = 1><tr><td colspan = 2><h2>Psi-power Usage</h2></td></tr>"
				for(var/faculty_id in psi.ranks)
					var/list/check_powers = psi.get_powers_by_faculty(faculty_id)
					if(LAZYLEN(check_powers))
						var/decl/psionic_faculty/faculty = SSpsi.get_faculty(faculty_id)
						dat += "<tr><td colspan = 2>[use_He_has] access to the following psi-powers within the <b>[faculty.name] faculty</b>:</td></tr>"
						for(var/decl/psionic_power/power in check_powers)
							dat += "<tr><td><b>[power.name]</b></td><td>[power.use_description]</td></tr>"
				dat += "</table>"
	else
		dat += "[use_He_has] no notable psychic latency or operancy."

	if(istype(machine))
		dat += "<a href='?src=\ref[machine];print=1'>Print</a> <a href='?src=\ref[machine];clear=1'>Clear Buffer</a>"
		machine.last_assay = dat
		return

	var/datum/browser/popup = new(viewer, "psi_assay_\ref[src]", "Psi-Assay")
	popup.set_content(jointext(dat,null))
	popup.open()
