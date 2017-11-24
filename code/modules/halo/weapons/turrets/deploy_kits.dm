
/obj/item/turret_deploy_kit
	name = "Turret Deploy Kit"
	desc = "Contains all the parts and single-use tools to construct a turret emplacement"

	icon = 'icons/obj/storage.dmi'
	icon_state = "satchel"

	var/obj/turret_contained = /obj/structure/turret
	var/deploy_time = 15 //The time it takes to deploy the turret, in seconds.

/obj/item/turret_deploy_kit/attack_self(var/mob/user)
	visible_message("<span class = 'danger'>[user] starts setting up a turret emplacement</span>")
	if(do_after(user,deploy_time SECONDS,src,1,1,,1))
		new turret_contained (user.loc)
		qdel(src)

/obj/item/turret_deploy_kit/HMG
	name = "Heavy Machine Gun Deploy Kit"

	turret_contained = /obj/structure/turret/HMG

/obj/item/turret_deploy_kit/chaingun
	name = "Chaingun Deploy Kit"

	turret_contained = /obj/structure/turret/chaingun