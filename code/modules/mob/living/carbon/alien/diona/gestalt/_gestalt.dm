/obj/structure/diona_gestalt
	name = "nascent diona gestalt"
	desc = "A heaving mass of nymphs. Chirp?"
	icon = 'icons/mob/gestalt.dmi'
	icon_state = "gestalt"
	density = TRUE
	opacity = FALSE
	anchored = FALSE
	movement_handlers = list(/datum/movement_handler/deny_multiz, /datum/movement_handler/delay = list(5))
	appearance_flags = DEFAULT_APPEARANCE_FLAGS | PIXEL_SCALE

	var/list/nymphs                  = list()
	var/list/valid_things_to_roll_up = list(/mob/living/carbon/alien/diona = TRUE, /mob/living/carbon/alien/diona/sterile = TRUE)
	var/list/democracy_bucket        = list("Change to a humanoid form." = /datum/gestalt_vote/form_change_humanoid)
	var/tmp/image/eyes_overlay
	var/tmp/datum/gestalt_vote/current_vote

/obj/structure/diona_gestalt/mob_breakout(var/mob/living/escapee)
	. = ..()
	shed_atom(escapee)
	return TRUE

/obj/structure/diona_gestalt/Initialize(var/mapload)
	eyes_overlay = image(icon = icon, icon_state = "eyes_gestalt")
	eyes_overlay.layer = EYE_GLOW_LAYER
	eyes_overlay.plane = EFFECTS_ABOVE_LIGHTING_PLANE
	update_icon()
	. = ..(mapload)

/obj/structure/diona_gestalt/on_update_icon()
	overlays = list(eyes_overlay)
	if(nymphs && nymphs.len)
		var/matrix/M = matrix()
		M.Scale(Clamp(nymphs.len * 0.1, 1, 2))
		transform = M
	else
		transform = null

/obj/structure/diona_gestalt/Destroy()
	for(var/thing in contents)
		var/atom/movable/AM = thing
		AM.dropInto(loc)
	nymphs.Cut()
	democracy_bucket.Cut()
	QDEL_NULL(current_vote)
	. = ..()

/obj/structure/diona_gestalt/examine(mob/user)
	. = ..()
	if(nymphs) to_chat(user, "It seems to be composed of at least [nymphs.len] nymph\s.")
