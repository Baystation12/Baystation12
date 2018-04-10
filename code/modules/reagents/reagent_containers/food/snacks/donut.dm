/obj/item/weapon/reagent_containers/food/snacks/donut
	name = "donut"
	desc = "Goes great with Robust Coffee."
	icon_state = "donut1"
	filling_color = "#d9c386"
	var/overlay_state = "box-donut1"
	center_of_mass = "x=13;y=16"
	nutriment_desc = list("sweetness", "donut")

/obj/item/weapon/reagent_containers/food/snacks/donut/normal
	name = "donut"
	desc = "Goes great with Robust Coffee."
	icon_state = "donut1"
	nutriment_amt = 3
/obj/item/weapon/reagent_containers/food/snacks/donut/normal/Initialize()
	. = ..()
	reagents.add_reagent(/datum/reagent/nutriment/sprinkles, 1)
	src.bitesize = 3
	if(prob(30))
		src.icon_state = "donut2"
		src.overlay_state = "box-donut2"
		src.SetName("frosted donut")
		reagents.add_reagent(/datum/reagent/nutriment/sprinkles, 2)
		center_of_mass = "x=19;y=16"

/obj/item/weapon/reagent_containers/food/snacks/donut/jelly
	name = "jelly doughnut"
	desc = "You jelly?"
	icon_state = "jdonut1"
	filling_color = "#ed1169"
	center_of_mass = "x=16;y=11"
	nutriment_amt = 3

/obj/item/weapon/reagent_containers/food/snacks/donut/jelly/Initialize()
	. = ..()
	reagents.add_reagent(/datum/reagent/nutriment/sprinkles, 1)
	reagents.add_reagent(/datum/reagent/drink/juice/berry, 5)
	bitesize = 5
	if(prob(30))
		src.icon_state = "jdonut2"
		src.overlay_state = "box-donut2"
		src.SetName("Frosted Jelly Donut")
		reagents.add_reagent(/datum/reagent/nutriment/sprinkles, 2)

/obj/item/weapon/reagent_containers/food/snacks/donut/slimejelly
	name = "jelly doughnut"
	desc = "You jelly?"
	icon_state = "jdonut1"
	filling_color = "#ed1169"
	center_of_mass = "x=16;y=11"
	nutriment_amt = 3

/obj/item/weapon/reagent_containers/food/snacks/donut/slimejelly/Initialize()
	. = ..()
	reagents.add_reagent(/datum/reagent/nutriment/sprinkles, 1)
	reagents.add_reagent(/datum/reagent/slimejelly, 5)
	bitesize = 5
	if(prob(30))
		src.icon_state = "jdonut2"
		src.overlay_state = "box-donut2"
		src.SetName("Frosted Jelly Donut")
		reagents.add_reagent(/datum/reagent/nutriment/sprinkles, 2)

/obj/item/weapon/reagent_containers/food/snacks/donut/cherryjelly
	name = "jelly doughnut"
	desc = "You jelly?"
	icon_state = "jdonut1"
	filling_color = "#ed1169"
	center_of_mass = "x=16;y=11"
	nutriment_amt = 3

/obj/item/weapon/reagent_containers/food/snacks/donut/cherryjelly/Initialize()
	. = ..()
	reagents.add_reagent(/datum/reagent/nutriment/sprinkles, 1)
	reagents.add_reagent(/datum/reagent/nutriment/cherryjelly, 5)
	bitesize = 5
	if(prob(30))
		src.icon_state = "jdonut2"
		src.overlay_state = "box-donut2"
		src.SetName("Frosted Jelly Donut")
		reagents.add_reagent(/datum/reagent/nutriment/sprinkles, 2)

/obj/item/weapon/reagent_containers/food/snacks/donut/chaos
	name = "Chaos Donut"
	desc = "Like life, it never quite tastes the same."
	icon_state = "donut1"
	filling_color = "#ed11e6"
	nutriment_amt = 2

/obj/item/weapon/reagent_containers/food/snacks/donut/chaos/Initialize()
	. = ..()
	reagents.add_reagent(/datum/reagent/nutriment/sprinkles, 1)
	bitesize = 10
	var/chaosselect = pick(1,2,3,4,5,6,7,8,9,10)
	switch(chaosselect)
		if(1)
			reagents.add_reagent(/datum/reagent/nutriment, 3)
		if(2)
			reagents.add_reagent(/datum/reagent/capsaicin, 3)
		if(3)
			reagents.add_reagent(/datum/reagent/frostoil, 3)
		if(4)
			reagents.add_reagent(/datum/reagent/nutriment/sprinkles, 3)
		if(5)
			reagents.add_reagent(/datum/reagent/toxin/phoron, 3)
		if(6)
			reagents.add_reagent(/datum/reagent/nutriment/coco, 3)
		if(7)
			reagents.add_reagent(/datum/reagent/slimejelly, 3)
		if(8)
			reagents.add_reagent(/datum/reagent/drink/juice/banana, 3)
		if(9)
			reagents.add_reagent(/datum/reagent/drink/juice/berry, 3)
		if(10)
			reagents.add_reagent(/datum/reagent/tricordrazine, 3)
	if(prob(30))
		src.icon_state = "donut2"
		src.overlay_state = "box-donut2"
		src.SetName("Frosted Chaos Donut")
		reagents.add_reagent(/datum/reagent/nutriment/sprinkles, 2)
