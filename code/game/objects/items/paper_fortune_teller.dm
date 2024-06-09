// Mostly exists as a demo for the FSM extension.
/obj/item/paper_fortune_teller
	name = "paper fortune teller"
	desc = "Origami, for children."
	icon_state = "fortune"
	icon = 'icons/obj/fortune_teller.dmi'
	var/choice_counter = 0
	var/busy = FALSE
	var/list/fortunes = new(8)
	var/static/list/possible_fortunes = list(
		"You will fall down an elevator shaft.",
		"Today it's up to you to create the peacefulness you long for.",
		"If you refuse to accept anything but the best, you very often get it.",
		"A smile is your passport into the hearts of others.",
		"Hard work pays off in the future, laziness pays off now.",
		"Change can hurt, but it leads a path to something better.",
		"Hidden in a valley beside an open stream- This will be the type of place where you will find your dream.",
		"Never give up. You're not a failure if you don't give up.",
		"Love can last a lifetime, if you want it to.",
		"The love of your life is stepping into your planet this summer.",
		"Your ability for accomplishment will follow with success.",
		"Please help me, I'm trapped in a fortune cookie factory!",
		"Improve, don't remove.",
		"Run.",
		"Please wake up."
	)

/obj/item/paper_fortune_teller/Initialize(ml, material_key)
	var/list/fortune_options = possible_fortunes.Copy()
	for(var/i = 1 to length(fortunes))
		fortunes[i] = pick_n_take(fortune_options)
	add_state_machine(src, /datum/state_machine/paper_fortune)
	. = ..()

/obj/item/paper_fortune_teller/on_update_icon()
	var/datum/state_machine/fsm = get_state_machine(src, /datum/state_machine/paper_fortune)
	if(fsm && istype(fsm.current_state, /singleton/state/paper_fortune))
		var/singleton/state/paper_fortune/fsm_state = fsm.current_state
		icon_state = "[initial(icon_state)]-[fsm_state.icon_state]"

/obj/item/paper_fortune_teller/attack_self(mob/user)
	var/datum/state_machine/fsm = get_state_machine(src, /datum/state_machine/paper_fortune)
	if(!fsm || !istype(fsm.current_state, /singleton/state/paper_fortune))
		to_chat(user, SPAN_WARNING("You can't seem to work out how \the [src] works."))
		return TRUE

	var/singleton/state/paper_fortune/fsm_state = fsm.current_state
	var/current_fsm = get_state_machine(src, /datum/state_machine/paper_fortune)
	if(current_fsm != fsm || fsm_state != fsm.current_state || QDELETED(src) || QDELETED(user) || loc != user)
		return TRUE

	var/option = input(user, "Select an option.", "Fortune Teller") as null|anything in fsm_state.fortune_choices
	current_fsm = get_state_machine(src, /datum/state_machine/paper_fortune)
	if(!option || current_fsm != fsm || fsm_state != fsm.current_state || QDELETED(src) || QDELETED(user) || loc != user)
		return TRUE

	choice_counter++
	if(choice_counter >= 3)
		to_chat(user, SPAN_NOTICE("The fortune under fold [option] reads: \"[fortunes[option] || "???"]\""))
		fsm.evaluate()
	else if(istext(option))
		to_chat(user, SPAN_NOTICE("You pick '[option]'."))
		alternate_by_color(option, user)
	else if(isnum(option))
		to_chat(user, SPAN_NOTICE("You pick '[option]'."))
		alternate_by_number(option, user)
	else
		to_chat(user, SPAN_WARNING("You can't seem to work out how to use \the [src]."))
	return TRUE

/obj/item/paper_fortune_teller/proc/alternate(amount, mob/user)
	busy = TRUE
	for(var/i = 1 to amount)
		advance()
		if(user)
			user.visible_message(SPAN_NOTICE("\The [user] opens and closes \the [src]."))
		sleep(0.5 SECONDS)
		if(QDELETED(src))
			break
	busy = FALSE

/// Alternates between two states based on the length of the color chosen.
/// E.g. 'Red' makes it switch three times. 'Yellow' does it six times, etc.
/obj/item/paper_fortune_teller/proc/alternate_by_color(color_word, mob/user)
	alternate(length(color_word), user)

/obj/item/paper_fortune_teller/proc/alternate_by_number(number, mob/user)
	alternate(number, user)

/obj/item/paper_fortune_teller/proc/advance()
	var/datum/state_machine/fsm = get_state_machine(src, /datum/state_machine/paper_fortune)
	if(fsm)
		fsm.evaluate()
