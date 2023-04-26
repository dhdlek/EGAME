<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>

<!DOCTYPE html>
<html>
  <head>
  <%@ include file="/WEB-INF/views/include/head.jsp" %>
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
    <meta charset="UTF-8">
    <title>Store eGame : 상품 등록</title>
    <script>
      $(document).ready(function () {
    	  $("#productName").focus();
    	  
    	  $("#productImg").on('change',function(){
    		  var fileName = $("#productImg").val();
    		  $(".product_Img_Input_fake").val(fileName);
    		});
    	  $("#productImg1").on('change',function(){
    		  var fileName = $("#productImg1").val();
    		  $(".product_Img_Input_fake1").val(fileName);
    		});
    	  $("#productImg2").on('change',function(){
    		  var fileName = $("#productImg2").val();
    		  $(".product_Img_Input_fake2").val(fileName);
    		});
    	  $("#productImg3").on('change',function(){
    		  var fileName = $("#productImg3").val();
    		  $(".product_Img_Input_fake3").val(fileName);
    		});
	   	    	
        $("#product_page_btn").click(function(){
           location.href = '/test/product'; 
        });

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
        	
        	$("#product_insert").prop("disabled", true);
        	
        	if($.trim($("#productName").val()).length <= 0)
    		{
    			alert("상품 이름을 입력하세요.");
    			$("#productName").val("");
    			$("#productName").focus();
    			$("#product_insert").prop("disabled", false);
    			return;
    		}
        	
        	if($.trim($("#productPrice").val()).length <= 0)
    		{
    			alert("상품 가격을 입력하세요.");
    			$("#productPrice").val("");
    			$("#productPrice").focus();
    			$("#product_insert").prop("disabled", false);
    			return;
    		}
        	
        	if($("input:checked").length <= 0)
        	{
        		alert("상품 장르를 선택하세요.");
        		$("#product_insert").prop("disabled", false);
        		return;
        	}
        	else if($("input:checked").length <= 1)
       		{
        		alert("상품 태그를 선택하세요.")
        		$("#product_insert").prop("disabled", false);
        		return;
       		}
        	
        	if($.trim($("#productContent").val()).length <= 0)
    		{
    			alert("상품 설명을 입력하세요.");
    			$("#productContent").val("");
    			$("#productContent").focus();
    			$("#product_insert").prop("disabled", false);
    			return;
    		}
        	
       		if(!$("#productImg").val())
			{
       			alert("메인 이미지를 업로드 하세요.");
       			$("#product_insert").prop("disabled", false);
    			return;
			}
       		else if(!$("#productImg1").val() || !$("#productImg2").val() || !$("#productImg3").val())
			{
       			alert("상세 이미지를 모두 업로드 하세요.")
       			$("#product_insert").prop("disabled", false);
    			return;
			}
        	
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
          
          $("#payPrice").val($("#productPrice").val());
		  
  		  var form = $("#productForm")[0];
		  var formData = new FormData(form);
		  
          formData.append("tags[]", tags);
          
          $.ajax({
            type: "POST",
            url: "/test/productInsert",
            data: formData,
            contentType: false,
            processData: false,
            datatype: "JSON",
            beforeSend: function (xhr) {
              xhr.setRequestHeader("AJAX", "true");
            },
            success: function (response) {
              if (response.code == 0) {
                alert("성공");
                location.href = "/user/myPage";
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
            }
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
    <link rel="stylesheet" href="/resources/css/product-reg-form.css" type="text/css">
  </head>
  <body>
  <%@ include file="/WEB-INF/views/include/navigation.jsp" %>
  
    <div class="space-adaptive"></div>
    <section class="product_reg_section">
        <span class="product_reg_section_title">상품 등록하기</span><button class="product_page_btn" id="product_page_btn">상품페이지</button>
        <div class="space-adaptive"></div>
        <form class="product_reg_form" id="productForm" name="productForm" method="post" enctype="multipart/form-data">
            <input class="product_reg_input" type="text" id="userSellerId" name="userSellerId" value="${user.userId}" disabled>
            <div class="space-adaptive"></div>
            <input class="product_reg_input" type="text" id="productName" name="productName" placeholder="상품 이름">
            <div class="space-adaptive"></div>
            <input class="product_reg_input" type="number" id="productPrice" name="productPrice" autocomplete="off" placeholder="상품 가격">
            <div class="space-adaptive"></div>
            <div class="tag_div">
                <div class="main_tag_wrapper">
                    <div class="main_tag_div"><input type="radio" name="main_tag" class="main_tag" value="0100">액션</div>
                    <div class="main_tag_div"><input type="radio" name="main_tag" class="main_tag" value="0200">레이싱</div>
                    <div class="main_tag_div"><input type="radio" name="main_tag" class="main_tag" value="0300">FPS</div>
                    <div class="main_tag_div"><input type="radio" name="main_tag" class="main_tag" value="0400">시뮬레이션</div>
                </div>
                <div id="action_tag_div">
                    <div class="sub_tag_wrapper">
                        <div class="sub_tag_div"><input type="checkbox" id="action_tag" name="action_tag" value="0101">1인칭</div>
                        <div class="sub_tag_div"><input type="checkbox" id="action_tag" name="action_tag" value="0102">3인칭</div>
                        <div class="sub_tag_div"><input type="checkbox" id="action_tag" name="action_tag" value="0103">판타지</div>
                        <div class="sub_tag_div"><input type="checkbox" id="action_tag" name="action_tag" value="0104">귀여운</div>
                        <div class="sub_tag_div"><input type="checkbox" id="action_tag" name="action_tag" value="0105">픽셀</div>
                        <div class="sub_tag_div"><input type="checkbox" id="action_tag" name="action_tag" value="0106">탄탄한스토리</div>
                        <div class="sub_tag_div"><input type="checkbox" id="action_tag" name="action_tag" value="0107">오픈월드</div>
                        <div class="sub_tag_div"><input type="checkbox" id="action_tag" name="action_tag" value="0108">공포</div>
                        <div class="sub_tag_div"><input type="checkbox" id="action_tag" name="action_tag" value="0109">솔로플레이</div>
                        <div class="sub_tag_div"><input type="checkbox" id="action_tag" name="action_tag" value="0110">협동</div>
                    </div>
                </div>
                <div id="racing_tag_div">
                    <div class="sub_tag_wrapper">
                        <div class="sub_tag_div"><input type="checkbox" id="racing_tag" name="racing_tag" value="0201">1인칭</div>
                        <div class="sub_tag_div"><input type="checkbox" id="racing_tag" name="racing_tag" value="0202">3인칭</div>
                        <div class="sub_tag_div"><input type="checkbox" id="racing_tag" name="racing_tag" value="0203">판타지</div>
                        <div class="sub_tag_div"><input type="checkbox" id="racing_tag" name="racing_tag" value="0204">자유로운트랙</div>
                        <div class="sub_tag_div"><input type="checkbox" id="racing_tag" name="racing_tag" value="0205">현실적인</div>
                        <div class="sub_tag_div"><input type="checkbox" id="racing_tag" name="racing_tag" value="0206">오토바이</div>
                        <div class="sub_tag_div"><input type="checkbox" id="racing_tag" name="racing_tag" value="0207">자동차</div>
                        <div class="sub_tag_div"><input type="checkbox" id="racing_tag" name="racing_tag" value="0208">멀티플레이</div>
                        <div class="sub_tag_div"><input type="checkbox" id="racing_tag" name="racing_tag" value="0209">비행</div>
                        <div class="sub_tag_div"><input type="checkbox" id="racing_tag" name="racing_tag" value="0210">커스터마이징</div>
                    </div>
                </div>
                <div id="fps_tag_div">
                    <div class="sub_tag_wrapper">
                        <div class="sub_tag_div"><input type="checkbox" id="fps_tag" name="fps_tag" value="0301">1인칭</div>
                        <div class="sub_tag_div"><input type="checkbox" id="fps_tag" name="fps_tag" value="0302">3인칭</div>
                        <div class="sub_tag_div"><input type="checkbox" id="fps_tag" name="fps_tag" value="0303">오픈월드</div>
                        <div class="sub_tag_div"><input type="checkbox" id="fps_tag" name="fps_tag" value="0304">PVP</div>
                        <div class="sub_tag_div"><input type="checkbox" id="fps_tag" name="fps_tag" value="0305">협동</div>
                        <div class="sub_tag_div"><input type="checkbox" id="fps_tag" name="fps_tag" value="0306">배틀로얄</div>
                        <div class="sub_tag_div"><input type="checkbox" id="fps_tag" name="fps_tag" value="0307">공포</div>
                        <div class="sub_tag_div"><input type="checkbox" id="fps_tag" name="fps_tag" value="0308">탄탄한스토리</div>
                        <div class="sub_tag_div"><input type="checkbox" id="fps_tag" name="fps_tag" value="0309">솔로플레이</div>
                        <div class="sub_tag_div"><input type="checkbox" id="fps_tag" name="fps_tag" value="0310">사실적인</div>
                    </div>
                </div>
                <div id="sim_tag_div">
                    <div class="sub_tag_wrapper">
                        <div class="sub_tag_div"><input type="checkbox" id="sim_tag" name="sim_tag" value="0401">1인칭</div>
                        <div class="sub_tag_div"><input type="checkbox" id="sim_tag" name="sim_tag" value="0402">3인칭</div>
                        <div class="sub_tag_div"><input type="checkbox" id="sim_tag" name="sim_tag" value="0403">스포츠</div>
                        <div class="sub_tag_div"><input type="checkbox" id="sim_tag" name="sim_tag" value="0404">전략</div>
                        <div class="sub_tag_div"><input type="checkbox" id="sim_tag" name="sim_tag" value="0405">농장</div>
                        <div class="sub_tag_div"><input type="checkbox" id="sim_tag" name="sim_tag" value="0406">운전</div>
                        <div class="sub_tag_div"><input type="checkbox" id="sim_tag" name="sim_tag" value="0407">생활</div>
                        <div class="sub_tag_div"><input type="checkbox" id="sim_tag" name="sim_tag" value="0408">건설</div>
                        <div class="sub_tag_div"><input type="checkbox" id="sim_tag" name="sim_tag" value="0409">협동</div>
                        <div class="sub_tag_div"><input type="checkbox" id="sim_tag" name="sim_tag" value="0410">솔로플레이</div>
                    </div>
                </div>
            </div>
            <div class="space-adaptive"></div>
            <div class="textarea_div">
                <textarea class="product_reg_textarea" id="productContent" name="productContent" placeholder="상품 내용(설명)"></textarea></div>
            <div class="space-adaptive"></div>
            <div class="img_upload_div">
            	<div style="position: relative;"><p>메인 이미지</p>
					<label class="product_Img_Label" for="productImg">파일첨부</label>
					<input id="productImg" name="productImg" type="file" style="display:none;" accept=".jpg">
					<input class="product_Img_Input_fake" type="text" placeholder="이미지는 jpg 파일만 업로드할 수 있습니다." readonly tabindex="-1">
           		</div>
           		<div class="space-adaptive"></div>
           		<div class="space-adaptive"></div>
           		<div style="position: relative;"><p>상세 이미지</p>
					<label class="product_Img_Label" for="productImg1">파일첨부</label>
					<input id="productImg1" name="productImg1" type="file" style="display:none;" accept=".jpg">
					<input class="product_Img_Input_fake1" type="text" placeholder="이미지는 jpg 파일만 업로드할 수 있습니다." readonly tabindex="-1">
				<div class="space-adaptive"></div>
					<label class="product_Img_Label" for="productImg2">파일첨부</label>
					<input id="productImg2" name="productImg2" type="file" style="display:none;" accept=".jpg">
					<input class="product_Img_Input_fake2" type="text" placeholder="이미지는 jpg 파일만 업로드할 수 있습니다." readonly tabindex="-1">
				<div class="space-adaptive"></div>
					<label class="product_Img_Label" for="productImg3">파일첨부</label>
					<input id="productImg3" name="productImg3" type="file" style="display:none;" accept=".jpg">
					<input class="product_Img_Input_fake3" type="text" placeholder="이미지는 jpg 파일만 업로드할 수 있습니다." readonly tabindex="-1">
           		</div>
           	</div>
           	<div class="space-adaptive"></div>
            <input class="product_insert_btn" type="button" id="product_insert" value="등록하기">
            <input type="hidden" id="payPrice">
        </form>
    </section>
    <%@ include file="/WEB-INF/views/include/footer.jsp" %>
  </body>
</html>
