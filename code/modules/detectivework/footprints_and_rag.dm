/mob
	var/bloody_hands = 0
	var/mob/living/carbon/human/bloody_hands_mob
	var/track_blood = 0
	var/list/feet_blood_DNA
	var/track_blood_type
	var/feet_blood_color

/obj/item/clothing/gloves
	var/transfer_blood = 0
	var/mob/living/carbon/human/bloody_hands_mob

/obj/item/clothing/shoes/
	var/track_blood = 0

/obj/item/weapon/reagent_containers/glass/rag
	name = "rag"
	desc = "For cleaning up messes, you suppose."
	w_class = 1
	icon = 'icons/obj/toy.dmi'
	icon_state = "rag"
	amount_per_transfer_from_this = 5
	possible_transfer_amounts = list(5)
	volume = 10
	can_be_placed_into = null
	flags = OPENCONTAINER | NOBLUDGEON

/obj/item/weapon/reagent_containers/glass/rag/New()
	..()
	update_name()

/obj/item/weapon/reagent_containers/glass/rag/attack_self(mob/user as mob)
	remove_contents(user)

/obj/item/weapon/reagent_containers/glass/rag/attackby()
	. = ..()
	update_name()

/obj/item/weapon/reagent_containers/glass/rag/proc/update_name()
	if(reagents.total_volume)
		name = "damp [initial(name)]"
	else
		name = "dry [initial(name)]"

/obj/item/weapon/reagent_containers/glass/rag/proc/remove_contents(mob/user, atom/trans_dest = null)
	if(!trans_dest && !user.loc)
		return

	if(reagents.total_volume)
		var/target_text = trans_dest? "\the [trans_dest]" : "\the [user.loc]"
		user.visible_message("<span class='danger'>\The [user] begins to wring out [src] over [target_text].</span>", "<span class='notice>You begin to wring out [src] over [target_text].</span>")
		
		if(do_after(user, reagents.total_volume*5)) //50 for a fully soaked rag
			if(trans_dest)
				reagents.trans_to(trans_dest, reagents.total_volume)
			else
				reagents.splash(user.loc, reagents.total_volume)
			user.visible_message("<span class='danger'>\The [user] wrings out [src] over [target_text].</span>", "<span class='notice'>You finish to wringing out [src].</span>")
			update_name()

/obj/item/weapon/reagent_containers/glass/rag/proc/wipe_down(atom/A, mob/user)
	if(!reagents.total_volume)
		user << "<span class='warning'>The [initial(name)] is dry!</span>"
	else
		user.visible_message("\The [user] starts to wipe down [A] with [src]!")
		reagents.splash(A, 1) //get a small amount of liquid on the thing we're wiping.
		update_name()
		if(do_after(user,30))
			user.visible_message("\The [user] finishes wiping off the [A]!")
			A.clean_blood()

/obj/item/weapon/reagent_containers/glass/rag/attack(atom/target as obj|turf|area, mob/user as mob , flag)
	if(ismob(target) && reagents.total_volume)
		if(user.zone_sel.selecting == "mouth")
			user.visible_message(
				"<span class='danger'>\The [user] smothers [target] with [src]!</span>", 
				"<span class='warning'>You smother [target] with [src]!</span>", 
				"You hear some struggling and muffled cries of surprise"
				)
			reagents.trans_to_mob(target, amount_per_transfer_from_this, CHEM_INGEST) //it's inhaled, really... maybe this should be CHEM_BLOOD?
			update_name()
		else
			wipe_down(target, user)
		return
	return ..()
	
/obj/item/weapon/reagent_containers/glass/rag/afterattack(atom/A as obj|turf|area, mob/user as mob, proximity)
	if(!proximity) 
		return

	if(istype(A, /obj/structure/reagent_dispensers))
		if(!reagents.get_free_space())
			user << "<span class='warning'>\The [src] is already soaked.</span>"
			return
		
		if(A.reagents && A.reagents.trans_to_obj(src, reagents.maximum_volume))
			user.visible_message("<span class='notice'>\The [user] soaks [src] using [A].</span>", "<span class='notice'>You soak [src] using [A].</span>")
			update_name()
		return
	
	if(istype(A) && (src in user))
		if(A.is_open_container())
			remove_contents(user, A)
		else if(!ismob(A)) //mobs are handled in attack() - this prevents us from wiping down people while smothering them.
			wipe_down(A, user)
		return

