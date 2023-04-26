<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<!DOCTYPE html>
<html>
<head>
<script type="text/javascript" src="/resources/js/jquery-3.5.1.min.js"></script>
<script type="text/javascript" src="/resources/js/icia.common.js"></script>
<script type="text/javascript" src="/resources/js/icia.ajax.js"></script>
<script type="text/javascript">
function kakaoPayResult(pgToken)
{
	$("#pgToken").val(pgToken);
    
    document.kakaoForm.action = "/kakao/payResult";
    document.kakaoForm.submit();
}
</script>
</head>
<body>
<iframe width="100%," height="650" src="${pcUrl}" frameborder="0" allowfullscreen=""></iframe>
<form name="kakaoForm" id="kakaoForm" method="post">
	<input type="hidden" name="orderId" id="orderId" value="${orderId}" />
	<input type="hidden" name="tId" id="tId" value="${tId}" />
	<input type="hidden" name="userId" id="userId" value="${userId}" />
	<input type="hidden" name="pgToken" id="pgToken" value="" />
</form>
</body>
</html>