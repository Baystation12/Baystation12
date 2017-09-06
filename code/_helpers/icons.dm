/*
IconProcs README

A BYOND library for manipulating icons and colors

by Lummox JR

version 1.0

The IconProcs library was made to make a lot of common icon operations much easier. BYOND's icon manipulation
routines are very capable but some of the advanced capabilities like using alpha transparency can be unintuitive to beginners.

CHANGING ICONS

Several new procs have been added to the /icon datum to simplify working with icons. To use them,
remember you first need to setup an /icon var like so:

var/icon/my_icon = new('iconfile.dmi')

icon/ChangeOpacity(amount = 1)
    A very common operation in DM is to try to make an icon more or less transparent. Making an icon more
    transparent is usually much easier than making it less so, however. This proc basically is a frontend
    for MapColors() which can change opacity any way you like, in much the same way that SetIntensity()
    can make an icon lighter or darker. If amount is 0.5, the opacity of the icon will be cut in half.
    If amount is 2, opacity is doubled and anything more than half-opaque will become fully opaque.
icon/GrayScale()
    Converts the icon to grayscale instead of a fully colored icon. Alpha values are left intact.
icon/ColorTone(tone)
    Similar to GrayScale(), this proc converts the icon to a range of black -> tone -> white, where tone is an
    RGB color (its alpha is ignored). This can be used to create a sepia tone or similar effect.
    See also the global ColorTone() proc.
icon/MinColors(icon)
    The icon is blended with a second icon where the minimum of each RGB pixel is the result.
    Transparency may increase, as if the icons were blended with ICON_ADD. You may supply a color in place of an icon.
icon/MaxColors(icon)
    The icon is blended with a second icon where the maximum of each RGB pixel is the result.
    Opacity may increase, as if the icons were blended with ICON_OR. You may supply a color in place of an icon.
icon/Opaque(background = "#000000")
    All alpha values are set to 255 throughout the icon. Transparent pixels become black, or whatever background color you specify.
icon/BecomeAlphaMask()
    You can convert a simple grayscale icon into an alpha mask to use with other icons very easily with this proc.
    The black parts become transparent, the white parts stay white, and anything in between becomes a translucent shade of white.
icon/AddAlphaMask(mask)
    The alpha values of the mask icon will be blended with the current icon. Anywhere the mask is opaque,
    the current icon is untouched. Anywhere the mask is transparent, the current icon becomes transparent.
    Where the mask is translucent, the current icon becomes more transparent.
icon/UseAlphaMask(mask, mode)
    Sometimes you may want to take the alpha values from one icon and use them on a different icon.
    This proc will do that. Just supply the icon whose alpha mask you want to use, and src will change
    so it has the same colors as before but uses the mask for opacity.

COLOR MANAGEMENT AND HSV

RGB isn't the only way to represent color. Sometimes it's more useful to work with a model called HSV, which stands for hue, saturation, and value.

    * The hue of a color describes where it is along the color wheel. It goes from red to yellow to green to
    cyan to blue to magenta and back to red.
    * The saturation of a color is how much color is in it. A color with low saturation will be more gray,
    and with no saturation at all it is a shade of gray.
    * The value of a color determines how bright it is. A high-value color is vivid, moderate value is dark,
    and no value at all is black.

Just as BYOND uses "#rrggbb" to represent RGB values, a similar format is used for HSV: "#hhhssvv". The hue is three
hex digits because it ranges from 0 to 0x5FF.

    * 0 to 0xFF - red to yellow
    * 0x100 to 0x1FF - yellow to green
    * 0x200 to 0x2FF - green to cyan
    * 0x300 to 0x3FF - cyan to blue
    * 0x400 to 0x4FF - blue to magenta
    * 0x500 to 0x5FF - magenta to red

Knowing this, you can figure out that red is "#000ffff" in HSV format, which is hue 0 (red), saturation 255 (as colorful as possible),
value 255 (as bright as possible). Green is "#200ffff" and blue is "#400ffff".

More than one HSV color can match the same RGB color.

Here are some procs you can use for color management:

ReadRGB(rgb)
    Takes an RGB string like "#ffaa55" and converts it to a list such as list(255,170,85). If an RGBA format is used
    that includes alpha, the list will have a fourth item for the alpha value.
hsv(hue, sat, val, apha)
    Counterpart to rgb(), this takes the values you input and converts them to a string in "#hhhssvv" or "#hhhssvvaa"
    format. Alpha is not included in the result if null.
ReadHSV(rgb)
    Takes an HSV string like "#100FF80" and converts it to a list such as list(256,255,128). If an HSVA format is used that
    includes alpha, the list will have a fourth item for the alpha value.
RGBtoHSV(rgb)
    Takes an RGB or RGBA string like "#ffaa55" and converts it into an HSV or HSVA color such as "#080aaff".
HSVtoRGB(hsv)
    Takes an HSV or HSVA string like "#080aaff" and converts it into an RGB or RGBA color such as "#ff55aa".
BlendRGB(rgb1, rgb2, amount)
    Blends between two RGB or RGBA colors using regular RGB blending. If amount is 0, the first color is the result;
    if 1, the second color is the result. 0.5 produces an average of the two. Values outside the 0 to 1 range are allowed as well.
    The returned value is an RGB or RGBA color.
BlendHSV(hsv1, hsv2, amount)
    Blends between two HSV or HSVA colors using HSV blending, which tends to produce nicer results than regular RGB
    blending because the brightness of the color is left intact. If amount is 0, the first color is the result; if 1,
    the second color is the result. 0.5 produces an average of the two. Values outside the 0 to 1 range are allowed as well.
    The returned value is an HSV or HSVA color.
BlendRGBasHSV(rgb1, rgb2, amount)
    Like BlendHSV(), but the colors used and the return value are RGB or RGBA colors. The blending is done in HSV form.
HueToAngle(hue)
    Converts a hue to an angle range of 0 to 360. Angle 0 is red, 120 is green, and 240 is blue.
AngleToHue(hue)
    Converts an angle to a hue in the valid range.
RotateHue(hsv, angle)
    Takes an HSV or HSVA value and rotates the hue forward through red, green, and blue by an angle from 0 to 360.
    (Rotating red by 60� produces yellow.) The result is another HSV or HSVA color with the same saturation and value
    as the original, but a different hue.
GrayScale(rgb)
    Takes an RGB or RGBA color and converts it to grayscale. Returns an RGB or RGBA string.
ColorTone(rgb, tone)
    Similar to GrayScale(), this proc converts an RGB or RGBA color to a range of black -> tone -> white instead of
    using strict shades of gray. The tone value is an RGB color; any alpha value is ignored.
*/

/*
Get Flat Icon DEMO by DarkCampainger

This is a test for the get flat icon proc, modified approprietly for icons and their states.
Probably not a good idea to run this unless you want to see how the proc works in detail.
mob
	icon = 'old_or_unused.dmi'
	icon_state = "green"

	Login()
		// Testing image underlays
		underlays += image(icon='old_or_unused.dmi',icon_state="red")
		underlays += image(icon='old_or_unused.dmi',icon_state="red", pixel_x = 32)
		underlays += image(icon='old_or_unused.dmi',icon_state="red", pixel_x = -32)

		// Testing image overlays
		overlays += image(icon='old_or_unused.dmi',icon_state="green", pixel_x = 32, pixel_y = -32)
		overlays += image(icon='old_or_unused.dmi',icon_state="green", pixel_x = 32, pixel_y = 32)
		overlays += image(icon='old_or_unused.dmi',icon_state="green", pixel_x = -32, pixel_y = -32)

		// Testing icon file overlays (defaults to mob's state)
		overlays += '_flat_demoIcons2.dmi'

		// Testing icon_state overlays (defaults to mob's icon)
		overlays += "white"

		// Testing dynamic icon overlays
		var/icon/I = icon('old_or_unused.dmi', icon_state="aqua")
		I.Shift(NORTH,16,1)
		overlays+=I

		// Testing dynamic image overlays
		I=image(icon=I,pixel_x = -32, pixel_y = 32)
		overlays+=I

		// Testing object types (and layers)
		overlays+=/obj/effect/overlayTest

		loc = locate (10,10,1)
	verb
		Browse_Icon()
			set name = "1. Browse Icon"
			// Give it a name for the cache
			var/iconName = "[ckey(src.name)]_flattened.dmi"
			// Send the icon to src's local cache
			src<<browse_rsc(getFlatIcon(src), iconName)
			// Display the icon in their browser
			src<<browse("<body bgcolor='#000000'><p><img src='[iconName]'></p></body>")

		Output_Icon()
			set name = "2. Output Icon"
			to_chat(src, "Icon is: \icon[getFlatIcon(src)]")

		Label_Icon()
			set name = "3. Label Icon"
			// Give it a name for the cache
			var/iconName = "[ckey(src.name)]_flattened.dmi"
			// Copy the file to the rsc manually
			var/icon/I = fcopy_rsc(getFlatIcon(src))
			// Send the icon to src's local cache
			src<<browse_rsc(I, iconName)
			// Update the label to show it
			winset(src,"imageLabel","image='\ref[I]'");

		Add_Overlay()
			set name = "4. Add Overlay"
			overlays += image(icon='old_or_unused.dmi',icon_state="yellow",pixel_x = rand(-64,32), pixel_y = rand(-64,32))

		Stress_Test()
			set name = "5. Stress Test"
			for(var/i = 0 to 1000)
				// The third parameter forces it to generate a new one, even if it's already cached
				getFlatIcon(src,0,2)
				if(prob(5))
					Add_Overlay()
			Browse_Icon()

		Cache_Test()
			set name = "6. Cache Test"
			for(var/i = 0 to 1000)
				getFlatIcon(src)
			Browse_Icon()

obj/effect/overlayTest
	icon = 'old_or_unused.dmi'
	icon_state = "blue"
	pixel_x = -24
	pixel_y = 24
	plane = ABOVE_TURF_PLANE
	layer = HOLOMAP_LAYER

world
	view = "7x7"
	maxx = 20
	maxy = 20
	maxz = 1
*/

#define TO_HEX_DIGIT(n) ascii2text((n&15) + ((n&15)<10 ? 48 : 87))

icon
	proc/MakeLying()
		var/icon/I = new(src,dir=SOUTH)
		I.BecomeLying()
		return I

	proc/BecomeLying()
		Turn(90)
		Shift(SOUTH,6)
		Shift(EAST,1)

	// Multiply all alpha values by this float
	proc/ChangeOpacity(opacity = 1.0)
		MapColors(1,0,0,0, 0,1,0,0, 0,0,1,0, 0,0,0,opacity, 0,0,0,0)

	// Convert to grayscale
	proc/GrayScale()
		MapColors(0.3,0.3,0.3, 0.59,0.59,0.59, 0.11,0.11,0.11, 0,0,0)

	proc/ColorTone(tone)
		GrayScale()

		var/list/TONE = ReadRGB(tone)
		var/gray = round(TONE[1]*0.3 + TONE[2]*0.59 + TONE[3]*0.11, 1)

		var/icon/upper = (255-gray) ? new(src) : null

		if(gray)
			MapColors(255/gray,0,0, 0,255/gray,0, 0,0,255/gray, 0,0,0)
			Blend(tone, ICON_MULTIPLY)
		else SetIntensity(0)
		if(255-gray)
			upper.Blend(rgb(gray,gray,gray), ICON_SUBTRACT)
			upper.MapColors((255-TONE[1])/(255-gray),0,0,0, 0,(255-TONE[2])/(255-gray),0,0, 0,0,(255-TONE[3])/(255-gray),0, 0,0,0,0, 0,0,0,1)
			Blend(upper, ICON_ADD)

	// Take the minimum color of two icons; combine transparency as if blending with ICON_ADD
	proc/MinColors(icon)
		var/icon/I = new(src)
		I.Opaque()
		I.Blend(icon, ICON_SUBTRACT)
		Blend(I, ICON_SUBTRACT)

	// Take the maximum color of two icons; combine opacity as if blending with ICON_OR
	proc/MaxColors(icon)
		var/icon/I
		if(isicon(icon))
			I = new(icon)
		else
			// solid color
			I = new(src)
			I.Blend("#000000", ICON_OVERLAY)
			I.SwapColor("#000000", null)
			I.Blend(icon, ICON_OVERLAY)
		var/icon/J = new(src)
		J.Opaque()
		I.Blend(J, ICON_SUBTRACT)
		Blend(I, ICON_OR)

	// make this icon fully opaque--transparent pixels become black
	proc/Opaque(background = "#000000")
		SwapColor(null, background)
		MapColors(1,0,0,0, 0,1,0,0, 0,0,1,0, 0,0,0,0, 0,0,0,1)

	// Change a grayscale icon into a white icon where the original color becomes the alpha
	// I.e., black -> transparent, gray -> translucent white, white -> solid white
	proc/BecomeAlphaMask()
		SwapColor(null, "#000000ff")	// don't let transparent become gray
		MapColors(0,0,0,0.3, 0,0,0,0.59, 0,0,0,0.11, 0,0,0,0, 1,1,1,0)

	proc/UseAlphaMask(mask)
		Opaque()
		AddAlphaMask(mask)

	proc/AddAlphaMask(mask)
		var/icon/M = new(mask)
		M.Blend("#ffffff", ICON_SUBTRACT)
		// apply mask
		Blend(M, ICON_ADD)

/*
	HSV format is represented as "#hhhssvv" or "#hhhssvvaa"

	Hue ranges from 0 to 0x5ff (1535)

		0x000 = red
		0x100 = yellow
		0x200 = green
		0x300 = cyan
		0x400 = blue
		0x500 = magenta

	Saturation is from 0 to 0xff (255)

		More saturation = more color
		Less saturation = more gray

	Value ranges from 0 to 0xff (255)

		Higher value means brighter color
 */

proc/ReadRGB(rgb)
	if(!rgb) return

	// interpret the HSV or HSVA value
	var/i=1,start=1
	if(text2ascii(rgb) == 35) ++start // skip opening #
	var/ch,which=0,r=0,g=0,b=0,alpha=0,usealpha
	var/digits=0
	for(i=start, i<=length(rgb), ++i)
		ch = text2ascii(rgb, i)
		if(ch < 48 || (ch > 57 && ch < 65) || (ch > 70 && ch < 97) || ch > 102) break
		++digits
		if(digits == 8) break

	var/single = digits < 6
	if(digits != 3 && digits != 4 && digits != 6 && digits != 8) return
	if(digits == 4 || digits == 8) usealpha = 1
	for(i=start, digits>0, ++i)
		ch = text2ascii(rgb, i)
		if(ch >= 48 && ch <= 57) ch -= 48
		else if(ch >= 65 && ch <= 70) ch -= 55
		else if(ch >= 97 && ch <= 102) ch -= 87
		else break
		--digits
		switch(which)
			if(0)
				r = (r << 4) | ch
				if(single)
					r |= r << 4
					++which
				else if(!(digits & 1)) ++which
			if(1)
				g = (g << 4) | ch
				if(single)
					g |= g << 4
					++which
				else if(!(digits & 1)) ++which
			if(2)
				b = (b << 4) | ch
				if(single)
					b |= b << 4
					++which
				else if(!(digits & 1)) ++which
			if(3)
				alpha = (alpha << 4) | ch
				if(single) alpha |= alpha << 4

	. = list(r, g, b)
	if(usealpha) . += alpha

proc/ReadHSV(hsv)
	if(!hsv) return

	// interpret the HSV or HSVA value
	var/i=1,start=1
	if(text2ascii(hsv) == 35) ++start // skip opening #
	var/ch,which=0,hue=0,sat=0,val=0,alpha=0,usealpha
	var/digits=0
	for(i=start, i<=length(hsv), ++i)
		ch = text2ascii(hsv, i)
		if(ch < 48 || (ch > 57 && ch < 65) || (ch > 70 && ch < 97) || ch > 102) break
		++digits
		if(digits == 9) break
	if(digits > 7) usealpha = 1
	if(digits <= 4) ++which
	if(digits <= 2) ++which
	for(i=start, digits>0, ++i)
		ch = text2ascii(hsv, i)
		if(ch >= 48 && ch <= 57) ch -= 48
		else if(ch >= 65 && ch <= 70) ch -= 55
		else if(ch >= 97 && ch <= 102) ch -= 87
		else break
		--digits
		switch(which)
			if(0)
				hue = (hue << 4) | ch
				if(digits == (usealpha ? 6 : 4)) ++which
			if(1)
				sat = (sat << 4) | ch
				if(digits == (usealpha ? 4 : 2)) ++which
			if(2)
				val = (val << 4) | ch
				if(digits == (usealpha ? 2 : 0)) ++which
			if(3)
				alpha = (alpha << 4) | ch

	. = list(hue, sat, val)
	if(usealpha) . += alpha

proc/HSVtoRGB(hsv)
	if(!hsv) return "#000000"
	var/list/HSV = ReadHSV(hsv)
	if(!HSV) return "#000000"

	var/hue = HSV[1]
	var/sat = HSV[2]
	var/val = HSV[3]

	// Compress hue into easier-to-manage range
	hue -= hue >> 8
	if(hue >= 0x5fa) hue -= 0x5fa

	var/hi,mid,lo,r,g,b
	hi = val
	lo = round((255 - sat) * val / 255, 1)
	mid = lo + round(abs(round(hue, 510) - hue) * (hi - lo) / 255, 1)
	if(hue >= 765)
		if(hue >= 1275)      {r=hi;  g=lo;  b=mid}
		else if(hue >= 1020) {r=mid; g=lo;  b=hi }
		else                 {r=lo;  g=mid; b=hi }
	else
		if(hue >= 510)       {r=lo;  g=hi;  b=mid}
		else if(hue >= 255)  {r=mid; g=hi;  b=lo }
		else                 {r=hi;  g=mid; b=lo }

	return (HSV.len > 3) ? rgb(r,g,b,HSV[4]) : rgb(r,g,b)

proc/RGBtoHSV(rgb)
	if(!rgb) return "#0000000"
	var/list/RGB = ReadRGB(rgb)
	if(!RGB) return "#0000000"

	var/r = RGB[1]
	var/g = RGB[2]
	var/b = RGB[3]
	var/hi = max(r,g,b)
	var/lo = min(r,g,b)

	var/val = hi
	var/sat = hi ? round((hi-lo) * 255 / hi, 1) : 0
	var/hue = 0

	if(sat)
		var/dir
		var/mid
		if(hi == r)
			if(lo == b) {hue=0; dir=1; mid=g}
			else {hue=1535; dir=-1; mid=b}
		else if(hi == g)
			if(lo == r) {hue=512; dir=1; mid=b}
			else {hue=511; dir=-1; mid=r}
		else if(hi == b)
			if(lo == g) {hue=1024; dir=1; mid=r}
			else {hue=1023; dir=-1; mid=g}
		hue += dir * round((mid-lo) * 255 / (hi-lo), 1)

	return hsv(hue, sat, val, (RGB.len>3 ? RGB[4] : null))

proc/hsv(hue, sat, val, alpha)
	if(hue < 0 || hue >= 1536) hue %= 1536
	if(hue < 0) hue += 1536
	if((hue & 0xFF) == 0xFF)
		++hue
		if(hue >= 1536) hue = 0
	if(sat < 0) sat = 0
	if(sat > 255) sat = 255
	if(val < 0) val = 0
	if(val > 255) val = 255
	. = "#"
	. += TO_HEX_DIGIT(hue >> 8)
	. += TO_HEX_DIGIT(hue >> 4)
	. += TO_HEX_DIGIT(hue)
	. += TO_HEX_DIGIT(sat >> 4)
	. += TO_HEX_DIGIT(sat)
	. += TO_HEX_DIGIT(val >> 4)
	. += TO_HEX_DIGIT(val)
	if(!isnull(alpha))
		if(alpha < 0) alpha = 0
		if(alpha > 255) alpha = 255
		. += TO_HEX_DIGIT(alpha >> 4)
		. += TO_HEX_DIGIT(alpha)

/*
	Smooth blend between HSV colors

	amount=0 is the first color
	amount=1 is the second color
	amount=0.5 is directly between the two colors

	amount<0 or amount>1 are allowed
 */
proc/BlendHSV(hsv1, hsv2, amount)
	var/list/HSV1 = ReadHSV(hsv1)
	var/list/HSV2 = ReadHSV(hsv2)

	// add missing alpha if needed
	if(HSV1.len < HSV2.len) HSV1 += 255
	else if(HSV2.len < HSV1.len) HSV2 += 255
	var/usealpha = HSV1.len > 3

	// normalize hsv values in case anything is screwy
	if(HSV1[1] > 1536) HSV1[1] %= 1536
	if(HSV2[1] > 1536) HSV2[1] %= 1536
	if(HSV1[1] < 0) HSV1[1] += 1536
	if(HSV2[1] < 0) HSV2[1] += 1536
	if(!HSV1[3]) {HSV1[1] = 0; HSV1[2] = 0}
	if(!HSV2[3]) {HSV2[1] = 0; HSV2[2] = 0}

	// no value for one color means don't change saturation
	if(!HSV1[3]) HSV1[2] = HSV2[2]
	if(!HSV2[3]) HSV2[2] = HSV1[2]
	// no saturation for one color means don't change hues
	if(!HSV1[2]) HSV1[1] = HSV2[1]
	if(!HSV2[2]) HSV2[1] = HSV1[1]

	// Compress hues into easier-to-manage range
	HSV1[1] -= HSV1[1] >> 8
	HSV2[1] -= HSV2[1] >> 8

	var/hue_diff = HSV2[1] - HSV1[1]
	if(hue_diff > 765) hue_diff -= 1530
	else if(hue_diff <= -765) hue_diff += 1530

	var/hue = round(HSV1[1] + hue_diff * amount, 1)
	var/sat = round(HSV1[2] + (HSV2[2] - HSV1[2]) * amount, 1)
	var/val = round(HSV1[3] + (HSV2[3] - HSV1[3]) * amount, 1)
	var/alpha = usealpha ? round(HSV1[4] + (HSV2[4] - HSV1[4]) * amount, 1) : null

	// normalize hue
	if(hue < 0 || hue >= 1530) hue %= 1530
	if(hue < 0) hue += 1530
	// decompress hue
	hue += round(hue / 255)

	return hsv(hue, sat, val, alpha)

/*
	Smooth blend between RGB colors

	amount=0 is the first color
	amount=1 is the second color
	amount=0.5 is directly between the two colors

	amount<0 or amount>1 are allowed
 */
proc/BlendRGB(rgb1, rgb2, amount)
	var/list/RGB1 = ReadRGB(rgb1)
	var/list/RGB2 = ReadRGB(rgb2)

	// add missing alpha if needed
	if(RGB1.len < RGB2.len) RGB1 += 255
	else if(RGB2.len < RGB1.len) RGB2 += 255
	var/usealpha = RGB1.len > 3

	var/r = round(RGB1[1] + (RGB2[1] - RGB1[1]) * amount, 1)
	var/g = round(RGB1[2] + (RGB2[2] - RGB1[2]) * amount, 1)
	var/b = round(RGB1[3] + (RGB2[3] - RGB1[3]) * amount, 1)
	var/alpha = usealpha ? round(RGB1[4] + (RGB2[4] - RGB1[4]) * amount, 1) : null

	return isnull(alpha) ? rgb(r, g, b) : rgb(r, g, b, alpha)

proc/BlendRGBasHSV(rgb1, rgb2, amount)
	return HSVtoRGB(RGBtoHSV(rgb1), RGBtoHSV(rgb2), amount)

proc/HueToAngle(hue)
	// normalize hsv in case anything is screwy
	if(hue < 0 || hue >= 1536) hue %= 1536
	if(hue < 0) hue += 1536
	// Compress hue into easier-to-manage range
	hue -= hue >> 8
	return hue / (1530/360)

proc/AngleToHue(angle)
	// normalize hsv in case anything is screwy
	if(angle < 0 || angle >= 360) angle -= 360 * round(angle / 360)
	var/hue = angle * (1530/360)
	// Decompress hue
	hue += round(hue / 255)
	return hue


// positive angle rotates forward through red->green->blue
proc/RotateHue(hsv, angle)
	var/list/HSV = ReadHSV(hsv)

	// normalize hsv in case anything is screwy
	if(HSV[1] >= 1536) HSV[1] %= 1536
	if(HSV[1] < 0) HSV[1] += 1536

	// Compress hue into easier-to-manage range
	HSV[1] -= HSV[1] >> 8

	if(angle < 0 || angle >= 360) angle -= 360 * round(angle / 360)
	HSV[1] = round(HSV[1] + angle * (1530/360), 1)

	// normalize hue
	if(HSV[1] < 0 || HSV[1] >= 1530) HSV[1] %= 1530
	if(HSV[1] < 0) HSV[1] += 1530
	// decompress hue
	HSV[1] += round(HSV[1] / 255)

	return hsv(HSV[1], HSV[2], HSV[3], (HSV.len > 3 ? HSV[4] : null))

// Convert an rgb color to grayscale
proc/GrayScale(rgb)
	var/list/RGB = ReadRGB(rgb)
	var/gray = RGB[1]*0.3 + RGB[2]*0.59 + RGB[3]*0.11
	return (RGB.len > 3) ? rgb(gray, gray, gray, RGB[4]) : rgb(gray, gray, gray)

// Change grayscale color to black->tone->white range
proc/ColorTone(rgb, tone)
	var/list/RGB = ReadRGB(rgb)
	var/list/TONE = ReadRGB(tone)

	var/gray = RGB[1]*0.3 + RGB[2]*0.59 + RGB[3]*0.11
	var/tone_gray = TONE[1]*0.3 + TONE[2]*0.59 + TONE[3]*0.11

	if(gray <= tone_gray) return BlendRGB("#000000", tone, gray/(tone_gray || 1))
	else return BlendRGB(tone, "#ffffff", (gray-tone_gray)/((255-tone_gray) || 1))


/*
Get flat icon by DarkCampainger. As it says on the tin, will return an icon with all the overlays
as a single icon. Useful for when you want to manipulate an icon via the above as overlays are not normally included.
The _flatIcons list is a cache for generated icon files.
*/

proc // Creates a single icon from a given /atom or /image.  Only the first argument is required.
	getFlatIcon(image/A, defdir=2, deficon=null, defstate="", defblend=BLEND_DEFAULT, always_use_defdir = 0)
		// We start with a blank canvas, otherwise some icon procs crash silently
		var/icon/flat = icon('icons/effects/effects.dmi', "icon_state"="nothing") // Final flattened icon
		if(!A)
			return flat
		if(A.alpha <= 0)
			return flat
		var/noIcon = FALSE

		var/curicon
		if(A.icon)
			curicon = A.icon
		else
			curicon = deficon

		if(!curicon)
			noIcon = TRUE // Do not render this object.

		var/curstate
		if(A.icon_state)
			curstate = A.icon_state
		else
			curstate = defstate

		if(!noIcon && !(curstate in icon_states(curicon)))
			if("" in icon_states(curicon))
				curstate = ""
			else
				noIcon = TRUE // Do not render this object.

		var/curdir
		if(A.dir != 2 && !always_use_defdir)
			curdir = A.dir
		else
			curdir = defdir

		var/curblend
		if(A.blend_mode == BLEND_DEFAULT)
			curblend = defblend
		else
			curblend = A.blend_mode

		// Layers will be a sorted list of icons/overlays, based on the order in which they are displayed
		var/list/layers = list()
		var/image/copy
		// Add the atom's icon itself, without pixel_x/y offsets.
		if(!noIcon)
			copy = image(icon=curicon, icon_state=curstate, layer=A.layer, dir=curdir)
			copy.color = A.color
			copy.alpha = A.alpha
			copy.blend_mode = curblend
			layers[copy] = A.layer

		// Loop through the underlays, then overlays, sorting them into the layers list
		var/list/process = A.underlays // Current list being processed
		var/pSet=0 // Which list is being processed: 0 = underlays, 1 = overlays
		var/curIndex=1 // index of 'current' in list being processed
		var/current // Current overlay being sorted
		var/currentLayer // Calculated layer that overlay appears on (special case for FLOAT_LAYER)
		var/compare // The overlay 'add' is being compared against
		var/cmpIndex // The index in the layers list of 'compare'
		while(TRUE)
			if(curIndex<=process.len)
				current = process[curIndex]
				if(current)
					currentLayer = current:layer
					if(currentLayer<0) // Special case for FLY_LAYER
						if(currentLayer <= -1000) return flat
						if(pSet == 0) // Underlay
							currentLayer = A.layer+currentLayer/1000
						else // Overlay
							currentLayer = A.layer+(1000+currentLayer)/1000

					// Sort add into layers list
					for(cmpIndex=1,cmpIndex<=layers.len,cmpIndex++)
						compare = layers[cmpIndex]
						if(currentLayer < layers[compare]) // Associated value is the calculated layer
							layers.Insert(cmpIndex,current)
							layers[current] = currentLayer
							break
					if(cmpIndex>layers.len) // Reached end of list without inserting
						layers[current]=currentLayer // Place at end

				curIndex++
			else if(pSet == 0) // Switch to overlays
				curIndex = 1
				pSet = 1
				process = A.overlays
			else // All done
				break

		var/icon/add // Icon of overlay being added

			// Current dimensions of flattened icon
		var/{flatX1=1;flatX2=flat.Width();flatY1=1;flatY2=flat.Height()}
			// Dimensions of overlay being added
		var/{addX1;addX2;addY1;addY2}

		for(var/I in layers)

			if(I:alpha == 0)
				continue

			if(I == copy) // 'I' is an /image based on the object being flattened.
				curblend = BLEND_OVERLAY
				add = icon(I:icon, I:icon_state, I:dir)
				// This checks for a silent failure mode of the icon routine. If the requested dir
				// doesn't exist in this icon state it returns a 32x32 icon with 0 alpha.
				if (I:dir != SOUTH && add.Width() == 32 && add.Height() == 32)
					// Check every pixel for blank (computationally expensive, but the process is limited
					// by the amount of film on the station, only happens when we hit something that's
					// turned, and bails at the very first pixel it sees.
					var/blankpixel;
					for(var/y;y<=32;y++)
						for(var/x;x<32;x++)
							blankpixel = isnull(add.GetPixel(x,y))
							if(!blankpixel)
								break
						if(!blankpixel)
							break
					// If we ALWAYS returned a null (which happens when GetPixel encounters something with alpha 0)
					if (blankpixel)
						// Pull the default direction.
						add = icon(I:icon, I:icon_state)
			else // 'I' is an appearance object.
				if(istype(A,/obj/machinery/atmospherics) && I in A.underlays)
					var/image/Im = I
					add = getFlatIcon(new/image(I), Im.dir, curicon, curstate, curblend, 1)
				else
					add = getFlatIcon(new/image(I), curdir, curicon, curstate, curblend, always_use_defdir)

			// Find the new dimensions of the flat icon to fit the added overlay
			addX1 = min(flatX1, I:pixel_x+1)
			addX2 = max(flatX2, I:pixel_x+add.Width())
			addY1 = min(flatY1, I:pixel_y+1)
			addY2 = max(flatY2, I:pixel_y+add.Height())

			if(addX1!=flatX1 || addX2!=flatX2 || addY1!=flatY1 || addY2!=flatY2)
				// Resize the flattened icon so the new icon fits
				flat.Crop(addX1-flatX1+1, addY1-flatY1+1, addX2-flatX1+1, addY2-flatY1+1)
				flatX1=addX1;flatX2=addX2
				flatY1=addY1;flatY2=addY2
			var/iconmode
			if(I in A.overlays)
				iconmode = ICON_OVERLAY
			else if(I in A.underlays)
				iconmode = ICON_UNDERLAY
			else
				iconmode = blendMode2iconMode(curblend)
			// Blend the overlay into the flattened icon
			flat.Blend(add, iconmode, I:pixel_x + 2 - flatX1, I:pixel_y + 2 - flatY1)

		if(A.color)
			flat.Blend(A.color, ICON_MULTIPLY)
		if(A.alpha < 255)
			flat.Blend(rgb(255, 255, 255, A.alpha), ICON_MULTIPLY)

		return icon(flat, "", SOUTH)

	getIconMask(atom/A)//By yours truly. Creates a dynamic mask for a mob/whatever. /N
		var/icon/alpha_mask = new(A.icon,A.icon_state)//So we want the default icon and icon state of A.
		for(var/I in A.overlays)//For every image in overlays. var/image/I will not work, don't try it.
			if(I:layer>A.layer)	continue//If layer is greater than what we need, skip it.
			var/icon/image_overlay = new(I:icon,I:icon_state)//Blend only works with icon objects.
			//Also, icons cannot directly set icon_state. Slower than changing variables but whatever.
			alpha_mask.Blend(image_overlay,ICON_OR)//OR so they are lumped together in a nice overlay.
		return alpha_mask//And now return the mask.

/mob/proc/AddCamoOverlay(atom/A)//A is the atom which we are using as the overlay.
	var/icon/opacity_icon = new(A.icon, A.icon_state)//Don't really care for overlays/underlays.
	//Now we need to culculate overlays+underlays and add them together to form an image for a mask.
	//var/icon/alpha_mask = getFlatIcon(src)//Accurate but SLOW. Not designed for running each tick. Could have other uses I guess.
	var/icon/alpha_mask = getIconMask(src)//Which is why I created that proc. Also a little slow since it's blending a bunch of icons together but good enough.
	opacity_icon.AddAlphaMask(alpha_mask)//Likely the main source of lag for this proc. Probably not designed to run each tick.
	opacity_icon.ChangeOpacity(0.4)//Front end for MapColors so it's fast. 0.5 means half opacity and looks the best in my opinion.
	for(var/i=0,i<5,i++)//And now we add it as overlays. It's faster than creating an icon and then merging it.
		var/image/I = image("icon" = opacity_icon, "icon_state" = A.icon_state, "layer" = layer+0.8)//So it's above other stuff but below weapons and the like.
		switch(i)//Now to determine offset so the result is somewhat blurred.
			if(1)	I.pixel_x--
			if(2)	I.pixel_x++
			if(3)	I.pixel_y--
			if(4)	I.pixel_y++
		overlays += I//And finally add the overlay.

/proc/getHologramIcon(icon/A, safety=1, noDecolor=FALSE)//If safety is on, a new icon is not created.
	var/icon/flat_icon = safety ? A : new(A)//Has to be a new icon to not constantly change the same icon.
	if (noDecolor == FALSE)
		flat_icon.ColorTone(rgb(125,180,225))//Let's make it bluish.
	flat_icon.ChangeOpacity(0.5)//Make it half transparent.
	var/icon/alpha_mask = new('icons/effects/effects.dmi', "scanline")//Scanline effect.
	flat_icon.AddAlphaMask(alpha_mask)//Finally, let's mix in a distortion effect.
	return flat_icon

//For photo camera.
/proc/build_composite_icon(atom/A)
	var/icon/composite = icon(A.icon, A.icon_state, A.dir, 1)
	for(var/O in A.overlays)
		var/image/I = O
		composite.Blend(icon(I.icon, I.icon_state, I.dir, 1), ICON_OVERLAY)
	return composite

proc/adjust_brightness(var/color, var/value)
	if (!color) return "#FFFFFF"
	if (!value) return color

	var/list/RGB = ReadRGB(color)
	RGB[1] = Clamp(RGB[1]+value,0,255)
	RGB[2] = Clamp(RGB[2]+value,0,255)
	RGB[3] = Clamp(RGB[3]+value,0,255)
	return rgb(RGB[1],RGB[2],RGB[3])

proc/sort_atoms_by_layer(var/list/atoms)
	// Comb sort icons based on levels
	var/list/result = atoms.Copy()
	var/gap = result.len
	var/swapped = 1
	while (gap > 1 || swapped)
		swapped = 0
		if(gap > 1)
			gap = round(gap / 1.3) // 1.3 is the emperic comb sort coefficient
		if(gap < 1)
			gap = 1
		for(var/i = 1; gap + i <= result.len; i++)
			var/atom/l = result[i]		//Fucking hate
			var/atom/r = result[gap+i]	//how lists work here
			if(l.plane > r.plane || (l.plane == r.plane && l.layer > r.layer))		//no "result[i].layer" for me
				result.Swap(i, gap + i)
				swapped = 1
	return result
/*
generate_image function generates image of specified range and location
arguments tx, ty, tz are target coordinates (requred), range defines render distance to opposite corner (requred)
cap_mode is capturing mode (optional), user is capturing mob (requred only wehen cap_mode = CAPTURE_MODE_REGULAR),
lighting determines lighting capturing (optional), suppress_errors suppreses errors and continues to capture (optional).
*/
proc/generate_image(var/tx as num, var/ty as num, var/tz as num, var/range as num, var/cap_mode = CAPTURE_MODE_PARTIAL, var/mob/living/user, var/lighting = 1, var/suppress_errors = 1)
	var/list/turfstocapture = list()
	//Lines below determine what tiles will be rendered
	for(var/xoff = 0 to range)
		for(var/yoff = 0 to range)
			var/turf/T = locate(tx + xoff,ty + yoff,tz)
			if(T)
				if(cap_mode == CAPTURE_MODE_REGULAR)
					if(user.can_capture_turf(T))
						turfstocapture.Add(T)
						continue
				else
					turfstocapture.Add(T)
			else
				//Capture includes non-existan turfs
				if(!suppress_errors)
					return
	//Lines below determine what objects will be rendered
	var/list/atoms = list()
	for(var/turf/T in turfstocapture)
		atoms.Add(T)
		for(var/atom/A in T)
			if(istype(A, /atom/movable/lighting_overlay) && lighting) //Special case for lighting
				atoms.Add(A)
				continue
			if(A.invisibility) continue
			atoms.Add(A)
	//Lines below actually render all colected data
	atoms = sort_atoms_by_layer(atoms)
	var/icon/cap = icon('icons/effects/96x96.dmi', "")
	cap.Scale(range*32, range*32)
	cap.Blend("#000", ICON_OVERLAY)
	for(var/atom/A in atoms)
		if(A)
			var/icon/img = getFlatIcon(A)
			if(istype(img, /icon))
				if(istype(A, /mob/living) && A:lying)
					img.BecomeLying()
				var/xoff = (A.x - tx) * 32
				var/yoff = (A.y - ty) * 32
				cap.Blend(img, blendMode2iconMode(A.blend_mode),  A.pixel_x + xoff, A.pixel_y + yoff)

	return cap

