ORANGE_DARK := \#d73b00
ORANGE_MID := \#d85e00
ORANGE_LIGHT := \#efbe6a

# pixels
BOXTARGET := 256

QUARTERBOX := $(shell echo "${BOXTARGET}*0.25" | bc)
THIRDBOX := $(shell echo "${BOXTARGET}/3" | bc)
HALFBOX := $(shell echo "${BOXTARGET}*0.5" | bc)
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

lightorangebox.png:
	magick -size ${BOXTARGET}x${BOXTARGET} \
		canvas:${ORANGE_MID} \
		\( \
			-size ${BOXTARGET}x${BOXTARGET} \
			-define gradient:radii=${THIRTEENSIXTEENTHSBOX},${THIRTEENSIXTEENTHSBOX} \
			-define gradient:center=0,0 \
			radial-gradient:black-white \
		\) -channel-fx '|gray=>alpha' \
		-compose Over \
		-layers merge \
		lightorangebox.png
