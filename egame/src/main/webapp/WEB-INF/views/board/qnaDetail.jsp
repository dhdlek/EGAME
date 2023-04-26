<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<%
	pageContext.setAttribute("newLine", "\n");
%>

<!DOCTYPE html>
<html lang="ko">

<head>
<%@ include file="/WEB-INF/views/include/head.jsp" %>
<link rel="stylesheet" href="/resources/css/qna-detail.css" type="text/css" />
<title>Store eGame : 문의</title>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
<script type="text/javascript">
$(document).ready(function() {
<c:choose>
	<c:when test="${empty qna}">
		alert("조회하신 문의가 존재하지 않습니다.");
		document.qnaForm.action = "/board/qna";
		document.qnaForm.submit();
	</c:when>
	<c:otherwise>
		$("#btnList").on("click", function() {
			document.qnaForm.action = "/board/qna";
			document.qnaForm.submit();
		});
		
		$("#btnReply").on("click", function() {
			
			$("#btnReply").prop("disabled", true);
			
			if($.trim($("#qnaReplyContent").val()).length <= 0)
			{
				alert("내용을 입력하세요.");
				$("#qnaReplyContent").val("");
				$("#qnaReplyContent").focus();
				$("#btnReply").prop("disabled", false);
			}
			
			var form = $("#qnaReplyForm")[0];
			var formData = new FormData(form);
			
			$.ajax({
				type:"POST",
				url:"/board/qnaReplyProc",
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
						alert("답변이 등록 되었습니다.");
						document.qnaForm.action = "/board/qna";
						document.qnaForm.submit();
					}
					else if(response.code == 400)
					{
						alert("파라미터 값이 올바르지 않습니다.");
						$("#btnReply").prop("disabled", false);
					}
					else
					{
						alert("문의 답변 등록 중 오류가 발생하였습니다.");
						$("#btnReply").prop("disabled", false);
					}
				},
				error:function(error)
				{
					game.common.error(error);
					alert("문의 답변 등록 중 오류가 발생하였습니다.");
					$("#btnReply").prop("disabled", false);
				}
			});
		});
		
		$("#btnUpdate").on("click", function() {
			document.qnaForm.action = "/board/qnaUpdateForm"
			document.qnaForm.submit();
		});
		
		$("#btnDelete").on("click", function(){
			if(confirm("문의를 삭제 하시겠습니까?") == true)
			{
				$.ajax({
					type:"POST",
					url:"/board/qnaDelete",
					data:{
						qnaSeq:<c:out value="${qna.qnaSeq}" />
					},
					dataType:"JSON",
					beforeSend:function(xhr){
						xhr.setRequestHeader("AJAX", "true");
					},
					success:function(response)
					{
						if(response.code == 0)
						{
							alert("문의가 삭제되었습니다.");
							location.href = "/board/qna";
						}
						else if(response.code == 400)
						{
							alert("파라미터 값이 올바르지 않습니다.");
						}
						else if(response.code == 404)
						{
							alert("문의를 찾을 수 없습니다.");
							location.href = "/board/qna";
						}
						else if(response.code == -999)
						{
							alert("답변이 존재하여 삭제할 수 없습니다.");
						}
						else
						{
							alert("문의 삭제중 오류가 발생하였습니다.");
						}
					},
					error:function(xhr, status, error)
					{
						icia.common.error(error);	
					}
				});
			}
		});
	</c:otherwise>
</c:choose>
});
</script>
</head>

<body>
<%@ include file="/WEB-INF/views/include/navigation.jsp" %>
<div style="min-height: 700px;">
<div class="body_div">
    <div class="space-adpative"></div>
    <section class="qna_detail_section">
        <div>
            <span class="user_id"><c:out value="${qna.userId}" /></span>
            <small class="qna_reg_date"><c:out value="${qna.qnaRegDate}" /></small>
            <span class="qna_status">
            	<c:if test="${qna.qnaStatus eq '답변완료'}">
            		<img class="iconComplete" src="/resources/icon/complete.png" alt="" />
            	</c:if>
            	<c:out value="${qna.qnaStatus}" />
           	</span>
        </div>
        <div>
            <span class="qna_title"><c:out value="${qna.qnaTitle}" /></span>
        </div>
        <div class="division_line_in" style="padding: 0;"></div>
        <div class="qna_content_div">
            <c:out value="${qna.qnaContent}" />
        </div>
    </section>
    <div class="space-adpative"></div>
    <section class="qna_detail_btn_section">
        <button type="button" id="btnList">목록</button>
        <c:if test="${boardMe eq 'Y' || cookieUserId eq 'test'}">
        	<c:if test="${empty qnaReply}">
		        <button type="button" id="btnUpdate">수정</button>
		        <button type="button" id="btnDelete">삭제</button>
	        </c:if>
        </c:if>
    </section>
    <div class="space-adpative"></div>
    <div class="division_line_out"></div>
    <div class="space-adpative"></div>
</div>

<div class="body_div">
   <c:if test="${!empty qnaReply}">
   	<section class="qna_detail_reply_section_after">
        <div>
            <span class="admin_id">관리자</span>
            <small class="qna_reg_date">${qnaReply.qnaRegDate}</small>
        </div>
        <div class="division_line_in" style="padding: 0;"></div>
        <div class="qna_content_div">
			${qnaReply.qnaContent}
        </div>
    </section>
   </c:if>
   <c:if test="${cookieUserId eq 'test' && empty qnaReply}">
	<form name="qnaReplyForm" id="qnaReplyForm" method="post">
	    <section class="qna_detail_reply_section_before">
	        <textarea class="qna_detail_reply_textarea" name="qnaReplyContent" id="qnaReplyContent" placeholder="답변 내용을 입력하세요." required></textarea>
	    </section>
	    <div class="space-adpative"></div>
	    <section class="qna_detail_btn_section">
	        <button type="button" id="btnReply" class="">답변</button>
	    </section>
	    <input type="hidden" name="qnaSeq" value="${qna.qnaSeq}" />
        <input type="hidden" name="searchValue" value="${searchValue}" />
        <input type="hidden" name="curPage" value="${curPage}" />
    </form>
   </c:if>
</div>

<div class="space-adpative"></div>

    <form name="qnaForm" id="qnaForm" method="post">
        <input type="hidden" name="qnaSeq" value="${qnaSeq}" />
        <input type="hidden" name="searchValue" value="${searchValue}" />
        <input type="hidden" name="curPage" value="${curPage}" />
    </form>   
</div> 

<%@ include file="/WEB-INF/views/include/footer.jsp" %>
</body>
</html>