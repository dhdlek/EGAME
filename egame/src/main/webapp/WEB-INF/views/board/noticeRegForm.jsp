<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<%
	pageContext.setAttribute("newLine", "\n");
%>

<!DOCTYPE html>
<html lang="ko">

<head>
<%@ include file="/WEB-INF/views/include/head.jsp" %>
<link rel="stylesheet" href="/resources/css/notice-reg-form.css" type="text/css" />
<title>Store eGame : 공지사항</title>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
<script type="text/javascript">
$(document).ready(function(){
	$("#noticeTitle").focus();
	
	$("#btnWrite").on("click", function(){
		
		$("#btnWrite").prop("disabled", true);
		
		if($.trim($("#noticeTitle").val()).length <= 0)
		{
			alert("제목을 입력하세요.");
			$("#noticeTitle").val("");
			$("#noticeTitle").focus();
			$("#btnWrite").prop("disabled", false);
			return;
		}
		
		if($.trim($("#noticeContent").val()).length <= 0)
		{
			alert("내용을 입력하세요.");
			$("#noticeContent").val("");
			$("#noticeContent").focus();
			$("#btnWrite").prop("disabled", false);
			return;
		}
		
		var form = $("#noticeRegForm")[0];
		var formData = new FormData(form);
		
		$.ajax({
			type:"POST",
			url:"/board/noticeWriteProc",
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
					alert("게시물이 등록 되었습니다.");
					location.href = "/board/notice";
				}
				else if(response.code == 400)
				{
					alert("파라미터 값이 올바르지 않습니다.");
					$("#btnWrite").prop("disabled", false);
				}
				else
				{
					alert("게시물 등록 중 오류가 발생하였습니다.");
					$("#btnWrite").prop("disabled", false);
				}
			},
			error:function(error)
			{
				game.common.error(error);
				alert("게시물 등록 중 오류가 발생하였습니다.");
				$("#btnWrite").prop("disabled", false);
			}
		});
	});
	
	$("#btnCancel").on("click", function(){
		document.noticeRegForm.action = "/board/notice";
		document.noticeRegForm.submit();
	});
});
</script>
</head>

<body>
<%@ include file="/WEB-INF/views/include/navigation.jsp" %>
<div style="min-height: 700px;">
<div class="space-adpative"></div>
	<div class="body_div">
	   	<form name="noticeRegForm" id="noticeRegForm" method="post">
		    <section class="notice_reg_section">
		    	<input type="text" class="notice_reg_title" name="noticeTitle" id="noticeTitle" maxlength="50" placeholder="제목을 입력하세요." required />
				<div class="division_line"></div>
		        <textarea class="notice_reg_textarea" name="noticeContent" id="noticeContent" placeholder="내용을 입력하세요." required></textarea>
		    </section>
		    <div class="space-adpative"></div>
		    <section class="notice_reg_btn_section">
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