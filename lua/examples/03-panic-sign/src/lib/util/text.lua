local graphics <const> = playdate.graphics

fonts = {
	nicoClean16 = graphics.font.new('fonts/nico/nico-clean-16'),
	nicoBold16 = graphics.font.new('fonts/nico/nico-bold-16'),
	nicoPaint16 = graphics.font.new('fonts/nico/nico-paint-16'),
}

fontFamilies = {
	nico = graphics.font.newFamily({
		[graphics.font.kVariantNormal] = 'fonts/nico/nico-clean-16',
		[graphics.font.kVariantBold] = 'fonts/nico/nico-bold-16',
		[graphics.font.kVariantItalic] = 'fonts/nico/nico-paint-16',
	})
}
