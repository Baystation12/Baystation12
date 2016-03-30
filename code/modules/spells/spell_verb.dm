/mob/proc/cast_spell(var/spell/spell in spell_list)
	set category = "IC"
	set name = "Cast"
	set desc = "Cast a spell"

	if(!spell_list.len)
		src.verbs -= /mob/proc/cast_spell
		return

	spell.perform(usr)