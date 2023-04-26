<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/WEB-INF/views/include/head.jsp" %>
<link rel="stylesheet" href="/resources/css/kakaoPay.css" type="text/css">
<script type="text/javascript" src="/resources/js/jquery-3.5.1.min.js"></script>
<script type="text/javascript">
$(document).ready(function() {
    
	$("#btnPay").on("click", function() {
		
		$("#btnPay").prop("disabled", true);
		
		if($.trim($("#totalAmount").val()).length <= 0)
		{
			alert("금액을 입력하세요.");
			$("#totalAmount").val("");
			$("#totalAmount").focus();
			
			$("#btnPay").prop("disabled", false);
			
			return;
		}
		
		if(!icia.common.isNumber($("#totalAmount").val()))
		{
			alert("금액은 숫자만 입력 가능합니다.");
			
			$("#totalAmount").val("");
			$("#totalAmount").focus();
			
			$("#btnPay").prop("disabled", false);
			
			return;
		}
		
		icia.ajax.post({
	        url: "/kakao/payReady",
	        data: {itemCode:$("#itemCode").val(), itemName:$("#itemName").val(), quantity:$("#quantity").val(), totalAmount:$("#totalAmount").val()},
	        success: function (response) 
	        {
	        	icia.common.log(response);
	        	
	        	if(response.code == 0)
	        	{
	        		var orderId = response.data.orderId;
	        		var tId = response.data.tId;
	        		var pcUrl = response.data.pcUrl;
	        		
	        		$("#orderId").val(orderId);
	        		$("#tId").val(tId);
	        		$("#pcUrl").val(pcUrl);
	        		
	        		var win = window.open('', 'kakaoPopUp', 'toolbar=no,location=no,status=no,menubar=no,scrollbars=yes,resizable=no,width=540,height=700,left=100,top=100');
	        		
	        		$("#kakaoForm").submit();
	        		
	        		$("#btnPay").prop("disabled", false);
	        	}
	        	else
	        	{
	        		alert("오류가 발생하였습니다.");
	        		$("#btnPay").prop("disabled", false);
	        	}
	        },
	        error: function (error) 
	        {
	        	icia.common.error(error);
	        	
        		$("#btnPay").prop("disabled", false);
	        }
	    });
	});
});

function movePage()
{
	location.href = "/user/myPage";
}
</script>
<style>
	.payForm {
		width: 200px;
	}
</style>
</head>
<body>
<%@ include file="/WEB-INF/views/include/navigation.jsp" %>

<!-- Signup Section Begin -->
<div class="container" style="min-height: 700px;">
	<div class="kakaoPay">
		<form class="payForm" name="payForm" id="payForm" method="post" style="color: #ffffff;">
			<input type="hidden" name="itemCode" id="itemCode" class="form-control mb-2" maxlength="32" placeholder="결제코드" value="1" readonly />
			<input type="hidden" name="itemName" id="itemName" maxlength="50" class="form-control" placeholder="상품명" value="포인트 충전" readonly /><br />
			<input type="hidden" name="quantity" id="quantity" maxlength="3" class="form-control mb-2" placeholder="수량" value="1" readonly />
			충전 금액<input type="text" name="totalAmount" id="totalAmount" maxlength="10" class="form-control mb-2" placeholder="금액을 입력하세요." value="" /><br />
			<div class="form-group row">
				<div class="col-sm-12">
					<button type="button" id="btnPay" class="btn btn-primary" title="카카오페이" style="text-align: center;">카카오페이</button>
				</div>
			</div>
		</form>
		
		<form name="kakaoForm" id="kakaoForm" method="post" target="kakaoPopUp" action="/kakao/payPopUp">
			<input type="hidden" name="orderId" id="orderId" value="" />
			<input type="hidden" name="tId" id="tId" value="" />
			<input type="hidden" name="pcUrl" id="pcUrl" value="" />
		</form>
	</div>
</div>

<!-- Footer Section Begin -->
<footer class="footer">
  <div class="container">
    <div class="row">
      <div class="col-lg-3">
        <div class="footer__logo">
          <a href="/index"><img src="/resources/icon/logo.png" alt="" /></a>
        </div>
      </div>
      <div class="col-lg-6">
        <div class="footer__nav">
          <ul>
            <li class="active"><a href="#">이용약관</a></li>
            <li><a href="#">개인정보처리방침</a></li>
            <li><a href="#">스토어 환불 정책</a></li>
          </ul>
        </div>
      </div>
      <div class="col-lg-3">
        <p>
          <!-- Link back to Colorlib can't be removed. Template is licensed under CC BY 3.0. -->
          Copyright &copy;
          <script>
            document.write(new Date().getFullYear());
          </script>
          All rights reserved | This template is made with by game
          <!-- Link back to Colorlib can't be removed. Template is licensed under CC BY 3.0. -->
        </p>
      </div>
    </div>
  </div>
</footer>
<!-- Footer Section End -->

<!-- Js Plugins -->
<script src="/resources/js/bootstrap.min.js"></script>
<script src="/resources/js/player.js"></script>
<script src="/resources/js/jquery.nice-select.min.js"></script>
<script src="/resources/js/mixitup.min.js"></script>
<script src="/resources/js/jquery.slicknav.js"></script>
<script src="/resources/js/owl.carousel.min.js"></script>
<script src="/resources/js/main.js"></script>
<script src="/resources/js/report-form.js"></script>
<script type="text/javascript" src="/resources/js/icia.common.js"></script>
<script type="text/javascript" src="/resources/js/icia.ajax.js"></script>
</body>
</html>