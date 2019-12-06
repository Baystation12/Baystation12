/obj/item/weapon/implanter/psi
	name = "psi-null implanter"
	desc = "An implant gun customized to interact with psi dampeners."
	var/implanter_mode = PSI_IMPLANT_AUTOMATIC

/obj/item/weapon/implanter/psi/attack_self(var/mob/user)
	var/choice = input("Select a new implant mode.", "Psi Dampener") as null|anything in list(PSI_IMPLANT_AUTOMATIC, PSI_IMPLANT_SHOCK, PSI_IMPLANT_WARN, PSI_IMPLANT_LOG, PSI_IMPLANT_DISABLED)
	if(!choice || user != loc) return
	var/obj/item/weapon/implant/psi_control/implant = imp
	if(!istype(implant))
		to_chat(user, "<span class='warning'>The implanter reports there is no compatible implant loaded.</span>")
		return
	implant.psi_mode = choice
	to_chat(user, "<span class='notice'>You set \the [src] to configure implants with the '[implant.psi_mode]' setting.</span>")

/obj/item/weapon/implanter/psi/New()
	..()
	imp = new /obj/item/weapon/implant/psi_control(src)
