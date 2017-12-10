//More or less only exists to set a few shared values and flags for vampire spells. Possibly the worst, but most apt name for this file. Might not even be necessary.


/spell/vampire
	spell_flags = NEEDSVAMPIRE | IGNOREDENSE
	invocation_type = SpI_NONE
	school = "vampirism"

/spell/aoe/vampire
	spell_flags = NEEDSVAMPIRE | IGNOREDENSE
	invocation_type = SpI_NONE //Technically false in several cases.
	school = "vampirism"

/spell/aoe_turf/conjure/vampire
	spell_flags = NEEDSVAMPIRE
	invocation_type = SpI_EMOTE
	school = "vampirism"

/spell/targeted/vampire
	spell_flags = NEEDSVAMPIRE
	invocation_type = SpI_NONE //Technically false in several cases.
	school = "vampirism"
/spell/hand/vampire
	spell_flags = NEEDSVAMPIRE
	invocation_type = SpI_NONE
	school = "vampirism"

/spell/projectile/vampire //None of these exist. YET.
	spell_flags = NEEDSVAMPIRE
	invocation_type = SpI_EMOTE
	school = "vampirism"

/spell/targeted/projectile/dumbfire/vampire //Ditto.
	spell_flags = NEEDSVAMPIRE
	invocation_type = SpI_EMOTE
	school = "vampirism"

