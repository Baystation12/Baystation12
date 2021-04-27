/spell/targeted/ethereal_jaunt/shift
	name = "Phase Shift"
	desc = "This spell allows you to pass through walls."

	charge_max = 20 SECONDS
	spell_flags = Z2NOCAST | INCLUDEUSER | CONSTRUCT_CHECK
	invocation_type = SpI_NONE
	duration = 5 SECONDS
	reappear_duration = 1.2 SECONDS

	hud_state = "const_shift"

/spell/targeted/ethereal_jaunt/shift/jaunt_disappear(var/atom/movable/overlay/animation, var/mob/living/target)
	to_chat(target, SPAN_DANGER("You silently phase out.")) // no visible message - phase shift is silent
	animation.icon_state = "phase_shift"
	animation.dir = target.dir
	flick("phase_shift", animation)

/spell/targeted/ethereal_jaunt/shift/jaunt_reappear(var/atom/movable/overlay/animation, var/mob/living/target)
	to_chat(target, SPAN_DANGER("You return from your jaunt."))
	animation.icon_state = "phase_shift2"
	animation.dir = target.dir
	flick("phase_shift2", animation)

/spell/targeted/ethereal_jaunt/shift/jaunt_steam(var/mobloc)
	return
