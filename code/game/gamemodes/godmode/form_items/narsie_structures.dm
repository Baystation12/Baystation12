/obj/structure/deity/altar/narsie
	name = "altar"
	desc = "A small desk, covered in blood."
	icon_state = "talismanaltar"

/obj/structure/deity/blood_forge
	name = "unholy forge"
	desc = "This forge gives off no heat, no light; its flames look almost unnatural."
	icon_state = "forge"
	build_cost = 1000
	health_max = 100
	var/recipe_feat_list = "Blood Crafting"
	var/text_modifications = list("Cost" = "Blood",
								"Dip" = "fire. Pain envelopes you as blood seeps out of your hands and you begin to shape it into something more useful",
								"Shape" = "You shape the fire as more and more blood comes out.",
								"Out" = "flames")

	power_adjustment = 2

/obj/structure/deity/blood_forge/attack_hand(mob/user)
	if(!linked_god?.is_follower(user, silent = TRUE) || !ishuman(user))
		return

	var/list/recipes = linked_god.feats[recipe_feat_list]
	if(!recipes)
		return

	var/dat = "<center><b>Recipies</b></center><br><br><i>Item - [text_modifications["Cost"]] Cost</i><br>"
	for(var/atom/a as anything in recipes)
		var/cost = recipes[type]
		dat += "<A href='?src=\ref[src];make_recipe=\ref[type];'>[initial(a.name)]</a> - [cost]<br><i>[initial(a.desc)]</i><br><br>"
	show_browser(user, dat, "window=forge")

/obj/structure/deity/blood_forge/CanUseTopic(user)
	if(!linked_god?.is_follower(user, silent = TRUE) || !ishuman(user))
		return STATUS_CLOSE
	return ..()

/obj/structure/deity/blood_forge/OnTopic(user, list/href_list)
	if(href_list["make_recipe"])
		var/list/recipes = linked_god.feats[recipe_feat_list]
		var/type = locate(href_list["make_recipe"]) in recipes
		if(type)
			var/cost = recipes[type]
			craft_item(type, cost, user)
		return TOPIC_REFRESH

/obj/structure/deity/blood_forge/proc/craft_item(path, blood_cost, mob/user)
	to_chat(user, SPAN_NOTICE("You dip your hands into \the [src]'s [text_modifications["Dip"]]"))
	for(var/count = 0, count < blood_cost/10, count++)
		if(!do_after(user, 5 SECONDS, src, DO_DEFAULT | DO_TARGET_UNIQUE_ACT))
			return
		user.visible_message(
			SPAN_NOTICE("\The [user] swirls their hands in \the [src]."),
			SPAN_NOTICE(text_modifications["Shape"])
		)
		if(linked_god)
			linked_god.take_charge(user, 10)
	var/obj/item/I = new path(get_turf(src))
	user.visible_message(
		SPAN_NOTICE("\The [user] pulls \an [I] from the [text_modifications["Out"]]."),
		SPAN_NOTICE("You pull the completed [I] from the [text_modifications["Out"]].")
	)

/obj/structure/deity/blood_forge/proc/take_charge(mob/living/user, charge)
	if(linked_god)
		linked_god.take_charge(user, charge)

//BLOOD LETTING STRUCTURE
//A follower can stand here and mumble prays as they let their blood flow slowly into the structure.
/obj/structure/deity/blood_stone
	name = "bloody stone"
	desc = "A jagged stone covered in the various stages of blood, from dried to fresh."
	icon_state = "blood_stone"
	health_max = 75
	build_cost = 700

/obj/structure/deity/blood_stone/attack_hand(var/mob/user)
	if(!linked_god?.is_follower(user, silent = TRUE) || !ishuman(user))
		return

	var/mob/living/carbon/human/H = user
	user.visible_message(
		SPAN_WARNING("\The [user] calmly slices their finger on \the [src], smearing it over the black stone."),
		SPAN_WARNING("You slowly slide your finger down one of \the [src]'s sharp edges, smearing it over its smooth surface.")
	)
	if(do_after(H, 5 SECONDS, src, DO_DEFAULT | DO_TARGET_UNIQUE_ACT))
		user.audible_message(
			"\The [user] utters something under their breath.",
			SPAN_OCCULT("You mutter a dark prayer to your master as you feel the stone eat away at your lifeforce.")
		)
		if(H.should_have_organ(BP_HEART))
			H.drip(5,get_turf(src))
		else
			H.adjustBruteLoss(5)
		linked_god.adjust_power_min(1,1)
