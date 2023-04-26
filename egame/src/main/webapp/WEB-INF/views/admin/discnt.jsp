<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%> <%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<!DOCTYPE html>
<html lang="en">
  <head>
    <%@ include file="/WEB-INF/views/include/head.jsp" %>
    <title>할인 관리</title>
    <link rel="stylesheet" href="/resources/css/notice.css" type="text/css" />
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
    <script>
      $(document).ready(function () {
        fn_discnt_ajax();

        $(".notice_menu").on("change", function () {
          $("#curPage").val(1);
          fn_discnt_ajax();
        });

        $("#search_btn").on("click", function () {
          fn_discnt_ajax();
        });
      });

      function fn_discnt_ajax() {
        const searchValue = $("#searchValue").val();
        const discntStatus = $("#discnt_status").val();
        const dateSearch = $("#date_search").val();
        const curPage = $("#curPage").val();

        $.ajax({
          type: "POST",
          url: "/admin/discntAjax",
          data: {
            searchValue: searchValue,
            discntStatus: discntStatus,
            dateSearch: dateSearch,
            curPage: curPage,
          },
          datatype: "JSON",
          beforeSend: function (xhr) {
            xhr.setRequestHeader("AJAX", "true");
          },
          success: function (response) {
            const discntList = response.data.discntList;
            const paging = response.data.paging;
            const curPage = response.data.curPage;
            $("#curPage").val(curPage);

            fn_discnt_list(discntList);
            fn_paging(paging);
          },
          error: function () {
            game.common.error(error);
          },
        });
      }

      function fn_discnt_list(discntList) {
        const discnt_body = $("#discntBody");
        discnt_body.empty();
        if (discntList.length > 0) {
          for (const d of discntList) {
            const discntStatus =
              d.discntStatus == "Y" ? "적용 중" : "미적용 중";
            const productSeq = d.productSeq;
            const discnt_html = `
			<tr>
				<td>${"${d.discntSeq}"}</td>
				<td><a href="javascript:void(0)" onclick="fn_detail(${"'${productSeq}'"})">${"${d.productName}"}</a></td>
				<td>${"${d.discntRate}"}%</td>
				<td>${"${d.discntStartDate}"}</td>
				<td>${"${d.discntEndDate}"}</td>
				<td>${"${discntStatus}"}</td>
				
			</tr>
			`;

            discnt_body.append(discnt_html);
          }
        } else {
          const discnt_html = `
			<tr>
				<td colspan="6"><h1 style="color:white">조건에 맞는 할인이 없습니다.</h1></td>
				
			</tr>
			`;
          discnt_body.append(discnt_html);
        }
      }

      function fn_paging(paging) {
        const pagingBody = $("#paging");

        pagingBody.empty();

        var html = `<ul class="discnt_page">
            `;
        if (paging.prevBlockPage != 0) {
          html =
            html +
            `
              <a href="javascript:void(0)" onclick="fn_list(${"${paging.prevBlockPage}"})"><i class="fa fa-angle-double-left"></i></a>
              `;
        }

        for (var i = paging.startPage; i <= paging.endPage; i++) {
          if (paging.curPage != i) {
            html =
              html +
              `<a href="javascript:void(0)"  onclick="fn_list(${"${i}"})" class="page_link">${"${i}"}</a>`;
          } else {
            html = html + ` <a class="page_link_cur">${"${i}"}</a>`;
          }
        }
        if (paging.nextBlockPage != 0) {
          html =
            html +
            `
              <a href="javascript:void(0)" onclick="fn_list(${"${paging.nextBlockPage}"})"><i class="fa fa-angle-double-right"></i></a>
              `;
        }

        pagingBody.append(html);
      }

      function fn_discnt_before_submit() {
        $.ajax({
          type: "POST",
          url: "/admin/discntBeforeSubmit",
          datatype: "JSON",
          beforeSend: function (xhr) {
            xhr.setRequestHeader("AJAX", "true");
          },
          success: function (response) {
            if (response.code == 0) {
              alert("업데이트 완료. 처리건수 : " + response.data);
              fn_ajax_lode();
            } else if (response.code == 404) {
              alert(response.msg);
              location.reload();
            }
          },
          error: function () {
            game.common.error(error);
          },
        });
      }

      function fn_discnt_end_submit() {
        $.ajax({
          type: "POST",
          url: "/admin/discntEndSubmit",
          datatype: "JSON",
          beforeSend: function (xhr) {
            xhr.setRequestHeader("AJAX", "true");
          },
          success: function (response) {
            if (response.code == 0) {
              alert("업데이트 완료. 처리건수 : " + response.data);
              fn_ajax_lode();
            } else if (response.code == 404) {
              alert(response.msg);
              location.reload();
            }
          },
          error: function () {
            game.common.error(error);
          },
        });
      }

      function fn_list(curPage) {
        $("#curPage").val(curPage);
        fn_discnt_ajax();
      }
      function fn_user_detail(userId) {
        const url = "/admin/userDetail?userId=" + userId;
        var popup = window.open(
          url,
          "_blank",
          "width=1000, height=700, scrollbars=yes, resizable =no"
        );
      }
      function fn_ajax_lode() {
        fn_discnt_ajax();
      }

      //디테일 페이지 이동 함수
      function fn_detail(product_seq) {
        const url = "/admin/productDetail?productSeq=" + product_seq;
        var popup = window.open(
          url,
          "_blank",
          "width=1000, height=1200, scrollbars=yes, resizable =no"
        );
      }
    </script>
    <style>
      tbody tr:hover {
        background-color: #e53637;
      }
      .notice_menu {
        display: flex;
      }
      .notice_search .search_input {
        margin-left: 15px;
      }
      a {
        text-decoration: none;
        color: white;
      }
      .notice_menu,
      .menu1,
      .menu2 {
        display: flex;
      }

      .notice_menu {
        justify-content: space-between;
        margin-bottom: 10px;
      }
      
      .menu2 {
      	height: 42px;
      }
      
      #productStatusHtml {
      	padding: 9px 20px;
      }
      
      .index_page a {
	    width: 42px;
	    height: 37px;
	    padding: 5px;
	    color: #fff;
	    text-align: center;
    }
    .discnt_page {
   		display: inline-flex;
    	text-align: center;
   	}
   	.notice_list
      {
      min-height: 492px;
      }
    </style>
  </head>
  <body>
    <%@ include file="/WEB-INF/views/include/navigationAdmin.jsp" %>

    <div class="space-adaptive"></div>
    <section class="notice_search">
      <div class="search-wrap">
        <input
          type="text"
          id="searchValue"
          class="search_input"
          placeholder="상품 이름을 입력해주세요"
        />
        <button type="button" class="search_btn" id="search_btn">검색</button>
      </div>
    </section>
    <div class="notice_menu">
      <div class="menu1">
        <div class="product__page__filter">
          <select name="discnt_status" id="discnt_status">
            <option value="">적용 여부</option>
            <option value="Y">적용 중</option>
            <option value="N">적용 전</option>
          </select>
        </div>
        <div class="product__page__filter">
          <select name="date_search" id="date_search">
            <option value="">날짜검색</option>
            <option value="before">할인 시작전</option>
            <option value="proceed">할인 중</option>
            <option value="end">할인 종료</option>
          </select>
        </div>
      </div>
      <div class="menu2">
        <div class="anime__details__btn">
          <a
            href="javascript:void(0)"
            class="watch-btn"
            onclick="fn_discnt_before_submit()"
            ><span style="font-size: 16px" id="productStatusHtml"
              >할인 일괄적용</span
            >
          </a>
        </div>
        <div class="anime__details__btn">
          <a
            href="javascript:void(0)"
            class="watch-btn"
            onclick="fn_discnt_end_submit()"
            ><span style="font-size: 16px" id="productStatusHtml"
              >할인 일괄헤제</span
            >
          </a>
        </div>
      </div>
    </div>
    <section class="notice_list">
      <table>
        <thead>
          <tr>
            <th scope="col">할인번호</th>
            <th scope="col">상품 이름</th>
            <th scope="col">할인 율</th>
            <th scope="col">할인 시작날짜</th>
            <th scope="col">할인 종료날짜</th>
            <th scope="col">할인 적용 여부</th>
          </tr>
        </thead>
        <tbody id="discntBody"></tbody>
      </table>
    </section>
    <div class="space-adaptive"></div>
    <section class="notice_bottom">
      <div class="product__pagination22" id="paging" style="color: #fff;"></div>
    </section>
    <div class="space-adaptive"></div>
    <div class="space-adaptive"></div>
    <input type="hidden" id="curPage" />
    <%@ include file="/WEB-INF/views/include/footer.jsp" %>
  </body>
</html>
