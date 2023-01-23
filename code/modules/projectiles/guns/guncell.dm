#define BATTERY_PISTOL 3
#define BATTERY_RIFLE 6
#define BATTERY_VOX 10
#define BATTERY_ALIEN 15

#define BATTERY_VERYSMALL 0
#define BATTERY_SMALL 1
#define BATTERY_MEDIUM 2
#define BATTERY_LARGE 3
#define BATTERY_MEGALARGE 4
#define BATTERY_HUGE 5

/obj/item/cell/guncell
	w_class = ITEM_SIZE_SMALL
	name = "Small battery"
	icon = 'proxima/icons/obj/guns/guncells.dmi'
	var/battery_chamber_size
	var/overcharged = FALSE			//will allow cell to be used as hand grenade
	var/discharging = FALSE			//To see if it's going to boom
	var/emp_vulnerable = FALSE

/obj/item/cell/guncell/proc/detonate(mob/living/user)
	var/turf/T = get_turf(src)
	var/explosion_size =
	if(T)

	if(explosion_size>0)
		explosion(O, -1, -1, explosion_size, round(explosion_size/2), 0)

	qdel(src)

/obj/item/cell/guncell/proc/discharge()
	playsound(loc, arm_sound, 75, 0, -3)
	addtimer(CALLBACK(src, .proc/detonate, user), 50) // 5 senconds

/obj/item/cell/guncell/attack_self(mob/user)
	if(discharging==TRUE)
		to_chat(user, "<span class='warning'>\The [src] is already discharging! Dispose it!</span>")
		return
	if(overcharged==TRUE)
		to_chat(user, "<span class='warning'>You activated guncell overcharge function. It will explode in 5 seconds.</span>")
		if (user)
			msg_admin_attack("[user.name] ([user.ckey]) primed \a [src] (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[user.x];Y=[user.y];Z=[user.z]'>JMP</a>)")
		discharge()
	else
		to_chat(user, "<span class='notice'>\The [src] doesn't have overcharged function. Please contact your local manufacturer.</span>")

/obj/item/cell/guncell/overcharged
	name = "Hypercharged small battery"

/obj/item/cell/guncell/pistol
	name = "Small pistol battery"

/obj/item/cell/guncell/pistol/overcharged
	name = "Hypercharged pistol battery"

/obj/item/cell/guncell/ascent
	name = "Ascent power core"
	desc = "A very special battery for a very comlex ascent weaponary. This one is stabilized."
	charge = 400 // base 20 shots
	maxcharge = 400
	battery_chamber_size = BATTERY_ALLIEN

/obj/item/cell/guncell/verysmall
	name = "Very-Small weapon battery"
	desc = "A small battery for energy guns. Rated for 100Wh."
	charge = 100 // base 5 shots
	maxcharge = 100
	battery_chamber_size = BATTERY_VERYSMALL
	icon_state = "b_0"

/obj/item/cell/guncell/small
	name = "Small weapon battery"
	desc = "A small battery for energy guns. Rated for 200Wh."
	charge = 200 // base 10 shots
	maxcharge = 200
	battery_chamber_size = BATTERY_SMALL
	icon_state = "b_1"

/obj/item/cell/guncell/medium
	name = "Medium weapon battery"
	desc = "A medium battery for energy guns. Rated for 300Wh."
	charge = 300 // base 15 shots
	maxcharge = 300
	battery_chamber_size = BATTERY_MEDIUM
	icon_state = "b_2"

/obj/item/cell/guncell/large
	name = "Large weapon battery"
	desc = "A large battery for energy guns. Rated for 400Wh."
	charge = 400 // base 20 shots
	maxcharge = 400
	battery_chamber_size = BATTERY_LARGE
	icon_state = "b_3"

/obj/item/cell/guncell/megalarge
	name = "Very-Large weapon battery"
	desc = "A very large battery for energy guns. Rated for 500Wh."
	charge = 500 // base 25 shots
	maxcharge = 500
	battery_chamber_size = BATTERY_MEGALARGE
	icon_state = "b_4"

/obj/item/cell/guncell/huge
	name = "Huge weapon battery"
	desc = "A huge battery for energy guns. Rated for 600Wh."
	charge = 600 // base 30 shots
	maxcharge = 600
	battery_chamber_size = BATTERY_HUGE
	icon_state = "b_5"



//pasta time
/obj/item/cell/guncell/on_update_icon()

	var/new_overlay_state = null
	switch(percent())
		if(70 to 100)
			new_overlay_state = "b_70+"
		if(35 to 69)
			new_overlay_state = "b_35+"
		if(0.05 to 34)
			new_overlay_state = "b_0+"

	if(new_overlay_state != overlay_state)
		overlay_state = new_overlay_state
		overlays.Cut()
		if(overlay_state)
			overlays += image(icon, overlay_state)

/obj/item/cell/guncell/overcharged/on_update_icon()

	var/new_overlay_state = null
	switch(percent())
		if(70 to 100)
			new_overlay_state = "bo_70+"
		if(35 to 69)
			new_overlay_state = "bo_35+"
		if(0.05 to 34)
			new_overlay_state = "bo_0+"

	if(new_overlay_state != overlay_state)
		overlay_state = new_overlay_state
		overlays.Cut()
		if(overlay_state)
			overlays += image(icon, overlay_state)

/obj/item/cell/guncell/pistol/on_update_icon()

	var/new_overlay_state = null
	switch(percent())
		if(70 to 100)
			new_overlay_state = "p_70+"
		if(35 to 69)
			new_overlay_state = "p_35+"
		if(0.05 to 34)
			new_overlay_state = "p_0+"

	if(new_overlay_state != overlay_state)
		overlay_state = new_overlay_state
		overlays.Cut()
		if(overlay_state)
			overlays += image(icon, overlay_state)

/obj/item/cell/guncell/pistol/overcharged/on_update_icon()

	var/new_overlay_state = null
	switch(percent())
		if(70 to 100)
			new_overlay_state = "po_70+"
		if(35 to 69)
			new_overlay_state = "po_35+"
		if(0.05 to 34)
			new_overlay_state = "po_0+"

	if(new_overlay_state != overlay_state)
		overlay_state = new_overlay_state
		overlays.Cut()
		if(overlay_state)
			overlays += image(icon, overlay_state)

/obj/item/cell/guncell/ascent/on_update_icon()

	var/new_overlay_state = null
	switch(percent())
		if(70 to 100)
			new_overlay_state = "a_70+"
		if(35 to 69)
			new_overlay_state = "a_35+"
		if(0.05 to 34)
			new_overlay_state = "a_0+"

	if(new_overlay_state != overlay_state)
		overlay_state = new_overlay_state
		overlays.Cut()
		if(overlay_state)
			overlays += image(icon, overlay_state)

/obj/item/cell/guncell/ascent/overcharged/on_update_icon()

	var/new_overlay_state = null
	switch(percent())
		if(70 to 100)
			new_overlay_state = "ao_70+"
		if(35 to 69)
			new_overlay_state = "ao_35+"
		if(0.05 to 34)
			new_overlay_state = "ao_0+"

	if(new_overlay_state != overlay_state)
		overlay_state = new_overlay_state
		overlays.Cut()
		if(overlay_state)
			overlays += image(icon, overlay_state)

/obj/item/cell/guncell/vox/on_update_icon()

	var/new_overlay_state = null
	switch(percent())
		if(70 to 100)
			new_overlay_state = "v_70+"
		if(35 to 69)
			new_overlay_state = "v_35+"
		if(0.05 to 34)
			new_overlay_state = "v_0+"

	if(new_overlay_state != overlay_state)
		overlay_state = new_overlay_state
		overlays.Cut()
		if(overlay_state)
			overlays += image(icon, overlay_state)

/obj/item/cell/guncell/vox/overcharged/on_update_icon()

	var/new_overlay_state = null
	switch(percent())
		if(70 to 100)
			new_overlay_state = "vo_70+"
		if(35 to 69)
			new_overlay_state = "vo_35+"
		if(0.05 to 34)
			new_overlay_state = "vo_0+"

	if(new_overlay_state != overlay_state)
		overlay_state = new_overlay_state
		overlays.Cut()
		if(overlay_state)
			overlays += image(icon, overlay_state)
