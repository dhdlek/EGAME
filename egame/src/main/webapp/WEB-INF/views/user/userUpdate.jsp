<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>

<!DOCTYPE html>
<html lang="ko">

<head>
<%@ include file="/WEB-INF/views/include/head.jsp" %>
<title>Store eGame : 회원정보수정</title>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
<script type="text/javascript">
$(document).ready(function(){
	$("#updateBtn").on("click", function(){
		
		//모든 공백 체크 정규식
		var emptCheck = /\s/g;
		//영문 대소문자, 숫자로만 이루어진 4~12자리 정규식
		var idPwCheck = /^[a-zA-Z0-9]{4,12}$/;
		//사용자 이름 정규식
		var nameCheck = /^[가-힣]{2,6}$/;
		
		if($.trim($("#userPwd1").val()).length <= 0)
		{
			alert("비밀번호를 입력하세요.");
			$("#userPwd1").val("");
			$("#userPwd1").focus();
			return;
		}
		
		if(emptCheck.test($("#userPwd1").val()))
		{
			alert("비밀번호는 공백을 포함할 수 없습니다.");
			$("#userPwd1").focus();
			return;
		}
		
		if(!idPwCheck.test($("#userPwd1").val()))
		{
			alert("비밀번호는 영문 대소문자와 숫자로 4~12자리 입니다.");
			$("#userPwd1").focus();
			return;
		}
		
		if($("#userPwd1").val() != $("#userPwd2").val())
		{
			alert("비밀번호가 일치하지 않습니다.");
			$("#userPwd2").focus();
			return;
		}
		
		if($.trim($("#userName").val()).length <= 0)
		{
			alert("사용자 이름을 입력하세요.");
			$("#userName").val("");
			$("#userName").focus();
			return;
		}	
		
		if(emptCheck.test($("#userName").val()))
		{
			alert("사용자 이름은 공백을 포함할 수 없습니다.");
			$("#userName").focus();
			return;
		}
		
		if(!nameCheck.test($("#userName").val()))
		{
			alert("사용자 이름은 한글을 사용하여 2~6자리로 입력하세요.");
			$("#userName").focus();
			return;
		}
		
		$("#userPwd").val($("#userPwd1").val());
		
		$.ajax({
			type:"POST",
			url:"/user/userUpdateProc",
			data:{
				userPwd:$("#userPwd").val(),
				userName:$("#userName").val(),
				userNickname:$("#userNickname").val(),
			},
			dataType:"JSON",
			beforeSend:function(xhr){
				xhr.setRequestHeader("AJAX", "true");
			},
			success:function(response){
				if(response.code == 0)
				{
					alert("회원 정보가 수정되었습니다.");
					location.href = "/";
				}
				else if(response.code == 400)
				{
					alert("파라미터 값이 올바르지 않습니다.");
					$("#userId").focus();
				}
				else if(response.code == 404)
				{
					alert("회원 정보가 없습니다.");
					location.href = "/";
				}
				else if(response.code == 500)
				{
					alert("회원 정보 수정 중 오류가 발생하였습니다.");
					$("#userId").focus();
				}
				else
				{
					alert("회원 정보 수정 중 오류가 발생하였습니다.2");
					$("#userId").focus();
				}
			},
			error:function(xhr, status, error){
				icia.common.error(error);
			}
		});
	});
});


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
                    <h2>회원정보수정</h2>
                    <p>Welcome to the official EGame Store.</p>
                </div>
            </div>
        </div>
    </div>
</section>
<!-- Normal Breadcrumb End -->

<!-- Signup Section Begin -->
<section class="signup spad">
    <div class="container">
        <div class="row">
            <div class="col-lg-6">
                <div class="login__form user_update_form" style="padding-left: 370px;">
                    <h3>회원정보수정</h3>
                    <form>
                        <div class="input__item">
                            <input type="text" placeholder="아이디" value="${user.userId}" disabled>
                            <span class="icon_profile"></span>
                        </div>
                        <div class="input__item">
                            <input type="password" id="userPwd1" placeholder="비밀번호" value="${user.userPwd}">
                            <span class="icon_lock"></span>
                        </div>
                        <div class="input__item">
                            <input type="password" id="userPwd2" placeholder="비밀번호 확인" value="${user.userPwd}">
                            <span class="icon_lock"></span>
                        </div>
                        <div class="input__item">
                            <input type="text" id="userName" placeholder="이름" value="${user.userName}">
                            <span class="icon_profile"></span>
                        </div>
                        <div class="input__item">
                            <input type="text" id="userNickname" placeholder="닉네임" value="${user.userNickname}">
                            <span class="icon_profile"></span>
                        </div>
                        <div class="input__item">
                            <input type="text" placeholder="이메일" value="${user.userEmail}" disabled>
                            <span class="icon_mail"></span>
                        </div>                           
<c:if test="${user.userClass eq 's'.charAt(0)}">                               
                        <div class="input__item">
                            <label style="position: relative;">
                                <input type="text" placeholder="사업자등록번호" value="${user.businessNum}" style="width: 370px;" disabled>
                                <span class="icon_lock"></span>                                
                            </label>
                        </div>
</c:if>                        
						<input type="hidden" id="userPwd" name="userPwd" value="" />
                        <button id="updateBtn" type="button" class="site-btn">회원정보수정</button>
                    </form>
                </div>
            </div>
        </div>
    </div>
</section>
<!-- Signup Section End -->

<%@ include file="/WEB-INF/views/include/footer.jsp" %>
</body>
</html>