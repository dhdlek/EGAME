<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%> <%@ include file="/WEB-INF/views/include/taglib.jsp" %>

<!DOCTYPE html>
<html lang="ko">
  <head>
    <%@ include file="/WEB-INF/views/include/head.jsp" %>
    <title>Store eGame : 회원정보 수정</title>
    <script src="https://code.jquery.com/jquery-3.4.1.js"></script>
    <script>
      $(document).ready(function () {
        const userStatus = $("#userStatus").val();
        const userClass = $("#userClass").val();
        const businessNum = $("#businessNum").val();
        if (userStatus == "1") {
          $(".current").html("정상");
          $("select[name='user_status'] option:eq(0)").prop("selected", true);
        } else if (userStatus == "0") {
          $(".current").html("정지");
          $("select[name='user_status'] option:eq(1)").prop("selected", true);
        }

        if (userClass == "u") {
          $("#userClassHtml").html("사용자");
        } else if (userClass == "s") {
          $("#userClassHtml").html("판매자");
          $("#businessNumHtml").html("사업자 번호 : " + businessNum);
        }
        $("#update").on("click", function () {
          fn_user_update();
        });
      });

      function fn_user_update() {
        const userId = $("#userId").val();
        const userStatus = $("#user_status").val();
        $.ajax({
          type: "POST",
          url: "/admin/userUpdate",
          data: {
            userId: userId,
            userStatus: userStatus,
          },
          datatype: "JSON",
          beforeSend: function (xhr) {
            xhr.setRequestHeader("AJAX", "true");
          },
          success: function (response) {
            if (response.code == 0) {
              opener.parent.fn_ajax_lode();
              location.reload();
            } else if (response.code == 400) {
              alert(response.msg);

              window.close();
            } else if (response.code == 404) {
              alert(response.msg);
              window.close();
            } else if (response.code == 500) {
              alert(response.msg);
              window.close();
            }
          },
          error: function () {
            game.common.error(error);
          },
        });
      }
    </script>
    <style>
      .anime__details__widget ul li {
        font-size: 20px;
      }
      li {
        margin-bottom: 20px;
      }
      #update {
        position: absolute;
        right: 25px;
        bottom: 160px;
      }
    </style>
  </head>

  <body>
    <!-- Anime Section Begin -->
    <section
      class="anime-details spad"
      style="min-height: 600px; margin-top: 50px"
    >
      <div class="container">
        <div class="anime__details__content">
          <div class="row">
            <div class="col-lg-3">
              <div
                class="anime__details__pic set-bg"
                style="
                  background-image: url(../resources/img_userimg/${user.userImg});
                "
                style="height: 300px"
              ></div>
            </div>
            <div class="col-lg-9">
              <div class="anime__details__text">
                <div class="anime__details__title">
                  <span>유저 아이디 : ${user.userId}</span>
                  <span>유저 닉네임 : ${user.userNickname}</span>
                  <span>유저 이메일 : ${user.userEmail}</span>
                </div>

                <div class="anime__details__widget">
                  <div class="row">
                    <div class="col-lg-6 col-md-6">
                      <ul>
                        <li>보유 게임 : ${countGame}</li>
                        <li>보유 포인트 : ${user.pointPos}</li>
                        <li>친구 : ${countFriend}</li>
                        <li>유저 계층 : <span id="userClassHtml"></span></li>
                        <li id="businessNumHtml"></li>
                        <li>
                          <div class="product__page__filter">
                            <select name="user_status" id="user_status">
                              <option value="1">정상</option>
                              <option value="0">정지</option>
                            </select>
                          </div>
                        </li>
                      </ul>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
        <input class="site-btn" type="button" id="update" value="수정하기" />
      </div>
    </section>
    <!-- Anime Section End -->
    <input type="hidden" id="userStatus" value="${user.userStatus}" />
    <input type="hidden" id="userClass" value="${user.userClass}" />
    <input type="hidden" id="businessNum" value="${user.businessNum}" />
    <input type="hidden" id="userId" value="${user.userId}" />
  </body>
</html>
