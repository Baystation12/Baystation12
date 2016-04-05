/mob/living/carbon/alien/larva
	name = "alien larva"
	real_name = "alien larva"
	adult_form = /mob/living/carbon/human
	speak_emote = list("hisses")
	icon_state = "larva"
	language = "Hivemind"
	maxHealth = 25
	health = 25

	base_spells = list(/spell/evolve/larva = /obj/screen/movable/spell_master/alien,
					/spell/attach_host = /obj/screen/movable/spell_master/alien,
					/spell/free/hide = /obj/screen/movable/spell_master/alien
					)

/mob/living/carbon/alien/larva/New()
	..()
	add_language("Xenomorph") //Bonus language.
	internal_organs |= new /obj/item/organ/xenos/hivenode(src)
	create_reagents(100)