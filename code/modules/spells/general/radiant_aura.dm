/spell/radiant_aura
	name = "Radiant aura"
	desc = "Form a protective layer of light around you, making you immune to laser fire."
	school = "transmutation"
	feedback = "ra"
	invocation_type = SpI_EMOTE
	invocation = "conjures a sphere of fire around themselves."
	school = "conjuration"
	spell_flags = NEEDSCLOTHES
	charge_max = 300
	cooldown_min = 100
	level_max = list(Sp_TOTAL = 2, Sp_SPEED = 2, Sp_POWER = 0)
	cast_sound = 'sound/effects/snap.ogg'
	duration = 40
	hud_state = "gen_immolate"

/spell/radiant_aura/choose_targets()
	return list(holder)

/spell/radiant_aura/cast(var/list/targets, var/mob/user)
	var/obj/aura/radiant_aura/A = new(user)
	QDEL_IN(A,duration)

/spell/radiant_aura/starlight
	spell_flags = 0
	charge_max = 400