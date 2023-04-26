<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<%
	pageContext.setAttribute("newLine", "\n");
%>

<!DOCTYPE html>
<html lang="ko">

<head>
<%@ include file="/WEB-INF/views/include/head.jsp" %>
<link rel="stylesheet" href="/resources/css/notice-detail.css" type="text/css" />
<title>Store eGame : 공지사항</title>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
<script type="text/javascript">
$(document).ready(function() {
<c:choose>
	<c:when test="${empty notice}">
		alert("조회하신 공지사항이 존재하지 않습니다.");
		document.noticeForm.action = "/board/notice";
		document.noticeForm.submit();
	</c:when>
	<c:otherwise>
		$("#btnList").on("click", function() {
			document.noticeForm.action = "/board/notice";
			document.noticeForm.submit();
		});
		
		$("#btnUpdate").on("click", function() {
			document.noticeForm.action = "/board/noticeUpdateForm"
			document.noticeForm.submit();
		});
		
		$("#btnDelete").on("click", function(){
			if(confirm("공지사항을 삭제 하시겠습니까?") == true)
			{
				$.ajax({
					type:"POST",
					url:"/board/noticeDelete",
					data:{
						noticeSeq:<c:out value="${notice.noticeSeq}" />
					},
					dataType:"JSON",
					beforeSend:function(xhr){
						xhr.setRequestHeader("AJAX", "true");
					},
					success:function(response)
					{
						if(response.code == 0)
						{
							alert("공지사항이 삭제되었습니다.");
							location.href = "/board/notice";
						}
						else if(response.code == 400)
						{
							alert("파라미터 값이 올바르지 않습니다.");
						}
						else if(response.code == 404)
						{
							alert("공지사항을 찾을 수 없습니다.");
							location.href = "/board/notice";
						}
						else
						{
							alert("공지사항 삭제중 오류가 발생하였습니다.");
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

<div class="body_div">
    <div class="space-adpative"></div>
    <section class="notice_detail_section">
        <div>
            <span class="user_id"><c:out value="관리자" /></span>
            <small class="notice_reg_date"><c:out value="${notice.noticeRegDate}" /></small>
        </div>
        <div>
            <span class="notice_title"><c:out value="${notice.noticeTitle}" /></span>
        </div>
        <div class="division_line_in" style="padding: 0;"></div>
        <div class="noticeContentDiv">
            <c:out value="${notice.noticeContent}" /> 
        </div>
    </section>
    <div class="space-adpative"></div>
    <section class="notice_detail_btn_section">
        <button type="button" id="btnList">목록</button>
        <c:if test="${cookieUserId eq 'test'}">
	        <button type="button" id="btnUpdate">수정</button>
	        <button type="button" id="btnDelete">삭제</button>
        </c:if>
    </section>
    <div class="space-adpative"></div>
</div>

    <form name="noticeForm" id="noticeForm" method="post">
        <input type="hidden" name="noticeSeq" value="${noticeSeq}" />
        <input type="hidden" name="searchValue" value="${searchValue}" />
        <input type="hidden" name="curPage" value="${curPage}" />
    </form>
    
<%@ include file="/WEB-INF/views/include/footer.jsp" %>
</body>
</html>