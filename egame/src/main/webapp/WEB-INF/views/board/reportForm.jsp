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
    <link rel="stylesheet" href="/resources/css/report-form.css" type="text/css">
    <link rel="stylesheet" href="/resources/css/bootstrap.min.css" type="text/css">
    <link rel="stylesheet" href="/resources/css/style.css" type="text/css">
    <link rel="stylesheet" href="/resources/css/elegant-icons.css" type="text/css">

    <!-- Js -->
    <script src="/resources/js/report-form.js"></script>

</head>

<body>
<%@ include file="/WEB-INF/views/include/navigationReport.jsp" %>

<!-- Report Section Start -->
<section class="report_section">
    <div class="report_form">
        <div class="report_context">
            <h2 style="margin-bottom: 20px;">신고하기</h2>
            <div class="report_wrapper">
                <input type="text" class="report_userid" value="유저아이디" disabled>
            </div>
            <div class="report_wrapper">
                <select required class="report_pr" onchange="categoryChange(this)">
                    <option selected disabled hidden>신고 대상</option>
                    <option value="a">상품</option>
                    <option value="b">리뷰</option>
                </select>
            </div>
            <div class="report_wrapper">
                <select required id="report_tag" class="report_tag">
                    <option selected disabled hidden>카테고리</option>
                </select>
            </div>
            <div class="report_wrapper">
                <div class="report_date">2023-02-28</div>
            </div>
            <div class="report_context_tbox">
                <textarea class="report_context_text" maxlength="500" placeholder="자세한 내용을 적어주세요"></textarea>
            </div>
            <a href="" class="report_btn">제출</a>
        </div>
    </div>
</section>
<!-- Report Section End -->

<%@ include file="/WEB-INF/views/include/footerReport.jsp" %>
</body>
</html>