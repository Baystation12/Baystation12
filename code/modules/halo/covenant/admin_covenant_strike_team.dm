#define COVENANT_MOBS list(/mob/living/carbon/human/covenant/sangheili,/mob/living/carbon/human/covenant/jiralhanae,/mob/living/carbon/human/covenant/kigyar,\
/mob/living/carbon/human/covenant/unggoy,/mob/living/carbon/human/covenant/tvoan,/mob/living/carbon/human/covenant/yanmee,/mob/living/simple_animal/mgalekgolo)

#define SANGHEILI_RANK_OUTFITS list(/decl/hierarchy/outfit/sangheili/minor/armed,/decl/hierarchy/outfit/sangheili/major/armed,/decl/hierarchy/outfit/sangheili/ultra/armed,\
/decl/hierarchy/outfit/sangheili/zealot/armed,/decl/hierarchy/outfit/sangheili/eva/armed,/decl/hierarchy/outfit/sangheili/honour_guard/armed,\
/decl/hierarchy/outfit/sangheili/specops/armed,/decl/hierarchy/outfit/sangheili/silentshadow)

#define KIGYAR_RANK_OUTFITS typesof(/decl/hierarchy/outfit/kigyar)

#define UNGGOY_RANK_OUTFITS list(/decl/hierarchy/outfit/unggoy/armed,/decl/hierarchy/outfit/unggoy/major/armed,/decl/hierarchy/outfit/unggoy/heavy/armed,\
/decl/hierarchy/outfit/unggoy/ultra/armed,/decl/hierarchy/outfit/unggoy/specops/armed,/decl/hierarchy/outfit/unggoy/deacon/armed,/decl/hierarchy/outfit/unggoy/honour_guard/armed)

#define JIRALHANAE_RANK_OUTFITS list(/decl/hierarchy/outfit/jiralhanae/covenant/minor/armed,/decl/hierarchy/outfit/jiralhanae/covenant/major/armed,\
/decl/hierarchy/outfit/jiralhanae/covenant/captain/armed,/decl/hierarchy/outfit/jiralhanae/covenant/chieftain/armed)

#define TVOAN_RANK_OUTFITS list(/decl/hierarchy/outfit/skirmisher_minor,/decl/hierarchy/outfit/skirmisher_major,/decl/hierarchy/outfit/skirmisher_murmillo/armed,\
/decl/hierarchy/outfit/skirmisher_commando/armed,/decl/hierarchy/outfit/skirmisher_champion)

#define YANMEE_RANK_OUTFITS list(/decl/hierarchy/outfit/yanmee/minor/armed,/decl/hierarchy/outfit/yanmee/major/armed,/decl/hierarchy/outfit/yanmee/ultra/armed,/decl/hierarchy/outfit/yanmee/leader/armed)


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
			else if(mob_selected == /mob/living/carbon/human/covenant/jiralhanae)
				rank_list_to_use = JIRALHANAE_RANK_OUTFITS
			else if(mob_selected == /mob/living/carbon/human/covenant/kigyar)
				rank_list_to_use = KIGYAR_RANK_OUTFITS
			else if(mob_selected == /mob/living/carbon/human/covenant/unggoy)
				rank_list_to_use = UNGGOY_RANK_OUTFITS
			else if(mob_selected == /mob/living/carbon/human/covenant/tvoan)
				rank_list_to_use = TVOAN_RANK_OUTFITS
			else if(mob_selected == /mob/living/carbon/human/covenant/yanmee)
				rank_list_to_use = YANMEE_RANK_OUTFITS
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

#define UNSC_MOBS list(/mob/living/carbon/human,/mob/living/carbon/human/spartan)
#define UNSC_MARINE_OUTFITS typesof(/decl/hierarchy/outfit/job/adminspawn_marine) - typesof(/decl/hierarchy/outfit/job/adminspawn_marine/spartan)
#define UNSC_SPARTAN_OUTFITS typesof(/decl/hierarchy/outfit/job/adminspawn_marine/spartan)
#define UNSC_ODST_OUTFITS typesof(/decl/hierarchy/outfit/job/adminspawn_marine/odsts)

/datum/admin_secret_item/fun_secret/spawn_unsc_squad
	name = "Create UNSC Squad"

/datum/admin_secret_item/fun_secret/spawn_unsc_squad/can_execute(var/mob/user)
	if(!ticker) return 0
	return ..()

/datum/admin_secret_item/fun_secret/spawn_unsc_squad/execute(var/mob/user)
	. = ..()
	if(.)

		var/end_selection

		while(!end_selection)
			var/mob/mob_selected = input(user,"Select the mob to create. Cancel to end team selection","Mob Selection","Cancel") as anything in UNSC_MOBS + list("Cancel")
			if(mob_selected == "Cancel")
				end_selection = 1
				break
			var/ckey_selected = input(user,"Choose a Ckey for the mob.","Ckey Selection",null)
			var/custom_name = input(user,"Pick a custom name for this mob. (Leave null to randomly generate)","Name selection",null)
			var/list/rank_list_to_use
			var/spawn_pod = /obj/vehicles/drop_pod/overmap/SOEIV
			var/decl/hierarchy/outfit/chosen_outfit
			if(mob_selected == /mob/living/carbon/human)
				rank_list_to_use = UNSC_MARINE_OUTFITS
			else if(mob_selected == /mob/living/carbon/human/spartan)
				rank_list_to_use = UNSC_SPARTAN_OUTFITS
			if(!isnull(rank_list_to_use))
				chosen_outfit = input(user,"Pick a rank","Rank Selection",null) as anything in rank_list_to_use
			var/mob/new_mob = new mob_selected
			new_mob.loc = user.loc
			var/name_original = new_mob.real_name
			if(chosen_outfit in UNSC_ODST_OUTFITS)
				new spawn_pod(user.loc)
				playsound(user.loc, 'sound/effects/bamf.ogg', 100, 1)
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
#undef JIRALHANAE_RANK_OUTFITS
#undef TVOAN_RANK_OUTFITS
#undef YANMEE_RANK_OUTFITS
#undef UNSC_MOBS
#undef UNSC_MARINE_OUTFITS
#undef UNSC_SPARTAN_OUTFITS
#undef UNSC_ODST_OUTFITS