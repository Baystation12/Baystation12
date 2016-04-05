/spell/targeted/equip_item/seed
	name = "Summon Seed"
	desc = "This spell summons a random seed into the hand of the wizard."
	feedback = "SE"
	delete_old = 0

	spell_flags = INCLUDEUSER | NEEDSCLOTHES
	invocation_type = SpI_WHISPER
	invocation = "Ria'li  akta"

	equipped_summons = list("active hand" = /obj/item/seeds/random)
	compatible_mobs = list(/mob/living/carbon/human)

	charge_max = 600 //1 minute
	cooldown_min = 200 //20 seconds
	level_max = list(Sp_TOTAL = 3, Sp_SPEED = 3, Sp_POWER = 0)

	range = -1
	max_targets = 1

	hud_state = "wiz_seed"