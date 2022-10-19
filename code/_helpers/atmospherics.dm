/obj/proc/analyze_gases(obj/A, mob/user, mode)
	user.visible_message(SPAN_NOTICE("\The [user] has used \an [src] on \the [A]."))
	A.add_fingerprint(user)

	var/air_contents = A.return_air()
	if(!air_contents)
		to_chat(user, SPAN_WARNING("Your [src] flashes a red light as it fails to analyze \the [A]."))
		return 0

	var/list/result = atmosanalyzer_scan(A, air_contents, mode)
	print_atmos_analysis(user, result)
	return 1

/proc/print_atmos_analysis(user, list/result)
	to_chat(user, SPAN_NOTICE("[result]"))
