//AOE flash. Decent range. Free, on a long cooldown.
/spell/aoe_turf/vampire/glare

	name = "Glare"
	desc = "Your eyes flash a bright light, stunning any who are watching."
	school = "vampirism"
	range = 2
	inner_radius = 4
	charge_max = 80 SECONDS
	cast_sound = ""
	invocation_type = SpI_EMOTE
	hud_state = "MAKEASPRITE"
	blood_cost = 0

/spell/aoe_turf/vampire/glare/cast()


	if(user.stat == DEAD)
		return

	if (!user.has_eyes())
		to_chat(src, "<span class='warning'>You don't have eyes!</span>")
		return

	if (istype(glasses, /obj/item/clothing/glasses/sunglasses/blindfold))
		to_chat(src, "<span class='warning'>You're blindfolded!</span>")
		return

	to_chat(src, "<span class='danger'>[src.name]'s eyes emit a blinding flash!</span>")
	var/list/victims = list()
	for (var/mob/living/carbon/human/H in view(range))
		if (H == src)
			continue

		if (!user.vampire_can_affect_target(H, 0))
			continue

		H.Weaken(8)
		H.stuttering = 20
		to_chat(H, "<span class='danger'>You are blinded by [src]'s glare!</span>")
		H.flash_eyes()
		victims += H

	admin_attacker_log_many_victims(src, victims, "used glare to stun", "was stunned by [key_name(src)] using glare", "used glare to stun")
