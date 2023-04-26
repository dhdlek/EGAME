<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%> <%@ include file="/WEB-INF/views/include/taglib.jsp" %>

<!DOCTYPE html>
<html lang="ko">
  <head>
    <%@ include file="/WEB-INF/views/include/head.jsp" %>
    <title>Store eGame : 회원가입</title>
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
    <script type="text/javascript">
      var email_check_boolean = false;
      var code;
      var businessNumCheck_boolean = false;
      $(document).ready(function () {
        $("#email_check_btn").on("click", function () {
          var emptCheck = /\s/g;
          const userEmail = $("#userEmail").val();

          if ($.trim(userEmail).length <= 0) {
            alert("이메일을 입력해 주세요");
            $("#userEmail").focus();
            return;
          }

          if (emptCheck.test(userEmail)) {
            alert("이메일은 공백을 포함할 수 없습니다.");
            $("#userEmail").focus();
            return;
          }

          if (!fn_validateEmail(userEmail)) {
            alert("사용자 이메일 형식이 올바르지 않습니다.");
            $("#userEmail").focus();
            return;
          }
          //유저 이메일 인증
          $.ajax({
            type: "GET",
            url: "/user/emailCheck",
            data: {
              userEmail: userEmail,
            },
            datatype: "JSON",
            beforeSend: function (xhr) {
              xhr.setRequestHeader("AJAX", "true");
            },
            success: function (response) {
              if (response.code == 400) {
                alert(response.msg);
                return;
              } else if (response.code == -1) {
                alert(response.msg);
                return;
              }

              alert("인증번호가 전송되었습니다.");

              $("#email_check_div").css("display", "block");
              $("#userEmail").attr("disabled", true);
              $("#email_check_btn").attr("disabled", true);

              code = response.data;
            },
            error: function (xhr, status, error) {
              icia.common.error(error);
            },
          });
        });

        //인증번호 확인 함수
        $("#cer_num_check").on("click", function () {
          const cer_code = $("#cer_check").val();

          if (code == cer_code) {
            $("#cer_num_check_div")
              .html("인증이 완료되었습니다.")
              .css("color", "green");
            $("#email_check_btn").attr("disabled", true);
            $("#cer_num_check").attr("disabled", true);

            $("#cer_check").attr("disabled", true);
            email_check_boolean = true;
          } else {
            $("#cer_num_check_div")
              .html("인증번호가 틀립니다.")
              .css("color", "red");
          }
        });
      });

      function fn_userRegChk() {
        //모든 공백 체크 정규식
        var checkbox = document.getElementById("userClass");
        var is_checked = checkbox.checked;
        var emptCheck = /\s/g;
        //영문 대소문자, 숫자로만 이루어진 4~12자리 정규식
        var idPwCheck = /^[a-zA-Z0-9]{4,12}$/;
		//사용자 이름 정규식
		var nameCheck = /^[가-힣]{2,6}$/;

        if ($.trim($("#userId").val()).length <= 0) {
          alert("사용자 아이디를 입력하세요.");
          $("#userId").val("");
          $("#userId").focus();
          return;
        }

        if (emptCheck.test($("#userId").val())) {
          alert("사용자 아이디는 공백을 포함할 수 없습니다.");
          $("#userId").focus();
          return;
        }

        if (!idPwCheck.test($("#userId").val())) {
          alert(
            "사용자 아이디는 4~12자의 영문 대소문자와 숫자로만 입력하세요."
          );
          $("#userId").focus();
          return;
        }

        if ($.trim($("#userPwd1").val()).length <= 0) {
          alert("비밀번호를 입력하세요.");
          $("#userPwd1").val("");
          $("#userPwd1").focus();
          return;
        }

        if (emptCheck.test($("#userPwd1").val())) {
          alert("비밀번호는 공백을 포함할 수 없습니다.");
          $("#userPwd1").focus();
          return;
        }

        if (!idPwCheck.test($("#userPwd1").val())) {
          alert("비밀번호는 영문 대소문자와 숫자로 4~12자리 입니다.");
          $("#userPwd1").focus();
          return;
        }

        if ($("#userPwd1").val() != $("#userPwd2").val()) {
          alert("비밀번호가 일치하지 않습니다.");
          $("#userPwd2").focus();
          return;
        }

        if ($.trim($("#userName").val()).length <= 0) {
          alert("사용자 이름을 입력하세요.");
          $("#userName").val("");
          $("#userName").focus();
          return;
        }
        
        if(!nameCheck.test($("#userName").val()))
		{
			alert("사용자 이름은 한글을 사용하여 2~6자리로 입력하세요.");
			$("#userName").focus();
			return;
		}

        if (!fn_validateEmail($("#userEmail").val())) {
          alert("사용자 이메일 형식이 올바르지 않습니다.");
          $("#userEmail").focus();
          return;
        }

        if (email_check_boolean == false) {
          alert("이메일 인증을 완료해야 회원가입을 할 수 있습니다.");
          $("#userEmail").focus();
          return;
        }
        if (is_checked == true) {
          if (businessNumCheck_boolean == false) {
            alert("사업자번호 중복체크를 완료해 주세요");
            $("#userEmail").focus();
            return;
          }
        }
        $("#userPwd").val($("#userPwd1").val());

        //중복 아이디 체크 ajax
        $.ajax({
          type: "POST",
          url: "/user/idCheck",
          data: {
            userId: $("#userId").val(),
          },
          datatype: "JSON",
          beforeSend: function (xhr) {
            xhr.setRequestHeader("AJAX", "true");
          },
          success: function (response) {
            if (response.code == 0) {
              fn_userReg();
            } else if (response.code == 100) {
              alert("중복된 아이디 입니다.");
              $("#userId").focus();
            } else if (response.code == 400) {
              alert("파라미터 값이 올바르지 않습니다.");
              $("#userId").focus();
            } else {
              alert("오류가 발생하였습니다.");
              $("#userId").focus();
            }
          },
          error: function (xhr, status, error) {
            icia.common.error(error);
          },
        });
      }

      $(document).ready(function () {
        $("input:checkbox[name=userClass]").change(function () {
          var checkbox = document.getElementById("userClass");
          var is_checked = checkbox.checked;
          var app_condition = $(this).val();
          console.log("작동");
          if (is_checked == true) {
            $("#businessNumBox").css("display", "block");
          } else if (is_checked == false) {
            $("#businessNumBox").css("display", "none");
          }
        });
      });

      function fn_userReg2() {
        const businessNum = $("#businessNum").val();
        var check = /^[0-9]+$/;
        if (!(businessNum.length == 20)) {
          alert("사업자 번호는 20자이여야 합니다.");

          return;
        }

        if (!check.test(businessNum)) {
          alert("사업자 번호는 숫자만 입력해주세요.");
          return;
        }

        $.ajax({
          type: "POST",
          url: "/user/businessNumCheck",
          data: {
            userBusinessNum: businessNum,
          },
          datatype: "JSON",
          beforeSend: function (xhr) {
            xhr.setRequestHeader("AJAX", "true");
          },
          success: function (response) {
            if (response.code == 0) {
              alert("사용가능한 사업자번호 입니다.");
              businessNumCheck_boolean = true;
              $("#businessNum").attr("disabled", true);
            } else if (response.code == 100) {
              alert("중복된 사업자번호 입니다.");
              $("#businessNum").focus();
            } else if (response.code == 400) {
              alert("파라미터 값이 올바르지 않습니다.");
              $("#businessNum").focus();
            } else {
              alert("오류가 발생하였습니다.");
              $("#businessNum").focus();
            }
          },
          error: function (xhr, status, error) {
            icia.common.error(error);
          },
        });
      }

      function fn_userReg() {
        var checkbox = document.getElementById("userClass");
        var is_checked = checkbox.checked;
        var userClass = "N";
        var check = /^[0-9]+$/;
        const userBusinessNum = $("#businessNum").val();

        if (is_checked == true) {
          userClass = "Y";
          if (!(userBusinessNum.length == 20)) {
            alert("사업자 번호는 20자이여야 합니다.");

            return;
          }

          if (!check.test(userBusinessNum)) {
            alert("사업자 번호는 숫자만 입력해주세요.");
            return;
          }
        }

        $.ajax({
          type: "POST",
          url: "/user/regProc",
          data: {
            userId: $("#userId").val(),
            userPwd: $("#userPwd").val(),
            userName: $("#userName").val(),
            userEmail: $("#userEmail").val(),
            userNickname: $("#userNickname").val(),
            userClass: userClass,
            userBusinessNum: userBusinessNum,
          },
          datatype: "JSON",
          beforeSend: function (xhr) {
            xhr.setRequestHeader("AJAX", "true");
          },
          success: function (response) {
            if (response.code == 0) {
              alert("회원 가입이 되었습니다.");
              location.href = "/user/login";
            } else if (response.code == 100) {
              alert("회원 아이디가 중복 되었습니다.");
              $("#userId").focus();
            } else if (response.code == 400) {
              alert("파라미터 값이 올바르지 않습니다.");
              $("#userId").focus();
            } else if (response.code == 500) {
              alert("회원 가입 중 오류가 발생하였습니다.");
              $("#userId").focus();
            } else {
              alert("회원 가입중 오류 발생");
              $("#userId").focus();
            }
          },
          error: function (xhr, status, error) {
            icia.common.error(error);
          },
        });
      }

      function fn_validateEmail(value) {
        var emailReg = /^([\w-\.]+@([\w-]+\.)+[\w-]{2,4})?$/;

        return emailReg.test(value);
      }
    </script>
    <style>
      #email_check_div {
        display: none;
      }
    </style>
  </head>

  <body>
    <%@ include file="/WEB-INF/views/include/navigation.jsp" %>

    <!-- Normal Breadcrumb Begin -->
    <section
      class="normal-breadcrumb set-bg"
      data-setbg="/resources/img_html/normal-breadcrumb.jpg"
    >
      <div class="container">
        <div class="row">
          <div class="col-lg-12 text-center">
            <div class="normal__breadcrumb__text">
              <h2>회원가입</h2>
              <p>EGAME에 오신걸 환영합니다.</p>
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
            <div class="login__form" style="padding-left: 370px">
              <h3>회원가입</h3>
              <form action="/user/login">
                <div class="input__item">
                  <input type="text" id="userId" placeholder="아이디" />
                  <span class="icon_profile"></span>
                </div>
                <div class="input__item">
                  <input type="password" id="userPwd1" placeholder="비밀번호" />
                  <span class="icon_lock"></span>
                </div>
                <div class="input__item">
                  <input
                    type="password"
                    id="userPwd2"
                    placeholder="비밀번호 확인"
                  />
                  <span class="icon_lock"></span>
                </div>
                <div class="input__item">
                  <input type="text" id="userName" placeholder="이름" />
                  <span class="icon_profile"></span>
                </div>
                <div class="input__item">
                  <input type="text" id="userNickname" placeholder="닉네임" />
                  <span class="icon_profile"></span>
                </div>
                <div class="input__item" style="margin-bottom: 0">
                  <input type="text" id="userEmail" placeholder="이메일" />
                  <span class="icon_mail"></span>
                </div>

                <button
                  class="btn btn-success"
                  type="button"
                  style="margin-top: 0; margin-bottom: 20px"
                  id="email_check_btn"
                >
                  이메일 인증
                </button>
                <div id="email_check_div" style="width: 370px">
                  <div class="input__item" style="margin-bottom: 0">
                    <input
                      type="text"
                      id="cer_check"
                      placeholder="인증번호 입력"
                    />
                    <span class="icon_mail"></span>
                  </div>
                  <div style="width: 100%">
                    <button
                      class="btn btn-info"
                      type="button"
                      style="margin-top: 0; margin-bottom: 20px"
                      id="cer_num_check"
                    >
                      인증번호 확인
                    </button>
                    <span style="font-size: 15px" id="cer_num_check_div"></span>
                  </div>
                </div>
                <div>
                  <input
                    type="checkbox"
                    name="userClass"
                    id="userClass"
                    value="5"
                  />
                  <span style="color: rgb(180, 179, 179)"
                    >상품을 판매합니까?</span
                  >
                  <span style="color: rgb(181, 5, 5)">예</span>
                </div>
                <div
                  class="input__item"
                  id="businessNumBox"
                  style="display: none"
                >
                  <label style="position: relative">
                    <input
                      type="text"
                      placeholder="사업자등록번호"
                      id="businessNum"
                      style="width: 370px"
                      value=""
                    />
                    <span class="icon_lock"></span>
                    <button
                      type="button"
                      onclick="fn_userReg2()"
                      style="
                        position: absolute;
                        right: 5px;
                        border-radius: 5px;
                        border: none;
                        background-color: #212483;
                        color: white;
                      "
                    >
                      중복체크
                    </button>
                  </label>
                </div>
                <input type="hidden" id="userPwd" name="userPwd" value="" />
                <button
                  type="button"
                  id="btnReg"
                  class="site-btn"
                  onclick="fn_userRegChk()"
                >
                  회원가입
                </button>
              </form>
              <h5>아이디가 있습니까? <a href="/user/login">로그인</a></h5>
            </div>
          </div>
        </div>
      </div>
    </section>
    <!-- Signup Section End -->

    <%@ include file="/WEB-INF/views/include/footer.jsp" %>
  </body>
</html>
