<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%><%@ include file="/WEB-INF/views/include/taglib.jsp" %>

<!DOCTYPE html>
<html lang="ko">
  <head>
    <title>Store eGame : 리뷰 상세</title>
    <%@ include file="/WEB-INF/views/include/head.jsp" %>
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>

    <script>
      $(document).ready(function () {
        window.resizeTo(1200, 300);
      });

      //리뷰 삭제 함수
      function fn_delete(reviewSeq) {
        const productSeq = $("#productSeq").val();

        $.ajax({
          type: "POST",
          url: "/review/delete",
          data: {
            productSeq: productSeq,
            reviewSeq: reviewSeq,
          },
          datatype: "JSON",
          beforeSend: function (xhr) {
            xhr.setRequestHeader("AJAX", "true");
          },
          success: function (response) {
            if (response.code == 0) {
              alert("삭제 완료");
              window.close();
            } else if (response.code == -1) {
              alert("리뷰 삭제 가 완료되지 않았습니다." + response.msg);
              location.reload();
            } else if (response.code == 400) {
              alert("오류발생" + response.msg);
              location.reload();
            } else if (response.code == 500) {
              alert(response.msg);
              location.reload();
            }
          },
          error: function () {
            //game.common.error(error);
          },
        });
      }
    </script>
    <style>
      ul {
        list-style: none;
        margin-left: 15px;
      }
      li {
        margin-right: 10px;
        margin-bottom: 10px;
      }
      .section-title {
        display: flex;
        justify-content: space-between;
      }
      .review_button {
        position: absolute;
        right: 15px;
      }
      .close_button {
        position: absolute;
        right: 0px;
        bottom: 0px;
      }

      .review_rating {
        width: 90px;
        text-align: center;
      }

      .review_rating i {
        font-size: 15px;
        color: #e89f12;
        display: inline-block;
      }

      .anime__review__item__pic {
        text-align: center;
      }
      #grade_value {
        text-align: right;
      }
      .anime__details__form {
        height: auto;
      }

      #discnt_value {
        display: none;
      }
    </style>
  </head>
  <div class="section-title">
    <h5 style="font-size: 22px">리뷰</h5>
  </div>
  <c:choose>
    <c:when test="${!empty review}">
      <div class="anime__review__item">
        <div class="anime__review__item__pic">
          <img src="/resources/img_userimg/${review.userImg}" alt="" />
          <div class="review_rating">
            <c:forEach var="i" begin="1" end="${review.productGrade}" step="10">
              <i class="fa fa-star"></i>
            </c:forEach>
          </div>
        </div>
        <div class="anime__review__item__text">
          <h6>
            ${review.userNickName} &nbsp;&nbsp;&nbsp;

            <span>${review.reviewRegDate}</span>
          </h6>
          <p id="myContent">${review.reviewContent}</p>
          <div class="anime__details__btn" style="float: right">
            <a
              href="javascript:void(0)"
              onclick="fn_delete(${review.reviewSeq})"
              class="follow-btn"
              style="font-size: 16px"
              >삭제</a
            >
          </div>
        </div>
      </div>
    </c:when>
    <c:otherwise>
      <h1 style="color: white">없거나 이미 삭제된 리뷰입니다.</h1>
    </c:otherwise>
  </c:choose>
  <script src="/resources/js/jquery-3.3.1.min.js"></script>
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
</html>
