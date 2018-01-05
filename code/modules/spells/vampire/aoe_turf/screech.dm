// Chiropteran Screech

/spell/aoe_turf/vampire/screech

	name = "Chiropteran Screech (90)"
	desc = "Emit a powerful screech which shatters glass within a seven-tile radius, and stuns hearers in a four-tile radius."
	school = "vampirism"
	blood_cost = 800
	range = 7
	inner_radius = 4
	charge_max = 360 SECONDS
	cast_sound = ""
	spell_flags = NEEDSVAMPIRE | IGNOREDENSE
	invocation_type = SpI_NONE
	hud_state = "MAKEASPRITE"

/spell/aoe_turf/vampire/screech/cast()
	visible_message("<span class='danger'>[usr.name] lets out an ear piercin shriek!</span>", "<span class='danger'>You let out an ear-shattering shriek!</span>", "<span class='danger'>You hear a painfully loud shriek!</span>")
	playsound(usr.loc, 'sound/effects/creepyshriek.ogg', 100, 1) //Spell sound needs to be loud and long-range, so we do not override the cast sound above.
	var/list/victims = list()

	for (var/mob/living/carbon/human/T in hearers(inner_radius, usr))
		if (T == usr)
			continue

		if (istype(T) && (T:l_ear || T:r_ear) && istype((T:l_ear || T:r_ear), /obj/item/clothing/ears/earmuffs))
			continue

		if (!vampire_can_affect_target(T, 0))
			continue

		to_chat(T, "<span class='danger'><font size='3'><b>You hear an ear piercing shriek and feel your senses go dull!</b></font></span>")
		T.Weaken(5)
		T.ear_deaf = 20
		T.stuttering = 20
		T.Stun(5)

		victims += T

	for (var/obj/structure/window/W in view(range))
		W.shatter()

	for (var/obj/machinery/light/L in view(range))
		L.broken()

	if (victims.len)
		admin_attacker_log_many_victims(usr, victims, "used chriopteran screech to stun", "was stunned by [key_name(usr)] using chriopteran screech", "used chiropteran screech to stun")
	else
		log_and_message_admins("used chiropteran screech.")