#copyright igor fischer djima154@yahoo.de
$=jQuery
$ ->
	
	class Case_Trainer
		constructor: ->
			@$table=$("#case_table")
			@$help=$(".ui-icon-help")
			@$count=$("#count")
			@cases=(k for k,v of case_order)
			@$rows=[]
			@nums=3
			for id,nm of case_order
				$row=$("<tr class='case_rows #{id}'></tr>")
				@$rows.push($row)
				td_case=$("<td class='case' id='#{id}'></td>").text(nm)
				$row.append(td_case)
				@$table.append($row)
			@words=(val for k,val of par_db)#.slice(1,10)
			for i in [@words.length...0]
				rand_num=Math.floor(Math.random()*i)
				word=@words.splice(rand_num,1)[0]
				@words.push(word)
			@filtered=(w for w in @words)
				
		_flatten: (nested_list) ->
			flat_array=[]
			for ar in nested_list
				flat_array=flat_array.concat(ar)
			flat_array
	
		_mean_word_length: (ar) ->
			length=0
			for wrd in ar
				length+=wrd.length
			length/ar.length
			
			
		_pick_random: (start=0,end,how_many=1) ->
			random_array=(n for n in [start...end])
			console.log("rand_ar",random_array)
			for el,i in random_array
				random_num=Math.floor(Math.random()*random_array.length)
				temp=random_array[i]
				random_array[i]=random_array[random_num]
				random_array[random_num]=temp
			random_array.slice(0,how_many)
		
		filter_data: (gender,number,freq=1) ->
			check_gender =(str) ->
				a=(g for g in gender when str.indexOf(g) isnt -1)
				return true if a.length > 0
			num_str= "#{number}"
			@filtered=(w for w in @words when check_gender(w[0]) and num_str.indexOf("#{w[2].sort()}") isnt -1 )
			@$count.text(@filtered.length)
		
		make_table: (misses) ->
			@$count.text(@filtered.length-1)
			$(".decl").remove()
			[word_par,word_stem,word_num]=@filtered.pop()
			@$help.prop("title",word_par)
			console.log(word_stem)
			ideal_par=reg_db[word_par]
	
			flatten_ar= @_flatten(ideal_par)
			mean_wrd= @_mean_word_length(flatten_ar)
			switch word_num.length
				when 1
					start=word_num[0]*flatten_ar.length/@nums
					end=(word_num[0]+1)*flatten_ar.length/@nums
					miss_randoms=@_pick_random(start,end,misses)
				when 3
					miss_randoms=@_pick_random(0,flatten_ar.length,misses)

			counter= 0
			for i in [0...3]
				for td,ii in ideal_par[i]
					stem= if word_stem.length > 1 then word_stem[i][ii] else word_stem[0]
					if i in word_num
						if counter in miss_randoms
								td_input=$("<input/>").data("sol",td).prop("size",3)
								tdata=$("<td class='decl'>#{stem}-</td>").append(td_input)
						else
								tdata=$("<td class='decl'>#{stem}-#{td}</td>")
					else
						tdata=$("<td class='missing decl'>")
					$row=@$rows[ii]
					$row.append(tdata)
					counter++
				
		check_table: ->
			right=true
			$inputs=$("#case_table").find("input")
			$inputs.each ->
				console.log(this,$(this))
				$input=$(this)
				user_input=$(this).val()
				solution=$(this).data("sol")
				if user_input isnt solution
					right=false
					$input.css("backgroundColor","#E83354")#.after("<span class='wrong'>Falsch</span>")
				else
					$input.css("backgroundColor","#66FA66")#.after("<span class='wrong'>Falsch</span>")
				
	class Session
		constructor: ->
			@case_trainer=new Case_Trainer()
			@_manager()
			#@_slider()
			@_filter()
			@case_trainer.make_table()
			
		_filter: ->
			$gender=$("#gen_pars").children()
			$number=$("#num_pars").children()
			$freq=$("#freq_pars").prop("checked","true")
			$(".parameters").change( =>
				gender=[]
				number=[]
				$gender.each( (i,o) ->
					o=$(o)
					gender.push(o.val()) if o.is(":checked"))
				$number.each( (i,o) ->
					o=$(o)
					number.push(parseInt(o.val())) if o.is(":checked"))
				number.push(1) if number.length is 2
				@case_trainer.filter_data(gender.sort(),number.sort())
				@_enableNextBut()
				)
			$gender.click()
			$number.click()


		_enableNextBut: ->
			if @case_trainer.filtered.length is 0
				$("#generator").prop("disabled",true)
			else
				$("#generator").prop("disabled",false)

		_manager: ->
			$("#generator").click =>
				misses=$("#num_miss").val()
				n=parseInt(misses)
				if n or n is 0
					@case_trainer.make_table(misses)
					@_enableNextBut()
				else
					alert("Not a valid number!")
			$("#check").click =>
				@case_trainer.check_table()
				
		_slider: ->
			$("#freq_pars").slider({
				range:true
				min:0
				max:100
				values:[0,100]
			})
			#TODO: add filter for cases and frequency by slider
	$case_div=$("#case_table")
	session=new Session()
	
			
