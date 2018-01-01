#define COVENANT_MOBS list(/mob/living/carbon/human/covenant/sangheili,/mob/living/carbon/human/covenant/kigyar,\
/mob/living/carbon/human/covenant/unggoy,/mob/living/simple_animal/lekgolo/mgalekgolo)

#define SANGHEILI_RANK_OUTFITS typesof(/decl/hierarchy/outfit/sangheili) - /decl/hierarchy/outfit/sangheili
#define KIGYAR_RANK_OUTFITS typesof(/decl/hierarchy/outfit/kigyar)
#define UNGGOY_RANK_OUTFITS typesof(/decl/hierarchy/outfit/unggoy)

/datum/admin_secret_item/fun_secret/spawn_covenant_squad
	name = "Create Covenant Squad"

/datum/admin_secret_item/fun_secret/spawn_covenant_squad/can_execute(var/mob/user)
	if(!ticker) return 0
	return ..()

/datum/admin_secret_item/fun_secret/spawn_covenant_squad/execute(var/mob/user)
	. = ..()
	if(.)

		var/end_selection

		while(!end_selection)
			var/mob/mob_selected = input(user,"Select the mob to create. Cancel to end team selection","Mob Selection","Cancel") as anything in COVENANT_MOBS + list("Cancel")
			if(mob_selected == "Cancel")
				end_selection = 1
				break
			var/ckey_selected = input(user,"Choose a Ckey for the mob.","Ckey Selection",null)
			var/custom_name = input(user,"Pick a custom name for this mob. (Leave null to randomly generate)","Name selection",null)
			var/list/rank_list_to_use
			var/decl/hierarchy/outfit/chosen_outfit
			if(mob_selected == /mob/living/carbon/human/covenant/sangheili)
				rank_list_to_use = SANGHEILI_RANK_OUTFITS
			else if(mob_selected == /mob/living/carbon/human/covenant/kigyar)
				rank_list_to_use = KIGYAR_RANK_OUTFITS
			else if(mob_selected == /mob/living/carbon/human/covenant/unggoy)
				rank_list_to_use = UNGGOY_RANK_OUTFITS
			if(!isnull(rank_list_to_use))
				chosen_outfit = input(user,"Pick a rank","Rank Selection",null) as anything in rank_list_to_use
			var/mob/new_mob = new mob_selected
			new_mob.loc = user.loc
			var/name_original = new_mob.real_name
			new_mob.name = custom_name
			new_mob.real_name = custom_name
			if(!new_mob.real_name)
				new_mob.real_name = name_original
				new_mob.name = name_original
			if(!isnull(ckey_selected))
				new_mob.ckey = ckey_selected
			if(!isnull(chosen_outfit))
				chosen_outfit = new chosen_outfit
				chosen_outfit.equip(new_mob)
				qdel(chosen_outfit)
	return 1


#undef SANGHEILI_RANK_OUTFITS
#undef KIGYAR_RANK_OUTFITS
#undef UNGGOY_RANK_OUTFITS
#undef COVENANT_MOBS