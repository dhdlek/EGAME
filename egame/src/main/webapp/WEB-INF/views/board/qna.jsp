<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>

<!DOCTYPE html>
<html>
<head>
<%@ include file="/WEB-INF/views/include/head.jsp" %>
<title>Store eGame : 문의</title>
<link rel="stylesheet" href="/resources/css/qna.css" type="text/css">
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
		document.qnaForm.qnaSeq.value = "";
		document.qnaForm.action = "/board/qnaRegForm";
		document.qnaForm.submit();
	});
	
	$("#btnSearch").on("click", function(){
		document.qnaForm.qnaSeq.value = "";
		document.qnaForm.searchValue.value = $("#_searchValue").val();
		document.qnaForm.curPage.value = "1";
		document.qnaForm.action = "/board/qna";
		document.qnaForm.submit();
	});
});

function fn_qnaDetail(qnaSeq)
{
	document.qnaForm.qnaSeq.value = qnaSeq;
	document.qnaForm.action = "/board/qnaDetail";
	document.qnaForm.submit();
}

function fn_qnaList(curPage)
{
	document.qnaForm.qnaSeq.value = "";
	document.qnaForm.curPage.value = curPage;
	document.qnaForm.action = "/board/qna";
	document.qnaForm.submit();
}

</script>
</head>

<body>
<%@ include file="/WEB-INF/views/include/navigation.jsp" %>
<!-- Breadcrumb Begin -->
<div class="breadcrumb-option">
    <div class="container">
        <div class="row">
            <div class="col-lg-12">
                <div class="breadcrumb__links">
                    <a href="/index"><i class="fa fa-home"></i> Home</a>
                    <span>문의</span>
                </div>
            </div>
        </div>
    </div>
</div>
<!-- Breadcrumb End -->

<div id="qna" style="min-height: 640px; width: 60%; margin: 0 auto; padding-top: 38px;">
	<div class="space-adaptive"></div>
	<section class="qna_search">
		<form onSubmit="return false;">
			<div class="search-wrap">
				<input type="text" id="_searchValue" class="search_input" value="${searchValue}" placeholder="검색어를 입력해주세요">
				<button type="button" id="btnSearch" class="search_btn">검색</button>
			</div>
		</form>
	</section>
	<div class="space-adaptive"></div>
	<section class="qna_list">
		<table>
			<thead>
			<tr>
				<th scope="col" class="th-num">번호</th>
				<th scope="col" class="th-title">제목</th>
				<th scope="col" class="th-writer">작성자</th>
				<th scope="col" class="th-date">등록일</th>
				<th scope="col" class="th-status">처리상태</th>
			</tr>
			</thead>
			<tbody>
	<c:choose>		
		<c:when test="${!empty list}">
			<c:forEach var="qna" items="${list}" varStatus="status">
				<tr href="javascript:void(0)" onclick="fn_qnaDetail(${qna.qnaSeq})">
					<td><c:out value="${qna.qnaSeq}" /></td>
					<th><c:out value="${qna.qnaTitle}" /></th>
					<td><c:out value="${qna.userId}" /></td>
					<td><c:out value="${qna.qnaRegDate}" /></td>
					<td><c:out value="${qna.qnaStatus}" /></td>
				</tr>
			</c:forEach>
		</c:when>
		<c:otherwise>
			<tr>
				<td colspan="5"><h2 style="color: #ffffff; text-align: center; font-weight: 700">문의내역이 없습니다.</h2></td>
			</tr>
		</c:otherwise>
	</c:choose>	
			</tbody>
		</table>
	</section>
	<div class="space-adaptive">
	</div>
		
	<section class="qna_bottom">
		<div class="qna_page">
			<c:if test="${!empty paging}">
				<c:if test="${paging.prevBlockPage gt 0}">
					<a href="javascript:void(0)" class="page_link" onclick="fn_qnaList(${paging.prevBlockPage})">이전</a>
				</c:if>
				<c:forEach var="i" begin="${paging.startPage}" end="${paging.endPage}">
					<c:choose>
						<c:when test="${i ne curPage}">
							<a href="javascript:void(0)" class="page_link" onclick="fn_qnaList(${i})">${i}</a>
						</c:when>
						<c:otherwise>
							<a href="javascript:void(0)" class="page_link_cur">${i}</a>
						</c:otherwise>
					</c:choose>
				</c:forEach>
				<c:if test="${paging.nextBlockPage gt 0}">
					<a href="javascript:void(0)" class="page_link" onclick="fn_qnaList(${paging.nextBlockPage})">다음</a>
				</c:if>
			</c:if>
			
			<form name="qnaForm" id="qnaForm" method="post">
				<input type="hidden" name="qnaSeq" value="" />
				<input type="hidden" name="searchValue" value="${searchValue}" />
				<input type="hidden" name="curPage" value="${curPage}" />
			</form>
		<button type="button" id="btnWrite" class="qna_write_btn">글쓰기</button>
		</div>
		
	</section>
	<div class="space-adaptive">
	</div>
	<div class="space-adaptive"></div>
</div>
<%@ include file="/WEB-INF/views/include/footer.jsp" %>	
</body>
</html>