/obj/item/device/floor_painter
	name = "floor painter"
	icon = 'icons/obj/bureaucracy.dmi'
	icon_state = "labeler1"
	item_state = "flight"

	var/list/decals = list(
		"white square" =      /obj/effect/floor_decal/corner,
		"blue square" =       /obj/effect/floor_decal/corner/blue,
		"pale blue square" =  /obj/effect/floor_decal/corner/paleblue,
		"green square" =      /obj/effect/floor_decal/corner/green,
		"lime square" =       /obj/effect/floor_decal/corner/lime,
		"yellow square" =     /obj/effect/floor_decal/corner/yellow,
		"beige square" =      /obj/effect/floor_decal/corner/beige,
		"red square" =        /obj/effect/floor_decal/corner/red,
		"pink square" =       /obj/effect/floor_decal/corner/pink,
		"purple square" =     /obj/effect/floor_decal/corner/purple,
		"mauve square" =      /obj/effect/floor_decal/corner/mauve,
		"orange square" =     /obj/effect/floor_decal/corner/orange,
		"brown square" =      /obj/effect/floor_decal/corner/brown,
		"grey square" =       /obj/effect/floor_decal/corner/grey,
		"hazard stripes" =    /obj/effect/floor_decal/industrial/warning,
		"corner, hazard" =    /obj/effect/floor_decal/industrial/warning/corner,
		"hatched marking" =   /obj/effect/floor_decal/industrial/hatch,
		"white outline" =     /obj/effect/floor_decal/industrial/outline,
		"blue outline" =      /obj/effect/floor_decal/industrial/outline/blue,
		"yellow outline" =    /obj/effect/floor_decal/industrial/outline/yellow,
		"grey outline" =      /obj/effect/floor_decal/industrial/outline/grey,
		"loading sign" =      /obj/effect/floor_decal/industrial/loading,
		"1" =                 /obj/effect/floor_decal/sign,
		"2" =                 /obj/effect/floor_decal/sign/two,
		"A" =                 /obj/effect/floor_decal/sign/a,
		"B" =                 /obj/effect/floor_decal/sign/b,
		"C" =                 /obj/effect/floor_decal/sign/c,
		"D" =                 /obj/effect/floor_decal/sign/d,
		"Ex" =                /obj/effect/floor_decal/sign/ex,
		"M" =                 /obj/effect/floor_decal/sign/m,
		"CMO" =               /obj/effect/floor_decal/sign/cmo,
		"V" =                 /obj/effect/floor_decal/sign/v,
		"Psy" =               /obj/effect/floor_decal/sign/p,
		"remove all decals" = /obj/effect/floor_decal/reset
		)
	var/decal = "remove all decals"

	var/list/paint_dirs = list(
		"north" =       NORTH,
		"northwest" =   NORTHWEST,
		"west" =        WEST,
		"southwest" =   SOUTHWEST,
		"south" =       SOUTH,
		"southeast" =   SOUTHEAST,
		"east" =        EAST,
		"northeast" =   NORTHEAST,
		"user-facing" = 0
		)
	var/paint_dir = "user-facing"

/obj/item/device/floor_painter/afterattack(var/atom/A, var/mob/user, proximity)
	if(!proximity)
		return

	var/turf/simulated/floor/F = A
	if(!istype(F))
		user << "<span class='warning'>\The [src] can only be used on station flooring.</span>"
		return

	if(!F.flooring || !F.flooring.can_paint || F.broken || F.burnt)
		user << "<span class='warning'>\The [src] cannot paint broken or missing tiles.</span>"
		return

	if(F.decals && F.decals.len > 5)
		user << "<span class='warning'>\The [F] has been painted too much; you need to clear it off.</span>"
		return

	var/painting_decal = decals[decal]
	if(!ispath(painting_decal))
		user << "<span class='warning'>\The [src] flashes an error light. You might need to reconfigure it.</span>"
		return

	var/painting_dir = 0
	if(paint_dir == "user-facing")
		painting_dir = user.dir
	else if(paint_dirs[paint_dir])
		painting_dir = paint_dirs[paint_dir]
	new painting_decal(F, painting_dir)

/obj/item/device/floor_painter/attack_self(mob/user as mob)

	var/choice = input("Do you wish to change the decal type or the paint direction?") as null|anything in list("Decal","Direction")
	if(choice == "Decal")
		var/new_decal = input("Select a decal.") as null|anything in decals
		if(new_decal && !isnull(decals[new_decal]))
			decal = new_decal
			user << "<span class='notice'>You set \the [src] decal to '[decal]'.</span>"
	else if(choice == "Direction")
		var/new_dir = input("Select a direction.") as null|anything in paint_dirs
		if(new_dir && !isnull(paint_dirs[new_dir]))
			paint_dir = new_dir
			user << "<span class='notice'>You set \the [src] direction to '[paint_dir]'.</span>"

/obj/item/device/floor_painter/examine(mob/user)
	..(user)
	user << "It is configured to paint the '[decal]' decal with a direction of '[paint_dir]'."
