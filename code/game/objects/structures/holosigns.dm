/obj/structure/holosign
	name = "wet floor sign"
	desc = "The words flicker as if they mean nothing."
	anchored = TRUE
	icon = 'icons/obj/janitor_tools.dmi' // move these into their own dmi if we ever add more than 1 of these
	var/obj/item/holosign_creator/projector
	icon_state = "holosign"

/obj/structure/holosign/Initialize(maploading, source_projector)
	if(source_projector)
		projector = source_projector
		projector.signs += src
	. =..()

/obj/structure/holosign/Destroy()
	if(projector)
		projector.signs -= src
		projector = null
	return ..()

/obj/structure/holosign/attack_hand(mob/living/user)
	. =  ..()
	if(.)
		return
	visible_message(SPAN_NOTICE("\The [user] waves through \the [src], causing it to dissipate."))
	deactivate(user)


/obj/structure/holosign/use_weapon(obj/item/weapon, mob/user, list/click_params)
	SHOULD_CALL_PARENT(FALSE)
	user.visible_message(
		SPAN_WARNING("\The [user] swings \a [weapon] at \the [src], causing it to vanish."),
		SPAN_WARNING("You swing \the [weapon] at \the [src], causing it to vanish.")
	)
	deactivate(user)
	return TRUE


/obj/structure/holosign/use_tool(obj/item/tool, mob/user, list/click_params)
	SHOULD_CALL_PARENT(FALSE)
	user.visible_message(
		SPAN_NOTICE("\The [user] waves \a [tool] at \the [src], causing it to vanish."),
		SPAN_NOTICE("You wave \the [tool] at \the [src], causing it to vanish.")
	)
	deactivate(user)
	return TRUE


/obj/structure/holosign/proc/deactivate(mob/living/user)
	user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
	user.do_attack_animation(src)
	qdel(src)
