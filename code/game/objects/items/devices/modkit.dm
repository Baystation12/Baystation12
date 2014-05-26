/obj/item/device/modkit
	name = "hardsuit modification kit"
	desc = "A kit containing all the needed tools and parts to modify a hardsuit for another user."
	icon_state = "modkit"
	var/conversion[]

/obj/item/device/modkit/afterattack(obj/O, mob/user as mob)
	if(!istype(O, /obj/item/clothing/suit/space/rig))
		user << "<span class='warning'>Target item must be a space suit to be modified.</span>"
		return
	if (!conversion[O.type])
		user << "<span class='warning'>There are no parts suitable for modification of this suit.</span>"
		return
	if(!isturf(O.loc))
		user << "<span class='warning'>[O] must be safely placed on the ground for modification.</span>"
		return
	playsound(user.loc, 'sound/items/Screwdriver.ogg', 100, 1)
	var/obj/N = new conversion[O.type]
	N.loc = O.loc
	user.visible_message("\red [user] opens \the [src] and modifies \the [O] into \the [N].","\red You open \the [src] and modify \the [O] into \the [N].")
	del(O)

/obj/item/device/modkit/tajaran
	name = "tajara hardsuit modification kit"
	desc = "A kit containing all the needed tools and parts to modify a hardsuit for another user. This one looks like it's meant for Tajara."

/obj/item/device/modkit/tajaran/New()
	//Direct conversion
	conversion[/obj/item/clothing/head/helmet/space/rig] = /obj/item/clothing/head/helmet/space/rig/tajara
	conversion[/obj/item/clothing/suit/space/rig] = /obj/item/clothing/suit/space/rig/tajara
	conversion[/obj/item/clothing/head/helmet/space/rig/mining] = /obj/item/clothing/head/helmet/space/rig/mining/tajara
	conversion[/obj/item/clothing/suit/space/rig/mining] = /obj/item/clothing/suit/space/rig/mining/tajara
	conversion[/obj/item/clothing/head/helmet/space/rig/medical] = /obj/item/clothing/head/helmet/space/rig/medical/tajara
	conversion[/obj/item/clothing/suit/space/rig/medical] = /obj/item/clothing/suit/space/rig/medical/tajara
	conversion[/obj/item/clothing/head/helmet/space/rig/elite] = /obj/item/clothing/head/helmet/space/rig/elite/tajara
	conversion[/obj/item/clothing/suit/space/rig/elite] = /obj/item/clothing/suit/space/rig/elite/tajara
	conversion[/obj/item/clothing/head/helmet/space/rig/security] = /obj/item/clothing/head/helmet/space/rig/security/tajara
	conversion[/obj/item/clothing/suit/space/rig/security] = /obj/item/clothing/suit/space/rig/security/tajara
	conversion[/obj/item/clothing/head/helmet/space/rig/atmos] = /obj/item/clothing/head/helmet/space/rig/atmos/tajara
	conversion[/obj/item/clothing/suit/space/rig/atmos] = /obj/item/clothing/suit/space/rig/atmos/tajara

	//Reverse conversion
	conversion[/obj/item/clothing/head/helmet/space/rig/tajara] = /obj/item/clothing/head/helmet/space/rig
	conversion[/obj/item/clothing/suit/space/rig/tajara] = /obj/item/clothing/suit/space/rig
	conversion[/obj/item/clothing/head/helmet/space/rig/mining/tajara] = /obj/item/clothing/head/helmet/space/rig/mining
	conversion[/obj/item/clothing/suit/space/rig/mining/tajara] = /obj/item/clothing/suit/space/rig/mining
	conversion[/obj/item/clothing/head/helmet/space/rig/medical/tajara] = /obj/item/clothing/head/helmet/space/rig/medical
	conversion[/obj/item/clothing/suit/space/rig/medical/tajara] = /obj/item/clothing/suit/space/rig/medical
	conversion[/obj/item/clothing/head/helmet/space/rig/elite/tajara] = /obj/item/clothing/head/helmet/space/rig/elite
	conversion[/obj/item/clothing/suit/space/rig/elite/tajara] = /obj/item/clothing/suit/space/rig/elite
	conversion[/obj/item/clothing/head/helmet/space/rig/security/tajara] = /obj/item/clothing/head/helmet/space/rig/security
	conversion[/obj/item/clothing/suit/space/rig/security/tajara] = /obj/item/clothing/suit/space/rig/security
	conversion[/obj/item/clothing/head/helmet/space/rig/atmos/tajara] = /obj/item/clothing/head/helmet/space/rig/atmos
	conversion[/obj/item/clothing/suit/space/rig/atmos/tajara] = /obj/item/clothing/suit/space/rig/atmos