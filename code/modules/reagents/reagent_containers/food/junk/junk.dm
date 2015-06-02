/obj/item/weapon/reagent_containers/food/snacks/junk
	icon = 'icons/obj/kitchen/junkfood/vendor.dmi'
	var/trash = null

/obj/item/weapon/reagent_containers/food/snacks/junk/New()
	..()
	reagents.add_reagent("nutriment", 4)

/obj/item/weapon/reagent_containers/food/snacks/junk/On_Consume(var/mob/M)
	if(..() && trash)
		if(ispath(trash,/obj/item))
			var/obj/item/TrashItem = new trash(usr)
			usr.put_in_hands(TrashItem)
		else if(istype(trash,/obj/item))
			usr.put_in_hands(trash)
		if(!M) M = usr
		usr.drop_from_inventory(src)
		qdel(src)

/obj/item/weapon/reagent_containers/food/snacks/junk/candy
	name = "candy"
	desc = "Nougat, love it or hate it."
	icon_state = "candy"
	trash = /obj/item/trash/candy
	filling_color = "#7D5F46"

/obj/item/weapon/reagent_containers/food/snacks/junk/candy/New()
	..()
	reagents.add_reagent("sugar", 2)

/obj/item/weapon/reagent_containers/food/snacks/junk/candy/donor
	name = "donor candy"
	desc = "A little treat for blood donors."
	trash = /obj/item/trash/candy

/obj/item/weapon/reagent_containers/food/snacks/junk/candy/corn
	name = "candy corn"
	desc = "It's a handful of candy corn. Cannot be stored in a detective's hat, alas."
	icon_state = "candy_corn"
	filling_color = "#FFFCB0"

/obj/item/weapon/reagent_containers/food/snacks/junk/chips
	name = "chips"
	desc = "Commander Riker's What-The-Crisps"
	icon_state = "chips"
	trash = /obj/item/trash/chips
	filling_color = "#E8C31E"
	bitesize = 1

/obj/item/weapon/reagent_containers/food/snacks/junk/chips/New()
	..()
	reagents.add_reagent("nutriment", 3)

/obj/item/weapon/reagent_containers/food/snacks/junk/popcorn
	name = "popcorn"
	desc = "Now let's find some cinema."
	icon_state = "popcorn"
	trash = /obj/item/trash/popcorn
	filling_color = "#FFFAD4"
	bitesize = 0.2 //Not very filling, takes forever to eat.
	var/unpopped = 0

/obj/item/weapon/reagent_containers/food/snacks/junk/popcorn/New()
	..()
	unpopped = rand(1,10)

/obj/item/weapon/reagent_containers/food/snacks/junk/popcorn/On_Consume()
	if(unpopped && prob(10))
		usr << "<span class='danger'>You bite down on an un-popped kernel!</span>"
		unpopped--
	..()

/obj/item/weapon/reagent_containers/food/snacks/junk/sosjerky
	name = "\improper Scaredy's Private Reserve Beef Jerky"
	icon_state = "sosjerky"
	desc = "Beef jerky made from the finest space cows."
	trash = /obj/item/trash/sosjerky
	filling_color = "#631212"

/obj/item/weapon/reagent_containers/food/snacks/junk/sosjerky/New()
	..()
	reagents.add_reagent("protein", 4)

/obj/item/weapon/reagent_containers/food/snacks/junk/no_raisin
	name = "\improper 4no Raisins"
	icon_state = "4no_raisins"
	desc = "Best raisins in the universe. Not sure why."
	trash = /obj/item/trash/raisins
	filling_color = "#343834"

/obj/item/weapon/reagent_containers/food/snacks/junk/no_raisin/New()
	..()
	reagents.add_reagent("nutriment", 2)

/obj/item/weapon/reagent_containers/food/snacks/junk/spacetwinkie
	name = "\improper Space Twinkie"
	icon_state = "space_twinkie"
	desc = "Guaranteed to survive longer then you will."
	filling_color = "#FFE591"

/obj/item/weapon/reagent_containers/food/snacks/junk/spacetwinkie/New()
	..()
	reagents.add_reagent("sugar", 4)

/obj/item/weapon/reagent_containers/food/snacks/junk/cheesiehonkers
	name = "\improper Cheesie Honkers"
	icon_state = "cheesie_honkers"
	desc = "Bite sized cheesie snacks that will honk all over your mouth"
	trash = /obj/item/trash/cheesie
	filling_color = "#FFA305"

/obj/item/weapon/reagent_containers/food/snacks/junk/syndicake
	name = "\improper Syndi-Cakes"
	icon_state = "syndi_cakes"
	desc = "An extremely moist snack cake that tastes just as good after being nuked."
	filling_color = "#FF5D05"
	trash = /obj/item/trash/syndi_cakes
	bitesize = 3

/obj/item/weapon/reagent_containers/food/snacks/junk/syndicake/New()
	..()
	reagents.add_reagent("doctorsdelight", 5)

/obj/item/weapon/reagent_containers/food/snacks/junk/liquidfood
	name = "\improper LiquidFood Ration"
	desc = "A prepackaged grey slurry of all the essential nutrients for a spacefarer on the go. Should this be crunchy?"
	icon_state = "liquidfood"
	trash = /obj/item/trash/liquidfood
	filling_color = "#A8A8A8"
	bitesize = 4

/obj/item/weapon/reagent_containers/food/snacks/junk/liquidfood/New()
	..()
	reagents.add_reagent("nutriment", 16)
	reagents.add_reagent("iron", 3)

/obj/item/weapon/reagent_containers/food/snacks/junk/tastybread
	name = "bread tube"
	desc = "Bread in a tube. Chewy...and surprisingly tasty."
	icon_state = "tastybread"
	trash = /obj/item/trash/tastybread
	filling_color = "#A66829"

/obj/item/weapon/reagent_containers/food/snacks/junk/tastybread/New()
	..()
	reagents.add_reagent("nutriment", 2)

/obj/item/weapon/reagent_containers/food/snacks/junk/skrellsnacks
	name = "\improper SkrellSnax"
	desc = "Cured fungus shipped all the way from Jargon 4, almost like jerky! Almost."
	icon_state = "skrellsnacks"
	filling_color = "#A66829"
	bitesize = 3

/obj/item/weapon/reagent_containers/food/snacks/junk/skrellsnacks/New()
	..()
	reagents.add_reagent("nutriment", 6)

