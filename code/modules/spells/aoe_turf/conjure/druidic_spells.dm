/spell/aoe_turf/conjure/summon
	var/name_summon = 0
	cast_sound = 'sound/weapons/wave.ogg'

/spell/aoe_turf/conjure/summon/before_cast()
	..()
	if(name_summon)
		var/newName = sanitize(input("Would you like to name your summon?") as null|text, MAX_NAME_LEN)
		if(newName)
			newVars["name"] = newName

/spell/aoe_turf/conjure/summon/conjure_animation(atom/movable/overlay/animation, turf/target)
	animation.icon_state = "shield2"
	flick("shield2",animation)
	sleep(10)
	..()


/spell/aoe_turf/conjure/summon/bats
	name = "Summon Space Bats"
	desc = "This spell summons a flock of spooky space bats."
	feedback = "SB"

	charge_max = 1200 //2 minutes
	spell_flags = NEEDSCLOTHES
	invocation = "Bla'yo daya!"
	invocation_type = SpI_SHOUT
	level_max = list(Sp_TOTAL = 3, Sp_SPEED = 3, Sp_POWER = 3)
	cooldown_min = 600

	range = 1

	summon_amt = 1
	summon_type = list(/mob/living/simple_animal/hostile/scarybat)

	hud_state = "wiz_bats"

/spell/aoe_turf/conjure/summon/bats/empower_spell()
	if(!..())
		return 0

	newVars = list("maxHealth" = 20 + spell_levels[Sp_POWER]*5, "health" = 20 + spell_levels[Sp_POWER]*5, "melee_damage_lower" = 10 + spell_levels[Sp_POWER], "melee_damage_upper" = 10 + spell_levels[Sp_POWER]*2)

	return "Your bats are now stronger."
