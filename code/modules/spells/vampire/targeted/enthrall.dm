
// Enthralls a person, giving the vampire a mortal slave.
/spell/targeted/vampire/enthrall
	name = "Enthrall"
	desc = "Bind a mortal soul with a bloodbond to obey your every command."
	charge_max = 280 SECONDS //A little more than 4:30.
	blood_cost = 150

/spell/targeted/vampire/enthrall/cast(var/obj/item/grab/G)
	var/datum/vampire/vampire = vampire_power(150, 0)
	if (!vampire)
		return

	var/obj/item/grab/G = get_active_hand()
	if (!istype(G))
		to_chat(src, "<span class='warning'>You must be grabbing a victim in your active hand to enthrall them.</span>")
		return
/*
	if (!(G.can_enthrall()))
		to_chat(src, "<span class='warning'>You must have the victim pinned to the ground to enthrall them.</span>")
		return
*/
	var/mob/living/carbon/human/T = G.affecting
	if (!istype(T))
		to_chat(src, "<span class='warning'>[T] is not a creature you can enthrall.</span>")
		return

	if (!T.client || !T.mind)
		to_chat(src, "<span class='warning'>[T]'s mind is empty and useless. They cannot be forced into a blood bond.</span>")
		return

	if (vampire.status & VAMP_DRAINING)
		to_chat(src, "<span class='warning'>Your fangs are already sunk into a victim's neck!</span>")
		return

	visible_message("<span class='danger'>[src] tears the flesh on their wrist, and holds it up to [T]. In a gruesome display, [T] starts lapping up the blood that's oozing from the fresh wound.</span>", "<span class='warning'>You inflict a wound upon yourself, and force them to drink your blood, thus starting the conversion process.</span>")
	to_chat(T, "<span class='warning'>You feel an irresistable desire to drink the blood pooling out of [src]'s wound. Against your better judgement, you give in and start doing so.</span>")

	if (!do_mob(src, T, 50))
		visible_message("<span class='danger'>[src] yanks away their hand from [T]'s mouth as they're interrupted, the wound quickly sealing itself!</span>", "<span class='danger'>You are interrupted!</span>")
		return

	to_chat(T, "<span class='danger'>Your mind blanks as you finish feeding from [src]'s wrist.</span>")
	vampire_thrall.add_antagonist(T.mind, 1, 1, 0, 1, 1)

	T.mind.vampire.master = src
	vampire.thralls += T
	to_chat(T, "<span class='notice'>You have been forced into a blood bond by [T.mind.vampire.master], and are thus their thrall. While a thrall may feel a myriad of emotions towards their master, ranging from fear, to hate, to love; the supernatural bond between them still forces the thrall to obey their master, and to listen to the master's commands.<br><br>You must obey your master's orders, you must protect them, you cannot harm them.</span>")
	to_chat(src, "<span class='notice'>You have completed the thralling process. They are now your slave and will obey your commands.</span>")
	admin_attack_log(src, T, "enthralled [key_name(T)]", "was enthralled by [key_name(src)]", "successfully enthralled")
