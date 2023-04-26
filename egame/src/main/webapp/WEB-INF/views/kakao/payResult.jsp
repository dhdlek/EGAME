<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<!DOCTYPE html>
<html>
<head>
<script type="text/javascript" src="/resources/js/jquery-3.5.1.min.js"></script>
<script type="text/javascript" src="/resources/js/icia.common.js"></script>
<script type="text/javascript" src="/resources/js/icia.ajax.js"></script>
<script type="text/javascript">
$(document).ready(function() {
	
	$.ajax({
		type:"POST",
		url:"/pointCharge",
		data:{
			payPrice: $("#payPrice").val()
		},
		datatype:"JSON",
		beforeSend:function(xhr){
			xhr.setRequestHeader("AJAX", "true");
		},
		success:function(response)
		{
			if(response.code == 0)
			{
				opener.location.href="/user/myPage";
				window.close();
			}
			else if(response.code == -1)
			{
				alert("로그인이 필요합니다.");
				opener.location.href="/user/login";
			}
			else if(response.code == 400)
			{
				alert("파라미터 값이 올바르지 않습니다.");	
			}
			else if(response.code == 401)
			{
				alert("정지된 아이디입니다.");
			}
			else if(response.code == 500)
			{
				alert("결제 중 오류가 발생하였습니다. 500");
			}
			else
			{
				alert("결제 중 오류가 발생하였습니다.");
			}
		},
		error:function(xhr, status, error)
		{
			game.common.error(error);
		}
	});
	
	$("#btnClose").on("click", function() {
		window.close();
	});
});
</script>
</head>
<body>
<input type="hidden" name="payPrice" id="payPrice" value="${kakaoPayApprove.amount.total}" />
<!-- div class="container">
<c:choose>
	<c:when test="${!empty kakaoPayApprove}">
		<h2>카카오페이 결제가 정상적으로 완료되었습니다.</h2>
			결제일시: ${kakaoPayApprove.approved_at}<br/>
			주문번호: ${kakaoPayApprove.partner_order_id}<br/>
			상품명  : ${kakaoPayApprove.item_name}<br/>
			상품수량: <fmt:formatNumber value="${kakaoPayApprove.quantity}" pattern="#,###"/><br/>
			결제금액: <fmt:formatNumber value="${kakaoPayApprove.amount.total}" pattern="#,###"/><br/>
			결제방법: ${kakaoPayApprove.payment_method_type}<br/>
		<input type="hidden" name="payPrice" id="payPrice" value="${kakaoPayApprove.amount.total}" />
	</c:when>
	<c:otherwise>
		<h2>카카오페이 결제중 오류가 발생하였습니다.</h2>
	</c:otherwise>
</c:choose>
</div>
<button id="btnClose" type="button">닫기</button -->
</body>
</html>