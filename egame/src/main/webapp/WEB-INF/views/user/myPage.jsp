<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>

<!DOCTYPE html>
<html lang="ko">

<head>
<%@ include file="/WEB-INF/views/include/head.jsp" %>
<title>Store eGame : 마이페이지</title>
<style>
	.saleGame a{
		color: #ffba00;
	}
	
	.saleGame a:hover{
		color: #ffffff;
	}
	#mypageBtn {
		display: flex;
		justify-content: space-between;
	}
	#productRegDiv {
		margin-right: 200px;
	}
</style>
<link rel="stylesheet" href="/resources/css/point-load-modal.css" type="text/css">
<script src="https://code.jquery.com/jquery-3.4.1.js"></script>
<script>
function fn_mygame()
{
	location.href = "/user/library";
}

$(document).ready(function() {
	
	$("#productRegBtn").on("click", function(){
		location.href = "/test/productRegForm";
	});
	
	$(".mygame").on("mouseover", function(){
		$(".mygame").css("color", "#0078ff")
	});
	
	$(".mygame").on("mouseleave", function(){
		$("#mygame1").css("color", "#b7b7b7")
		$("#mygame2").css("color", "#ffffff")
	});
	
	$(".sellgame").on("mouseover", function(){
		$(".sellgame").css("color", "#0078ff")
	});
	
	$(".sellgame").on("mouseleave", function(){
		$(".sellgame").css("color", "#ffba00")
	});
	
	var cookieUserId = "<c:out value='${cookieUserId}'/>";	
	
	$("#btnKaKaoPay").on("click", function() {
		
		$("#btnKaKaoPay").prop("disabled", true);
		
		if($.trim($("#totalAmount").val()).length <= 0)
		{
			alert("금액을 입력하세요.");
			$("#totalAmount").val("");
			$("#totalAmount").focus();
			$("#btnKaKaoPay").prop("disabled", false);
			return;
		}
		
		if(!icia.common.isNumber($("#totalAmount").val()))
		{
			alert("금액은 숫자만 입력 가능합니다.");
			$("#totalAmount").val("");
			$("#totalAmount").focus();
			$("#btnKaKaoPay").prop("disabled", false);
			return;
		}
		
		icia.ajax.post({
	        url: "/kakao/payReady",
	        data: {
	        	itemCode:$("#itemCode").val(),
	        	itemName:$("#itemName").val(),
	        	quantity:$("#quantity").val(),
	        	totalAmount:$("#totalAmount").val()
        	},
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
	        		$("#btnKaKaoPay").prop("disabled", false);
	        	}
	        	else
	        	{
	        		alert("오류가 발생하였습니다.");
	        		$("#btnKaKaoPay").prop("disabled", false);
	        	}
	        },
	        error: function (error) 
	        {
	        	icia.common.error(error);
        		$("#btnKaKaoPay").prop("disabled", false);
	        }
	    });
	});
	
	$("#img-update").on("click", function(cookieUserId) {
		$("#img-update").prop("disabled", true);
		var fileInput = document.querySelector("#userFile").value;
		
		if(fileInput == "")
		{
			if(confirm("기본이미지로 변경하시겠습니까?"))		
			{
				fn_updateImg(cookieUserId);				
			}
			else
			{
				$('#popup_box').modal('hide');
			}
		}
		else
		{
			fn_updateImg(cookieUserId);				
		}
		
	});
});

//프로필 변경
function fn_updateImg(cookieUserId)
{
	var form = $("#imgForm")[0];
	var formData = new FormData(form);	
	
	$.ajax({
		type:"POST",
		enctype:"multipart/form-data",
		url:"/user/updateImg",
		data:formData,
		processData:false,
		contentType:false,
		cache:false,
		beforeSend:function(xhr){
			xhr.setRequestHeader("AJAX", "true");
		},
		success:function(response){
			if(response.code == 0)
			{
				alert("프로필 사진이 변경되었습니다.");				
				location.href = "/user/myPage";
			}
			else if(response.code == 1)
			{
				alert("기본이미지로 변경되었습니다.");
				location.href = "/user/myPage";
			}
			else if(response.code == 500)
			{
				alert("프로필 변경 중 오류가 발생하였습니다.");
				$("#img-update").prop("disabled", false);
			}
		},
		error:function(error){
			icia.common.error(error);
			alert("프로필 변경 중 오류가 발생하였습니다.");
			$("#img-update").prop("disabled", false);
		}
	});
	
	//location.reload();
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
                    <span>마이페이지</span>
                </div>
            </div>
        </div>
    </div>
</div>
<!-- Breadcrumb End -->

<!-- Anime Section Begin -->
<section class="anime-details spad" style="min-height: 600px; margin-top: 50px;">
    <div class="container">
        <div class="anime__details__content">
            <div class="row">
                <div class="col-lg-3">
               
                    <div class="anime__details__pic set-bg" data-setbg="/resources/img_userimg/${user.userImg}" style="height: 300px;">	                        
                        <div class="view" style="margin-bottom: -15px;">
                            <a data-toggle="modal" data-target="#popup_box" style="cursor: pointer;">프로필 변경</a>
                        </div>	                            
                    </div>


                    <!-- 프로필변경 팝업창 -->
                    <div class="modal fade" id="popup_box">
                        <div class="modal-dialog">
                            <div class="modal-content">
                                <div class="modal-header">
                                    <p>프로필 변경</p>
                                    <button type="button" class="close" data-dismiss="modal">&times;</button>                                        
                                </div>
                                <form name="imgForm" id="imgForm" method="post" enctype="multipart/form-data">
	                                <div class="modal-body" style="display: flex;">
	                                    <!-- 미리보기 <img src="/resources/img_userimg/프로필이미지.jpg" alt="이미지 없음" style="border: 1px solid gray; width: 80px; height: 90px; color: black;"> -->
	                                    <input type="file" id="userFile" name="userFile" class="form-control mb-2" placeholder="파일을 선택하세요." style="margin-left: 10px;" accept="image/*" required />
	                                </div>
	                                <div class="modal-footer">
	                                	<button type="submit" class="btn btn-default" id="img-update">저장</button>                                       
	                                    <button type="button" class="btn btn-default" data-dismiss="modal">닫기</button>
	                                </div>
                                </form>
                            </div>            
                        </div>
                    </div>
                    
                    <!-- 포인트충전 모달 -->
                    <div class="modal-container" id="modal-container">
	                    <div class="pointLoadModal" id="pointLoadModal">
	                    	<h3>포인트 충전</h3>
	                    	<div class="space-adpative"></div>
	                    	<form class="payForm" name="payForm" id="payForm" method="post" style="color: #ffffff;">
								<input type="hidden" name="itemCode" id="itemCode" maxlength="32" placeholder="결제코드" value="1" readonly="">
								<input type="hidden" name="itemName" id="itemName" maxlength="50" placeholder="상품명" value="포인트 충전" readonly="">
								<div class="pointLoadModal_inputDiv">
									<input type="hidden" name="quantity" id="quantity" maxlength="3" placeholder="수량" value="1" readonly="">
									<span>충전할 금액</span><input type="number" name="totalAmount" id="totalAmount" maxlength="10" placeholder="금액을 입력하세요." value="">
								</div>
								<div class="amountOption_div">
									<div class="amountOption1">+1000</div><div class="amountOption2">+5000</div><div class="amountOption3">+10000</div><div class="amountOption4">+50000</div>
								</div>
								<div class="space-adpative"></div>
								<div class="pointLoadBefore">
									<span>충전 전</span><input type="number" name="pointLoadBefore_input" id="pointLoadBefore_input" value="${user.pointPos}" disabled>
								</div>
								<div class="space-adpative"></div>
								<div class="pointLoadAfter">
									<span>충전 후</span><input type="number" name="pointLoadAfter_input" id="pointLoadAfter_input" value="" disabled>
								</div>
								<div class="space-adpative"></div>
								<div class="pointLoadBtn">
									<button type="button" id="btnKaKaoPay" title="카카오페이" class="btnKaKaoPay">카카오페이 결제하기</button>
									<button type="button" id="btnCancel" class="btnCancel">취소</button>
								</div>
							</form>
							<form name="kakaoForm" id="kakaoForm" method="post" target="kakaoPopUp" action="/kakao/payPopUp">
								<input type="hidden" name="orderId" id="orderId" value="">
								<input type="hidden" name="tId" id="tId" value="">
								<input type="hidden" name="pcUrl" id="pcUrl" value="">
							</form>
	                    </div>
                    </div>
                    
                </div>
                <div class="col-lg-9">
                    <div class="anime__details__text">
                        <div class="anime__details__title">
 
<c:choose> 
    <c:when test="${!empty user.userNickname}">                            
                            <span>${user.userNickname}</span>
	</c:when>
	<c:otherwise>
							<span>${user.userId}</span>
	</c:otherwise>
</c:choose>	                            
                            
                            <span>${user.userEmail}</span>
                        </div>                                                                                                                                                                                                                                                                                                                   

                        <div class="anime__details__widget">
                            <div class="row">
                                <div class="col-lg-6 col-md-6">
                                    <ul>  
                                        <li>
                                        	<span><a href="/user/library" class="mygame" id="mygame1" style="color: #B7B7B7;">보유 게임:</a></span>
                                            <a href="/user/library" class="mygame" id="mygame2" style="color: #ffffff;"> ${countGame}</a>
                                        </li>
                                        <li><span>보유 포인트:</span> ₩<fmt:formatNumber value="${user.pointPos}" pattern="#,###"/></li> 
                                        <li><span>사용 포인트:</span> ₩<fmt:formatNumber value="${expenditure}" pattern="#,###"/></li>
                                        <li><span>장바구니:</span> ${countCart}</li>
                                        <li><span>친구:</span> ${countFriend}</li>
                                    </ul>
                                </div>
                                <div class="col-lg-6 col-md-6">
                                    <ul>
                                    	<c:if test="${user.userClass eq 's'.charAt(0)}">    
                                    		<li class="saleGame">
                                    		<span><a href="/seller/saleGame" class="sellgame">판매 게임:</a></span>
                                            <a href="/seller/saleGame" class="sellgame"> ${countSaleGame}</a>
                                    		</li>                 
                                    		<li><span>총 매출액:</span> ₩<fmt:formatNumber value="${totalAmount}" pattern="#,###"/></li>                                   
										</c:if>
                                        <li><span>문의:</span> ${countQnaReview} / ${countQna}</li>
                                        <li><span>리뷰:</span> ${countReview}</li>
                                        <li><span>신고:</span> ${countCompleteReport} / ${countReport}</li>
                                    </ul>
                                </div>
                            </div>
                        </div>
                        <div id="mypageBtn">
                        <div class="anime__details__btn">
                        	<button type="button" id="pointBtn" class="follow-btn" style="border: none;">포인트 충전</button>
                            <a href="/user/friend" class="watch-btn"><span>친구</span> <i class="fa fa-angle-right"></i></a>                            
                        </div>
                        <c:if test="${user.userClass eq 's'.charAt(0)}">    
                        <div class="anime__details__btn" id="productRegDiv">
                        	<button type="button" id="productRegBtn" class="follow-btn" style="border: none;">상품 등록</button>
                        </div>
                        </c:if>
                        </div>
                    </div>
                </div>
            </div>
        </div>      
    </div>
</section>
<!-- Anime Section End -->
    
<%@ include file="/WEB-INF/views/include/footer.jsp" %>
<script>
	/* 포인트 충전 모달 */
	$(document).ready(function(){
		
		const modal = document.getElementById('modal-container');
		const open = document.getElementById('pointBtn');
		const close = document.getElementById('btnCancel');
		
		//Show modal
		open.addEventListener('click', () => {
			modal.classList.add('show-modal');
			$("#totalAmount").val("");
			$("#pointLoadAfter_input").val("");
		});
		
		//Hide modal
		close.addEventListener('click', () => {
			modal.classList.remove('show-modal');
		});
		
		//Hide modal
		window.addEventListener('click', (e) => {
			e.target === modal ? modal.classList.remove('show-modal') : false
		});
		
		$("#totalAmount").on("propertychange change paste input", function(){
			const totalAmount = parseInt($("#totalAmount").val())
			const before = parseInt($("#pointLoadBefore_input").val())
			
			$("#pointLoadAfter_input").val(totalAmount + before);
		});
		
		$(".amountOption1").on("click", function(){
			if($("#totalAmount").val() == "")
			{
				$("#totalAmount").val("0");
			}
			$("#totalAmount").val(parseInt($("#totalAmount").val()) + parseInt(1000));
			$("#pointLoadAfter_input").val(parseInt($("#totalAmount").val()) + parseInt($("#pointLoadBefore_input").val()));
		});
		
		$(".amountOption2").on("click", function(){
			if($("#totalAmount").val() == "")
			{
				$("#totalAmount").val("0");
			}
			$("#totalAmount").val(parseInt($("#totalAmount").val()) + parseInt(5000));
			$("#pointLoadAfter_input").val(parseInt($("#totalAmount").val()) + parseInt($("#pointLoadBefore_input").val()));
		});
		
		$(".amountOption3").on("click", function(){
			if($("#totalAmount").val() == "")
			{
				$("#totalAmount").val("0");
			}
			$("#totalAmount").val(parseInt($("#totalAmount").val()) + parseInt(10000));
			$("#pointLoadAfter_input").val(parseInt($("#totalAmount").val()) + parseInt($("#pointLoadBefore_input").val()));
		});
		
		$(".amountOption4").on("click", function(){
			if($("#totalAmount").val() == "")
			{
				$("#totalAmount").val("0");
			}
			$("#totalAmount").val(parseInt($("#totalAmount").val()) + parseInt(50000));
			$("#pointLoadAfter_input").val(parseInt($("#totalAmount").val()) + parseInt($("#pointLoadBefore_input").val()));
		});
		
	});
	/* 포인트 충전 모달 */
</script>
</body>
</html>