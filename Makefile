ORANGE_DARK := \#d73b00
ORANGE_MID := \#d85e00
ORANGE_LIGHT := \#efbe6a
YELLOW := \#ffce00
GREEN := \#008600

BLUE := \#0000ff

# pixels
BOXTARGET := 256

DOUBLEBOX := $(shell echo "${BOXTARGET}*2" | bc)
QUARTERBOX := $(shell echo "${BOXTARGET}*0.25" | bc)
THIRDBOX := $(shell echo "${BOXTARGET}/3" | bc)
HALFBOX := $(shell echo "${BOXTARGET}*0.5" | bc)
EIGHTHBOX := $(shell echo "${BOXTARGET}/8" | bc)
TWOTHIRDBOX := $(shell echo "${BOXTARGET}-${THIRDBOX}" | bc)
THREEQUARTERBOX := $(shell echo "${BOXTARGET}*0.75" | bc)
THIRTEENSIXTEENTHSBOX := $(shell echo "${BOXTARGET}*0.8125" | bc)
SEVENEIGHTHSBOX := $(shell echo "${BOXTARGET}*0.875" | bc)

# calculate border width
DARKORANGE_WIDTH := $(shell echo "${BOXTARGET}/31" | bc)
# boundaries of punch-out rectangle
# could be width,width if we weren't simplifying compositing
DARKORANGE_X := 0,0
DARKORANGE_Y := $(shell echo "${BOXTARGET}-${DARKORANGE_WIDTH}" | bc)

LIGHTORANGE_WIDTH := $(shell echo "${BOXTARGET}/13.2307" | bc)
LIGHTORANGE_X := ${LIGHTORANGE_WIDTH}
LIGHTORANGE_Y := $(shell echo "${BOXTARGET}-${LIGHTORANGE_WIDTH}" | bc)

YELLOWGREEN_WIDTH := $(shell echo "${BOXTARGET}/10.8333" | bc)
YELLOWGREEN_WIDTHONEHALF := $(shell echo "${YELLOWGREEN_WIDTH}*1.5" | bc)
YELLOWGREEN_X := ${YELLOWGREEN_WIDTH}
YELLOWGREEN_Y := $(shell echo "${BOXTARGET}-${YELLOWGREEN_X}" | bc)

white.png:
	magick -size 1x1 canvas:#ffffff white.png

gray.png:
	magick -size 1x1 canvas:#c0c0c0 gray.png

blue.png:
	magick -size 1x1 canvas:#0000a0 blue.png

darkgray.png:
	magick -size 1x1 canvas:#a8a8a8 darkgray.png

black.png:
	magick -size 1x1 canvas:#000000 black.png

darkorange.png:
	magick -size 1x1 canvas:${ORANGE_DARK} darkorange.png

midorange.png:
	magick -size 1x1 canvas:${ORANGE_MID} midorange.png

lightorange.png:
	magick -size 1x1 canvas:${ORANGE_MID} lightorange.png

darkorangebox.png:
	magick -size ${BOXTARGET}x${BOXTARGET} \
		-define gradient:radii=${THREEQUARTERBOX},${QUARTERBOX} \
		-define gradient:angle=135 \
		-define gradient:center=${SEVENEIGHTHSBOX},${HALFBOX} \
		radial-gradient:${ORANGE_MID}-${ORANGE_DARK} \
		\( +clone -threshold 9 -draw "rectangle 0,0 ${DARKORANGE_Y},${DARKORANGE_Y}" \) -channel-fx '|gray=>alpha' \
		darkorangebox.png

# we currently do this very kludgey thing because IM wants you to stack masks and I just
lightorangebox.png:
	magick -size ${BOXTARGET}x${BOXTARGET} \
		canvas:${ORANGE_MID} \
		\( \
			\( \
				-size ${BOXTARGET}x${BOXTARGET} \
				-define gradient:radii=${TWOTHIRDBOX},${TWOTHIRDBOX} \
				-define gradient:center=${LIGHTORANGE_X},${LIGHTORANGE_X} \
				radial-gradient:black-white \
			\) \
			\( \
				-size ${BOXTARGET}x${BOXTARGET} \
				-define gradient:radii=${QUARTERBOX},${QUARTERBOX} \
				-define gradient:center=${LIGHTORANGE_Y},${THIRDBOX} \
				radial-gradient:black-white \
			\) \
			-compose Darken -composite \
			-fill black -draw "rectangle ${LIGHTORANGE_X},${LIGHTORANGE_X} ${LIGHTORANGE_Y},${LIGHTORANGE_Y}" \
			-channel-fx '|gray=>alpha' \
		\) \
		-compose copy-opacity -composite \
		lightorangebox.png

yelgrnbox.png:
	magick -size ${BOXTARGET}x${BOXTARGET} \
		-define gradient:direction=East \
		gradient:${YELLOW}-${GREEN} \
		\( \
			\( \
				-size ${BOXTARGET}x${BOXTARGET} \
				-define gradient:radii=${QUARTERBOX},${QUARTERBOX} \
				-define gradient:center=${BOXTARGET},${BOXTARGET} \
				radial-gradient:black-white \
			\) \
			\( \
				-size ${BOXTARGET}x${BOXTARGET} \
				-define gradient:radii=${BOXTARGET},${THREEQUARTERBOX} \
				-define gradient:center=0,0 \
				radial-gradient:black-white \
			\) \
			-compose Darken -composite \
			-fill black -draw "rectangle ${YELLOWGREEN_X},${YELLOWGREEN_X} ${YELLOWGREEN_Y},${YELLOWGREEN_Y}" \
			-fill black -draw "rectangle ${YELLOWGREEN_X},0 ${BOXTARGET},${YELLOWGREEN_Y}" \
			-channel-fx '|gray=>alpha' \
		\) \
		-compose copy-opacity -composite \
		yelgrnbox.png
