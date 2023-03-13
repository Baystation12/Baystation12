#define EVAC_OPT_ABANDON_SHIP "abandon_ship"
#define EVAC_OPT_BLUESPACE_JUMP "bluespace_jump"
#define EVAC_OPT_CANCEL_ABANDON_SHIP "cancel_abandon_ship"
#define EVAC_OPT_CANCEL_BLUESPACE_JUMP "cancel_bluespace_jump"
#define EVAC_OPT_CONFIRM_ABANDON "confirm_abandon"

// Apparently, emergency_evacuation --> "abandon ship" and !emergency_evacuation --> "bluespace jump"
// That stuff should be moved to the evacuation option datums but someone can do that later
/datum/evacuation_controller


/datum/evacuation_controller/starship/fast
	name = "escape pod controller"

	evac_prep_delay    = 0 MINUTES
	evac_launch_delay  = 5 MINUTES
	evac_transit_delay = 2 MINUTES

	transfer_prep_additional_delay     = 20 MINUTES
	autotransfer_prep_additional_delay = 10 MINUTES
	emergency_prep_additional_delay    = 3 MINUTES

	evacuation_options = list(
		EVAC_OPT_CONFIRM_ABANDON =  new /datum/evacuation_option/confirm_abandon(),
		EVAC_OPT_ABANDON_SHIP = new /datum/evacuation_option/abandon_ship/fast(),
		EVAC_OPT_BLUESPACE_JUMP = new /datum/evacuation_option/bluespace_jump/fast(),
		EVAC_OPT_CANCEL_ABANDON_SHIP = new /datum/evacuation_option/cancel_abandon_ship(),
		EVAC_OPT_CANCEL_BLUESPACE_JUMP = new /datum/evacuation_option/cancel_bluespace_jump()
	)


/datum/evacuation_controller/starship/fast/cancel_evacuation()
	var/emerg = emergency_evacuation
	. = ..()


	if(emerg)
		// Close the pods (space shields)
		for(var/obj/machinery/door/blast/regular/escape_pod/ES in world)
			INVOKE_ASYNC(ES, /obj/machinery/door/blast/proc/force_close)
		for (var/datum/shuttle/autodock/ferry/escape_pod/pod in escape_pods) // Unarm the pods!
			pod.set_self_unarm()

/datum/evacuation_controller/starship/fast/can_cancel()
	// Are we evacuating?
	if(isnull(evac_called_at))
		return 0
	// Have we already launched?
	if(!((state == 1) || (state == EVAC_LAUNCHING)))
		return 0
	// Are we already committed?
	if(world.time > evac_no_return)
		return 0
	return 1

/datum/evacuation_controller/starship/fast/make_prepared()
	var/time_diff = evac_ready_time - world.time
	evac_ready_time = world.time
	evac_launch_time -= time_diff
	evac_arrival_time -= time_diff
	evac_no_return -= time_diff

/datum/evacuation_controller/starship/fast/call_evacuation(var/mob/user, var/_emergency_evac, var/forced, var/skip_announce, var/autotransfer)
	if((user && isAI(user)) || forced)
		if(state == 1)
			make_prepared()
			return 1
		emergency_prep_additional_delay = 0 MINUTES
		confirmed = "confirmed"
		skip_announce = TRUE


	. = ..(user, _emergency_evac, forced, skip_announce, autotransfer)
	emergency_prep_additional_delay = initial(emergency_prep_additional_delay)	// Reseting time shortcut
	if(.)
		evac_no_return = evac_ready_time + round(evac_launch_delay/2)

/datum/evacuation_controller/starship/fast/available_evac_options()
	if (is_on_cooldown())
		return list()
	if (is_idle())
		return list(evacuation_options[EVAC_OPT_BLUESPACE_JUMP], evacuation_options[EVAC_OPT_ABANDON_SHIP])
	if (is_evacuating())
		if (emergency_evacuation)
			if(confirmed != "confirmed" && state == 1)
				return list(evacuation_options[EVAC_OPT_CONFIRM_ABANDON], evacuation_options[EVAC_OPT_CANCEL_ABANDON_SHIP])
			return list(evacuation_options[EVAC_OPT_CANCEL_ABANDON_SHIP])
		else
			return list(evacuation_options[EVAC_OPT_CANCEL_BLUESPACE_JUMP])

/datum/evacuation_controller/starship/fast/handle_evac_option(var/option_target, var/mob/user, var/force)
	var/datum/evacuation_option/selected = evacuation_options[option_target]
	if (!isnull(selected) && istype(selected))
		selected.execute(user, force)

/datum/evacuation_option/confirm_abandon
	option_text = "Подтвердить приказ об эвакуации"
	option_desc = "confirm abandonation"
	option_target = EVAC_OPT_CONFIRM_ABANDON
	needs_syscontrol = TRUE
	silicon_allowed = TRUE
	abandon_ship = TRUE

/datum/evacuation_option/confirm_abandon/execute(mob/user)
	if (!evacuation_controller)
		return
	if (evacuation_controller.confirmed == "confirmed")
		to_chat(user, "Протокол эвакуации уже исполняется.")
		return
	var/mob/living/carbon/human/H = user
	var/username = "Unknown"
	if (istype(H))
		username = H.get_id_name() == "confirmed" ? "Unknown" : H.get_id_name()	// If someone set ID name "confirmed"
	if (evacuation_controller.confirmed == username)
		to_chat(user, "Вы иницировали эвакуацию и не можете ее подтвердить.")
		return
	evacuation_controller.make_prepared()
	to_chat(user, "Протокол эвакуации подтвержден.")

/datum/evacuation_option/abandon_ship/fast
	option_text = "Покинуть судно"
	option_desc = "abandon the spacecraft"
	option_target = EVAC_OPT_ABANDON_SHIP
	needs_syscontrol = TRUE
	silicon_allowed = TRUE
	abandon_ship = TRUE

/datum/evacuation_option/abandon_ship/fast/execute(mob/user, var/force_evac = FALSE)
	if (!evacuation_controller)
		return
	if (evacuation_controller.deny)
		to_chat(user, "Невозможно иницировать процедуру эвакуации.")
		return
	if (evacuation_controller.is_on_cooldown())
		to_chat(user, evacuation_controller.get_cooldown_message())
		return
	if (evacuation_controller.is_evacuating())
		if(evacuation_controller.confirmed != "confirmed" && force_evac)
			to_chat(user, "Протокол эвакуации подтвержден.")
			evacuation_controller.make_prepared()
		else
			to_chat(user, "Протокол эвакуации уже исполняется.")
		return
	if(!user || isAI(user) || force_evac)
		evacuation_controller.emergency_prep_additional_delay = 0 MINUTES
		evacuation_controller.confirmed = "confirmed"
	if (evacuation_controller.call_evacuation(user, 1, 0, evacuation_controller.confirmed == "confirmed"))
		if(evacuation_controller.confirmed != "confirmed")
			evacuation_controller.confirmed = "Unknown"
			var/mob/living/carbon/human/H = user
			if(istype(H))
				evacuation_controller.confirmed = H.get_id_name() == "confirmed" ? "Unknown" : H.get_id_name()	// If someone set ID name "confirmed"
		log_and_message_admins("[user? key_name(user) : "Autotransfer"] has initiated abandonment of the spacecraft.")

/datum/evacuation_option/cancel_abandon_ship
	option_text = "Отменить эвакуацию"

/datum/evacuation_option/bluespace_jump/fast
	option_text = "Инициализировать блюспейс прыжок"

/datum/evacuation_option/bluespace_jump/fast/execute(mob/user)
	if (!evacuation_controller)
		return
	if (evacuation_controller.deny)
		to_chat(user, "Невозможно иницировать подготовку прыжка.")
		return
	if (evacuation_controller.is_on_cooldown())
		to_chat(user, evacuation_controller.get_cooldown_message())
		return
	if (evacuation_controller.is_evacuating())
		to_chat(user, "Процедуры подготовки прыжка уже зайдествованы.")
		return 0

/datum/evacuation_option/cancel_bluespace_jump
	option_text = "Отменить блюспейс прыжок"

#undef EVAC_OPT_CONFIRM_ABANDON
#undef EVAC_OPT_ABANDON_SHIP
#undef EVAC_OPT_BLUESPACE_JUMP
#undef EVAC_OPT_CANCEL_ABANDON_SHIP
#undef EVAC_OPT_CANCEL_BLUESPACE_JUMP
