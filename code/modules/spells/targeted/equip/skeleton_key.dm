/spell/targeted/equip_item/skeleton_key
	name = "Skeleton Key"
	desc = "This spell gives full access to electronic-powered systems and machines."
	feedback = "KN"
	school = "transmutation"
	charge_type = Sp_RECHARGE
	charge_max = 1200
	spell_flags = NEEDSCLOTHES | INCLUDEUSER
	invocation = "Aulie Oxin Fiera."
	invocation_type = SpI_WHISPER
	range = -1
	max_targets = 1
	level_max = list(Sp_TOTAL = 2, Sp_SPEED = 1, Sp_POWER = 1)
	duration = 250
	cooldown_min = 350
	delete_old = 0
	compatible_mobs = list(/mob/living/carbon/human)
	hud_state = "wiz_knock"
	equipped_summons = list("active hand" = /obj/item/weapon/card/id/silver/skeleton_key)

/spell/targeted/equip_item/skeleton_key/cast(list/targets, mob/user = usr)
	..()
	for(var/mob/M in targets)
		M.visible_message("An unusual card appears in \the [M]'s hand!")

/spell/targeted/equip_item/skeleton_key/empower_spell()
	if(!..())
		return 0

	duration += 50

	return "The skeleton key now lasts for [duration/10] seconds."