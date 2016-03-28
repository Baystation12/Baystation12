/mob/verb/cast_spell(var/spell/spell in spell_list)
	set category = "IC"
	set name = "Cast"
	set desc = "Cast a spell"

	if(!spell_list.len)
		return
	if(spell.holder != usr)
		return

	spell.perform(usr)