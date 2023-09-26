/obj/structure/fountain
	name = "fountain"
	desc = "A beautifully constructed fountain."
	icon = 'icons/obj/structures/fountain.dmi'
	icon_state = "fountain_g"
	density = TRUE
	anchored = TRUE
	unacidable = TRUE
	pixel_x = -16


/obj/structure/fountain/strange
	name = "strange fountain"
	desc = "The water from the spout is still as if frozen in time, yet the water in the base ripples perpetually."
	icon_state = "fountain"
	var/used = FALSE


/obj/structure/fountain/strange/Initialize()
	. = ..()
	light_color = get_random_colour(lower = 190)
	set_light(5, 0.6, light_color)


/obj/structure/fountain/strange/attack_hand(mob/living/user)
	if(user.incapacitated())
		return
	if(!CanPhysicallyInteract(user))
		return
	if(used)
		to_chat(user, "\The [src] is still and lifeless...")
		return
	if(!ishuman(user) || user.isSynthetic())
		to_chat(user, "Try as you might to touch the fountain, some force prevents you from doing so.")
		return
	if(alert("As you reach out to touch the fountain, a feeling of doubt overcomes you. Steel yourself and proceed?",,"Yes", "No") == "Yes")
		visible_message("\The [user] touches \the [src].")
		time_dilation(user)
	else
		visible_message("\The [user] retracts their hand suddenly.")


/obj/structure/fountain/strange/proc/time_dilation(mob/living/carbon/human/user)
	for(var/mob/living/L in oviewers(7, src))
		L.flash_eyes(3)
		L.eye_blurry += 9
	visible_message(SPAN_WARNING("\The [src] erupts in a bright flash of light!"))
	playsound(src,'sound/items/time.ogg',100)
	if(rand(1, 6) == 1 || user.age < 18)
		to_chat(user, SPAN_CLASS("cultannounce", "You touch the fountain. All the memories of your life seem to fade into the distant past as seconds drag like years. You feel the inexplicable sensation of your skin tightening and thinning across your entire body as your muscles degrade and your joints weaken. Time returns to its 'normal' pace. You can only just barely remember touching the fountain."))
		user.change_hair_color(80, 80, 80)
		user.changed_age = rand(15, 20)
	else
		to_chat(user, SPAN_CLASS("cultannounce", "You touch the fountain. Everything stops - then reverses. You relive in an instant the events of your life. The fountain, yesterday's lunch, your first love, your first kiss. It all feels as though it just happened moments ago. Then it feels like it never happened at all. Time reverses back into normality and continues its advance. You feel great, but why are you here?"))
		user.changed_age = rand(15, 17) - user.age
	used = TRUE
	desc = "The water flows beautifully from the spout, but the water in the pool does not ripple."
