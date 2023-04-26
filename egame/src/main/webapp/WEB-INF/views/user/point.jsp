<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>

<!DOCTYPE html>
<html lang="ko">

<head>
<%@ include file="/WEB-INF/views/include/head.jsp" %>
<link rel="stylesheet" href="/resources/css/point.css" type="text/css">
<title>Store eGame : 포인트 내역</title>
<script type="text/javascript" src="/resources/js/jquery-3.5.1.min.js"></script>
<script>
//페이지 이동 함수
function fn_list(curPage)
{
	document.pointForm.curPage.value = curPage;
	document.pointForm.action = "/user/point";
	document.pointForm.submit();
}

//디테일 페이지 이동 함수
function fn_detail(product_seq)
{
  var popup = window.open(`/storeDetail?productSeq=${"${product_seq}"}`, "_blank", 'width=1000, height=1200, scrollbars=yes, resizable =no')
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
                    <a href="/user/myPage">마이페이지</a>
                    <span>포인트 내역</span>
                </div>
            </div>
        </div>
    </div>
</div>
<!-- Breadcrumb End -->

<!-- 포인트 내역 -->
<c:choose>
	<c:when test="${!empty list}">
	<div id="point" style="min-height: 540px; width: 60%; margin: 0 auto; margin-top: 50px; margin-bottom: 70px;">
	<table class="point_table">
		<thead>
			<tr>
	            <th style="width: 44%;">상품 정보</th>
	            <th style="width: 15%;">포인트 내역</th>
	            <th style="width: 15%;">보유 포인트</th>
	            <th style="width: 13%;">구매/환불</th>
	            <th style="width: 13%;">내역 날짜</th>
		    </tr>
		</thead>
		<tbody id="tbody">
			<c:forEach var="point" items="${list}" varStatus="status">
		    	<tr>
		    <c:choose>
		    	<c:when test="${!empty point.productName}">
			    	<td class="point_table_td1" style="text-align: center; padding-top: 18px; padding-bottom: 18px;">
			        	<a href="javascript:void(0)" onclick="fn_detail(${point.productSeq})">
			            ${point.productName}
			            </a>
			        </td>
		        </c:when>
		        <c:otherwise>
			    	<td class="point_table_td1" style="text-align: center; padding-top: 18px; padding-bottom: 18px;">
			        	<a href="javascript:void(0)" style="cursor:default;">포인트 충전</a>
			        </td>
		        </c:otherwise>
			</c:choose>
			<c:choose>
				<c:when test="${point.pointStatus eq 'Y'}">
			    	<td class="point_table_td2">
			        	<span>+ <fmt:formatNumber value="${point.pointVar}" pattern="#,###"/></span>
			        </td>
		        </c:when>
		        <c:when test="${point.pointStatus eq 'N'}">
			    	<td class="point_table_td2">
			        	<span>- <fmt:formatNumber value="${point.pointVar}" pattern="#,###"/></span>
			        </td>
		        </c:when>
			</c:choose>
			        <td class="point_table_td2">
			        	<span>₩<fmt:formatNumber value="${point.pointPos}" pattern="#,###"/></span>
			        </td>
			<c:choose>
				<c:when test="${point.pointStatus eq 'N'}">
			        <td class="point_table_td2">
			        	<span>구매</span>
			        </td>
			        <td class="point_table_td2">
			        	<span>${point.pointDate}</span>
			        </td>
		        </c:when>
		        <c:when test="${point.payStatus eq 0}">
			    	<td class="point_table_td2">
			    		<span>환불</span>
			    	</td>
			    	<td class="point_table_td2">
			    		<span>${point.pointDate}</span>
			    	</td>
		        </c:when>
		        <c:when test="${point.payMethod eq 'c'}">
	               	<td class="point_table_td2">
	                    <span>충전</span>
	                </td>
	                <td class="point_table_td2">
	                    <span>${point.pointDate}</span>
	                </td>
		        </c:when>
			</c:choose>
		        </tr>
			</c:forEach> 
		</tbody>
	</table>

	<div class="point_page">
	<c:if test="${!empty paging}">
		<c:if test="${paging.prevBlockPage gt 0}">
	        <a href="javascript:void(0)" class="page_link" onclick="fn_list(${paging.prevBlockPage})">이전</a>
	    </c:if>
	    <c:forEach var="i" begin="${paging.startPage}" end="${paging.endPage}">
	    	<c:choose>
	    		<c:when test="${i ne curPage}">
	        		<a href="javascript:void(0)" class="page_link" onclick="fn_list(${i})">${i}</a>
	        	</c:when>
	        	<c:otherwise>
					<a href="javascript:void(0)" class="page_link pagination_curPage" style="cursor:default;">${i}</a>
				</c:otherwise>
			</c:choose>
		</c:forEach>
		<c:if test="${paging.nextBlockPage gt 0}">
	        <a href="javascript:void(0)" class="page_link" onclick="fn_list(${paging.nextBlockPage})">다음</a>
	    </c:if>    
	</c:if>
	    </div>
	    
	    <form name="pointForm" id="pointForm" method="post">
			<input type="hidden" id="curPage" name="curPage" value="${curPage}" />
		</form>
		
	</div>
	</c:when>
	<c:otherwise>
		<div id="point" style="min-height: 473px; width: 60%; margin: 0 auto; margin-top: 50px; margin-bottom: 70px;">
			<h2 style="color: #ffffff; font-weight: 700; margin-top: 100px; margin-bottom: 50px; text-align: center;">포인트 내역이 없습니다.</h2>
		</div>
	</c:otherwise>
</c:choose>

<%@ include file="/WEB-INF/views/include/footer.jsp" %>
</body>
</html>