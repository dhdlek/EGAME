<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
  <head>
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
    <meta charset="UTF-8" />
    <title>Insert title here</title>
    <script>
      $(document).ready(function () {
        $(".main_tag").on("change", function () {
          //#action_tag_div

          if ($("input[name='main_tag']:checked").val() == "0100") {
            check_false();
            $("#action_tag_div").css("display", "block");
            $("#racing_tag_div").css("display", "none");
            $("#fps_tag_div").css("display", "none");
            $("#sim_tag_div").css("display", "none");
          } else if ($("input[name='main_tag']:checked").val() == "0200") {
            check_false();
            $("#action_tag_div").css("display", "none");
            $("#racing_tag_div").css("display", "block");
            $("#fps_tag_div").css("display", "none");
            $("#sim_tag_div").css("display", "none");
          } else if ($("input[name='main_tag']:checked").val() == "0300") {
            check_false();
            $("#action_tag_div").css("display", "none");
            $("#racing_tag_div").css("display", "none");
            $("#fps_tag_div").css("display", "block");
            $("#sim_tag_div").css("display", "none");
          } else if ($("input[name='main_tag']:checked").val() == "0400") {
            check_false();
            $("#action_tag_div").css("display", "none");
            $("#racing_tag_div").css("display", "none");
            $("#fps_tag_div").css("display", "none");
            $("#sim_tag_div").css("display", "block");
          }
        });

        $("#product_insert").on("click", function () {
          var tags = [];
          if ($("input[name='main_tag']:checked").val() == "0100") {
            tags.push("0100");
            $("input:checkbox[name=action_tag]").each(function (index) {
              if ($(this).is(":checked") == true) {
                tags.push($(this).val());
              }
            });
          } else if ($("input[name='main_tag']:checked").val() == "0200") {
            tags.push("0200");
            $("input:checkbox[name=racing_tag]").each(function (index) {
              if ($(this).is(":checked") == true) {
                tags.push($(this).val());
              }
            });
          } else if ($("input[name='main_tag']:checked").val() == "0300") {
            tags.push("0300");
            $("input:checkbox[name=fps_tag]").each(function (index) {
              if ($(this).is(":checked") == true) {
                tags.push($(this).val());
              }
            });
          } else if ($("input[name='main_tag']:checked").val() == "0400") {
            tags.push("0400");
            $("input:checkbox[name=sim_tag]").each(function (index) {
              if ($(this).is(":checked") == true) {
                tags.push($(this).val());
              }
            });
          }
          $("#payPrice").val($("#productPrice"));

          $.ajax({
            type: "POST",
            url: "/test/productInsert",
            data: {
              productName: $("#productName").val(),
              productContent: $("#productContent").val(),
              userSellerId: $("#userSellerId").val(),
              productPrice: $("#productPrice").val(),
              payPrice: $("#productPrice").val(),
              tags: tags,
            },
            datatype: "JSON",
            beforeSend: function (xhr) {
              xhr.setRequestHeader("AJAX", "true");
            },
            success: function (response) {
              if (response.code == 0) {
                alert("성공");
                location.reload();
                return;
              } else if (response.code == 400) {
                alert("파라미터값이 잘못되었습니다");
                return;
              } else if (response.code == 500) {
                alert("인서트중 에러발생");
                return;
              }
            },
            error: function () {
              game.common.error(error);
            },
          });
        });
      });
      function check_false() {
        $("input:checkbox[name='action_tag']").prop("checked", false);
        $("input:checkbox[name='racing_tag']").prop("checked", false);
        $("input:checkbox[name='fps_tag']").prop("checked", false);
        $("input:checkbox[name='sim_tag']").prop("checked", false);
      }
    </script>
    <style>
      #action_tag_div,
      #racing_tag_div,
      #fps_tag_div,
      #sim_tag_div {
        display: none;
      }
    </style>
  </head>
  <body>
    <a href="/test/product">상품 페이지</a>
    <h1 id="test"></h1>
    <form action="/test/productInsert" method="post">
      상품 제목 : <input type="text" id="productName" /><br />
      상품 내용 :
      <textarea id="productContent" rows="30px" cols="100px"></textarea><br />
      판매자아이디 : <input type="text" id="userSellerId" /><br />
      상품 가격 : <input type="text" id="productPrice" /><br />

      상품 태그<br />
      <input
        type="radio"
        name="main_tag"
        class="main_tag"
        value="0100"
      />액션<br />
      <div id="action_tag_div">
        <input type="checkbox" name="action_tag" value="0101" />1인칭<br />
        <input type="checkbox" name="action_tag" value="0102" />3인칭<br />
        <input type="checkbox" name="action_tag" value="0103" />판타지<br />
        <input type="checkbox" name="action_tag" value="0104" />귀여운<br />
        <input type="checkbox" name="action_tag" value="0105" />픽셀<br />
        <input
          type="checkbox"
          name="action_tag"
          value="0106"
        />탄탄한스토리<br />
        <input type="checkbox" name="action_tag" value="0107" />오픈월드<br />
        <input type="checkbox" name="action_tag" value="0108" />공포<br />
        <input type="checkbox" name="action_tag" value="0109" />솔로플레이<br />
        <input type="checkbox" name="action_tag" value="0110" />협동<br />
      </div>
      <input
        type="radio"
        name="main_tag"
        class="main_tag"
        value="0200"
      />레이싱<br />
      <div id="racing_tag_div">
        <input type="checkbox" name="racing_tag" value="0201" />1인칭<br />
        <input type="checkbox" name="racing_tag" value="0202" />3인칭<br />
        <input type="checkbox" name="racing_tag" value="0203" />판타지<br />
        <input
          type="checkbox"
          name="racing_tag"
          value="0204"
        />자유로운트랙<br />
        <input type="checkbox" name="racing_tag" value="0205" />현실적인<br />
        <input type="checkbox" name="racing_tag" value="0206" />오토바이<br />
        <input type="checkbox" name="racing_tag" value="0207" />자동차<br />
        <input type="checkbox" name="racing_tag" value="0208" />멀티플레이<br />
        <input type="checkbox" name="racing_tag" value="0209" />비행<br />
        <input
          type="checkbox"
          name="racing_tag"
          value="0210"
        />커스터마이징<br />
      </div>
      <input
        type="radio"
        name="main_tag"
        class="main_tag"
        value="0300"
      />FPS<br />
      <div id="fps_tag_div">
        <input type="checkbox" name="fps_tag" value="0301" />1인칭<br />
        <input type="checkbox" name="fps_tag" value="0302" />3인칭<br />
        <input type="checkbox" name="fps_tag" value="0303" />오픈월드<br />
        <input type="checkbox" name="fps_tag" value="0304" />PVP<br />
        <input type="checkbox" name="fps_tag" value="0305" />협동<br />
        <input type="checkbox" name="fps_tag" value="0306" />배틀로얄<br />
        <input type="checkbox" name="fps_tag" value="0307" />공포<br />
        <input type="checkbox" name="fps_tag" value="0308" />탄탄한스토리<br />
        <input type="checkbox" name="fps_tag" value="0309" />솔로플레이<br />
        <input type="checkbox" name="fps_tag" value="0310" />사실적인<br />
      </div>
      <input
        type="radio"
        name="main_tag"
        class="main_tag"
        value="0400"
      />시뮬레이션<br />
      <div id="sim_tag_div">
        <input type="checkbox" name="sim_tag" value="0401" />1인칭<br />
        <input type="checkbox" name="sim_tag" value="0402" />3인칭<br />
        <input type="checkbox" name="sim_tag" value="0403" />스포츠<br />
        <input type="checkbox" name="sim_tag" value="0404" />전략<br />
        <input type="checkbox" name="sim_tag" value="0405" />농장<br />
        <input type="checkbox" name="sim_tag" value="0406" />운전<br />
        <input type="checkbox" name="sim_tag" value="0407" />생활<br />
        <input type="checkbox" name="sim_tag" value="0408" />건설<br />
        <input type="checkbox" name="sim_tag" value="0409" />협동<br />
        <input type="checkbox" name="sim_tag" value="0410" />솔로플레이<br />
      </div>
      <input type="button" id="product_insert" value="전송" /><br />
      <input type="hidden" id="payPrice" />
    </form>
  </body>
</html>
