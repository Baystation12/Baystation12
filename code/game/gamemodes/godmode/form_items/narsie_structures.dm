/obj/structure/deity/blood_forge
	name = "unholy forge"
	desc = "This forge gives off no heat, no light, its flames look almost unnatural."
	icon_state = "forge"
	build_cost = 1000
	health = 50
	var/busy = 0
	var/recipe_feat_list = "Blood Crafting"
	var/text_modifications = list("Cost" = "Blood",
								"Dip" = "fire. Pain envelopes you as blood seeps out of your hands and you begin to shape it into something more useful",
								"Shape" = "You shape the fire as more and more blood comes out.",
								"Out" = "flames")

	power_adjustment = 2

/obj/structure/deity/blood_forge/attack_hand(var/mob/user)
	if(!linked_god || !linked_god.is_follower(user, silent = 1) || !ishuman(user))
		return

	var/list/recipes = linked_god.feats[recipe_feat_list]
	if(!recipes)
		return

	var/dat = "<center><b>Recipies</b></center><br><br><i>Item - [text_modifications["Cost"]] Cost</i><br>"
	for(var/type in recipes)
		var/atom/a = type
		var/cost = recipes[type]
		dat += "<A href='?src=\ref[src];make_recipe=\ref[type];'>[initial(a.name)]</a> - [cost]<br><i>[initial(a.desc)]</i><br><br>"
	show_browser(user, dat, "window=forge")

/obj/structure/deity/blood_forge/CanUseTopic(var/user)
	if(!linked_god || !linked_god.is_follower(user, silent = 1) || !ishuman(user))
		return STATUS_CLOSE
	return ..()

/obj/structure/deity/blood_forge/OnTopic(var/user, var/list/href_list)
	if(href_list["make_recipe"])
		var/list/recipes = linked_god.feats[recipe_feat_list]
		var/type = locate(href_list["make_recipe"]) in recipes
		if(type)
			var/cost = recipes[type]
			craft_item(type, cost, user)
		return TOPIC_REFRESH

/obj/structure/deity/blood_forge/proc/craft_item(var/path, var/blood_cost, var/mob/user)
	if(busy)
		to_chat(user, "<span class='warning'>Someone is already using \the [src]!</span>")
		return

	busy = 1
	to_chat(user, "<span class='notice'>You dip your hands into \the [src]'s [text_modifications["Dip"]]</span>")
	for(var/count = 0, count < blood_cost/10, count++)
		if(!do_after(user, 50,src))
			busy = 0
			return
		user.visible_message("\The [user] swirls their hands in \the [src].", text_modifications["Shape"])
		if(linked_god)
			linked_god.take_charge(user, 10)
	var/obj/item/I = new path(get_turf(src))
	user.visible_message("\The [user] pull out \the [I] from the [text_modifications["Out"]].", "You pull out the completed [I] from the [text_modifications["Out"]].")
	busy = 0

/obj/structure/deity/blood_forge/proc/take_charge(var/mob/living/user, var/charge)
	if(linked_god)
		linked_god.take_charge(user, charge)

//BLOOD LETTING STRUCTURE
//A follower can stand here and mumble prays as they let their blood flow slowly into the structure.
/obj/structure/deity/blood_stone
	name = "bloody stone"
	desc = "A jagged stone covered in the various stages of blood, from dried to fresh."
	icon_state = "blood_stone"
	health = 100 //Its a piece of rock.
	build_cost = 700

/obj/structure/deity/blood_stone/attack_hand(var/mob/user)
	if(!linked_god || !linked_god.is_follower(user, silent = 1) || !ishuman(user))
		return

	var/mob/living/carbon/human/H = user
	user.visible_message("<span class='warning'>\The [user] calmly slices their finger on \the [src], smeering it over the black stone.</span>","<span class='warning'>You slowly slide your finger down one of \the [src]'s sharp edges, smeering it over its smooth surface.</span>")
	while(do_after(H,50,src))
		user.audible_message("\The [user] utters something under their breath.", "<span class='cult'>You mutter a dark prayer to your master as you feel the stone eat away at your lifeforce.</span>")
		if(H.should_have_organ(BP_HEART))
			H.drip(5,get_turf(src))
		else
			H.adjustBruteLoss(5)
		linked_god.adjust_power(1,1)
