<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>

<!DOCTYPE html>
<html lang="ko">

<head>
<%@ include file="/WEB-INF/views/include/head.jsp" %>
<link rel="stylesheet" href="/resources/css/friend.css" type="text/css">
<title>Store eGame : 친구</title>

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
                    <a href="/myPage.html">마이페이지</a>
                    <span>친구</span>
                </div>
            </div>
        </div>
    </div>
</div>
<!-- Breadcrumb End -->

<!-- Friend Page -->
<div class="friend-page">
    <div class="friend-page-section">
        <!-- friendPage sideBar -->
        <div class="friend-page-side">
            <div class="friend-page-side-wrap">

<c:if test="${!empty friendSide}">
	<c:forEach var="friendSide" items="${friendSide}" varStatus="status">         
	        	<div class="friend-page-side-section">                        
	            	<div class="friend-page-side-userName">
	            	
		<c:choose>		
			<c:when test="${!empty friendSide.userNickname}">				            	
                        <a href="javascript:void(0)" onclick="fn_friendView('${friendSide.frUserId}')">${friendSide.userNickname}</a>
			</c:when> 
			<c:otherwise>
						<a href="javascript:void(0)" onclick="fn_friendView('${friendSide.frUserId}')">${friendSide.frUserId}</a> 
			</c:otherwise>                       
		</c:choose>                        
                        
                    </div>
	                    
		<c:choose>
			<c:when test="${friendSide.frStatus eq 1}">
					<div class="friend-page-side-userStatus">친구신청</div>
			</c:when>
			<c:when test="${friendSide.frStatus eq 2}">
					<div class="friend-page-side-userStatus">수락대기</div>
			</c:when>					
			<c:when test="${friendSide.frStatus eq 4}">                                            
                    <div class="friend-page-side-userStatus">친구</div>
			</c:when>				
		</c:choose>                    
	                    
                </div>
                <hr />
                <input type="hidden" id="friendId" data-no="${friendSide.frUserId}" value="${friendSide.frUserId}"/>
	</c:forEach>                
</c:if>                                     
                
            </div>
        </div>  
        
        <!-- friendPage main -->
        <div class="friend-page-main">
<c:if test="${empty friend}">        
        	<h2 style="color: #ffffff; margin-top:20px; margin-left: 120px;">친구 목록이 없습니다.</h2>
</c:if>        	
            <div class="friend-page-main-row">
            
<c:if test="${!empty friend}">
	<c:forEach var="friend" items="${friend}" varStatus="status">	            
                <div class="friend-page-main-column">
                    <div class="friend-page-main-column-wrap">  
                     	<c:choose>
									<c:when test="${friend.frStatus eq 1}">
											<div class="friend-page-userStatus">친구신청</div>
									</c:when>
									<c:when test="${friend.frStatus eq 2}">
											<div class="friend-page-userStatus">수락대기</div>
									</c:when>					
									<c:when test="${friend.frStatus eq 4}">                                            
						                    <div class="friend-page-userStatus">친구</div>
									</c:when>				
								</c:choose>       
                        <div class="friend-page-main-img" style="background-image : url(/resources/img_userimg/${friend.userImg}); background-size: cover;">		                                       
                            <!-- img src="/resources/img_userimg/${friend.userImg}" alt="이미지" -->
                        </div>		                                            
                        <div class="friend-page-main-name">
                            <a href="javascript:void(0)" onclick="fn_friendView('${friend.frUserId}')">${friend.userNickname}</a>
                        </div> 
                        <div class="friend-page-main-email">
                            <span>${friend.userEmail}</span>
                        </div>   
                        		     
                    </div>
                </div>		              
	</c:forEach>                
</c:if>                          
            
	        </div>
	    </div> 
	</div>	
</div>

<div class="pagination-wrap">
	<div class="pagination">  
<c:if test="${!empty paging}">
	<c:if test="${paging.prevBlockPage gt 0}">
	  	<a href="javascript:void(0)" onclick="fn_list(${paging.prevBlockPage})">&laquo;</a>
  	</c:if>
  	<c:forEach var="i" begin="${paging.startPage}" end="${paging.endPage}">
  		<c:choose>
			<c:when test="${i ne curPage}">	
	  	<a href="javascript:void(0)" onclick="fn_list(${i})">${i}</a>
  			</c:when>
  			<c:otherwise>
	  	<a href="javascript:void(0)" onclick="fn_list(${i})" class="pagination_curPage">${i}</a>
  			</c:otherwise>
  		</c:choose>
	</c:forEach>
	<c:if test="${paging.nextBlockPage gt 0}">
		<a href="javascript:void(0)" onclick="fn_list(${paging.nextBlockPage})">&raquo;</a>
	</c:if>
</c:if>	
	</div> 
</div>

	<form name="friendForm" id="friendForm" method="post">
		<input type="hidden" name="curPage" value="${curPage}" />
	</form>
                	

<%@ include file="/WEB-INF/views/include/footer.jsp" %>  
<script>
//페이징
function fn_list(curPage)
{	
	document.friendForm.curPage.value = curPage;
	document.friendForm.action = "/user/friend";
	document.friendForm.submit();
}

//친구 마이페이지 url 이동
function fn_friendView(e)
{	
	//console.log(e);
	const asd = "input[data-no=" + e + "]";
	//console.log(asd);
	const friendId = document.querySelector(asd).value;
	//console.log(friendId);
	var url = "/user/friendPage?friendId=" + friendId;
	location.href = url;
}

</script>
</body>
</html>