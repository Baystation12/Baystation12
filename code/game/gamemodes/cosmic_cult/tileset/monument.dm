/obj/cosmic_cult/monument
	name = "\improper The Monument"
	desc = "Built of a thousand little nothings, its surface reflects a starless emptiness..."
	icon = 'icons/coscult/cosmic-monument.dmi'
	icon_state = "base"
	pixel_x = -32
	bound_x = -32
	bound_width = 96
	density = TRUE
	anchored = TRUE
	layer = ABOVE_LIGHTING_LAYER

/obj/cosmic_cult/monument/Initialize()
	. = ..()
	update_icon()

/obj/cosmic_cult/monument/on_update_icon()
	set_light(6, 1, "#42a4ae")

/obj/cosmic_cult/monument/attack_hand(mob/living/user)
	set waitfor = FALSE

	if (!is_cosmic_cultist(user))
		to_chat(user, SPAN_CLASS("malign", "You reach out to [src], and [src] reaches back out to you. It shouldn't be here."))
		return

	var/datum/cosmic_cultist/cultist = user.mind.cosmic_cultist
	var/influence = cultist.try_begin_get_new_influence()

	if (isnull(influence))
		to_chat(user, SPAN_CLASS("malign", "[src] has nothing to give to you. Return when you have acquired more power."))
		return

	var/instance = cultist.get_power_instance(influence)
	cosmic_cult_shockwave_vfx(get_step(src, NORTH))
	cosmic_cult_monument_influence(src)
	cosmic_cult_monument_projectile(src, user)
	cosmic_cult_monument_influence_icon(user, instance)

	sleep(3 SECONDS)
	cultist.finish_get_new_influence()
