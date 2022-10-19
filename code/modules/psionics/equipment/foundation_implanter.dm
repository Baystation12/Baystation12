/obj/item/implanter/psi
	name = "psi-null implanter"
	desc = "An implant gun customized to interact with psi dampeners."
	var/implanter_mode = PSI_IMPLANT_AUTOMATIC

/obj/item/implanter/psi/attack_self(mob/user)
	var/choice = input("Select a new implant mode.", "Psi Dampener") as null|anything in list(PSI_IMPLANT_AUTOMATIC, PSI_IMPLANT_SHOCK, PSI_IMPLANT_WARN, PSI_IMPLANT_LOG, PSI_IMPLANT_DISABLED)
	if(!choice || user != loc) return
	var/obj/item/implant/psi_control/implant = imp
	if(!istype(implant))
		to_chat(user, SPAN_WARNING("The implanter reports there is no compatible implant loaded."))
		return
	implant.psi_mode = choice
	to_chat(user, SPAN_NOTICE("You set \the [src] to configure implants with the '[implant.psi_mode]' setting."))

/obj/item/implanter/psi/New()
	..()
	imp = new /obj/item/implant/psi_control(src)
