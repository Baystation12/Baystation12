/* *
DM version compatibility macros & procs
Retain even if empty - the future exists
*/

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
