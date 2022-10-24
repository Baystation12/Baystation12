/singleton/state/paper_fortune
	var/state_name
	var/list/fortune_choices
	var/icon_state = "closed"

/singleton/state/paper_fortune/entered_state(datum/holder)
	var/obj/item/paper_fortune_teller/P = holder
	P.update_icon()

// The starting point.
/singleton/state/paper_fortune/closed
	transitions = list(/singleton/state_transition/paper_fortune/closed_to_open_vertical)
	state_name = "closed"
	fortune_choices = list(
		"Red" = "#ff8888",
		"Green" = "#88ff88",
		"Blue" = "#8888ff",
		"Yellow" = "#ffff88"
	)

/singleton/state/paper_fortune/closed/entered_state(datum/holder)
	..()
	var/obj/item/paper_fortune_teller/P = holder
	P.choice_counter = 0

// Alternates between this and the below state.
/singleton/state/paper_fortune/open_vertical
	transitions = list(
		/singleton/state_transition/paper_fortune/vertical_to_horizontal,
		/singleton/state_transition/paper_fortune/open_to_closed
	)
	state_name = "open vertically"
	fortune_choices = list(1, 3, 5, 7)
	icon_state = "open-vert"

/singleton/state/paper_fortune/open_horizontal
	transitions = list(
		/singleton/state_transition/paper_fortune/horizontal_to_vertical,
		/singleton/state_transition/paper_fortune/open_to_closed
	)
	state_name = "open horizontally"
	fortune_choices = list(2, 4, 6, 8)
	icon_state = "open-hori"

/singleton/state_transition/paper_fortune/closed_to_open_vertical
	target = /singleton/state/paper_fortune/open_vertical

/singleton/state_transition/paper_fortune/closed_to_open_vertical/is_open(datum/holder)
	return TRUE

/singleton/state_transition/paper_fortune/open_to_closed
	target = /singleton/state/paper_fortune/closed

/singleton/state_transition/paper_fortune/open_to_closed/is_open(datum/holder)
	var/obj/item/paper_fortune_teller/P = holder
	return P.choice_counter >= 3

/singleton/state_transition/paper_fortune/vertical_to_horizontal
	target = /singleton/state/paper_fortune/open_horizontal

/singleton/state_transition/paper_fortune/vertical_to_horizontal/is_open(datum/holder)
	var/obj/item/paper_fortune_teller/P = holder
	return P.choice_counter < 3

/singleton/state_transition/paper_fortune/horizontal_to_vertical
	target = /singleton/state/paper_fortune/open_vertical

/singleton/state_transition/paper_fortune/horizontal_to_vertical/is_open(datum/holder)
	var/obj/item/paper_fortune_teller/P = holder
	return P.choice_counter < 3

/datum/state_machine/paper_fortune
	current_state = /singleton/state/paper_fortune/closed
