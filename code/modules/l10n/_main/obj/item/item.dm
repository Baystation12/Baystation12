
/datum/lang/main/obj/item

	sign
		name = "sign"
		desc = null
		var/which_direction = "In which direction?"
		var/select_direction = "Select direction"

		proc/fasten(var/args)	return "You fasten \the [translation(args["sign"]) ? translation(args["sign"]) : "sign"] with your [translation(args["tool"]) ? translation(args["tool"]) : "screwdriver"]."