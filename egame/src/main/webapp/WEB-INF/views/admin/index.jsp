<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%> <%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<!DOCTYPE html>
<html lang="en">
  <head>
    <%@ include file="/WEB-INF/views/include/head.jsp" %>
    <title>유저 관리</title>
    <link rel="stylesheet" href="/resources/css/notice.css" type="text/css" />
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
    <script>
      $(document).ready(function () {
        fn_user_ajax();

        $(".notice_menu").on("change", function () {
          $("#curPage").val(1);
          fn_user_ajax();
        });

        $("#search_btn").on("click", function () {
          fn_user_ajax();
        });
      });

      function fn_user_ajax() {
        const searchType = $("#search_type").val();
        const searchValue = $("#searchValue").val();
        const userStatus = $("#user_status").val();
        const userClass = $("#user_class").val();
        const curPage = $("#curPage").val();

        $.ajax({
          type: "POST",
          url: "/admin/user",
          data: {
            searchType: searchType,
            searchValue: searchValue,
            userStatus: userStatus,
            userClass: userClass,
            curPage: curPage,
          },
          datatype: "JSON",
          beforeSend: function (xhr) {
            xhr.setRequestHeader("AJAX", "true");
          },
          success: function (response) {
            const userList = response.data.userList;
            const paging = response.data.paging;
            const curPage = response.data.curPage;
            $("#curPage").val(curPage);

            fn_user_list(userList);
            fn_paging(paging);
          },
          error: function () {
            game.common.error(error);
          },
        });
      }

      function fn_user_list(userList) {
        const user_body = $("#userBody");
        console.log(1231);
        user_body.empty();
        var userId;
        if (userList.length > 0) {
          for (const u of userList) {
            const userStatus = u.userStatus == "1" ? "정상" : "정지";
            const userClass = u.userClass == "u" ? "사용자" : "판매자";
            userId = u.userId;
            const user_html = `
			<tr onclick="fn_user_detail(${"'${userId}'"})">
				<td><a href="javascript:void(0)">${"${userId}"}</a></td>
				<td>${"${u.userEmail}"}</td>
				<td>${"${u.userNickname}"}</td>
				<td>${"${u.userRegDate}"}</td>
				<td>${"${userStatus}"}</td>
				<td>${"${userClass}"}</td>
				
			</tr>
			`;

            user_body.append(user_html);
          }
        } else {
          const user_html = `
			<tr>
				<td colspan="6"><h1 style="color:white">조건에 맞는 유저가 없습니다.</h1></td>
				
			</tr>
			`;
          user_body.append(user_html);
        }
      }

      function fn_paging(paging) {
        const pagingBody = $("#paging");

        pagingBody.empty();

        var html = `<ul class="index_page">
            `;
        if (paging.prevBlockPage != 0) {
          html =
            html +
            `
              <a href="javascript:void(0)" onclick="fn_list(${"${paging.prevBlockPage}"})"><i class="fa fa-angle-double-left"></i></a>
              `;
        }

        if(paging.startPage !=0)
       	{
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
       	}

        pagingBody.append(html);
      }
      function fn_list(curPage) {
        $("#curPage").val(curPage);
        fn_user_ajax();
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
        fn_user_ajax();
      }
    </script>
    <style>
      tbody tr:hover {
        background-color: #e53637;
      }
      .notice_menu {
        display: flex;
        margin-bottom: 10px;
      }
      .notice_search .search_input {
        margin-left: 15px;
      }
      a {
        text-decoration: none;
        color: white;
      }
      a:hover {
        color: black;
      }
      
		.index_page {
			display: inline-flex;
		}
		
		.index_page a {
			width: 42px;
		    height: 37px;
		    padding: 5px;
		    color: #fff;
		    text-align: center
	    }
	   	
	   	.page_link_cur {
	   		background-color: #e53637;
		    cursor: default;
		    margin-left: 2px;
		    margin-right: 2px;
	   	}
      .notice_list
      {
      min-height: 470px;
      }
    </style>
  </head>
  <body>
    <%@ include file="/WEB-INF/views/include/navigationAdmin.jsp" %>

    <div class="space-adaptive"></div>
    <section class="notice_search">
      <div class="product__page__filter">
        <select name="search_type" id="search_type">
          <option value="">검색종류</option>
          <option value="userId">유저 아이디</option>
          <option value="userNickname">유저 닉네임</option>
          <option value="userEmail">유저 이메일</option>
        </select>
      </div>
      <div class="search-wrap">
        <input
          type="text"
          id="searchValue"
          class="search_input"
          placeholder="검색어를 입력해주세요"
        />
        <button type="button" class="search_btn" id="search_btn">검색</button>
      </div>
    </section>
    <div class="notice_menu">
      <div class="product__page__filter">
        <select name="user_status" id="user_status">
          <option value="">유저상태</option>
          <option value="1">정상</option>
          <option value="0">정지</option>
        </select>
      </div>
      <div class="product__page__filter">
        <select name="user_class" id="user_class">
          <option value="">유저계층</option>
          <option value="u">사용자</option>
          <option value="s">판매자</option>
        </select>
      </div>
    </div>
    <section class="notice_list">
      <table>
        <thead>
          <tr>
            <th scope="col">유저 아이디</th>
            <th scope="col">유저 이메일</th>
            <th scope="col">유저 닉네임</th>
            <th scope="col">생성날짜</th>
            <th scope="col">유저 상태</th>
            <th scope="col">유저 계층</th>
          </tr>
        </thead>
        <tbody id="userBody"></tbody>
      </table>
    </section>
    <div class="space-adaptive"></div>
    <section class="notice_bottom">
      <div id="paging"></div>
    </section>
    <div class="space-adaptive"></div>
    <div class="space-adaptive"></div>
    <input type="hidden" id="curPage" />
    <%@ include file="/WEB-INF/views/include/footer.jsp" %>
  </body>
</html>
