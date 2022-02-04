/* *
DM version compatibility macros & procs
Retain even if empty - the future exists
*/

#if DM_VERSION < 513


#define islist(A) istype(A, /list)
#define ismovable(A) istype(A, /atom/movable)

#define arctan(X) arcsin((X) / sqrt(1 + (X) * (X)))

#define copytext_char(ARGS...) copytext_char(ARGS)
#define findlasttext_char(ARGS...) findlasttext(ARGS)
#define findlasttextEx_char(ARGS...) findlasttextEx(ARGS)
#define findtext_char(ARGS...) findtext(ARGS)
#define findtextEx_char(ARGS...) findtextEx(ARGS)
#define length_char(X) length(X)
#define nonspantext_char(ARGS...) nonspantext(ARGS)
#define replacetext_char(ARGS...) replacetext_char(ARGS)
#define replacetextEx_char(ARGS...) replacetextEx(ARGS)
#define spantext_char(ARGS...) spantext(ARGS)
#define splittext_char(ARGS...) splittext(ARGS)
#define text2ascii_char(ARGS...) text2ascii(ARGS)

#define regex_replace_char(RE, ARGS...) RE.Replace(ARGS)
#define regex_replace(RE, ARGS...) RE.Replace(ARGS)
#define regex_find_char(RE, ARGS...) RE.Find(ARGS)
#define regex_find(RE, ARGS...) RE.Find(ARGS)

/proc/hex2num(hex)
	. = 0
	var/place = 1
	for (var/i in length(hex) to 1 step -1)
		var/num = text2ascii(hex, i)
		switch (num)
			if (45) return . * -1 // -
			if (48 to 57) num -= 48 // 0-9
			if (65 to 70) num -= 55 // A-F
			if (97 to 102) num -= 87 // a-f
			else
				crash_with("invalid hex '[hex]'")
				return 0
		. += num * place
		place *= 16

/proc/num2hex(num)
	if (!isfinite(num) || !num)
		return "0"
	num = round(abs(num))
	while (num)
		switch (num & 0xf)
			if (0) . = "0[.]"
			if (1 to 9) . = "[num & 0xf][.]"
			else . = "[ascii2text((num & 0xf) + 87)][.]"
		num >>= 4


#else //513+


#define regex_replace_char(RE, ARGS...) RE.Replace_char(ARGS)
#define regex_replace(RE, ARGS...) RE.Replace(ARGS)
#define regex_find_char(RE, ARGS...) RE.Find_char(ARGS)
#define regex_find(RE, ARGS...) RE.Find(ARGS)

#define hex2num(hex) (text2num(hex, 16) || 0)
#define num2hex(num) num2text(num, 1, 16)


#endif


#if DM_VERSION < 514

/// Create the list(R, G, B[, A]) for inputs "#RGB", "#RGBA", "#RRGGBB", or "#RRGGBBAA". IGNORES color space.
/proc/rgb2num(T)
	var/static/regex/allowed = new(@"^#[0-9a-fA-F]{3,8}$")
	if (findtext(T, allowed))
		switch (length(T))
			if (4) return list(hex2num("[T[2]][T[2]]"), hex2num("[T[3]][T[3]]"), hex2num("[T[4]][T[4]]")) //"#RGB"
			if (5) return list(hex2num("[T[2]][T[2]]"), hex2num("[T[3]][T[3]]"), hex2num("[T[4]][T[4]]"), hex2num("[T[5]][T[5]]")) //"#RGBA"
			if (7) return list(hex2num("[T[2]][T[3]]"), hex2num("[T[4]][T[5]]"), hex2num("[T[6]][T[7]]")) //"#RRGGBB"
			if (9) return list(hex2num("[T[2]][T[3]]"), hex2num("[T[4]][T[5]]"), hex2num("[T[6]][T[7]]"), hex2num("[T[8]][T[9]]")) //"#RRGGBBAA"
	crash_with("bad color '[T]'")

#endif
