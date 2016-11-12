
//Port from VORE
/obj/item/weapon/pickaxe/excavationdrill
	name = "excavation drill"
	icon = 'icons/obj/xenoarchaeology.dmi'
	icon_state = "excavationdrill"
	item_state = "syringe_0"
	excavation_amount = 15
	digspeed = 30
	desc = "Advanced archaeological drill combining ultrasonic excitation and bluespace manipulation to provide extreme precision. The diamond tip is adjustable from 1 to 30 cm."
	drill_sound = 'sound/weapons/thudswoosh.ogg'
	drill_verb = "drilling"
	force = 10.0
	attack_verb = list("drilled")

/obj/item/weapon/pickaxe/excavationdrill/attack_self(mob/user as mob)
	var/depth = input("Put the desired depth (1-30 centimeters).", "Set Depth", 30) as num
	if(depth>30 || depth<1)
		to_chat(user, "<span class='notice'>Invalid depth.</span>")
		return
	excavation_amount = depth
	to_chat(user, "<span class='notice'>You set the depth to [depth]cm.</span>")

/obj/item/weapon/pickaxe/excavationdrill/examine(mob/user)
	..()
	var/depth = excavation_amount
	to_chat(user, "<span class='info'>It is currently set at [depth]cms.</span>")


/datum/design/item/weapon/mining/excavationdrill
	name = "Excavation Drill"
	desc = "Advanced archaeological drill combining ultrasonic excitation and bluespace manipulation to provide extreme precision. The silver tip is adjustable from 1 to 30 cm."
	id = "excavationdrill"
	req_tech = list(TECH_MATERIAL = 4, TECH_POWER = 3, TECH_ENGINEERING = 3)
	materials = list(DEFAULT_WALL_MATERIAL = 4000, "glass" = 1000) //Original was with silver, I removed it so fuckers in xenoarch go and fucking do R&D first.
	build_path = /obj/item/weapon/pickaxe/excavationdrill
	sort_string = "KAAAX"

//End port from VORE