#screen width vs. size of image width
growthRatio = Screen.width / 732
imageHeight = growthRatio * 432


class exports.Input extends Layer
	@define "style",
		get: -> @input.style
		set: (value) ->
			_.extend @input.style, value

	@define "value",
		get: -> @input.value
		set: (value) ->
			@input.value = value

	constructor: (options = {}) ->
		options.setup ?= false
		options.width ?= Screen.width
		options.clip ?= false
		options.height ?= 60
		options.backgroundColor ?= if options.setup then "rgba(255, 60, 47, .5)" else "transparent"
		options.fontSize ?= 30
		options.lineHeight ?= 30
		options.padding ?= 10
		options.text ?= ""
		options.placeholder ?= ""
		options.virtualKeyboard ?= if Utils.isMobile() then false else true
		options.type ?= "text"
		options.goButton ?= false
		options.autoCorrect ?= "on"
		options.autoComplete ?= "on"
		options.autoCapitalize ?= "on"
		options.spellCheck ?= "on"
		options.autofocus ?= false

		super options

		@placeholderColor = options.placeholderColor if options.placeholderColor?
		@input = document.createElement "input"
		@input.id = "input-#{_.now()}"
		@input.style.cssText = "outline: none; font-size: #{options.fontSize}px; line-height: #{options.lineHeight}px; padding: #{options.padding}px; width: #{options.width}px; height: #{options.height}px; border: none; background-image: url(about:blank); background-color: #{options.backgroundColor};"
		@input.value = options.text
		@input.type = options.type
		@input.placeholder = options.placeholder
		@input.setAttribute "autocorrect", options.autoCorrect
		@input.setAttribute "autocomplete", options.autoComplete
		@input.setAttribute "autocapitalize", options.autoCapitalize
		if options.autofocus == true
			@input.setAttribute "autofocus", true
		@input.setAttribute "spellcheck", options.spellCheck
		@form = document.createElement "form"

		if options.goButton
			@form.action = "#"
			@form.addEventListener "submit", (event) ->
				event.preventDefault()

		@form.appendChild @input
		@_element.appendChild @form

		@backgroundColor = "transparent"
		@updatePlaceholderColor options.placeholderColor if @placeholderColor

		#only show honor virtual keyboard option when not on mobile,
		#otherwise ignore
		if !Utils.isMobile() && options.virtualKeyboard is true
			@input.addEventListener "focus", ->
				exports.keyboardLayer.bringToFront()
				exports.keyboardLayer.stateCycle()
			@input.addEventListener "blur", ->
				exports.keyboardLayer.animate("default")

	updatePlaceholderColor: (color) ->
		@placeholderColor = color
		if @pageStyle?
			document.head.removeChild @pageStyle
		@pageStyle = document.createElement "style"
		@pageStyle.type = "text/css"
		css = "##{@input.id}::-webkit-input-placeholder { color: #{@placeholderColor}; }"
		@pageStyle.appendChild(document.createTextNode css)
		document.head.appendChild @pageStyle

	focus: () ->
		@input.focus()

	onFocus: (cb) ->
		@input.addEventListener "focus", ->
			cb.apply(@)

	onBlur: (cb) ->
		@input.addEventListener "blur", ->
			cb.apply(@)
