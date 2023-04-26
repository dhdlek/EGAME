<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>

<!DOCTYPE html>
<html lang="ko">

<head>
    <meta charset="UTF-8">
    <meta name="description" content="Game Template">
    <meta name="keywords" content="Game, unica, creative, html">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <title>Store eGame : 신고 리스트</title>

    <!-- Google Font -->
    <link href="https://fonts.googleapis.com/css2?family=Oswald:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Mulish:wght@300;400;500;600;700;800;900&display=swap" rel="stylesheet">

    <!-- Css Styles -->
    <link rel="stylesheet" href="/resources/css/bootstrap.min.css" type="text/css">
    <link rel="stylesheet" href="/resources/css/style.css" type="text/css">
    <link rel="stylesheet" href="/resources/css/elegant-icons.css" type="text/css">
    <link rel="stylesheet" href="/resources/css/report-list.css" type="text/css">
    <link rel="stylesheet" href="/resources/css/navigation.css" type="text/css" />

    <!-- Js -->
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
    
    <script>
    $(document).ready(function(){
    	$("#searchValue").keyup(function(event)
    	{
    		var c =  event.keyCode || event.which;
    		if(c===13)
            {
                $("#btnSearch").click();
            }
        });
    	
    	$.load = function(){
    		if($("#searchPr").val() == '전체')
   			{
    			$('[name="sub_select"]').html("<option></option>");
   			}
	    	if($("#searchPr").val() == '상품')
	        {
	            $('[name="sub_select"]').html("<option value='전체' <c:if test="${report.reportPR eq 'P'}">selected</c:if>>전체</option><option value='저작권위반' <c:if test="${searchTag eq '저작권위반'}">selected</c:if>>저작권위반</option><option value='아동학대' <c:if test="${searchTag eq '아동학대'}">selected</c:if>>아동학대</option><option value='법률위반' <c:if test="${searchTag eq '법률위반'}">selected</c:if>>법률위반</option><option value='악성코드' <c:if test="${searchTag eq '악성코드'}">selected</c:if>>악성코드</option><option value='사기' <c:if test="${searchTag eq '사기'}">selected</c:if>>사기</option><option value='카테고리' <c:if test="${searchTag eq '카테고리'}">selected</c:if>>카테고리</option><option value='기타' <c:if test="${searchTag eq '기타'}">selected</c:if>>기타</option>");
	        }
	        if($("#searchPr").val() == '리뷰')
	        {
	            $('[name="sub_select"]').html("<option value='전체' <c:if test="${report.reportPR eq 'R'}">selected</c:if>>전체</option><option value='홍보글' <c:if test="${searchTag eq '홍보글'}">selected</c:if>>홍보글</option><option value='음란성' <c:if test="${searchTag eq '음란성'}">selected</c:if>>음란성</option><option value='혐오' <c:if test="${searchTag eq '혐오'}">selected</c:if>>혐오</option>");
	        }
    	}
    	
    	$.load();
    	
    	$("#searchPr").change(function(){
            $.load();
        });
    	
    	$("#btnSearch").on("click", function(){
    		document.reportListForm.reportSeq.value = "";
    		document.reportListForm.searchPr.value = $("#searchPr option:selected").val();
    		document.reportListForm.searchTag.value = $("#searchTag option:selected").val();
    		document.reportListForm.searchValueOption.value = $("#searchValueOption option:selected").val();
    		document.reportListForm.searchValue.value = $("#searchValue").val();
    		document.reportListForm.curPage.value = "1";
    		document.reportListForm.action = "/board/reportList";
    		document.reportListForm.submit();
    	});
    });

    function fn_reportDetail(reportSeq)
    {
    	document.reportListForm.reportSeq.value = reportSeq;
    	document.reportListForm.action = "/board/reportDetail";
    	document.reportListForm.submit();
    }

    function fn_reportList(curPage)
    {
    	document.reportListForm.reportSeq.value = "";
    	document.reportListForm.curPage.value = curPage;
    	document.reportListForm.action = "/board/reportList";
    	document.reportListForm.submit();
    }
    </script>
</head>

<body>
<%@ include file="/WEB-INF/views/include/navigationAdmin.jsp" %>

<section class="report_list_section">
    <div class="space-adpative"></div>
    <h2>신고 현황</h2>
    <div class="space-adpative"></div>
    <div class="report_search">
        <form onSubmit="return false;">
            <select class="report_pr" id="searchPr">
                <option selected disabled hidden></option>
                <option value="전체" <c:if test="${searchPr ne ''}">selected</c:if>>전체</option>
                <option value="상품" <c:if test="${searchPr eq 'P'}">selected</c:if>>상품</option>
                <option value="리뷰" <c:if test="${searchPr eq 'R'}">selected</c:if>>리뷰</option>
            </select>
            <select id="searchTag" class="report_tag" name="sub_select">
            </select>
            <select id="searchValueOption" class="report_searchvalue_option">
            	<option selected disabled hidden></option>
                <option <c:if test="${searchValueOption eq '아이디'}">selected</c:if>>아이디</option>
                <option <c:if test="${searchValueOption eq '내용'}">selected</c:if>>내용</option>
            </select>
                <input class="report_search_textbox" id="searchValue" value="${searchValue}" placeholder="아이디 혹은 내용 입력">
                <button type="button" id="btnSearch" class="report_search_btn">검색</button>
        </form>
    </div>
    <div class="space-adpative"></div>
    <table class="report_list_table">
        <thead>
            <tr>
                <th class="th-num" style="width: 2%">번호</th>
                <th class="th-pr" style="width: 3%">신고구분</th>
                <th class="th-tag" style="width: 3%">신고태그</th>
                <th class="th-pnum" style="width: 3%">상품번호</th>
                <th class="th-rnum" style="width: 3%">리뷰번호</th>
                <th class="th-id" style="width: 6%">신고자아이디</th>
                <th class="th-date" style="width: 3%">신고날짜</th>
                <th class="th-status" style="width: 3%">처리상태</th>
            </tr>
        </thead>
        <tbody>
	<c:if test= "${!empty list}">
		<c:forEach var="report" items="${list}" varStatus="status">
            <tr href="javascript:void(0)" onclick="fn_reportDetail(${report.reportSeq})">
                <td><c:out value="${report.reportSeq}" /></td>
                <td>
                	<c:if test="${report.reportPr eq 'P'}">상품</c:if>
                	<c:if test="${report.reportPr eq 'R'}">리뷰</c:if>
               	</td>
                <td><c:out value="${report.reportTag}" /></td>
                <td>
                	<c:if test="${report.productSeq ne 0}"><c:out value="${report.productSeq}" /></c:if>
                	<c:if test="${report.productSeq eq 0}">-</c:if>
               	</td>
                <td>
                	<c:if test="${report.reviewSeq ne 0}"><c:out value="${report.reviewSeq}" /></c:if>
                	<c:if test="${report.reviewSeq eq 0}">-</c:if>
                </td>
                <td><c:out value="${report.userId}" /></td>
                <td><c:out value="${report.reportRegDate}" /></td>
                <td><c:if test='${report.reportStatus eq "N"}'><c:out value="미처리" /></c:if>
            		<c:if test='${report.reportStatus eq "Y"}'><c:out value="처리완료" /></c:if>
				</td>
            </tr>
	    </c:forEach>
	</c:if>
        </tbody>
    </table>
</section>
<div class="space-adpative"></div>

<section class="reportList_bottom">
	<div class="reportList_page">
		<c:if test="${!empty paging}">
			<c:if test="${paging.prevBlockPage gt 0}">
				<a href="javascript:void(0)" class="page_link" onclick="fn_reportList(${paging.prevBlockPage})">이전</a>
			</c:if>
			<c:forEach var="i" begin="${paging.startPage}" end="${paging.endPage}">
				<c:choose>
					<c:when test="${i ne curPage}">
						<a href="javascript:void(0)" class="page_link" onclick="fn_reportList(${i})">${i}</a>
					</c:when>
					<c:otherwise>
						<a href="javascript:void(0)" class="page_link_cur">${i}</a>
					</c:otherwise>
				</c:choose>
			</c:forEach>
			<c:if test="${paging.nextBlockPage gt 0}">
				<a href="javascript:void(0)" class="page_link" onclick="fn_reportList(${paging.nextBlockPage})">다음</a>
			</c:if>
		</c:if>
		
		<form name="reportListForm" id="reportListForm" method="post">
			<input type="hidden" id="reportSeq" name="reportSeq" value="" />
			<input type="hidden" id="searchPr" name="searchPr" value="${searchPr}" />
			<input type="hidden" id="searchTag" name="searchTag" value="${searchTag}" />
			<input type="hidden" id="searchValueOption" name="searchValueOption" value="${searchValueOption}" />
			<input type="hidden" id="searchValue" name="searchValue" value="${searchValue}" />
			<input type="hidden" id="curPage" name="curPage" value="${curPage}" />
		</form>
	</div>
</section>
<div class="space-adpative"></div>
<%@ include file="/WEB-INF/views/include/footerReport.jsp" %>
</body>
</html>