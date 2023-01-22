/obj/item/implant/psi_control
	name = "psi dampener implant"
	desc = "A safety implant for registered psi-operants."
	known = TRUE

	var/overload = 0
	var/max_overload = 100
	var/psi_mode = PSI_IMPLANT_AUTOMATIC

/obj/item/implant/psi_control/islegal()
	return TRUE

/obj/item/implant/psi_control/Initialize()
	. = ..()
	SSpsi.psi_dampeners += src

/obj/item/implant/psi_control/Destroy()
	SSpsi.psi_dampeners -= src
	. = ..()

/obj/item/implant/psi_control/emp_act()
	..()
	update_functionality()

/obj/item/implant/psi_control/meltdown()
	. = ..()
	update_functionality()

/obj/item/implant/psi_control/disrupts_psionics()
	var/use_psi_mode = get_psi_mode()
	return (!malfunction && (use_psi_mode == PSI_IMPLANT_SHOCK || use_psi_mode == PSI_IMPLANT_WARN)) ? src : FALSE

/obj/item/implant/psi_control/removed()
	var/mob/living/M = imp_in
	if(disrupts_psionics() && istype(M) && M.psi)
		to_chat(M, SPAN_NOTICE("You feel the chilly shackles around your psionic faculties fade away."))
	. = ..()

/obj/item/implant/psi_control/proc/update_functionality(var/silent)
	var/mob/living/M = imp_in
	if(get_psi_mode() == PSI_IMPLANT_DISABLED || malfunction)
		if(implanted && !silent && istype(M) && M.psi)
			to_chat(M, SPAN_NOTICE("You feel the chilly shackles around your psionic faculties fade away."))
	else
		if(implanted && !silent && istype(M) && M.psi)
			to_chat(M, SPAN_NOTICE("Bands of hollow ice close themselves around your psionic faculties."))

/obj/item/implant/psi_control/meltdown()
	if(!malfunction)
		overload = 100
		if(imp_in)
			for(var/thing in SSpsi.psi_monitors)
				var/obj/machinery/psi_monitor/monitor = thing
				monitor.report_failure(src)
	. = ..()

/obj/item/implant/psi_control/proc/get_psi_mode()
	if(psi_mode == PSI_IMPLANT_AUTOMATIC)
		var/decl/security_state/security_state = decls_repository.get_decl(GLOB.using_map.security_state)
		return security_state.current_security_level.psionic_control_level
	return psi_mode

/obj/item/implant/psi_control/withstand_psi_stress(var/stress, var/atom/source)

	var/use_psi_mode = get_psi_mode()

	if(malfunction || use_psi_mode == PSI_IMPLANT_DISABLED)
		return stress

	. = 0

	if(stress > 0)

		// If we're disrupting psionic attempts at the moment, we might overload.
		if(disrupts_psionics())
			var/overload_amount = Floor(stress/10)
			if(overload_amount > 0)
				overload += overload_amount
				if(overload >= 100)
					if(imp_in)
						to_chat(imp_in, SPAN_DANGER("Your psi dampener overloads violently!"))
					meltdown()
					update_functionality()
					return
				if(imp_in)
					if(overload >= 75 && overload < 100)
						to_chat(imp_in, SPAN_DANGER("Your psi dampener is searing hot!"))
					else if(overload >= 50 && overload < 75)
						to_chat(imp_in, SPAN_WARNING("Your psi dampener is uncomfortably hot..."))
					else if(overload >= 25 && overload < 50)
						to_chat(imp_in, SPAN_WARNING("You feel your psi dampener heating up..."))

		// If all we're doing is logging the incident then just pass back stress without changing it.
		if(source && source == imp_in && implanted)
			for(var/thing in SSpsi.psi_monitors)
				var/obj/machinery/psi_monitor/monitor = thing
				monitor.report_violation(src, stress)
			if(use_psi_mode == PSI_IMPLANT_LOG)
				return stress
			else if(use_psi_mode == PSI_IMPLANT_SHOCK)
				to_chat(imp_in, SPAN_DANGER("Your psi dampener punishes you with a violent neural shock!"))
				imp_in.flash_eyes()
				imp_in.Weaken(5)
				if(isliving(imp_in))
					var/mob/living/M = imp_in
					if(M.psi) M.psi.stunned(5)
			else if(use_psi_mode == PSI_IMPLANT_WARN)
				to_chat(imp_in, SPAN_WARNING("Your psi dampener primly informs you it has reported this violation."))
