/spell/targeted/exhude_pleasantness
	name = "Exhude Pleasantness"
	desc = "A simple spell used to make friends with people. Be warned, this spell only has a subtle effect"
	feedback = "AP"
	school = "Illusion"
	spell_flags = INCLUDEUSER
	range = 5
	max_targets = 0
	charge_max = 100
	var/list/possible_messages = list("seems pretty trustworthy!", "makes you feel appreciated.", "looks pretty cool.", "feels like the only decent person here!", "makes you feel safe.")
	hud_state = "friendly"

/spell/targeted/exhude_pleasantness/cast(var/list/targets, var/mob/user)
	for(var/m in targets)
		var/mob/living/L = m
		if(L.mind && L.mind.special_role == ANTAG_SERVANT)
			to_chat(m, "<span class='notice'>\The [user] seems relatively harmless.</span>")
		else
			to_chat(m, "<font size='3'><span class='notice'>\The [user] [pick(possible_messages)]</span></font>")