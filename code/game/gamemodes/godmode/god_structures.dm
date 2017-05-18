/obj/structure/deity
	icon = 'icons/obj/cult.dmi'
	var/mob/living/deity/linked_god
	var/health = 10
	var/power_adjustment = 10 //How much power we get/lose
	var/build_cost = 0 //How much it costs to build this item.
	var/must_be_converted_turf = 1 //Whether we can only spawn this structure if it is near an altar.
	var/important_structure = 0 //Whether this structure is required to use certian spells/grant boons/etc
	density = 1
	anchored = 1
	icon_state = "tomealtar"

/obj/structure/deity/New(var/newloc, var/god)
	..(newloc)
	if(god)
		linked_god = god
		linked_god.form.sync_structure(src)
		linked_god.add_source(power_adjustment, src)

/obj/structure/deity/Destroy()
	if(linked_god)
		linked_god.add_source(-power_adjustment, src)
		linked_god = null
	return ..()

/obj/structure/deity/attackby(obj/item/W as obj, mob/user as mob)
	user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
	user.do_attack_animation(src)
	playsound(get_turf(src), 'sound/effects/Glasshit.ogg', 50, 1)
	user.visible_message(
		"<span class='danger'>[user] hits \the [src] with \the [W]!</span>",
		"<span class='danger'>You hit \the [src] with \the [W]!</span>",
		"<span class='danger'>You hear something breaking!</span>"
		)
	take_damage(W.force)

/obj/structure/deity/proc/take_damage(var/amount)
	health -= amount
	if(health < 0)
		src.visible_message("\The [src] crumbles!")
		qdel(src)

/obj/structure/deity/bullet_act(var/obj/item/projectile/P)
	take_damage(P.damage)

/obj/structure/deity/proc/attack_deity(var/mob/living/deity/deity)
	return

/obj/structure/deity/pylon
	name = "pylon"
	desc = "A crystal platform used to communicate with the deity."
	power_adjustment = 15
	important_structure = 1
	build_cost = 400
	icon_state = "pylon"
	var/datum/radio_frequency/radio_connection

/obj/structure/deity/pylon/New()
	..()
	radio_connection = radio_controller.add_object(src, 666, "deity")

/obj/structure/deity/pylon/attack_deity(var/mob/living/deity/D)
	if(D.pylon == src)
		D.leave_pylon()
	else
		D.possess_pylon(src)

/obj/structure/deity/pylon/Destroy()
	if(linked_god && linked_god.pylon == src)
		linked_god.leave_pylon()
	radio_connection = null
	radio_controller.remove_object(src, 666)
	return ..()

/obj/structure/deity/pylon/hear_talk(mob/M as mob, text, verb, datum/language/speaking)
	var/datum/signal/S = new()
	S.data = list("text" = text, "deity" = linked_god, "language" = speaking, "mob" = M, "verb" = verb)
	S.frequency = 666
	radio_connection.post_signal(src,S,"deity")
	if(linked_god)
		to_chat(linked_god, "\icon[src] <span class='game say'><span class='name'>[M]</span> (<A href='?src=\ref[linked_god];pylon=\ref[src];'>P</A>) [verb], [linked_god.pylon == src ? "<b>" : ""]<span class='message'><span class='body'>\"[text]\"</span></span>[linked_god.pylon == src ? "</b>" : ""]</span>")

/obj/structure/deity/pylon/receive_signal(var/datum/signal/s)
	if(s.data["deity"] && s.data["deity"] == linked_god)
		var/list/mobs = list()
		var/list/objs = list()
		get_mobs_and_objs_in_view_fast(get_turf(src), mobs, objs, 0) //Ghosts will get the message already.
		for(var/o in objs)
			if(istype(o, /obj/structure/deity/pylon)) //Pls no feedback loop.
				continue
			var/obj/O = o
			O.hear_talk(s.data["mob"], s.data["text"], s.data["verb"], s.data["language"])
		for(var/m in mobs)
			var/mob/M = m
			M.hear_say(s.data["text"], s.data["verb"], s.data["language"], italics = 1, speaker = s.data["mob"])