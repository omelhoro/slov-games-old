#copyright igor fischer djima154@yahoo.de
$=jQuery
$ ->
	class Case_Text
		constructor: ->
			@casus=$(".case")#.removeClass("selected")
			@nouns=""
			@cases=($(w).prop("class").split(" ")[1] for w in @casus)
			@casus_selected=[$(@casus[0]),0]
			@noun_selected=[$(@nouns[0]),0]
		
		mark_noun: ->
			cas=@casus_selected[0].attr('class').split(' ')[1]
			for ca in @cases
				console.log(ca)
				i=[@noun_selected[0].prop("class"),ca]
				@noun_selected[0].removeClass(ca)
				i=@noun_selected[0].prop("class")
			@noun_selected[0].addClass(cas)
			@noun_selected[0].data("user",cas)

		move_cases: (direction) ->
			@casus_selected[0].toggleClass("selected")
			if direction is 83
				@casus_selected[1]+=1
			else if direction is 87
				@casus_selected[1]-=1
			@casus_selected[1]=0 if @casus_selected[1] is @casus.length
			@casus_selected[1]=@casus.length-1 if @casus_selected[1] is -1
			@casus_selected[0]=$(@casus[@casus_selected[1]])
			@casus_selected[0].toggleClass("selected")

		move_nouns: (direction) ->
			@noun_selected[0].removeClass("selected")
			console.log(@noun_selected)
			if direction is 68
				@noun_selected[1]+=1
			else if direction is 65
				@noun_selected[1]-=1
			@noun_selected[1]=0 if @noun_selected[1] is @nouns.length
			@noun_selected[1]=@nouns.length-1 if @noun_selected[1] is -1
			@noun_selected[0]=$(@nouns[@noun_selected[1]])
			@noun_selected[0].toggleClass("selected")
		
	#score=total_itms=0

	class Session
		constructor: ->
			@$div_task=$("div#task")
			@div_texts=$("div#texts")#.append
			@$button_par=$("button.par_cont")
			for ky,_ of txt_db
				ky_but=$("<input type='radio' name='text' value='#{ky}'>#{ky}<br/>")
				@div_texts.append(ky_but)
			@case_text = new Case_Text()
			@text=""
			@_control()
			@div_texts.children().first().click()
			$("button#next").click()
			
		_control: ->
			$(@case_text.casus[0]).addClass("selected") #select first casus only at first time
			@$button_par.click( (e) =>
				console.log("ii")
				
				@$div_task.contents().remove()
				$but=$(e.target)
				@text[1]+=parseInt($but.val())
				console.log(@text,$but.val(),@text[0][@text[1]])
				p=$("<p></p>").append(@text[0][@text[1]])
				@$div_task.append(p)

				#@case_text.casus.removeClass("selected")
				@case_text.nouns=$(".noun")
				$(@case_text.nouns[0]).addClass("selected")
				@case_text.noun_selected=[$(@case_text.nouns[0]),0]
				if @text[1] is 0
					@$button_par.filter("#prev").prop("disabled",true)
				else
					@$button_par.filter("#prev").prop("disabled",false)
				if @text[1] is @text[0].length-2
					@$button_par.filter("#next").prop("disabled",true)
				else
					@$button_par.filter("#next").prop("disabled",false)
			)
			$("input[name='text']").change( (e) =>
				txt=$(e.target).val()
				@text=[txt_db[txt],-1]
				$("button#next").click()
				)
				
			$("#case-controller").click =>
				@case_controller()
				
			$("#reseter").click =>
				score=total_itms=0
				$("#score").remove()
				$(".valuation").remove()
				@case_text.nouns.removeData("user").removeClass("false").removeClass("correct")

			$(document).keyup (e) => 
				key_pressed = e.which
				console.log(key_pressed)
				if key_pressed in [83,87]
					@case_text.move_cases(key_pressed)  
				else if key_pressed in [65,68]
					@case_text.move_nouns(key_pressed)
				else if key_pressed is 32
					@case_text.mark_noun()

		case_controller: ->
			@case_text.nouns.each ->
				$item=$(this)
				right_case=$item.data("case")			
				user_case=$item.data("user")	
				#total_itms+=1
				if right_case is user_case
					$item.addClass("correct")
					#score+=1
				else
					$item.addClass("false")
					#$("<span class='valuation'>Falsch</span>").insertAfter($item)

	session=new Session()
