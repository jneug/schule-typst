


#let __tree(item, lvl, n) = block({
	let node = item
	if type(item) == "array" {
		node = item.first()
		let m = 0
		for child in item.slice(1) {
			__tree(child, lvl+1, m)
			m += 1
		}
	}

	place(top+left, dx:n*1cm, dy:lvl*1cm, ellipse[#node])
})

#let __parse_tree( def ) = {
	let tree = ()
	for node in def {

	}
}

#let tree(
	binary: false,
	def
) = {
	__tree(def, 0, 0)
}
