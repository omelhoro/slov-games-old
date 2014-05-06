#copyright igor fischer djima154@yahoo.de
$=jQuery
$ ->
	class Voc_Trainer
		constructor: (lessons) ->
			@word_dict={}
			@word_array=[]
			@freq_pos={}
			for lesson in lessons
				for wr_lst in voc_db[lesson]
					pos=wr_lst[1]
					@freq_pos[pos]=if @freq_pos[pos]? then @freq_pos[pos]+1  else 1 
					@word_dict[wr_lst[0]]=wr_lst
					@word_array.push(wr_lst[0])
			console.log(@freq_pos)
			#array for modus mult choice to pick from a non popping array
			@mult_ar=(w for w in @word_array)
			for i in [0...@word_array.length]
				wr_index=Math.floor(Math.random()*@word_array.length)
				word=@word_array[wr_index]
				@word_array[wr_index]=@word_array[i]
				@word_array[i]=word
			@status="input"
			
				
		serve_word: -> 
			word=@word_array.pop()
			trans=@word_dict[word][3]
			pos=@word_dict[word][1]
			pos_freq=@freq_pos[pos] < 3 
			
			$word.text(word).data("sol",trans)
			$input_field.val("")
			rand_ar=[trans]
			console.log(rand_ar,trans,@word_dict[word])
			while rand_ar.length < 3 #or counter >15
				rand_wrd=@mult_ar[Math.floor(Math.random()*@mult_ar.length)]
				rand_pos=@word_dict[rand_wrd][1]
				rand_wrd=@word_dict[rand_wrd][3]
				if rand_wrd not in rand_ar and  (rand_pos is pos or pos_freq)
					console.log(rand_pos,rand_wrd,pos_freq,@freq_pos[pos])
					if Math.random() >0.5 then rand_ar.push(rand_wrd) else rand_ar.unshift(rand_wrd)
			for el,i in rand_ar
				$("span#op#{i+1}").text(el)
			
		check_word: ->
			if @status is "input"
				user_input= $input_field.val() 
			else 
				temp= $word_ops.filter( -> $(this).is(":checked"))
				val= temp.val()
				user_input=$("span##{val}").text()
			solution=$word.data("sol")
			console.log(user_input,solution)
			if user_input is solution
				$history_div=$("#history_right")
				$(".word").css({backgroundColor: "green"})
			else
				$(".word").css({backgroundColor: "red"})
				$history_div=$("#history_false")
			$(".word").animate({backgroundColor: "white"},1500)
			$history_div.append($("<p></p>").text($(".word").text()))#+": "+solution+" - "+user_input))
	
	class Session
		constructor: ->
			@voc_trainer=""
			@_check_menu()	
			@_watch_modus()
			@_watch_start()
			
			
		_watch_modus: ->
			$("div#mult").hide()
			$("input[name='modus']").change( (eve) =>
				console.log(eve,eve.target)
				val=$(eve.target).val()
				switch val
					when "input" 
						$("div#mult").hide()
					when "mult" 
						$("div#input").hide()
				$("div##{val}").show()
				if @voc_trainer
					@voc_trainer.status=val
			)

		_control_voc_trainer: ->
			@voc_trainer.serve_word()
			$("#next_word").click =>
				@voc_trainer.serve_word()
			$("#check").click =>
				@voc_trainer.check_word()	
			
		_watch_start: ->
			$("#start").click (e) =>
				$lessons=$("input[name='les']")
				$lessons_checked=$lessons.filter(":checked")
				lessons=[]
				if $lessons_checked.length > 0
					$lessons_checked.each ((i,elm) ->
						console.log("iii")
						ls=$(this)
						lessons.push(ls.val()))
					$(".voc_trainer_controller").prop("disabled",false)
					@voc_trainer=new Voc_Trainer(lessons)
					$("#options").hide("slow")
					@_control_voc_trainer()
				else
					alert("No lessons chosen! Try again.")
				
		_check_menu: ->
			$les_box=$("input[value^='les']")
			$sel_lnk=$(".select")
			$sel_lnk.click( (e)-> 
				e.preventDefault()
				switch $(e.target).prop("id")
					when "unselect_all" then  $les_box.prop("checked",false)
					when "select_all" then $les_box.prop("checked",true)
				)

					
	console.log(voc_db)
	$input_field=$(".translation")
	$status_field=$("#correction")
	$word=$(".word")
	$word_ops=$("input[name='word_ops']")
	$choice_par=$("p#les_choice").append($("<tr><td>?</td><td>Lektion</td><td># Wörter</td></tr>"))
	lesKeys=(ky for ky,_ of voc_db).sort( (a,b) ->
		a=parseInt(a.match(/\d+/))
		b=parseInt(b.match(/\d+/))
		return a-b
		)
	for ky in lesKeys
		$tabRow=$("<tr>")
		$input_bx=$("<td><input type='checkbox'name='les' value='#{ky}'/></td>")
		$input_lbl=$("<td>").text("Lektion #{ky.replace('les','')}")
		$lesLength=$("<td>").text(voc_db[ky].length)
		$tabRow.append($input_bx).append($input_lbl).append($lesLength)
		$choice_par.append($tabRow)
		#$choice_par.append($input_lbl).append($input_bx).append("<br/>")
	
	session=new Session()
