<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>

<!DOCTYPE html>
<html lang="ko">

<head>
<%@ include file="/WEB-INF/views/include/head.jsp" %>
<title>Store eGame : 공지수정</title>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
<link rel="stylesheet" href="/resources/css/notice-update-form.css" type="text/css">

<script>
$(document).ready(function(){
	$("#noticeTitle").focus();
	
	$("#btnUpdate").on("click", function(){
		
		$("#btnUpdate").prop("disabled", true);
		
		if($.trim($("#noticeTitle").val()).length <= 0)
		{
			alert("제목을 입력하세요.");
			$("#noticeTitle").val("");
			$("#noticeTitle").focus();
			$("#btnUpdate").prop("disabled", false); // 저장버튼 활성화
			return;
		}
		
		if($.trim($("#noticeContent").val()).length <= 0)
		{
			alert("내용을 입력하세요.");
			$("#noticeContent").val("");
			$("#noticeContent").focus();
			$("#btnUpdate").prop("disabled", false);
			return;
		}
		
		var form = $("#noticeUpdateForm")[0];
		var formData = new FormData(form);
		
		$.ajax({
			type:"POST",
			url:"/board/noticeUpdateProc",
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
					alert("공지사항이 수정 되었습니다.");
					location.href = "/board/notice";
				}
				else if(response.code == 400)
				{
					alert("파라미터 값이 올바르지 않습니다.");
					$("#btnUpdate").prop("disabled", false);
				}
				else
				{
					alert("공지사항 수정 중 오류가 발생하였습니다.");
					$("#btnUpdate").prop("disabled", false);
				}
			},
			error:function(error)
			{
				game.common.error(error);
				alert("공지사항 수정 중 오류가 발생하였습니다.");
				$("#btnUpdate").prop("disabled", false);
			}
		});
	});
	
	$("#btnCancel").on("click", function(){
		document.noticeForm.action = "/board/notice";
		document.noticeForm.submit();
	});
});

</script>
</head>

<body>
 <%@ include file="/WEB-INF/views/include/navigation.jsp" %>
 
<div style="min-height: 700px;">
	<div class="space-adpative"></div>
		<div class="body_div">
		   	<form name="noticeUpdateForm" id="noticeUpdateForm" method="post">
			    <section class="notice_update_section">
			    	<input type="text" class="notice_update_title" name="noticeTitle" id="noticeTitle" maxlength="16" placeholder="제목을 입력하세요." value="${notice.noticeTitle}" required />
					<div class="division_line"></div>
			        <textarea class="notice_update_textarea" name="noticeContent" id="noticeContent" placeholder="내용을 입력하세요." required>${notice.noticeContent}</textarea>
			    </section>
			    <div class="space-adpative"></div>
			    <section class="notice_update_btn_section">
			        <button type="button" id="btnUpdate" class="">저장</button>
			        <button type="button" id="btnCancel" class="">취소</button>
			    </section>
			    <input type="hidden" name="noticeSeq" value="${noticeSeq}">
		    </form>
		    <form name="noticeForm" id="noticeForm" method="post">
		        <input type="hidden" name="noticeSeq" value="${notice.noticeSeq}" />
		        <input type="hidden" name="searchValue" value="${searchValue}" />
		        <input type="hidden" name="curPage" value="${curPage}" />
	   		</form>
		</div>
</div>
    
<%@ include file="/WEB-INF/views/include/footer.jsp" %>
</body>
</html>