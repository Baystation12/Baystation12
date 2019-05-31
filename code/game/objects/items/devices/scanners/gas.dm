/obj/item/device/scanner/gas
	name = "gas analyzer"
	desc = "A hand-held environmental scanner which reports current gas levels."
	icon_state = "atmos"
	item_state = "analyzer"

	origin_tech = list(TECH_MAGNET = 1, TECH_ENGINEERING = 1)
	window_width = 350
	window_height = 400
	var/advanced_mode = 0

/obj/item/device/scanner/gas/verb/verbosity(mob/user)
	set name = "Toggle Advanced Gas Analysis"
	set category = "Object"
	set src in usr

	if (!user.incapacitated())
		advanced_mode = !advanced_mode
		to_chat(user, "You toggle advanced gas analysis [advanced_mode ? "on" : "off"].")

/obj/item/device/scanner/gas/is_valid_scan_target(atom/O)
	return istype(O)

/obj/item/device/scanner/gas/scan(atom/A, mob/user)
	var/air_contents = A.return_air()
	if(!air_contents)
		to_chat(user, "<span class='warning'>Your [src] flashes a red light as it fails to analyze \the [A].</span>")
		return
	scan_data = atmosanalyzer_scan(A, air_contents, advanced_mode)
	scan_data = jointext(scan_data, "<br>")
	user.show_message(SPAN_NOTICE(scan_data))