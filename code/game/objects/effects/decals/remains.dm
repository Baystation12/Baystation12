/obj/item/remains
	name = "remains"
	gender = PLURAL
	icon = 'icons/effects/blood.dmi'
	icon_state = "remains"
	anchored = FALSE

/obj/item/remains/human
	desc = "They look like human remains. They have a strange aura about them."

/obj/effect/decal/remains	// Apparently used by cult somewhere?
	desc = "They look like human remains. They have a strange aura about them."
	icon = 'icons/effects/blood.dmi'
	icon_state = "remains"

/obj/item/remains/xeno
	desc = "They look like the remains of something... alien. They have a strange aura about them."
	icon_state = "remainsxeno"

/obj/item/remains/robot
	desc = "They look like the remains of something mechanical. They have a strange aura about them."
	icon = 'icons/mob/robots_gibs.dmi'
	icon_state = "remainsrobot"

/obj/item/remains/mouse
	desc = "They look like the remains of a small rodent."
	icon_state = "mouse"

/obj/item/remains/lizard
	desc = "They look like the remains of a small rodent."
	icon_state = "lizard"

/obj/item/remains/attack_hand(mob/user as mob)
	to_chat(user, "<span class='notice'>[src] sinks together into a pile of ash.</span>")
	var/turf/simulated/floor/F = get_turf(src)
	if (istype(F))
		new /obj/effect/decal/cleanable/ash(F)
	qdel(src)

/obj/item/remains/robot/attack_hand(mob/user as mob)
	return
