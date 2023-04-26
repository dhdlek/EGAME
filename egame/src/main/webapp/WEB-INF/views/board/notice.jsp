<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>

<!DOCTYPE html>
<html>
<head>
<%@ include file="/WEB-INF/views/include/head.jsp" %>
<title>Store eGame : 공지사항</title>
<link rel="stylesheet" href="/resources/css/notice.css" type="text/css">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
<script>

$(document).ready(function(){
	$("#_searchValue").keyup(function(event)
	{
        if (event.which === 13) 
        {
            $("#btnSearch").click();
        }
    });
	
	$("#btnWrite").on("click", function() {
		document.noticeForm.noticeSeq.value = "";
		document.noticeForm.action = "/board/noticeRegForm";
		document.noticeForm.submit();
	});
	
	$("#btnSearch").on("click", function(){
		document.noticeForm.noticeSeq.value = "";
		document.noticeForm.searchValue.value = $("#_searchValue").val();
		document.noticeForm.curPage.value = "1";
		document.noticeForm.action = "/board/notice";
		document.noticeForm.submit();
	});
});

function fn_noticeDetail(noticeSeq)
{
	document.noticeForm.noticeSeq.value = noticeSeq;
	document.noticeForm.action = "/board/noticeDetail";
	document.noticeForm.submit();
}

function fn_noticeList(curPage)
{
	document.noticeForm.noticeSeq.value = "";
	document.noticeForm.curPage.value = curPage;
	document.noticeForm.action = "/board/notice";
	document.noticeForm.submit();
}

</script>

<body>
<%@ include file="/WEB-INF/views/include/navigation.jsp" %>
<!-- Breadcrumb Begin -->
<div class="breadcrumb-option">
    <div class="container">
        <div class="row">
            <div class="col-lg-12">
                <div class="breadcrumb__links">
                    <a href="/index"><i class="fa fa-home"></i> Home</a>
                    <span>공지사항</span>
                </div>
            </div>
        </div>
    </div>
</div>
<!-- Breadcrumb End -->

<div id="notice" style="min-height: 640px; width: 60%; margin: 0 auto; padding-top: 38px;">
	<div class="space-adaptive"></div>
	<section class="notice_search">
		<form onSubmit="return false;">
			<div class="search-wrap">
				<input type="text" id="_searchValue" class="search_input" placeholder="검색어를 입력해주세요">
				<button type="button" id="btnSearch" class="search_btn">검색</button>
			</div>
		</form>
	</section>
 	<!--div class="notice_menu">
		<button onclick="location.href='/board/notice'">egame</button>
		<button onclick="location.href='/board/notice'">특집</button>
		<button onclick="location.href='/board/notice'">이벤트</button>
	</div-->
	<div class="space-adaptive"></div>
	<section class="notice_list">
		<table>
			<thead>
			<tr>
				<th scope="col" class="th-num">번호</th>
				<th scope="col" class="th-title">제목</th>
				<th scope="col" class="th-writer">작성자</th>
				<th scope="col" class="th-date">등록일</th>
			</tr>
			</thead>
			<tbody>
		<c:if test="${!empty list}">
			<c:forEach var="notice" items="${list}" varStatus="status">
				<tr href="javascript:void(0)" onclick="fn_noticeDetail(${notice.noticeSeq})" class="notice_list">
					<td>${notice.noticeSeq}</td>
					<th><c:out value="${notice.noticeTitle}" /></th>
					<td>관리자</td>
					<td>${notice.noticeRegDate}</td>
				</tr>
			</c:forEach>
		</c:if>
			</tbody>
		</table>
	</section>
	<div class="space-adaptive"></div>
		
	<section class="notice_bottom" style="margin-bottom: 48px;">
		<div class="notice_page">
			<c:if test="${!empty paging}">
				<c:if test="${paging.prevBlockPage gt 0}">
					<a href="javascript:void(0)" class="page_link" onclick="fn_noticeList(${paging.prevBlockPage})">이전</a>
				</c:if>
				<c:forEach var="i" begin="${paging.startPage}" end="${paging.endPage}">
					<c:choose>
						<c:when test="${i ne curPage}">
							<a href="javascript:void(0)" class="page_link" onclick="fn_noticeList(${i})">${i}</a>
						</c:when>
						<c:otherwise>
							<a href="javascript:void(0)" class="page_link_cur">${i}</a>
						</c:otherwise>
					</c:choose>
				</c:forEach>
				<c:if test="${paging.nextBlockPage gt 0}">
					<a href="javascript:void(0)" class="page_link" onclick="fn_noticeList(${paging.nextBlockPage})">다음</a>
				</c:if>
			</c:if>
			
			<form name="noticeForm" id="noticeForm" method="post">
				<input type="hidden" name="noticeSeq" value="" />
				<input type="hidden" name="searchValue" value="${searchValue}" />
				<input type="hidden" name="curPage" value="${curPage}" />
			</form>
		</div>
		
	</section>
	<div class="space-adaptive">
		<c:if test="${!empty cookieUserId && cookieUserId eq 'test'}">
		<button type="button" id="btnWrite" class="notice_write_btn">글쓰기</button>
		</c:if>
	</div>
	<div class="space-adaptive"></div>
</div>
<%@ include file="/WEB-INF/views/include/footer.jsp" %>
	
</body>
</html>