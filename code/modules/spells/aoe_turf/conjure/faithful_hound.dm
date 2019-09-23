/spell/aoe_turf/conjure/faithful_hound
	name = "Faithful Hound"
	desc = "Summon a spectral watchdog with a special password. Anyone without the password is in for a barking and a biting."
	feedback = "FH"

	charge_max = 600
	spell_flags = NEEDSCLOTHES
	invocation = "Du korilath tangus"
	invocation_type = SpI_WHISPER
	range = 0

	summon_amt = 1
	summon_type = list(/mob/living/simple_animal/faithful_hound)
	hud_state = "wiz_hound"

/spell/aoe_turf/conjure/faithful_hound/before_cast()
	..()
	var/password = sanitize(input("What password will this beast listen to?") as text, MAX_NAME_LEN)
	newVars = list("password" = password, "allowed_mobs" = list(usr))

/spell/aoe_turf/conjure/faithful_hound/tower
	charge_max = 1
	spell_flags = 0