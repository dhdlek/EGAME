<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<%
	pageContext.setAttribute("newLine", "\n");
%>

<!DOCTYPE html>
<html lang="ko">

<head>
<%@ include file="/WEB-INF/views/include/head.jsp" %>
<link rel="stylesheet" href="/resources/css/qna-reg-form.css" type="text/css" />
<title>Store eGame : 문의</title>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
<script type="text/javascript">
$(document).ready(function(){
	$("#qnaTitle").focus();
	
	$("#btnWrite").on("click", function(){
		
		$("#btnWrite").prop("disabled", true);
		
		if($.trim($("#qnaTitle").val()).length <= 0)
		{
			alert("제목을 입력하세요.");
			$("#qnaTitle").val("");
			$("#qnaTitle").focus();
			$("#btnWrite").prop("disabled", false);
			return;
		}
		
		if($.trim($("#qnaContent").val()).length <= 0)
		{
			alert("내용을 입력하세요.");
			$("#qnaContent").val("");
			$("#qnaContent").focus();
			$("#btnWrite").prop("disabled", false);
			return;
		}
		
		var form = $("#qnaRegForm")[0];
		var formData = new FormData(form);
		
		$.ajax({
			type:"POST",
			url:"/board/qnaWriteProc",
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
					alert("문의 등록 되었습니다.");
					location.href = "/board/qna";
				}
				else if(response.code == 400)
				{
					alert("파라미터 값이 올바르지 않습니다.");
					$("#btnWrite").prop("disabled", false);
				}
				else
				{
					alert("문의 등록 중 오류가 발생하였습니다.");
					$("#btnWrite").prop("disabled", false);
				}
			},
			error:function(error)
			{
				game.common.error(error);
				alert("문의 등록 중 오류가 발생하였습니다.");
				$("#btnWrite").prop("disabled", false);
			}
		});
	});
	
	$("#btnCancel").on("click", function(){
		document.qnaRegForm.action = "/board/qna";
		document.qnaRegForm.submit();
	});
});
</script>
</head>

<body>
<%@ include file="/WEB-INF/views/include/navigation.jsp" %>
<div style="min-height: 700px;">
<div class="space-adpative"></div>
	<div class="body_div">
	   	<form name="qnaRegForm" id="qnaRegForm" method="post">
		    <section class="qna_reg_section">
		    	<input type="text" class="qna_reg_title" name="qnaTitle" id="qnaTitle" maxlength="50" placeholder="제목을 입력하세요." required />
				<div class="division_line"></div>
		        <textarea class="qna_reg_textarea" name="qnaContent" id="qnaContent" placeholder="내용을 입력하세요." required></textarea>
		    </section>
		    <div class="space-adpative"></div>
		    <section class="qna_reg_btn_section">
		        <button type="button" id="btnWrite" class="">등록</button>
		        <button type="button" id="btnCancel" class="">취소</button>
		    </section>
	    </form>
	</div>
<div class="space-adpative"></div>
</div> 

<%@ include file="/WEB-INF/views/include/footer.jsp" %>
</body>
</html>