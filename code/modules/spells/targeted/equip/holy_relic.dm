/spell/targeted/equip_item/holy_relic
	name = "Summon Holy Relic"
	desc = "This spell summons a relic of purity into your hand for a short while."
	feedback = "SR"
	school = "conjuration"
	charge_type = Sp_RECHARGE
	charge_max = 600
	spell_flags = NEEDSCLOTHES | INCLUDEUSER
	invocation = "Yee'Ro Su!"
	invocation_type = SpI_SHOUT
	range = -1
	max_targets = 1
	level_max = list(Sp_TOTAL = 2, Sp_SPEED = 1, Sp_POWER = 1)
	duration = 250
	cooldown_min = 350
	delete_old = 0
	compatible_mobs = list(/mob/living/carbon/human)

	hud_state = "purge1"

	equipped_summons = list("active hand" = /obj/item/weapon/nullrod)

/spell/targeted/equip_item/holy_relic/cast(list/targets, mob/user = usr)
	..()
	for(var/mob/M in targets)
		M.visible_message("A rod of metal appears in \the [M]'s hand!")

/spell/targeted/equip_item/holy_relic/empower_spell()
	if(!..())
		return 0

	duration += 50

	return "The holy relic now lasts for [duration/10] seconds."