<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>

<!DOCTYPE html>
<html lang="ko">

<head>
    <meta charset="UTF-8">
    <meta name="description" content="Game Template">
    <meta name="keywords" content="Game, unica, creative, html">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <title>Store eGame : 신고 등록</title>

    <!-- Google Font -->
    <link href="https://fonts.googleapis.com/css2?family=Oswald:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Mulish:wght@300;400;500;600;700;800;900&display=swap" rel="stylesheet">

    <!-- Css Styles -->
    <link rel="stylesheet" href="/resources/css/report-reg-form.css" type="text/css">
    <link rel="stylesheet" href="/resources/css/bootstrap.min.css" type="text/css">
    <link rel="stylesheet" href="/resources/css/style.css" type="text/css">
    <link rel="stylesheet" href="/resources/css/elegant-icons.css" type="text/css">

    <!-- Js -->
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.1/jquery.min.js"></script>    
	
	<script>
    $(document).ready(function(){
    	
    	$.load = function(){
	    	if($("#reportPr").val() == '상품')
	        {
	            $('[name="reportTag"]').html("<option value='저작권위반' <c:if test="${searchTag eq '저작권위반'}">selected</c:if>>저작권위반</option><option value='아동학대' <c:if test="${searchTag eq '아동학대'}">selected</c:if>>아동학대</option><option value='법률위반' <c:if test="${searchTag eq '법률위반'}">selected</c:if>>법률위반</option><option value='악성코드' <c:if test="${searchTag eq '악성코드'}">selected</c:if>>악성코드</option><option value='사기' <c:if test="${searchTag eq '사기'}">selected</c:if>>사기</option><option value='카테고리' <c:if test="${searchTag eq '카테고리'}">selected</c:if>>카테고리</option><option value='기타' <c:if test="${searchTag eq '기타'}">selected</c:if>>기타</option>");
	        }
	        if($("#reportPr").val() == '리뷰')
	        {
	            $('[name="reportTag"]').html("<option value='홍보글' <c:if test="${searchTag eq '홍보글'}">selected</c:if>>홍보글</option><option value='음란성' <c:if test="${searchTag eq '음란성'}">selected</c:if>>음란성</option><option value='혐오' <c:if test="${searchTag eq '혐오'}">selected</c:if>>혐오</option>");
	        }
    	}
    	
    	$.load();
    	
    	$("#reportPr").change(function(){
            $.load();
    	});
    	
    	$("#btnWrite").on("click", function(){
    		
    		$("#btnWrite").prop("disabled", true);
    		
    		if($.trim($("#reportTag").val()).length <= 0 || $.trim($("#reportTag").val()).length == null)
    		{
    			alert("신고 옵션을 선택하세요.");
    			$("#btnWrite").prop("disabled", false);
    			return;
    		}
    		
    		if($.trim($("#reportContent").val()).length <= 0)
    		{
    			alert("내용을 입력하세요.");
    			$("#reportContent").val("");
    			$("#reportContent").focus();
    			$("#btnWrite").prop("disabled", false);
    			return;
    		}
    		
    		var form = $("#reportRegForm")[0];
    		var formData = new FormData(form);
    		
    		$.ajax({
    			type:"POST",
    			url:"/board/reportWriteProc",
    			data:formData,
    			processData:false,
    			contentType:false,
    			cache:false,
    			beforeSend:function(xhr){
    				xhr.setRequestHeader("AJAX", "true");
    			},
    			success:function(response)
    			{
    				if(response.code == 0)
    				{
    					alert("신고가 정상적으로 접수 되었습니다.");
    					location.href = "/";
    				}
    				else if(response.code == 400)
    				{
    					alert("파라미터 값이 올바르지 않습니다.");
    					$("#btnWrite").prop("disabled", false);
    				}
    				else
    				{
    					alert("신고 접수 중 오류가 발생하였습니다.");
    					$("#btnWrite").prop("disabled", false);
    				}
    			},
    			error:function(error)
    			{
    				game.common.error(error);
    				alert("신고 접수 중 오류가 발생하였습니다.");
    				$("#btnWrite").prop("disabled", false);
    			}
    		});
    	});
    		
    });
	</script>
</head>

<body>
<%@ include file="/WEB-INF/views/include/navigationReport.jsp" %>

<!-- Report Section Start -->
<section class="report_section">
   	<form name="reportRegForm" id="reportRegForm" method="post">
	    <div class="report_form">
	        <div class="report_context">
	            <h2 style="margin-bottom: 20px;">신고하기</h2>
		            <div class="report_wrapper">
		                <select required class="report_pr" name="reportPr" id="reportPr">
		                    <option selected disabled hidden>신고 구분</option>
		                    <option value="상품">상품</option>
		                    <option value="리뷰">리뷰</option>
		                </select>
		            </div>
		            <div class="report_wrapper">
		                <select required class="report_tag" name="reportTag" id="reportTag">
		                </select>
		            </div>
		            <div class="report_context_tbox">
		                <textarea class="report_context_text" name="reportContent" id="reportContent" maxlength="500" placeholder="자세한 내용을 적어주세요"></textarea>
		            </div>
	            <button class="report_btn" id="btnWrite">제출</button>
	        </div>
	    </div>
	</form>
</section>
<!-- Report Section End -->

<%@ include file="/WEB-INF/views/include/footerReport.jsp" %>
</body>
</html>