


#let clamp( value, min, max ) = {
	if type(value) != type(min) or type(value) != type(max) {
		panic("Can't clamp values of different types!")
	}
	if value < min { return min }
	else if value > max { return max }
	else { return value }
}
