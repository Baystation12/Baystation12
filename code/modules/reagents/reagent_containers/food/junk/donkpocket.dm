/obj/item/weapon/reagent_containers/food/snacks/junk/donkpocket
	name = "Donk-pocket"
	desc = "The food of choice for the seasoned traitor."
	icon_state = "donkpocket"
	filling_color = "#DEDEAB"
	bitesize = 6
	var/warm = 0
	var/list/heated_reagents = list("tricordrazine" = 5)

/obj/item/weapon/reagent_containers/food/snacks/junk/donkpocket/New()
	..()
	reagents.add_reagent("protein", 2)

/obj/item/weapon/reagent_containers/food/snacks/junk/donkpocket/proc/heat()
	warm = 1
	for(var/reagent in heated_reagents)
		reagents.add_reagent(reagent, heated_reagents[reagent])
	name = "warm " + name
	cooltime()

/obj/item/weapon/reagent_containers/food/snacks/junk/donkpocket/proc/cooltime()
	if(warm)
		spawn(4200)
			warm = 0
			for(var/reagent in heated_reagents)
				src.reagents.del_reagent(reagent)
			name = initial(name)
	return

/obj/item/weapon/reagent_containers/food/snacks/junk/donkpocket/sinpocket
	name = "\improper Sin-pocket"
	desc = "The food of choice for the veteran. Do <B>NOT</B> overconsume."
	filling_color = "#6D6D00"
	heated_reagents = list("doctorsdelight" = 5, "hyperzine" = 0.75, "synaptizine" = 0.25)
	var/has_been_heated = 0

/obj/item/weapon/reagent_containers/food/snacks/junk/donkpocket/sinpocket/attack_self(mob/user)
	if(has_been_heated)
		user << "<span class='notice'>The heating chemicals have already been spent.</span>"
		return
	has_been_heated = 1
	user.visible_message("<span class='notice'>[user] crushes \the [src] package.</span>", "You crush \the [src] package and feel a comfortable heat build up.")
	spawn(200)
		user << "You think \the [src] is ready to eat about now."
		heat()
