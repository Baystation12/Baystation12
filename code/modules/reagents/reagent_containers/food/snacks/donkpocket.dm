/obj/item/weapon/reagent_containers/food/snacks/donkpocket
	name = "Donk-pocket"
	desc = "The food of choice for the seasoned traitor."
	icon_state = "donkpocket"
	filling_color = "#dedeab"
	center_of_mass = "x=16;y=10"
	nutriment_desc = list("heartiness" = 1, "dough" = 2)
	nutriment_amt = 2
	var/warm = 0
	var/list/heated_reagents = list(/datum/reagent/tricordrazine = 5)

/obj/item/weapon/reagent_containers/food/snacks/donkpocket/Initialize()
	. = ..()
	reagents.add_reagent(/datum/reagent/nutriment/protein, 2)


/obj/item/weapon/reagent_containers/food/snacks/donkpocket/proc/heat()
	warm = 1
	for(var/reagent in heated_reagents)
		reagents.add_reagent(reagent, heated_reagents[reagent])
	bitesize = 6
	SetName("\improper Warm " + name)
	cooltime()

/obj/item/weapon/reagent_containers/food/snacks/donkpocket/proc/cooltime()
	if (src.warm)
		addtimer(CALLBACK(src, .proc/cool), 7 MINUTES)

/obj/item/weapon/reagent_containers/food/snacks/donkpocket/proc/cool()
	src.warm = 0
	for(var/reagent in heated_reagents)
		src.reagents.del_reagent(reagent)
	src.SetName(initial(name))

/obj/item/weapon/reagent_containers/food/snacks/donkpocket/sinpocket
	name = "\improper Sin-pocket"
	desc = "The food of choice for the veteran. Do <B>NOT</B> overconsume."
	filling_color = "#6d6d00"
	heated_reagents = list(/datum/reagent/drink/doctor_delight = 5, /datum/reagent/hyperzine = 0.75, /datum/reagent/synaptizine = 0.25)
	var/has_been_heated = 0

/obj/item/weapon/reagent_containers/food/snacks/donkpocket/sinpocket/attack_self(mob/user)
	if(has_been_heated)
		to_chat(user, "<span class='notice'>The heating chemicals have already been spent.</span>")
		return
	has_been_heated = 1
	user.visible_message("<span class='notice'>[user] crushes \the [src] package.</span>", "You crush \the [src] package and feel a comfortable heat build up.")
	addtimer(CALLBACK(src, .proc/do_heat, user), 20 SECONDS)

/obj/item/weapon/reagent_containers/food/snacks/donkpocket/sinpocket/proc/do_heat(mob/user)
	to_chat(user, "You think \the [src] is ready to eat about now.")
	heat()