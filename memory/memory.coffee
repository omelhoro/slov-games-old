$= jQuery
$ ->
	class SVGCard
		@WI=150
		@HE=150
		constructor: (@text) ->
			@svg= @makeCard()

		makeCard: ->
			text= "<text y=#{SVGCard.HE/2} x=2 font-size='10px'>#{@text.replace("_svg","")}</text>"
			$("<svg height=#{SVGCard.HE}  width=#{SVGCard.WI} id='#{@text}' class='mem_txt'>#{text}</svg>")
	
	class SecretCard

		constructor: (@text,@class) ->
			@card= @makeCard()

		makeCard: ->
			"<td><img id='#{@text}' class='#{@class}' data-stat='secret' src='memory/pics/secret.jpg' ></td>"


	class TableView

		constructor: (@data) ->
			@makeTable()
			@current_sel=[]

		makeTable: ->
			t= $("<table id='memory'>")
			tr= $("<tr>")
			itms= []
			for k,v of @data
				c= new SecretCard(k,"mem_pic")
				td= $(c.card)
				itms.push(td)
			for k,v of @data
				c= new SecretCard(k+"_svg","mem_txt")
				td= $(c.card)
				itms.push(td)

			#randomize
			for i in [itms.length...0]
				rand_num= Math.floor(Math.random()*i)
				word= itms.splice(rand_num,1)[0]
				itms.push(word)
			for itm,i in itms
				if (i)%5==0
					tr= $("<tr>") 
					t.append(tr)
				tr.append(itm)


			$("#wrap").append(t)
			@turnCard()

		control_selected: =>
			tab= $("table")
			stat= ( (c.prop("id")).replace("_svg","") for c in  @current_sel)
			if stat[0]==stat[1]
				(c.attr("class","solved") for c in @current_sel)
				(c.unbind() for c in @current_sel)
				$(".solved").css("background-color","green")
				$(".solved").animate({
					backgroundColor: "white"
					},1000)
			else
				tab.css("backgroundColor","red")
				$("table").animate({
					backgroundColor: "white"
					},1000)
				(c.click() for c in @current_sel) 
				(@_turnSecretSvg(c) for c in @current_sel when c.prop("tagName")=="svg") 
			@current_sel=[]

		addToSel: (e) ->
			@current_sel.push(e)
			if @current_sel.length ==2
				setTimeout(@control_selected,1000)

		turnCard: ->
			$("img.mem_pic").click( (e) =>
				target= $(e.target)
				toturn= target.prop("id")
				switch target.data("stat")
					when "secret" 
						k= @data[toturn]
						target.prop("src","memory/pics/#{k}.jpg")
						target.data("stat","active")
						@addToSel(target)
					when "active"
						target.prop("src",'memory/pics/secret.jpg')
						target.data("stat","secret")
				)
			$("img.mem_txt").click( (e) =>
				@_makeSvg(e)
				)
			$("svg.mem_txt").click( (e) =>
				#@_turnSecretSvg(e)
				)


		_makeSvg: (e) ->
			console.log "ckeckcl",@current_sel,e
			target= $(e.target)
			toturn= target.prop("id")
			tdPar= target.parent()
			svg= new SVGCard(toturn)
			tdPar.append(svg.svg)
			target.remove()
			#$("text").each( (i,ec) -> console.log ec.getBBox())
			console.log svg.svg
			svg.svg.on("click", (e) =>
				#@_turnSecretSvg(e) 
				)
			@addToSel(svg.svg)

			

		_turnSecretSvg: (e) ->
			target= e
			toturn= target.prop("id")
			tdPar= target.parent()
			target.remove()
			secret= $("<img id='#{toturn}' class='mem_txt' data-stat='secret' src='memory/pics/secret.jpg' >")
			tdPar.append(secret)
			console.log secret
			secret.on("click", (e) =>
				@_makeSvg(e)
				)

	$.getJSON("memory/pics_map.json", (data) ->
		#s= new SVGCard("jkldjsfdsf")
		#$("#wrap").append(s.svg)

		table= new TableView(data)
		)