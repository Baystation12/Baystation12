/datum/build_mode/ladders
	name = "Ladders"
	icon_state = "buildmode6"
	var/turf/ladder_upper
	var/turf/ladder_lower

/datum/build_mode/ladders/Help()
	to_chat(user, "<span class='notice'>***********************************************************</span>")
	to_chat(user, "<span class='notice'>Left Click on Turf   = Set as upper ladder loc</span>")
	to_chat(user, "<span class='notice'>Right Click on Turf  = Set as lower ladder loc</span>")
	to_chat(user, "<span class='notice'>As soon as both points have been selected, the ladder is created.</span>")
	to_chat(user, "<span class='notice'>***********************************************************</span>")

/datum/build_mode/ladders/OnClick(var/atom/A, var/list/parameters)
	if(parameters["left"])
		ladder_upper = get_turf(A)
		to_chat(user, "<span class='notice'>Defined [ladder_upper] ([ladder_upper.type]) as the upper ladder location.</span>")
	if(parameters["right"])
		ladder_lower = get_turf(A)
		to_chat(user, "<span class='notice'>Defined [ladder_lower] ([ladder_lower.type]) as the lower ladder location.</span>")
	if(ladder_upper && ladder_lower)
		to_chat(user, "<span class='notice'>Ladder locations set, building ladders.</span>")
		Log("Created a ladder between '[log_info_line(ladder_upper)]' and '[log_info_line(ladder_lower)]'.")
		var/obj/structure/ladder/upper = new /obj/structure/ladder(ladder_upper)
		var/obj/structure/ladder/lower = new /obj/structure/ladder/up(ladder_lower)
		upper.target_down = lower
		lower.target_up = upper
		ladder_upper = null
		ladder_lower = null
