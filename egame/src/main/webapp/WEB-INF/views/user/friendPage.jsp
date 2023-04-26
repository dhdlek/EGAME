<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>

<!DOCTYPE html>
<html lang="ko">

<head>
<%@ include file="/WEB-INF/views/include/head.jsp" %>
<link rel="stylesheet" href="/resources/css/library.css" type="text/css">
<title>Store eGame : 마이페이지</title>
<script src="https://code.jquery.com/jquery-3.4.1.js"></script>
<script type="text/javascript" src="/resources/js/jquery-3.5.1.min.js"></script>
<script>
$(document).ready(function() {
	
	var friendId = $("#friendId").val();
	var cookieUserId = "<c:out value='${cookieUserId}'/>";	
	
	$("#add-friends").on("click", function(friendId) {	
		$("#add-friends").prop("disabled", true);		
		fn_addFriend(friendId);
	});
	
	$("#cancle-friends").on("click", function(friendId) {
		$("#cancle-friends").prop("disabled", true);
		fn_cancleFriend(friendId);
	});
		
});

//친구추가
function fn_addFriend(friendId)
{	
	if(friendId === null)
	{
		alert("존재하지 않는 사용자입니다.");
		$("#add-friends").prop("disabled", false);
		return;
	}
	
	$.ajax({
		type:"GET",
		url:"/user/addFriend",
		data:{
			friendId: $("#friendId").val()
		},		
		dataType:"JSON",
		beforeSend:function(xhr){
			xhr.setRequestHeader("AJAX", "true");
		},
		success:function(response){
			if(response.code == 0)
			{
				alert("친구신청이 완료되었습니다.");
				$("#add-friends").prop("disabled", false);
				location.reload();
			}
			else if(response.code == 1)
			{
				alert("친구신청이 수락되었습니다.");
				$("#add-friends").prop("disabled", false);
				location.reload();
			}
			else if(response.code == 400)
			{
				alert("이미 친구신청이 되었습니다.");
				$("#add-friends").prop("disabled", false);
				location.reload();
			}
			else if(response.code == 401)
			{
				alert("친구신청을 할 수 없습니다.");
				$("#add-friends").prop("disabled", false);
				location.reload();
			}
			else if(response.code == 402)
			{
				alert("이미 친구 등록이 되어있습니다.");
				$("#add-friends").prop("disabled", false);
			}
			else if(response.code == 500)
			{
				alert("처리 중 오류가 발생하였습니다.");
				$("#cancle-friends").prop("disabled", false);
			}
			else if(response.code == -2)
			{
				alert("로그인이 필요합니다.");
				location.href = "/user/login";
			}
		},
		error:function(error){
			icia.common.error(error);
			alert("친구추가 중 오류가 발생하였습니다.");
			$("#add-friends").prop("disabled", false);
		}
	});
}

//친구 끊기
function fn_cancleFriend(friendId)
{	
	if(friendId === null)
	{
		alert("존재하지 않는 사용자입니다.");
		$("#cancle-friends").prop("disabled", false);
		return;
	}
	
	$.ajax({
		type:"GET",
		url:"/user/cancleFriend",
		data:{
			friendId:$("#friendId").val()
		},		
		dataType:"JSON",
		beforeSend:function(xhr){
			xhr.setRequestHeader("AJAX", "true");
		},
		success:function(response){
			if(response.code == 1)
			{
				alert("친구 신청이 거절되었습니다.");
				$("#cancle-friends").prop("disabled", false);
				location.reload();
			}
			else if(response.code == 2)
			{
				alert("친구 신청이 취소되었습니다.");
				$("#cancle-friends").prop("disabled", false);
				location.reload();
			}
			else if(response.code == 3)
			{
				alert("친구 목록에서 삭제되었습니다.");
				$("#cancle-friends").prop("disabled", false);
				location.reload();
			}
			else if(response.code == 400)
			{
				alert("친구 등록이 되어있지 않습니다.");
				$("#cancle-friends").prop("disabled", false);
			}
			else if(response.code == 500)
			{
				alert("처리 중 오류가 발생하였습니다.");
				$("#cancle-friends").prop("disabled", false);
			}
		},
		error:function(error){
			icia.common.error(error);
			alert("친구끊기 중 오류가 발생하였습니다.");
			$("#cancle-friends").prop("disabled", false);
		}
	});
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
                    <div class="anime__details__pic set-bg" data-setbg="/resources/img_userimg/${user.userImg}" style="height: 300px;"></div>                                        
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
                        <c:choose>
	                        <c:when test = "${user.userStatus eq '1'.charAt(0)}">
								<div class="anime__details__btn">
								<c:if test="${empty friend.frStatus}">
		                        	<button type="button" id="add-friends" class="follow-btn" style="border: none;">친구 추가</button>
		                        </c:if>
		                        <c:if test="${friend.frStatus eq 1}">
		                        	<button type="button" id="cancle-friends" class="follow-btn" style="border: none;">신청 취소</button>
		                        </c:if>
		                        <c:if test="${friend.frStatus eq 2}">
		                        	<button type="button" id="add-friends" class="follow-btn" style="border: none;">수락</button>
		                        	<button type="button" id="cancle-friends" class="follow-btn" style="border: none;">거절</button>
		                        </c:if>
		                        <c:if test="${friend.frStatus eq 4}">
		                        	<button type="button" id="cancle-friends" class="follow-btn" style="border: none;">친구 끊기</button>
		                        </c:if>	                        	   
									<input type="hidden" id="friendId" name="friendId" value="${user.userId}" />							  
								</div>   
							</c:when>
							<c:otherwise>
								<h1 style="color:red">정지된 사용자 입니다.</h1>
							</c:otherwise>                     	                  	                        
                        </c:choose>                                                                                                                                                                                                                                                                                                               
                                                
                    </div>
                </div>
            </div>
        </div>       
    </div>
    <!-- 보유게임 -->
<c:if test="${user.userStatus eq '1'.charAt(0)}">
<c:choose>    
    <c:when test="${friend.frStatus eq 4}">
	<div id="library" style="min-height: 250px; width: 60%; margin: 0 auto; margin-top: 50px; margin-bottom: 50px;">
	    <table class="library_table">
	        <thead>
	            <tr>
	                <th style="width: 60%;">상품정보</th>                
	                <th style="width: 20%;">구매날짜</th>
	            </tr>
	        </thead>
	        <tbody id="tbody">
	    <c:if test="${empty list}">
	    		<tr>
	    			<td colspan="2">
	    				<h2 style="color: #ffffff; text-align: center; padding-top:40px">보유게임이 없습니다.</h2>
	    			</td>
	    		</tr>
	    </c:if>
		<c:if test="${!empty list}">  
			<c:forEach var="pay" items="${list}" varStatus="status">
	            <tr>
	                <td class="library_table_td1" style="padding-left: 15px;">
	                    <a href="javascript:void(0)" onclick="fn_detail(${pay.productSeq})">
	                    <img src="/resources/img_library/${pay.productName}.jpg" width="30%">
	                    &nbsp;&nbsp;${pay.productName}
	                    </a>
	                </td>
	                <td class="library_table_td2">
	                    <span>${pay.payDate}</span>
	                </td>	               	                 
	            </tr>
			</c:forEach>
		</c:if>
			</tbody>
	    </table>
	</div>
	</c:when>
	<c:otherwise>
	<h2 style="color: #ffffff; text-align: center;">친구등록을 하시면 친구의 보유게임을 보실 수 있습니다.</h2>
	</c:otherwise>
</c:choose>	
</c:if>
</section>
<!-- Anime Section End -->
    
<%@ include file="/WEB-INF/views/include/footer.jsp" %>
</body>
</html>