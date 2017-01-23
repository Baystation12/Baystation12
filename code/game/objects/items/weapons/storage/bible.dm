/obj/item/weapon/storage/bible
	name = "bible"
	desc = "Apply to head repeatedly."
	icon_state ="bible"
	throw_speed = 1
	throw_range = 5
	w_class = ITEM_SIZE_NORMAL
	max_w_class = ITEM_SIZE_SMALL
	max_storage_space = 4
	var/mob/affecting = null
	var/deity_name = "Christ"

/obj/item/weapon/storage/bible/booze
	name = "bible"
	desc = "To be applied to the head repeatedly."
	icon_state ="bible"

	startswith = list(
		/obj/item/weapon/reagent_containers/food/drinks/bottle/small/beer,
		/obj/item/weapon/spacecash/bundle/c50,
		/obj/item/weapon/spacecash/bundle/c50,
		)

/obj/item/weapon/storage/bible/afterattack(atom/A, mob/user as mob, proximity)
	if(!proximity) return
	if(user.mind && (user.mind.assigned_role == "Chaplain"))
		if(A.reagents && A.reagents.has_reagent("water")) //blesses all the water in the holder
			to_chat(user, "<span class='notice'>You bless \the [A].</span>") // I wish it was this easy in nethack
			var/water2holy = A.reagents.get_reagent_amount("water")
			A.reagents.del_reagent("water")
			A.reagents.add_reagent("holywater",water2holy)

/obj/item/weapon/storage/bible/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if (src.use_sound)
		playsound(src.loc, src.use_sound, 50, 1, -5)
	..()
