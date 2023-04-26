<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>

<!DOCTYPE html>
<html lang="ko">

<head>
<%@ include file="/WEB-INF/views/include/head.jsp" %>
    <meta charset="UTF-8">
    <meta name="description" content="Game Template">
    <meta name="keywords" content="Game, unica, creative, html">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <title>Store eGame : 신고 내역</title>

    <!-- Google Font -->
    <link href="https://fonts.googleapis.com/css2?family=Oswald:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Mulish:wght@300;400;500;600;700;800;900&display=swap" rel="stylesheet">

    <!-- Css Styles -->
    <link rel="stylesheet" href="/resources/css/report-detail.css" type="text/css">
    <link rel="stylesheet" href="/resources/css/bootstrap.min.css" type="text/css">
    <link rel="stylesheet" href="/resources/css/style.css" type="text/css">
    <link rel="stylesheet" href="/resources/css/elegant-icons.css" type="text/css">
	<style>
		body { color: #fff; }
		.report_detail_btn
		{
			position: unset;
		}
	</style>

    <!-- Js -->
    <script src="/resources/js/report-form.js"></script>
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.1/jquery.min.js"></script>
	
<script type="text/javascript">
	$(document).ready(function() {
		<c:choose>
			<c:when test="${empty report}">
				alert("조회하신 문의가 존재하지 않습니다.");
				document.reportDetailForm.action = "/board/reportList";
				document.reportDetailForm.submit();
			</c:when>
			<c:otherwise>
				$("#btnList").on("click", function() {
					document.reportDetailForm.action = "/board/reportList";
					document.reportDetailForm.submit();
				});
				
				
				$("#btnUpdate").on("click", function(){
					
					var form = $("#reportStatusUpdateForm")[0];
					var formData = new FormData(form);
					
					$.ajax({
						type:"POST",
						url:"/board/reportStatusUpdateProc",
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
								alert("처리상태가 수정 되었습니다.");
								location.href = "/board/reportList";
							}
							else if(response.code == 400)
							{
								alert("파라미터 값이 올바르지 않습니다.");
							}
							else if(response.code == 404)
							{
								alert("해당 신고를 찾을 수 없습니다.");
							}
							else
							{
								alert("수정 중 오류가 발생하였습니다.");
							}
						},
						error:function(error)
						{
						}
					});
				});
			</c:otherwise>
		</c:choose>
	});
	//디테일 페이지 이동 함수
	function fn_product_detail(product_seq)
      {
        const url = "/admin/productDetail?productSeq=" + product_seq;
        var popup = window.open(url, "_blank", 'width=1000, height=1200, scrollbars=yes, resizable =no');

      }

	  function fn_review_detail(review_Seq)
	  {
		const url = "/admin/reviewDetail?reviewSeq=" + review_Seq;
        var popup = window.open(url, "_blank",'scrollbars=no, resizable =no');
	  }
</script>
</head>

<body>
<%@ include file="/WEB-INF/views/include/navigationAdmin.jsp" %>

<!-- Report Section Start -->
<section class="report_section">
	<form name ="reportStatusUpdateForm" id="reportStatusUpdateForm" method="post">
	    <div class="report_detail_form">
	        <div class="report_detail_form_title">신고 상세내역</div>
	        <div class="space-adaptive"></div>
	        <div class="report_detail_form_wrapper">
	            <div class="report_detail_form_ele"><small>신고 번호</small><br><c:out value="${report.reportSeq}" /></div>
	            <div class="report_detail_form_ele"><small>신고자 아이디</small><br><c:out value="${report.userId}" /></div>
	            <div class="report_detail_form_ele"><small>상품 번호</small><br>
	            	<c:if test="${report.productSeq ne 0}"><a href="javascript:void(0)" onclick="fn_product_detail(${report.productSeq})" style="color:white"><c:out value="${report.productSeq}" /></a></c:if>
	               	<c:if test="${report.productSeq eq 0}">-</c:if>
	       		</div>
	            <div class="report_detail_form_ele"><small>리뷰 번호</small><br>
		            <c:if test="${report.reviewSeq ne 0}"><a href="javascript:void(0)" onclick="fn_review_detail(${report.reviewSeq})" style="color:white"><c:out value="${report.reviewSeq}" /></a></c:if>
		            <c:if test="${report.reviewSeq eq 0}">-</c:if>
				</div>
	            <div class="report_detail_form_ele"><small>신고 날짜</small><br><c:out value="${report.reportRegDate}" /></div>
	            <div class="report_detail_form_ele"><small>처리상태</small><br>
	                <select class="report_status_select" name="reportStatus" id="reportStatus">
	                	<option <c:if test="${report.reportStatus eq '미처리'}"> selected </c:if> value="미처리">미처리</option>
	                    <option <c:if test="${report.reportStatus eq '처리완료'}"> selected </c:if> value="처리완료">처리완료</option>
	                </select>
	            </div>
	            <div class="report_detail_form_ele"><small>신고 구분</small><br>
	            	<c:if test="${report.reportPr eq 'P'}">상품</c:if>
	               	<c:if test="${report.reportPr eq 'R'}">리뷰</c:if>
	            </div>
	            <div class="report_detail_form_ele"><small>신고 태그</small><br><c:out value="${report.reportTag}" /></div>
	        </div>
	        <div class="report_content_div">
	            <div>신고내용</div>
	            <textarea disabled><c:out value="${report.reportContent}" /></textarea>
	        </div>
			<div class="report_detail_btn" style="text-align: right;">
				<button type="button" class="btnList" id="btnList">목록</button>
				<button type="button" class="btnList" id="btnUpdate">저장</button>
			</div>
	    </div>
	    <input type="hidden" name="reportSeq" value="${report.reportSeq}" />
    </form>
	
</section>

<form name="reportDetailForm" id="reportDetailForm" method="post">
	<input type="hidden" id="reportSeq" name="reportSeq" value="${reportSeq}" />
	<input type="hidden" id="searchPr" name="searchPr" value="${searchPr}" />
	<input type="hidden" id="searchTag" name="searchTag" value="${searchTag}" />
	<input type="hidden" id="searchValueOption" name="searchValueOption" value="${searchValueOption}" />
	<input type="hidden" id="searchValue" name="searchValue" value="${searchValue}" />
	<input type="hidden" id="curPage" name="curPage" value="${curPage}" />
</form>
<!-- Report Section End -->


</body>
</html>