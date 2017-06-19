/obj/item/ammo_casing
	name = "bullet casing"
	desc = "A bullet casing."
	icon = 'icons/obj/gun_components/ammo_casings.dmi'
	icon_state = "small"
	flags = CONDUCT
	slot_flags = SLOT_BELT | SLOT_EARS
	throwforce = 1
	w_class = 1
	matter = list("steel" = 1000)

	var/leaves_residue = 1
	var/caliber	                        // Which kind of guns it can be loaded into
	var/projectile_type                 // The bullet type to create when New() is called
	var/obj/item/projectile/projectile  // The loaded bullet - make it so that the projectiles are created only when needed?
	var/spent_icon = null


/obj/item/ammo_casing/initialize()
	name = "[initial(name)] ([caliber])"

/obj/item/ammo_casing/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(istype(W, /obj/item/weapon/screwdriver))
		if(!projectile)
			to_chat(user, "<span class='notice'>There is no bullet in the casing to inscribe anything into.</span>")
			return

		var/tmp_label = ""
		var/label_text = sanitizeSafe(input(user, "Inscribe some text into \the [initial(projectile.name)]","Inscription",tmp_label), MAX_NAME_LEN)
		if(length(label_text) > 20)
			to_chat(user, "<span class='warning'>The inscription can be at most 20 characters long.</span>")
		else if(!label_text)
			to_chat(user, "<span class='notice'>You scratch the inscription off of [initial(projectile)].</span>")
			projectile.name = initial(projectile.name)
		else
			to_chat(user, "<span class='notice'>You inscribe \"[label_text]\" into \the [initial(projectile.name)].</span>")
			projectile.name = "[initial(projectile.name)] (\"[label_text]\")"
	else ..()

/obj/item/ammo_casing/New()
	..()
	if(ispath(projectile_type))
		projectile = new projectile_type(src)
	pixel_x = rand(-10, 10)
	pixel_y = rand(-10, 10)

//removes the projectile from the ammo casing
/obj/item/ammo_casing/proc/expend()
	. = projectile
	projectile = null
	set_dir(pick(cardinal)) //spin spent casings
	if(spent_icon)
		icon_state = spent_icon
	// Aurora forensics port, gunpowder residue.
	if(leaves_residue)
		leave_residue()
	name = "spent [name]"

/obj/item/ammo_casing/proc/leave_residue()
	var/mob/living/carbon/human/H
	if(ishuman(loc))
		H = loc //in a human, somehow
	else if(loc && ishuman(loc.loc))
		H = loc.loc //more likely, we're in a gun being held by a human

	if(H)
		if(H.gloves && (H.l_hand == loc || H.r_hand == loc))
			var/obj/item/clothing/G = H.gloves
			G.gunshot_residue = caliber
		else
			H.gunshot_residue = caliber

// Predefines.
/obj/item/ammo_casing/gyrojet
	caliber = CALIBER_CANNON
	icon_state = "rocket"
	spent_icon = "rocket-spent"
	projectile_type = /obj/item/projectile/bullet/gyro

/obj/item/ammo_casing/grenade
	caliber = CALIBER_GRENADE
	icon_state = "rocket"
	projectile_type = /obj/item/projectile/bullet/gyro

/obj/item/ammo_casing/rocket
	caliber = CALIBER_ROCKET
	icon_state = "rocket"
	projectile_type = /obj/item/projectile/bullet/gyro
