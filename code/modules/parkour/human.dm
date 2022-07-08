/mob/living/carbon/human
	var/is_parkourmode = FALSE
	var/parkourthrought = FALSE
	var/obj/screen/parkour/parkour

/mob/living/carbon/human/proc/do_parkour(var/turf/target)
	var/old_pass_flags = src.pass_flags
	src.pass_flags |= PASS_FLAG_TABLE
	jump_layer_shift()
	animate(src, pixel_z = 16, time = 3, easing = SINE_EASING | EASE_IN)
	animate(pixel_z = default_pixel_z, time = 3, easing = SINE_EASING | EASE_OUT)
	var/yo = abs(round(target.y - loc.y, 1))
	var/xo = abs(round(target.x - loc.x, 1))

	src.throw_at(target, min(max(yo, xo), 5), 1, src, FALSE, CALLBACK(src, /mob/living/carbon/human/proc/end_parkour, target, old_pass_flags))
	addtimer(CALLBACK(src, /mob/living/proc/jump_layer_shift_end), 4.5)

/mob/living/carbon/human/proc/end_parkour(var/atom/target, var/pass_flag)
	src.pass_flags = pass_flag

/obj/screen/parkour
	name = "parkour"
	desc = "LMB - Turn on/off parkour mode\nALT + LMB - Turn on/off jump throught mode"
	icon = 'icons/mob/screen1_White.dmi'
	icon_state = "parkour0"
	var/image/passthrought

/obj/screen/parkour/Click(var/location, var/control, var/params)
	var/mob/living/carbon/human/user = usr
	var/list/p = params2list(params)

	if(p["alt"] && user.skill_check(SKILL_HAULING, SKILL_EXPERT))
		user.parkourthrought = !user.parkourthrought
		if(user.parkourthrought)
			overlays += passthrought
		else
			overlays -= passthrought
		to_chat(user, SPAN_INFO(user.parkourthrought ? "Now you will jump throw objects." : "Now you will jump on the objects."))

	else if (!p["shift"] && user.skill_check(SKILL_HAULING, SKILL_ADEPT))
		user.is_parkourmode = !user.is_parkourmode
		icon_state = "parkour[user.is_parkourmode]"
		to_chat(user, SPAN_INFO(user.is_parkourmode ? "Now you will parkour. Yay!" : "You are no longer parkour now."))

	else
		to_chat(user, SPAN_WARNING("You don't have enough skill!"))
