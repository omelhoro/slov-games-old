#copyright igor fischer djima154@yahoo.de
$=jQuery
$ ->
	$("button").button()
	$("#sortable").sortable({revert: true,items:"> li",axis:"x"})
	$( "li" ).disableSelection()
	$("#check").click ->
		$list=$("ul#sortable")
		solution=$list.data("sol")
		user_input= ""
		$list.children("li").each ->
			console.log($(this).text())
			user_input=user_input+" "+$(this).text()
		user_input=user_input.trim()
		if user_input is solution
			$("#status").attr("class","ui-icon ui-icon-circle-check")
		else
			$("#status").attr("class","ui-icon ui-icon-circle-close")
	
	$droppables=$(".droppable")
	$draggable=$("#draggable_clitic").draggable()
	$droppables.droppable({drop: (e,ui) -> 
		$(this).css({backgroundColor: "red"}).text($draggable.text())
		$draggable.remove()
		})
	$("#reset").click ->
		$droppables.css({backgroundColor: "#CCCCCC"}).text("")
		$("#task").append($draggable.draggable())
	$("#check_clit").click ->
		$droppables.each ->
			$drop=$(this)
			if $drop.text() and $drop.data("sol")
				console.log("right")
				$("#status_clit").attr("class","ui-icon ui-icon-circle-check")
				return false
			else
				console.log("false")
			$("#status_clit").attr("class","ui-icon ui-icon-circle-close")
