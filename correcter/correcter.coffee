#copyright igor fischer djima154@yahoo.de
$=jQuery
$ ->
	class TaskTrainer

		@control_element: (event) ->
			is_right=false
			$event=$(event)
			$event.siblings("input").each ->
				user_input=$(this).val().trim().replace(/\s{2,}/g, ' ','').replace(" ","_")
				solution=$(this).data("sol").toString().split(",")
				solution=(w.trim() for w in solution)
				if user_input in solution
					is_right=true
				else
					is_right=false
				if is_right is true
					$event.addClass("right").text('✓')
					#$event.prop("class","right").text('✓')
				else
					$event.addClass("false").text('x')
					#$event.prop("class","false").text('X')
						
		constructor: (tasks) ->
			@task_hist=[]
			@ava_tasks=tasks
			@giveExample()
			@_showGerman()

		_showGerman: ->
			tskGerman= $("#tsk_de")
			show= -> tskGerman.css("visibility","visible")
			hide= -> tskGerman.css("visibility","hidden")
			$("#tsk_sl").hover(show,hide)

		giveExample: ->
			$("#help").click(->
				$inputBut=$(".corrector").first()
				inputEl= $inputBut.siblings("input")
				inputSol=inputEl.data("sol").replace("_"," ")
				inputEl.val(inputSol)
				TaskTrainer.control_element($inputBut)
				)
						
		serve_task: ->
			$("div#task").remove()
	
			cur_task=Math.floor(Math.random()*@ava_tasks.length)
			while cur_task in @task_hist
				cur_task=Math.floor(Math.random()*@ava_tasks.length)
			@task_hist.push(cur_task)
			console.log cur_task
	
			taskDiv=$("<div id='task'>")
			taskKy=@ava_tasks[cur_task]
			header=@ava_tasks[cur_task].join()
			taskTxt=taskDb[taskKy[0]][taskKy[1]]
			if header.indexOf("|<") != -1 
				lstIndex=header.indexOf("|<")
				lstSstr=header.substring(lstIndex+1)
				header=header.substring(0,lstIndex-1)
			
			#taskDiv.append("<h3>#{header}</h3>")
			taskDiv.append(lstSstr) if lstSstr?
			taskDiv.append(taskTxt)
			taskDiv.append("<p><button class='corrector-all'>Check all</button></p>")
			$("#exercises").append(taskDiv)
	
			$("#task").on("click",".corrector",(e) -> TaskTrainer.control_element(e.target))
			$("#task").on("click",".corrector-all",(e) -> 
				$p=$(this).parent().prevAll().find("button")
				console.log($p)
				$p.each (i,e) ->
					TaskTrainer.control_element(e)
				)
				
			@_inputBoxes(taskDiv)
			@_showGerman()
			if @task_hist.length == @ava_tasks.length
				$("button.serve_task").prop("disabled",true)
	
		_inputBoxes: (taskDiv) ->
			letter_len=0
			array_len=0
			$inputs=taskDiv.find("input")
			$inputs.each ->
				letter_len+=$(@).data("sol").length
				array_len+=1	
				mean_len=letter_len/array_len
				$inputs.prop("size",mean_len)
			
		
			
	class Session
		constructor: ->
			@ava_tasks=[]#((ky,(k for k,v in val) for ky,val of taskDb)
			@_updateNumTasks()
			@reg_funcs($("button"))
			@taskTrainer=""
			$("div#exercises").hide()
			$("div#options").find("input").click()#prop("checked",true)

		startTrainer: ->
				
			$("button.start_trainer").prop("disabled",true)
			$("button.serve_task").prop("disabled",false)
			$("div#options").hide(1000)
			
			@taskTrainer=new TaskTrainer(@ava_tasks)
			@taskTrainer.serve_task()
			$("div#exercises").show(1000)
			
		_updateNumTasks: ->
			lesMap={
					beginner:("les"+n for n in [0...6]),
					adv_beginner:("les"+n for n in [6...9]),
					advanced:("les"+n for n in [9...18]),
				}
			checkBox=$("div#options").find("input")
			checkBox.change( =>
				@ava_tasks=[]
				lesLevel=[]
				pos=[]
				checkBox.each ->
					if $(this).prop("checked")
						parId=$(this).parent().prop("id")
						$checkVal=$(this).val()  
						if parId is "lesLevel" then lesLevel.push(lesMap[$checkVal])  else pos.push($checkVal)
						
				for ll in lesLevel
					for les in ll
							for k,v of taskDb[les]
								if k? and k.split(",")[0] in pos
									@ava_tasks.push([les,k])
				$("span#numTasks").text(@ava_tasks.length)
				)
			
		
		reg_funcs: ($buttons) ->
			$buttons.click( (e) =>
				clss=$(e.target).prop("class")
				switch clss
					when "serve_task" then @taskTrainer.serve_task()
					when "start_trainer" 
						if @ava_tasks.length >0 
							 @startTrainer() 
						else 
							alert("No tasks in the pool!")
			)
	
	session=new Session()
