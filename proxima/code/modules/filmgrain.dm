GLOBAL_VAR_INIT(film_grain_stat, FALSE)

/mob/living/carbon/human
	var/obj/screen/film_grain

/obj/screen/filmgraim
	icon = 'icons/effects/static.dmi'
	icon_state = "4 light"

/client/proc/toggle_film_grain()
	set category = "Fun"
	set name = "Toggle film grain"
	set desc = "Toggle's horror screen effect for everyone"

	if(alert("Are you sure? This will toggle film grain to [!GLOB.film_grain_stat]", "Confirm", "Yes", "No") == "No") return

	GLOB.film_grain_stat = !GLOB.film_grain_stat
	var/stat = GLOB.film_grain_stat
	var/horytext = list(
		SPAN_NOTICE("Это облегчение... Будто камень с плечь."),
		SPAN_WARNING("Вам кажется, что в ваших глазах потемнело, а все вокруг стало каким то другим. Возможно, вам стоит передохнуть...")
	)
	var/horysound = list(
		'proxima/sound/ambience/horror_3.ogg',
		'proxima/sound/misc/statue/scare1.ogg'
	)
	for (var/mob/living/carbon/human/H in SSmobs.mob_list)
		if(!H.film_grain) continue
		if(H.client)
			if(stat)
				H.client.screen += H.film_grain
			else
				H.client.screen -= H.film_grain

			to_chat(H, horytext[stat+1])
			sound_to(H, horysound[stat+1])

	log_and_message_admins("film grain toggled to [stat]")
