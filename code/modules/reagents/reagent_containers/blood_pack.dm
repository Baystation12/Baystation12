/obj/item/weapon/storage/box/bloodpacks
	name = "blood packs bags"
	desc = "This box contains blood packs."
	icon_state = "sterile"
	New()
		..()
		new /obj/item/weapon/reagent_containers/blood/empty(src)
		new /obj/item/weapon/reagent_containers/blood/empty(src)
		new /obj/item/weapon/reagent_containers/blood/empty(src)
		new /obj/item/weapon/reagent_containers/blood/empty(src)
		new /obj/item/weapon/reagent_containers/blood/empty(src)
		new /obj/item/weapon/reagent_containers/blood/empty(src)
		new /obj/item/weapon/reagent_containers/blood/empty(src)

/obj/item/weapon/reagent_containers/blood
	name = "BloodPack"
	desc = "Flexible bag for IV injectors."
	icon = 'icons/obj/bloodpack.dmi'
	icon_state = "empty"
	volume = 200

	var/species = "Human"
	var/blood_type = null

/obj/item/weapon/reagent_containers/blood/New()
	..()
	if(blood_type)
		name = "BloodPack ([species], [blood_type])"
		var/datum/species/species_type = all_species[species]
		var/blood_colour = species_type.blood_color
		reagents.add_reagent("blood", 200, list("donor"=null,"viruses"=null,"blood_DNA"=null,"blood_type"=blood_type,"species"=species,"resistances"=null,"trace_chem"=null,"blood_colour"=blood_colour))
		update_icon()

/obj/item/weapon/reagent_containers/blood/on_reagent_change()
	update_icon()

/obj/item/weapon/reagent_containers/blood/update_icon()
	overlays.Cut()
	var/percent = round(reagents.total_volume / volume * 100)
	if(reagents.total_volume)
		var/image/filling = image('icons/obj/bloodpack.dmi', "[round(percent,25)]")
		filling.color = reagents.get_color()
		overlays += filling
	overlays += image('icons/obj/bloodpack.dmi', "top")

/obj/item/weapon/reagent_containers/blood/APlus
	blood_type = "A+"

/obj/item/weapon/reagent_containers/blood/AMinus
	blood_type = "A-"

/obj/item/weapon/reagent_containers/blood/BPlus
	blood_type = "B+"

/obj/item/weapon/reagent_containers/blood/BMinus
	blood_type = "B-"

/obj/item/weapon/reagent_containers/blood/OPlus
	blood_type = "O+"

/obj/item/weapon/reagent_containers/blood/OMinus
	blood_type = "O-"

/obj/item/weapon/reagent_containers/blood/OMinus/unathi
	species = "Unathi"

/obj/item/weapon/reagent_containers/blood/OMinus/tajara
	species = "Tajaran"

/obj/item/weapon/reagent_containers/blood/OMinus/skrell
	species = "Skrell"

/obj/item/weapon/reagent_containers/blood/OMinus/resomi
	species = "Resomi"

/obj/item/weapon/reagent_containers/blood/random/New()
	blood_type = pick("A+", "A-", "B+", "B-", "O+", "O-")
	..()

/obj/item/weapon/reagent_containers/blood/random/unathi
	species = "Unathi"

/obj/item/weapon/reagent_containers/blood/random/tajara
	species = "Tajaran"

/obj/item/weapon/reagent_containers/blood/random/skrell
	species = "Skrell"

/obj/item/weapon/reagent_containers/blood/random/resomi
	species = "Resomi"

/obj/item/weapon/reagent_containers/blood/empty
	species = null