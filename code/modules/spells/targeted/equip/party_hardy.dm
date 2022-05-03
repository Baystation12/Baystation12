/spell/targeted/equip_item/party_hardy
	name = "Summon Party"
	desc = "This spell was invented for the sole purpose of getting crunked at 11am on a Tuesday. Does not require wizard garb."
	feedback = "PY"
	school = "conjuration"
	charge_type = Sp_RECHARGE
	charge_max = 900
	cooldown_min = 600
	spell_flags = INCLUDEUSER
	invocation = "Llet'Su G'iit Rrkned!" //Let's get wrecked.
	invocation_type = SpI_SHOUT
	range = 6
	max_targets = 0
	level_max = list(Sp_TOTAL = 3, Sp_SPEED = 1, Sp_POWER = 2)
	delete_old = 0

	hud_state = "wiz_party"

	compatible_mobs = list(/mob/living/carbon/human)
	equipped_summons = list("active hand" = /obj/item/reagent_containers/food/drinks/bottle/small/beer)

/spell/targeted/equip_item/party_hardy/empower_spell()
	if(!..())
		return 0
	switch(spell_levels[Sp_POWER])
		if(1)
			equipped_summons = list("active hand" = /obj/item/reagent_containers/food/drinks/bottle/small/beer,
								"off hand" = /obj/item/reagent_containers/food/snacks/poppypretzel)
			return "The spell will now give everybody a preztel as well."
		if(2)
			equipped_summons = list("active hand" = /obj/item/reagent_containers/food/drinks/bottle/absinthe,
								"off hand" = /obj/item/reagent_containers/food/snacks/poppypretzel,
								"[slot_head]" = /obj/item/clothing/head/collectable/wizard)
			return "Woo! Now everybody gets a cool wizard hat and MORE BOOZE!"

	return 0