<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
  <head>
    <%@include file="/WEB-INF/views/include/head.jsp" %>
    <meta charset="UTF-8" />
    <title>Insert title here</title>
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
    <script>
      $(document).ready(function () {
        // 글목록가져오기
        product_ajax();

        //검색종류 변경시 실행
        $(".search_value").on("change", function () {
          $("#curPage").val(1);
          product_ajax();
          console.log("test");
        });

        //메인태그 선택시 소분류 태그 보이게끔함
        $(".main_tag").on("change", function () {
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

        //검색 밸류초기화
        $("#search_reset").on("click", function () {
          search_reset();
          product_ajax();
        });
        //검색밸류(이름검색, 정렬방법) 변경시 상품검색
        $(".search_box").on("change", function () {
          $("#curPage").val(1);
          product_ajax();
        });
      });

      //에이작스 실행 함수
      function product_ajax() {
        const tagParentNum = $("input[name='main_tag']:checked").val();
        const discntCheck = $("input[name='discntCheck']:checked").val();
        const productName = $("#productName").val();
        const minPrice = $("#minPrice").val();
        const maxPrice = $("#maxPrice").val();
        const curPage = $("#curPage").val();
        const order_value = $("#order_value").val();
        console.log("order_value : " + order_value);
        var tagNum = [];
        if (tagParentNum == "0100") {
          $("input:checkbox[name=action_tag]").each(function (index) {
            if ($(this).is(":checked") == true) {
              tagNum.push($(this).val());
            }
          });
        } else if (tagParentNum == "0200") {
          $("input:checkbox[name=racing_tag]").each(function (index) {
            if ($(this).is(":checked") == true) {
              tagNum.push($(this).val());
            }
          });
        } else if (tagParentNum == "0300") {
          $("input:checkbox[name=fps_tag]").each(function (index) {
            if ($(this).is(":checked") == true) {
              tagNum.push($(this).val());
            }
          });
        } else if (tagParentNum == "0400") {
          $("input:checkbox[name=sim_tag]").each(function (index) {
            if ($(this).is(":checked") == true) {
              tagNum.push($(this).val());
            }
          });
        }
        if (tagNum.length == 0) {
          tagNum.push(" ");
        }

        $.ajax({
          type: "GET",
          url: "/test/productForm",
          data: {
            productName: productName,
            discntCheck: discntCheck,
            orderValue: order_value,
            minPrice: minPrice,
            maxPrice: maxPrice,
            curPage: curPage,
            tagParentNum: tagParentNum,
            tagNum: tagNum,
          },
          datatype: "JSON",
          beforeSend: function (xhr) {
            xhr.setRequestHeader("AJAX", "true");
          },
          success: function (response) {
            var productList = response.data.productList;
            var paging = response.data.paging;

            product_print(productList);
            paging_print(paging);
          },
          error: function () {
            game.common.error(error);
          },
        });
      }
      //페이징 넘버 띄워주는 함수
      function paging_print(paging) {
        if (paging != null) {
          var paging_html = $(".paging");
          paging_html.empty();
          var html = `<ul>
            `;
          if (paging.prevBlockPage != 0) {
            html =
              html +
              `
              <li><a onclick="fn_list(${"${paging.prevBlockPage}"})">이전블럭</a></li>
              `;
          }

          for (var i = paging.startPage; i <= paging.endPage; i++) {
            if (paging.curPage != i) {
              html =
                html + `<li><a onclick="fn_list(${"${i}"})">${"${i}"}</a></li>`;
            } else {
              html = html + `<li>${"${i}"}</li>`;
            }
          }
          if (paging.nextBlockPage != 0) {
            html =
              html +
              `
              <li><a onclick="fn_list(${"${paging.nextBlockPage}"})">다음블럭</a></li>
              `;
          }

          paging_html.append(html);
        }
      }
      //body에 상품목록 띄워주는 함수
      function product_print(productList) {
        const $tbody = $("#product");

        $tbody.empty();
        if (productList.length != 0) {
          for (const t of productList) {
            var count = 0;
            var product_list = `
            <tr>
              <td>${"${t.productName}"}</td>
              <td>${"${t.reviewCnt}"}</td>
              <td>${"${t.productBuyCnt}"}</td>
              <td>${"${t.productGrade}"}</td>
              <td>${"${t.payPrice}"}</td>
            </tr>
            `;

            product_list =
              product_list +
              `<tr>
              `;
            for (const a of t.tagName) {
              count++;
              product_list =
                product_list +
                `<td>${"${a}"}</td>
              `;
              if (count == 5) break;
            }
            product_list =
              product_list +
              `</tr>
            <tr>
              <td colspan="5">
              <hr size="5px" color="white"/>
              </td>
            </tr>`;

            $tbody.append(product_list);
          }
        } else {
          var product_list = `
          <tr>
            <td>상품이 존재하지 않습니다.<td>
          <tr>`;

          $tbody.append(product_list);
        }
      }
      //대분류 변경 시 소분류 체크 해제
      function check_false() {
        $("input:checkbox[name='action_tag']").prop("checked", false);
        $("input:checkbox[name='racing_tag']").prop("checked", false);
        $("input:checkbox[name='fps_tag']").prop("checked", false);
        $("input:checkbox[name='sim_tag']").prop("checked", false);
      }
      //검색종류 초기화 함수
      function search_reset() {
        check_false();
        $("input[name='main_tag']").prop("checked", false);

        $("#minPrice").val("");

        $("#maxPrice").val("");

        $("input[name='discntCheck']").prop("checked", false);

        $("#action_tag_div").css("display", "none");

        $("#racing_tag_div").css("display", "none");

        $("#fps_tag_div").css("display", "none");

        $("#sim_tag_div").css("display", "none");

        $("#curPage").val(1);

        $("#productName").val("");

        // $("#order_value").option(0);
        // $("#order_value").val("").prop("selected", true);
        $("select[name='order_value'] option:eq(0)").prop("selected", true);
        $(".current").html("정렬방법");
      }
      //페이지 이동 함수
      function fn_list(curPage) {
        $("#curPage").val(curPage);
        product_ajax();
      }
    </script>
    <style>
      /*소분류 기본 none*/
      #action_tag_div,
      #racing_tag_div,
      #fps_tag_div,
      #sim_tag_div {
        display: none;
      }

      .product_table {
        margin: 0;
        width: 1000px;
      }
      .product_body {
        display: flex;
        justify-content: space-evenly;
        color: white;
      }
      .search_value {
        width: 150px;
        border: 2px solid wheat;
      }
      input[type="number"]::-webkit-outer-spin-button,
      input[type="number"]::-webkit-inner-spin-button {
        -webkit-appearance: none;
        margin: 0;
      }
      input[type="number"] {
        width: 145px;
      }
      ul {
        list-style: none;
        margin: 0;
        padding: 0;
      }

      li {
        margin: 0 5px 0 5px;
        padding: 0 0 0 0;
        border: 0;
        float: left;
      }
      .product_footer {
        display: flex;
        justify-content: center;
      }
      .paging {
        font-size: 25px;
      }
      .search_box {
        display: flex;
        flex-direction: row-reverse;
        margin: 0 100px 0 0;
      }
      .name_search {
        margin: 0 100px 0 0;
      }
    </style>
  </head>
  <body>
    <%@include file="/WEB-INF/views/include/navigation.jsp" %>
    <div class="search_box">
      <div class="order_search">
        <select name="order_value" id="order_value">
          <option value="">정렬방법</option>
          <option value="price_desc">가격▲</option>
          <option value="price_asc">가격▼</option>
          <option value="grade_desc">평점▲</option>
          <option value="grade_asc">평점▼</option>
        </select>
      </div>
      <div class="name_search" style="color: white">
        게임검색
        <input type="text" id="productName" /><input
          type="button"
          id="nameSearch"
          value="검색"
        />
      </div>
    </div>
    <hr color="white" />
    <div class="product_body">
      <div class="product_table">
        <table width="100%">
          <thead>
            <tr>
              <th>제목</th>
              <th>리뷰 갯수</th>
              <th>구매 횟수</th>
              <th>평점</th>
              <th>가격</th>
            </tr>
            <tr>
              <td colspan="5">
                <hr size="5px" color="white" />
              </td>
            </tr>
          </thead>
          <tbody id="product"></tbody>
        </table>
      </div>
      <div class="search_value">
        할인여부
        <input type="checkbox" name="discntCheck" value="Y" />
        <hr color="white" />
        가격검색<br />
        최소 가격<br />
        <input type="number" id="minPrice" />
        <br />
        최대 가격
        <br />
        <input type="number" id="maxPrice" />
        <hr color="white" />
        상품 태그
        <hr color="white" />
        <input type="radio" name="main_tag" class="main_tag" value="0100" />액션
        <br />
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
          <input
            type="checkbox"
            name="action_tag"
            value="0109"
          />솔로플레이<br />
          <input type="checkbox" name="action_tag" value="0110" />협동<br />
        </div>
        <hr color="white" />
        <input
          type="radio"
          name="main_tag"
          class="main_tag"
          value="0200"
        />레이싱

        <br />
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
          <input
            type="checkbox"
            name="racing_tag"
            value="0208"
          />멀티플레이<br />
          <input type="checkbox" name="racing_tag" value="0209" />비행<br />
          <input
            type="checkbox"
            name="racing_tag"
            value="0210"
          />커스터마이징<br />
        </div>
        <hr color="white" />
        <input type="radio" name="main_tag" class="main_tag" value="0300" />FPS

        <br />
        <div id="fps_tag_div">
          <input type="checkbox" name="fps_tag" value="0301" />1인칭<br />
          <input type="checkbox" name="fps_tag" value="0302" />3인칭<br />
          <input type="checkbox" name="fps_tag" value="0303" />오픈월드<br />
          <input type="checkbox" name="fps_tag" value="0304" />PVP<br />
          <input type="checkbox" name="fps_tag" value="0305" />협동<br />
          <input type="checkbox" name="fps_tag" value="0306" />배틀로얄<br />
          <input type="checkbox" name="fps_tag" value="0307" />공포<br />
          <input
            type="checkbox"
            name="fps_tag"
            value="0308"
          />탄탄한스토리<br />
          <input type="checkbox" name="fps_tag" value="0309" />솔로플레이<br />
          <input type="checkbox" name="fps_tag" value="0310" />사실적인<br />
        </div>
        <hr color="white" />
        <input
          type="radio"
          name="main_tag"
          class="main_tag"
          value="0400"
        />시뮬레이션

        <br />
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
        <hr color="white" />
        <input type="button" value="초기화" id="search_reset" />
      </div>
    </div>
    <div class="product_footer">
      <div class="paging"></div>
    </div>
    <input type="hidden" id="curPage" />
    <br /><br /><br /><br /><br />
    <%@include file="/WEB-INF/views/include/footer.jsp" %>
  </body>
</html>
