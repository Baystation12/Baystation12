/decl/aspect/groundbreaker
	name = ASPECT_GROUNDBREAKER
	desc = "Strike the earth! You're a miner by trade."
	category = "Background"
	aspect_cost = 2

/decl/aspect/groundbreaker/do_post_spawn(var/mob/living/carbon/human/holder)
	if(!istype(holder))
		return
	holder.put_in_hands(new /obj/item/weapon/pickaxe/drill(get_turf(holder)))
	holder.equip_to_slot_if_possible(new /obj/item/clothing/head/hardhat(get_turf(holder)), slot_head)

/decl/aspect/handyman
	name = ASPECT_HANDYMAN
	desc = "You're handy with tools, and are rarely found without them."
	category = "Background"
	aspect_cost = 2

/decl/aspect/handyman/do_post_spawn(var/mob/living/carbon/human/holder)
	if(istype(holder))
		holder.put_in_hands(new /obj/item/weapon/storage/toolbox/mechanical(get_turf(holder)))

/decl/aspect/prospector
	name = ASPECT_PROSPECTOR
	desc = "You work for an interplanetary mining cartel, finding and staking out deposits of metals and rare earths."
	category = "Skills"
	aspect_cost = 2

/decl/aspect/prospector/do_post_spawn(var/mob/living/carbon/human/holder)
	if(!istype(holder))
		return
	holder.put_in_hands(new /obj/item/device/analyzer(get_turf(holder)))
	holder.put_in_hands(new /obj/item/stack/flag/yellow(get_turf(holder)))


/decl/aspect/first_responder
	name = ASPECT_FIRSTAID
	desc = "You have basic first aid training."
	category = "Background"
	aspect_cost = 2

/decl/aspect/first_responder/do_post_spawn(var/mob/living/carbon/human/holder)
	if(istype(holder))
		holder.put_in_hands(new /obj/item/weapon/storage/firstaid/regular(get_turf(holder)))

/decl/aspect/sawbones
	name = ASPECT_SAWBONES
	desc = "You work as an itinerant doctor, taking the Hippocratic Oath to places it would rather not go."
	category = "Background"
	parent_name = ASPECT_FIRSTAID
	aspect_cost = 2

/decl/aspect/sawbones/do_post_spawn(var/mob/living/carbon/human/holder)
	if(istype(holder))
		holder.put_in_hands(new /obj/item/weapon/storage/firstaid/surgery(get_turf(holder)))
