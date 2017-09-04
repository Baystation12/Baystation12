/spell/aoe_turf/conjure/summonEdSwarm //test purposes
	name = "Dispense Wizard Justice"
	desc = "This spell dispenses wizard justice."

	summon_type = list(/mob/living/bot/secbot/ed209)
	summon_amt = 10
	range = 3
	newVars = list("emagged" = 1,"name" = "Wizard's Justicebot")

	hud_state = "wiz_ed"

/spell/aoe_turf/conjure/carp
	name = "Summon Carp"
	desc = "This spell conjures a simple carp."

	school = "conjuration"
	charge_max = 1200
	spell_flags = NEEDSCLOTHES
	invocation = "Nouk Fhumm Sacp Risska!"
	invocation_type = SpI_SHOUT
	range = 1

	summon_type = list(/mob/living/simple_animal/hostile/carp)

	hud_state = "wiz_carp"

/spell/aoe_turf/conjure/creature
	name = "Summon Creature Swarm"
	desc = "This spell tears the fabric of reality, allowing horrific daemons to spill forth"

	school = "conjuration"
	charge_max = 1200
	spell_flags = 0
	invocation = "Ia-Ia! Naomesnalia!"
	invocation_type = SpI_SHOUT
	summon_amt = 10
	range = 3

	summon_type = list(/mob/living/simple_animal/hostile/creature)

	hud_state = "wiz_creature"

/spell/aoe_turf/conjure/mirage
	name = "Summon Mirage"
	desc = "This spell summons a harmless carp mirage for a few seconds."
	feedback = "MR"
	school = "illusion"
	charge_max = 1200
	spell_flags = NEEDSCLOTHES
	invocation = "Nouk Fhunhm Sacp Risska!"
	invocation_type = SpI_SHOUT
	range = 1

	duration = 600
	cooldown_min = 600
	level_max = list(Sp_TOTAL = 4, Sp_SPEED = 2, Sp_POWER = 3)

	summon_type = list(/mob/living/simple_animal/hostile/carp)

	hud_state = "wiz_carp"

	newVars = list("melee_damage_lower" = 0, "melee_damage_upper" = 0, "break_stuff_probability" = 0)

/spell/aoe_turf/conjure/mirage/empower_spell()
	if(!..())
		return 0

	summon_amt++

	return "You now summon [summon_amt] mirages per spellcast."