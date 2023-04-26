<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>

<!DOCTYPE html>
<html lang="ko">

<head>
<%@ include file="/WEB-INF/views/include/head.jsp" %>
<title>Store eGame : 문의 수정</title>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
<link rel="stylesheet" href="/resources/css/qna-update-form.css" type="text/css">
<script>
$(document).ready(function(){
	$("#qnaTitle").focus();
	
	$("#btnSave").on("click", function(){
		
		$("#btnSave").prop("disabled", true);
		
		if($.trim($("#qnaTitle").val()).length <= 0)
		{
			alert("제목을 입력하세요.");
			$("#qnaTitle").val("");
			$("#qnaTitle").focus();
			$("#btnSave").prop("disabled", false);
			return;
		}
		
		if($.trim($("#qnaContent").val()).length <= 0)
		{
			alert("내용을 입력하세요.");
			$("#qnaContent").val("");
			$("#qnaContent").focus();
			$("#btnSave").prop("disabled", false);
			return;
		}
		
		var form = $("#qnaUpdateForm")[0];
		var formData = new FormData(form);
		
		$.ajax({
			type:"POST",
			url:"/board/qnaUpdateProc",
			data:formData,
			processData:false,
			contentType:false,
			cache:false,
			beforeSend:function(xhr){
				xhr.setRequestHeader("AJAX", "true");
			},
			success:function(response)
			{
				if(response.code == 0)
				{
					alert("문의가 수정 되었습니다.");
					location.href = "/board/qna";
				}
				else if(response.code == 400)
				{
					alert("파라미터 값이 올바르지 않습니다.");
					$("#btnSave").prop("disabled", false);
				}
				else
				{
					alert("문의 수정 중 오류가 발생하였습니다.");
					$("#btnSave").prop("disabled", false);
				}
			},
			error:function(error)
			{
				game.common.error(error);
				alert("문의 수정 중 오류가 발생하였습니다.");
				$("#btnSave").prop("disabled", false);
			}
		});
	});
	
	$("#btnCancel").on("click", function(){
		document.qnaForm.action = "/board/qnaDetail";
		document.qnaForm.submit();
	});
});

</script>
</head>


<body>
<%@ include file="/WEB-INF/views/include/navigation.jsp" %>
 
<div style="min-height: 700px;">
	<div class="space-adpative"></div>
		<div class="body_div">
		   	<form name="qnaUpdateForm" id="qnaUpdateForm" method="post">
			    <section class="qna_update_section">
			    	<input type="text" class="qna_update_title" name="qnaTitle" id="qnaTitle" maxlength="16" placeholder="제목을 입력하세요." value="${qna.qnaTitle}" required />
					<div class="division_line"></div>
			        <textarea class="qna_update_textarea" name="qnaContent" id="qnaContent" placeholder="내용을 입력하세요." required>${qna.qnaContent}</textarea>
			    </section>
			    <div class="space-adpative"></div>
			    <section class="qna_update_btn_section">
			        <button type="button" id="btnSave" class="">저장</button>
			        <button type="button" id="btnCancel" class="">취소</button>
			    </section>
			    <input type="hidden" name="qnaSeq" value="${qnaSeq}" />
		    </form>
		    <form name="qnaForm" id="qnaForm" method="post">
	            <input type="hidden" name="qnaSeq" value="${qna.qnaSeq}" />
	            <input type="hidden" name="searchValue" value="${searchValue}" />
	            <input type="hidden" name="curPage" value="${curPage}" />
	        </form>
		</div>
</div> 
 
<%@ include file="/WEB-INF/views/include/footer.jsp" %>
</body>
</html>