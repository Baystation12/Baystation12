#define isWrench(A)      (A && A.iswrench())
#define isWelder(A)      (A && A.iswelder())
#define isCoil(A)        (A && A.iscoil())
#define isWirecutter(A)  (A && A.iswirecutter())
#define isScrewdriver(A) (A && A.isscrewdriver())
#define isMultitool(A)   (A && A.ismultitool())
#define isCrowbar(A)     (A && A.iscrowbar())
#define isHatchet(A)     (A && A.ishatchet())

/atom/proc/iswrench()
	return FALSE

/atom/proc/iswelder()
	return FALSE

/atom/proc/iscoil()
	return FALSE

/atom/proc/iswirecutter()
	return FALSE

/atom/proc/isscrewdriver()
	return FALSE

/atom/proc/ismultitool()
	return FALSE

/atom/proc/iscrowbar()
	return FALSE

/atom/proc/ishatchet()
	return FALSE

/obj/item/weapon/wrench/iswrench()
	return TRUE

/obj/item/weapon/weldingtool/iswelder()
	return TRUE

/obj/item/stack/cable_coil/iscoil()
	return TRUE

/obj/item/weapon/wirecutters/iswirecutter()
	return TRUE

/obj/item/weapon/screwdriver/isscrewdriver()
	return TRUE

/obj/item/device/multitool/ismultitool()
	return TRUE

/obj/item/weapon/crowbar/iscrowbar()
	return TRUE

/obj/item/weapon/material/hatchet/ishatchet()
	return TRUE