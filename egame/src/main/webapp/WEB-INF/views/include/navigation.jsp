<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%> <%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
<script>
	const split = window.location.pathname.split('/');
	const curAdd = split.reverse()[0];
	(window.location.href).slice(-3)
	
	$(document).ready(function(){
		if(curAdd == "store")
		{
			$("#menuStore").attr("style", "background-color: #e53637");
			if((window.location.href).slice(-3) == "100")
			{
				$("#menuStoreAction").attr("style", "background-color: #e53637");
			}
			if((window.location.href).slice(-3) == "200")
			{
				$("#menuStoreRacing").attr("style", "background-color: #e53637");
			}
			if((window.location.href).slice(-3) == "300")
			{
				$("#menuStoreFps").attr("style", "background-color: #e53637");
			}
			if((window.location.href).slice(-3) == "400")
			{
				$("#menuStoreSimulator").attr("style", "background-color: #e53637");
			}
			
			$(".productSearch_div").css("display", "none")
		}
		
		else if(curAdd == "qna")
		{
			$("#menuQna").attr("style", "background-color: #e53637");
		}
		
		else if(curAdd == "notice")
		{
			$("#menuNotice").attr("style", "background-color: #e53637");
		}
		
		else if(curAdd == "myPage")
		{
			$("#menuMyPage").attr("style", "background-color: #e53637");
		}
		
		else if(curAdd == "userUpdate")
		{
			$("#menuMyPage").attr("style", "background-color: #e53637");
			$("#menuUserUpdate").attr("style", "background-color: #e53637");
		}
		
		else if(curAdd == "library")
		{
			$("#menuMyPage").attr("style", "background-color: #e53637");
			$("#menuLibrary").attr("style", "background-color: #e53637");
		}
		
		else if(curAdd == "point")
		{
			$("#menuMyPage").attr("style", "background-color: #e53637");
			$("#menuPoint").attr("style", "background-color: #e53637");
		}
		
		else if(curAdd == "friend")
		{
			$("#menuMyPage").attr("style", "background-color: #e53637");
			$("#menuFriend").attr("style", "background-color: #e53637");
		}
		
		else if(curAdd == "cart")
		{
			$("#menuCart").attr("style", "background-color: #e53637");
		}
	});
</script>
<% if(com.game.web.util.CookieUtil.getCookie(request,
(String)request.getAttribute("AUTH_COOKIE_NAME")) != null) { %>
<!-- Page Preloder -->
<c:if test="${requestScope['javax.servlet.forward.request_uri'] ne '/board/reportList'}">
	<div id="preloder">
	  <div class="loader"></div>
	</div>
</c:if>

<!-- Header Section Begin -->
<header>
    <section class="nav_section">
        <ul class="navi">
            <li class="navi_li"><a class="navi_logo_a" href="/index"><img class="navi_logo_img" src="/resources/icon/logo.png" alt="" /></a></li>
            <li class="navi_li"><a class="navi_li_a" id="menuStore" href="/store" >스토어<span class="arrow_carrot-down"></span></a>
                <ul class="store_dropdown">
                    <li><a class="navi_li_a" id="menuStoreAction" href="/store?tagParentNum=0100">액션</a></li>
                    <li><a class="navi_li_a" id="menuStoreRacing" href="/store?tagParentNum=0200">레이싱</a></li>
                    <li><a class="navi_li_a" id="menuStoreFps" href="/store?tagParentNum=0300">FPS</a></li>
                    <li><a class="navi_li_a" id="menuStoreSimulator" href="/store?tagParentNum=0400">시뮬레이션</a></li>
                </ul>
            </li>
            <li class="navi_li"><a class="navi_li_a" id="menuQna" href="/board/qna">문의</a></li>
            <li class="navi_li"><a class="navi_li_a" id="menuNotice" href="/board/notice">공지사항</a></li>
            <c:if test="${cookie.USER_ID.value ne '74657374'}">
            <li class="navi_li"><a class="navi_li_a" id="menuMyPage" href="/user/myPage">마이페이지<span class="arrow_carrot-down"></span></a>
                <ul class="dropdown">
                    <li class="navi_li"><a class="navi_li_a" id="menuUserUpdate" href="/user/userUpdate">회원정보수정</a></li>
                    <li class="navi_li"><a class="navi_li_a" id="menuLibrary" href="/user/library">보유게임</a></li>
                    <li class="navi_li"><a class="navi_li_a" id="menuPoint" href="/user/point">포인트 상세내역</a></li>
                    <li class="navi_li"><a class="navi_li_a" id="menuFriend" href="/user/friend">친구 목록</a></li>
                </ul>
            </li>
            </c:if>
            <li class="navi_li"><a class="navi_li_a" id="menuCart" href="/user/cart">장바구니</a></li>
            <li>
                <div class="productSearch_div">
                    <input class="productSearch_input" type="text" placeholder="스토어 검색" id="productSearch"/>
                    <a class="searchIcon" id="search" onclick="fn_nameSearch()" href="javascript:void(0)">
                        <img src="https://s3.ap-northeast-2.amazonaws.com/cdn.wecode.co.kr/icon/search.png"/>
                    </a>
                </div>
            </li>
            <c:if test="${cookie.USER_ID.value eq '74657374'}">
            	<a class="adminMenu" href="/admin/index"><span>관리자메뉴</span></a>
            </c:if>
            <a class=".navi_loginOut" href="/user/loginOutProc"><span class="icon_profile" id="login_icon_profile">로그아웃</span></a>
        </ul>
    </section>
</header>

<!-- Header End -->
<% } else { %>
<!-- Page Preloder -->
<c:if test="${requestScope['javax.servlet.forward.request_uri'] ne '/board/reportlist'}">
	<div id="preloder">
	  <div class="loader"></div>
	</div>
</c:if>

<!-- Header Section Begin -->
<header>
    <section class="nav_section">
        <ul class="navi">
            <li class="navi_li"><a class="navi_logo_a" href="/index"><img class="navi_logo_img" src="/resources/icon/logo.png" alt="" /></a></li>
            <li class="navi_li"><a class="navi_li_a" id="menuStore" href="/store" >스토어<span class="arrow_carrot-down"></span></a>
                <ul class="store_dropdown">
                    <li><a class="navi_li_a" id="menuStoreAction" href="/store?tagParentNum=0100">액션</a></li>
                    <li><a class="navi_li_a" id="menuStoreRacing" href="/store?tagParentNum=0200">레이싱</a></li>
                    <li><a class="navi_li_a" id="menuStoreFps" href="/store?tagParentNum=0300">FPS</a></li>
                    <li><a class="navi_li_a" id="menuStoreSimulator" href="/store?tagParentNum=0400">시뮬레이션</a></li>
                </ul>
            </li>
            <li class="navi_li"><a class="navi_li_a" id="menuNotice" href="/board/notice">공지사항</a></li>
            <li>
                <div class="productSearch_div">
                    <input class="productSearch_input" type="text" placeholder="스토어 검색" id="productSearch"/>
                    <a class="searchIcon" id="search" onclick="fn_nameSearch()" href="javascript:void(0)">
                        <img src="https://s3.ap-northeast-2.amazonaws.com/cdn.wecode.co.kr/icon/search.png"/>
                    </a>
                </div>
            </li>
            <a class=".navi_loginOut" href="/user/login"><span class="icon_profile" id="login_icon_profile">로그인</span></a>
        </ul>
    </section>
</header>
<!-- Header End -->
<% } %>
<script>
$(document).ready(function(){
	$("#productSearch").keyup(function(event)
			{
		        if (event.which === 13)
		        {
		            $("#search").click();
		        }
		    });
});
  function fn_nameSearch() {
    const productName = $("#productSearch").val();
    location.href = `/store?productName=${"${productName}"}`;
  }
</script>
