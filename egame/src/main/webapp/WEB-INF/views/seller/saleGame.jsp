<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<!DOCTYPE html>
<html lang="ko">

<head>
<%@ include file="/WEB-INF/views/include/head.jsp" %>
<link rel="stylesheet" href="/resources/css/library.css" type="text/css">
<title>Store eGame : 판매게임</title>
<script type="text/javascript" src="/resources/js/jquery-3.5.1.min.js"></script>
<script>
$(document).ready(function(){
	$.ajax({
		
	});
});
//페이지 이동 함수
function fn_list(curPage)
{
	document.libraryForm.curPage.value = curPage;
	document.libraryForm.action = "/seller/saleGame";
	document.libraryForm.submit();
}

//디테일 페이지 이동 함수
function fn_detail(product_seq)
{
  var popup = window.open(`/storeDetail?productSeq=${"${product_seq}"}`, "_blank", 'width=1000, height=1200, scrollbars=yes, resizable =no')
}

//상품 판매정지 -> 일단 스테이터스를 'N'으로 처리
function fn_waitStatusPrd(productSeq)
{
	if(confirm("판매정지 하시겠습니까?") == true)
	{
		$.ajax({
			type:"POST",
			url:"/saleGame/waitStatusPrd",
			data:{
				productSeq: productSeq
			},
			dataType:"JSON",
			beforeSend:function(xhr){
				xhr.setRequestHeader("AJAX", "true");
			},
			success:function(response){
				if(response.code == 0)
				{
					alert("판매정지되었습니다.");
					location.reload();
				}
				else if(response.code == -1)
				{
					alert("로그인이 필요합니다.");
					location.href = "/user/login"
				}
				else if(response.code == 400)
				{
					alert("파라미터 값이 올바르지 않습니다.");
				}
				else if(response.code == 401)
				{
					alert("정지된 아이디 입니다.");
				}
				else if(response.code == 404)
				{
					alert("목록을 찾을 수 없습니다.");
				}
				else if(response.code == 500)
				{
					alert("판매정지 중 오류가 발생하였습니다. 500");
				}
				else
				{
					alert("판매정지 중 오류가 발생하였습니다.");
				}
			},
			error:function(xhr, status, error){
				icia.common.error(error);
			}
		});
	}
}

function fn_saleDetail()
{
	location.href = "/seller/saleDetail";
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
                    <span>판매게임</span>
                </div>
            </div>
        </div>
    </div>
</div>
<!-- Breadcrumb End -->

<!-- 보유게임 -->
<div id="library" style="min-height: 540px; width: 60%; margin: 0 auto; margin-top: 50px; margin-bottom: 50px;">
    <table class="library_table">
        <thead>
            <tr>
                <th style="width: 50%;">상품정보</th>                
                <th style="width: 12%;">판매수</th>
                <th style="width: 26%;">총 매출액</th>
                <th style="width: 12%;">승인여부</th>
                <!-- th style="width: 15%;">정지요청</th --> 
            </tr>
        </thead>
        <tbody id="tbody">
     
	<c:if test="${!empty list}">
		<c:forEach var="product" items="${list}" varStatus="status">
            <tr>                        
                <c:choose>
		        	<c:when test="${pay.productStatus eq 'Y'.charAt(0)}">
		                <td class="library_table_td1" style="padding-left: 15px;">
		                    <a href="javascript:void(0)" onclick="fn_detail(${product.productSeq})">
		                    <img src="/resources/img_gamemain/${product.productName}.jpg" width="155px" height="100px">
		                    &nbsp;&nbsp;${product.productName}
		                    </a>
		                </td>
		        	</c:when>
		            <c:when test="${pay.productStatus eq 'S'.charAt(0)}">
		                	<td class="library_table_td1" style="padding-left: 15px;">
		                    <img src="/resources/img_gamemain/${product.productName}.jpg" width="155px" height="100px">
		                    &nbsp;&nbsp;<strike>${product.productName}</strike>
		                    <span style="color: #e53637;">정지된 상품입니다.</span>
		                </td>
		            </c:when>
		            <c:otherwise>
		            	<td class="library_table_td1" style="padding-left: 15px;">
		                    <img src="/resources/img_gamemain/${product.productName}.jpg" width="155px" height="100px">
		                    &nbsp;&nbsp;${product.productName}
		                </td>
		            </c:otherwise>
		        </c:choose>
                <td class="library_table_td2">
                    <span>${product.productBuyCnt}</span>
                </td>
                <td class="library_table_td2">
                    <span>₩<fmt:formatNumber value="${product.amount}" pattern="#,###"/></span>
                </td>
		<c:choose>
			<c:when test="${product.productStatus eq 'Y'.charAt(0)}">
                <td class="library_table_td2">
                	<span>판매중</span>
                </td>
            </c:when>
            <c:when test="${product.productStatus eq 'S'.charAt(0)}">
            	<td class="library_table_td2">
                	<span style="color: #e53637">판매정지</span>
                </td>
            </c:when>
            <c:otherwise>
                <td class="library_table_td2">
                	<span>승인대기중</span>
                </td>
            </c:otherwise>
        </c:choose>    
				<!-- td class="library_table_td2" style="padding-top: 18px; padding-bottom: 18px;">
                    <button class="site-btn" onclick="fn_waitStatusPrd(${product.productSeq})">판매정지</button>
                </td -->
            </tr>
		</c:forEach>
	</c:if>

		</tbody>
    </table>
    <button class="site-btn" onclick="fn_saleDetail()" style="float: right; margin-top: 30px; margin-right: 24px;">판매내역</button>
    <div class="library_page" style="margin-bottom: 100px; margin-top: 20px; padding-left: 160px;">
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
    
    <form name="libraryForm" id="libraryForm" method="post">
		<input type="hidden" id="curPage" name="curPage" value="${curPage}" />
	</form>
</div>

<%@ include file="/WEB-INF/views/include/footer.jsp" %>
</body>
</html>