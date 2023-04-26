<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>

<!DOCTYPE html>
<html lang="ko">

<head>
<%@ include file="/WEB-INF/views/include/head.jsp" %>
<title>Store eGame : 로그인</title>
<script src="https://code.jquery.com/jquery-3.4.1.js"></script>
<script type="text/javascript">
$(document).ready(function() {
	
	$("#userId").focus();
	
	$("#userId").on("keypress", function(e){
		
		if(e.which == 13)
		{	
			fn_loginCheck();
		}
		
	});
	
	$("#userPwd").on("keypress", function(e){
		
		if(e.which == 13)
		{	
			fn_loginCheck();
		}
		
	});
		
	//로그인 버튼 선택시
	$("#btnLogin").on("click", function() {
		
		fn_loginCheck();
		
	});
	
});

function fn_loginCheck()
{
	if($.trim($("#userId").val()).length <= 0)
	{
		alert("아이디를 입력하세요.");
		$("#userId").val("");
		$("#userId").focus();
		return;
	}
	
	if($.trim($("#userPwd").val()).length <= 0)
	{
		alert("비밀번호를 입력하세요.");
		$("#userPwd").val("");
		$("#userPwd").focus();
		return;
	}
	
	$.ajax({
		type: "POST",
		url: "/user/loginProc",
		data: {
			userId:$("#userId").val(),
			userPwd:$("#userPwd").val()
		},
		datatype:"JSON",
		beforeSend:function(xhr){
			xhr.setRequestHeader("AJAX", "true");
		},
		success:function(response){
			
			if(!icia.common.isEmpty(response))
			{
				icia.common.log(response);
				
				var code = icia.common.objectValue(response, "code", -500);	//code값이 없으면 -500
				
				if(code == 0)	//로그인 성공
				{
					location.href = "/index";
				}
				else
				{
					if(code == -1)
					{
						alert("비밀번호가 올바르지 않습니다.");
						$("#userPwd").focus();
					}
					else if(code == 404)
					{
						alert("아이디와 일치하는 사용자 정보가 없습니다.");
						$("#userId").focus();
					}
					else if(code == 400)
					{
						alert("파라미터 값이 올바르지 않습니다.");
						$("#userId").focus();
					}
					else if(code == 405)
					{
						alert("정지된 사용자입니다.");
						$("userId").focus();
					}
					else
					{
						alert("오류가 발생하였습니다.22");
						$("#userId").focus();
					}
				}
			}
			else
			{
				alert("오류가 발생하였습니다.");
				$("#userId").focus();
			}
		},
		error:function(xhr, status, error)
		{
			icia.common.error(error);
		}
	});
}
</script>
</head>

<body>
<%@ include file="/WEB-INF/views/include/navigation.jsp" %>

<!-- Normal Breadcrumb Begin -->
<section class="normal-breadcrumb set-bg" data-setbg="/resources/img_html/normal-breadcrumb.jpg">
    <div class="container">
        <div class="row">
            <div class="col-lg-12 text-center">
                <div class="normal__breadcrumb__text">
                    <h2>로그인</h2>
                    <p>EGAME에 오신걸 환영합니다.</p>
                </div>
            </div>
        </div>
    </div>
</section>
<!-- Normal Breadcrumb End -->

<!-- Login Section Begin -->
<section class="login spad">
    <div class="container">
        <div class="row">
            <div class="col-lg-6">
                <div class="login__form">
                    <h3>로그인</h3>
                    <form action="#">
                        <div class="input__item">
                            <input type="text" placeholder="아이디" id="userId">
                            <span class="icon_profile"></span>
                        </div>
                        <div class="input__item">
                            <input type="password" placeholder="비밀번호" id="userPwd">
                            <span class="icon_lock"></span>
                        </div>
                        <button type="button" class="site-btn" id="btnLogin">로그인</button>
                    </form>
                    <!-- <a href="#" class="forget_pass">비밀번호 찾기</a> -->
                </div>
            </div>
            <div class="col-lg-6">
                <div class="login__register">
                    <h3>회원가입 하시겠습니까?</h3>
                    <a href="/user/signUp" class="primary-btn">회원가입</a>
                </div>
            </div>
        </div>
    </div>
</section>
<!-- Login Section End -->

<%@ include file="/WEB-INF/views/include/footer.jsp" %>
</body>
</html>