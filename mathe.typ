#import "./util.typ": clamp

// #let cancelto(base, new, dx:2pt, dy:-1pt) = $cancel(base)^#move(dx:dx, dy:dy, $new$)$

#let cancelup(base, new, dx:2pt, dy:-1pt) = $cancel(base)^#move(dx:dx, dy:dy, $new$)$
#let canceldown(base, new, dx:2pt, dy:1pt) = $cancel(base)_#move(dx:dx, dy:dy, $new$)$


#let punkt(..coords) = $(#coords.pos().map(v => $#v$).join($thin|thin$))$
#let vect(name) = $accent(name, arrow)$
#let rest(r) = $med upright(sans("R"))#r$

#let anteil(a, b, num, size:1cm, blank:white, fill:gray, flip:false) = box(
	width: a*size,
	height: b*size,
	baseline: (b*size)*0.5,
	for j in range(b) {
		for i in range(a) {
			place(
				top+left,
				dx: i*size,
				dy: j*size,
				square(
					size:size,
					fill:if num > 0 {fill} else {blank},
					stroke:clamp(size/10, .2pt, 2pt)+black
				)
			)
			num -= 1
		}
	}
)
