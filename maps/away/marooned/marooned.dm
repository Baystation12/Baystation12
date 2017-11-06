#include "marooned_areas.dm"
#include "marooned.dmm"
#include "../mining/mining_areas.dm"

/turf/simulated/floor/marooned/snow
	name = "snow"
	icon = 'icons/turf/snow.dmi'
	icon_state = "snow"
	temperature = T20C - 40

/obj/effect/overmap/sector/marooned
	name = "Glacier planet with power signature in polar region"
	desc = "Moon-sized planet with breathable atmosphere. We detect power signature on a surface."
	icon_state = "object"
	known = 0

	generic_waypoints = list(
		"nav_marooned_1",
		"nav_marooned_2",
		"nav_marooned_antag"
	)

/obj/effect/shuttle_landmark/nav_marooned/nav1
	name = "Planetside Navpoint #1"
	landmark_tag = "nav_marooned_1"

/obj/effect/shuttle_landmark/nav_marooned/nav2
	name = "Planetside Navpoint #2"
	landmark_tag = "nav_marooned_2"

/obj/effect/shuttle_landmark/nav_marooned/nav3
	name = "Planetside Navpoint #3"
	landmark_tag = "nav_marooned_antag"

/obj/item/clothing/under/magintka_uniform
	name = "Magnitka fleet officer uniform"
	desc = "Dark uniform coat worn by Magnitka fleet officers."
	icon_state = "magnitka_officer"
	item_state = "magnitka_officer_on"
	worn_state = "magnitka_officer"
	icon = 'marooned_sprites.dmi'

/obj/item/clothing/accessory/medal/silver/marooned_medal
	name = "\improper marooned officer's  medal"
	desc = "An silver round medal of marooned officer. It has inscription \"For Distinguished Service\" in lower part. On medal's plank it's engraved \"H. Warda\""
	icon_state = "marooned_medal"
	icon = 'marooned_sprites.dmi'

/obj/effect/landmark/corpse/marooned_officer
	name = "Marooned Magnitka's fleet officer"
	corpseuniform = /obj/item/clothing/under/magintka_uniform
	corpsesuit = /obj/item/clothing/suit/storage/hooded/wintercoat
	corpseshoes = /obj/item/clothing/shoes/jungleboots
	corpsegloves = /obj/item/clothing/gloves/thick
	corpsehelmet = /obj/item/clothing/head/beret
	corpsepocket1 = /obj/item/weapon/material/butterfly/switchblade

/obj/item/weapon/paper/marooned/note1
	name = "Marooned note 1"
	info = "Those bastards!<br>They just pushed me inside pod and locked the hatch, then started yelling at each other outside. It seems, some of the officers, Lt. Pytlak was loudest, who joined this fucking mutiny said I won't go to surface with nothing but my coat. Ha!<br> Some time later they opened the hatch, three sailors aiming at me, and another pushed inside couple of crates."

/obj/item/weapon/paper/marooned/note2
	name = "Marooned note 2"
	info = "Landing was harsh, oh, too harsh. This little pod was not meant to land to atmosphere. <br> Pod stopped hard at rocky wall, and I lost consciousness for few hours, it seems.<br> Seems I broke couple of ribs and lost few teeth. <br> When I got outside, it was dark. It was so cold I momentarily started to shake. I checked crates and beside some food I found warm coat, thanks gods."

/obj/item/weapon/paper/marooned/note3
	name = "Marooned note 3"
	info = "Now I don't think anyone will find this, but I'll Introduce myself. Major of Fleet Horacy Warda, Magnitka Defence forces.<br><br> I hid inside pod until morning came, then left for reconnaissance mission. What I found was few small snow-covered valleys, some trees, couple of ponds that are surpisingly still liquid. Hope it's some thermal water, I can't keep eating snow to get thirst down. <br><i>Major Warda</i> <br>2549-07-11"

/obj/item/weapon/paper/marooned/note4
	name = "Marooned note 4"
	info = "I set up myself small wooden shelter, luckily I had hatchet and I know how to make things with wood since I helped my late father with his construction work.<br> When star was going close to horizont, I noticed deer-like creature. I rushed inside and grabed that gun they left, shot three times. This piece of junk with cut away barrel is only good to put in mouth and pull the trigger. I won't give up so fast. <br><i>Major Warda</i> <br>2549-09-11"

/obj/item/weapon/paper/marooned/note5
	name = "Marooned note 5"
	info = "I returned to crash site and checked if there's still anything useful. I found some electronic scraps, almost undamaged battery and few metal rods.<br> Back at shelter I tried to remember all I know about radio schemes but to little success. Best I can do is to make some sort of antenna, pick this mobile radio I still had in my pocket and amplify signal by connecting battery I found to radio power input<br> Have to pray it won't just explode or catch fire. <br><i>Major Warda</i> <br>2549-13-11"

/obj/item/weapon/paper/marooned/note6
	name = "Marooned note 6"
	info = "Seems my jury-rigged emergency radio transmitter works. I hope it sends anything at least.<br> I can't recharge it anymore since generator I have has no more fuel so I'll make one emergency call every day when I wake up.<br> Now I still have some food and water tastes weird but still good to drink, I simply must wait for any help to arrive. <br><i>Major Warda</i> <br>2549-16-11"

/obj/item/weapon/paper/marooned/note7
	name = "Marooned note 7"
	info = "I barely managed to stand up and get to table to write this down. Seems I got cold and too starved to make it<br> I &ave t& <br> Can't wa&t<br> I know I was loyal to the end. For my wife and daughter, I love you. <br> Glory to Magnitka! <br><i>Major Horacy Warda</i> <br>2549-04-12"