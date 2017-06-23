# Sketch
sketch = Framer.Importer.load("imported/PrototypeNew@4x", scale: 1)

{analytics, analyticsBack, seo, seoBack, dropdown, d1, d2, d3, d4, d5, d6, d7, d8, d9, d1hover, d2hover, d3hover, d4hover, d5hover, d6hover, d7hover, d8hover, d9hover, pointerTop, settingsZone, headlineZone, masker, New, content, tagmanagerTextGuide, facebookTextGuide, gaTextGuide, metadescriptionTextGuide, keywordsTextGuide, pagetitleTextGuide, urlTextGuide, tagmanagerLineGuide, facebookLineGuide, gaLineGuide, metadescriptionLineGuide, keywordsLineGuide, pagetitleLineGuide, urlLineGuide, tagmanager, facebook, ga, metadescription, keywords, pagetitle, url, seoBg, analyticsBg} = sketch
# Document Setup
document.body.style.cursor = "auto"
Framer.Extras.Hints.disable()
Framer.Extras.Preloader.enable()
InputModule = require "input"

Screen.backgroundColor = "#F2F2F2"

mask = new Layer
	width: 1200
	height: 1142
	x: Align.center()
	clip: true

New.parent = mask
# Click Events
initial = content.y
zones = [d3, d6, settingsZone]
responders = [[seo, 69], [analytics, 26], [dropdown, 0]]
hide = [analytics, seo, dropdown, d1hover, d2hover, d3hover, d4hover, d5hover, d6hover, d7hover, d8hover, d9hover]
back = [analyticsBack, seoBack]

createIn = (i) ->
	zones[i].onClick ->
		for layer in responders
			layer[0].visible = false
		responders[i][0].visible = true
		content.y = initial + responders[i][1]

createOut = (i) ->
	back[i].onClick ->
		content.y = initial
		for layer in responders
			layer[0].visible = false

for layer in hide
	layer.visible = false

for layer, i in zones
	createIn(i)

for layer, i in back
	createOut(i)

headlineZone.onClick ->
	masker.visible = false
# Dropdown
ds = [d1, d2, d3, d4, d5, d6, d7, d8, d9]
dhovers = [d1hover, d2hover, d3hover, d4hover, d5hover, d6hover, d7hover, d8hover, d9hover]

createHovers = (i) ->
	ds[i].onMouseOver ->
		dhovers[i].visible = true
	ds[i].onMouseOut ->
		dhovers[i].visible = false

for layer,i in ds
	createHovers(i)


textGuides = [tagmanagerTextGuide, facebookTextGuide, gaTextGuide, metadescriptionTextGuide, keywordsTextGuide, pagetitleTextGuide, urlTextGuide]
lineGuides = [tagmanagerLineGuide, facebookLineGuide, gaLineGuide, metadescriptionLineGuide, keywordsLineGuide, pagetitleLineGuide, urlLineGuide]
textClicks = [tagmanager, facebook, ga, metadescription, keywords, pagetitle, url]
textInput = ["Google tag manager ID", "Facebook pixel ID", "Google analytics ID", "Meta description", "Keywords", "Page title", "Canonical link URL"]
textLayers = []
lineLayers = []
inputs = []







for layer, i in textGuides
	layer.visible = false
	textLayer = new TextLayer
		parent: textClicks[i]
		x: textGuides[i].x
		y: textGuides[i].y
		font: "400 14px/1 Roboto"
		color: "#8EA0A9"
		text: textInput[i]
		originX: 0
		originY: 0
		animationOptions: 
			curve: Bezier(0.4, 0.0, 0.2, 1)
			time: 0.2
	textLayer.status = "down"
	textLayers.push(textLayer)
	
	do (textLayer, i) ->
		seoBg.onClick ->
			if inputs[i].value is "" and textLayer.status is "up"
				textLayer.animate
					scale: 1
					y: textLayer.y + 20
				textLayer.status = "down"
				inputs[i].visible = false
		analyticsBg.onClick ->
			if inputs[i].value is "" and textLayer.status is "up"
				textLayer.animate
					scale: 1
					y: textLayer.y + 20
				textLayer.status = "down"
				inputs[i].visible = false
		content.onClick ->
			if inputs[i].value is "" and textLayer.status is "up"
				textLayer.animate
					scale: 1
					y: textLayer.y + 20
				textLayer.status = "down"
				inputs[i].visible = false
		textClicks[i].onClick ->
			do (i) ->
				if inputs[i].value is ""
					for layer, i in textLayers
						if layer.status is "up" and inputs[i].value is "" and textLayer.isAnimating is false
							layer.animate
								scale: 1
								y: layer.y + 20
							layer.status = "down"
							inputs[i].visible = false
					if textLayer.status is "down" and textLayer.isAnimating is false
						textLayer.animate
							scale: 12/14
							y: textLayer.y - 20
						textLayer.status = "up"
				else
					layer.focus


for layer, i in lineGuides
	lineLayer = new Layer
		parent: textClicks[i]
		x: lineGuides[i].midX
		y: lineGuides[i].y
		height: 2
		width: 0
		backgroundColor: "#1E88E5"
		status: "hide"
		animationOptions: 
			curve: "ease", time: 0.15
	lineLayers.push(lineLayer)
	showWidth = lineGuides[i].width
	minX = lineGuides[i].minX
	midX = lineGuides[i].midX
	do (lineLayer, showWidth, minX, midX) ->
		lineLayer.placeBefore(lineGuides[i])
		textClicks[i].onClick ->
			do (i) ->
				for layer, i in lineLayers
					if layer.status is "show" and layer.isAnimating is false
						layer.animate
							width: 0
							x: midX
						layer.status = "hide"
				if lineLayer.isAnimating is false
					lineLayer.animate
						width: showWidth
						x: minX
					lineLayer.status = "show"
	seoBg.onClick ->
		for layer in lineLayers
			if layer.status is "show"
				layer.animate
					width: 0
					x: midX
				layer.status = "hide"
	analyticsBg.onClick ->
		for layer in lineLayers
			if layer.status is "show"
				layer.animate
					width: 0
					x: midX	
				layer.status = "hide"
	content.onClick ->
		for layer in lineLayers
			if layer.status is "show"
				layer.animate
					width: 0
					x: midX	
				layer.status = "hide"


for layer, i in textGuides
	input = new InputModule.Input
		parent: textClicks[i]
		width: lineGuides[i].width
		height: textGuides[i].height
		x: lineGuides[i].x
		y: textGuides[i].y - 10
		virtualKeyboard: false
		fontSize: 14
		lineHeight: 20
		padding: 10
	input.style =
		color: "#37475A"
		font: "Roboto"
	input.visible = false
	inputs.push(input)
	do (input) ->
		Events.wrap(input.form).addEventListener "submit", (event) ->
			event.preventDefault()
		textClicks[i].onClick ->
			input.visible = true
			input.bringToFront()
			input.focus()

# Affordances

pointers = [analyticsBack, seoBack, dropdown, pointerTop, ]


createAffordances = (index) ->
	pointers[index].onMouseOver ->
		if pointers[index].visible == true
			document.body.style.cursor = "pointer"
	pointers[index].onMouseOut ->
		document.body.style.cursor = "auto"

for layer, i in pointers
	createAffordances(i)