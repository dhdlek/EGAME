p<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%> <%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<!DOCTYPE html>
<html lang="ko">
  <head>
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
    <%@ include file="/WEB-INF/views/include/head.jsp" %>
    <title>Store eGame : 게임</title>
    <style>
      ul {
        list-style: none;
        margin-left: 15px;
      }
      li {
        margin-right: 10px;
        margin-bottom: 10px;
      }
      .section-title
      {
        display: flex;
        justify-content: space-between;

      }
      .review_button
      {
       position:absolute;
       right: 15px;
       
      }
      .close_button
      {
        position: absolute;
        right: 0px;
        bottom: 0px;
      }

      .review_rating
      {
        width: 90px;
        text-align: center;
      }

      .review_rating i 
      {
        font-size: 15px;
        color: #e89f12;
        display: inline-block;
      }

      .anime__review__item__pic{
          text-align: center;
      }
      #grade_value
      {
        text-align: right;
      }
      .anime__details__form
      {
        height: auto;
      }
      
      #discnt_value
      {
        display: none;
      }
    </style>
    
  </head>

  <body>
    <c:if test="${!empty product}">
      <!-- Breadcrumb Begin -->
      <div class="breadcrumb-option">
        <div class="container">
          <div class="row">
            <div class="col-lg-12">
              <div class="breadcrumb__links">
                <a href="./index.html"><i class="fa fa-home"></i> Home</a>
                <a href="./categories.html">스토어</a>
                <span>${product.productName}</span>
              </div>
            </div>
          </div>
        </div>
      </div>
      <!-- Breadcrumb End -->

      <!-- Hero Section Begin -->
      <section class="hero">
        <div class="container">
          <div class="detail__hero__items">
            <div id="detailMain"></div>
            <div class="detail__img">
              <img
                src="/resources/img_gamedetail/${product.productName}_1.jpg"
                width="100"
                height="56.2"
                id="img1"
                style="padding-right: 10px"
              />
              <img
                src="/resources/img_gamedetail/${product.productName}_2.jpg"
                width="100"
                height="56.2"
                id="img2"
                style="padding-right: 10px"
              />
              <img
                src="/resources/img_gamedetail/${product.productName}_3.jpg"
                width="100"
                height="56.2"
                id="img3"
                style="padding-right: 10px"
              />
            </div>
          </div>
        </div>
      </section>
      <!-- Hero Section End -->

      <!-- Anime Section Begin -->
      <section class="anime-details spad">
        <div class="container">
          <div class="anime__details__content">
            <div class="row">
              <div class="col-lg-12">
                <div class="anime__details__text">
                  <div class="anime__details__title">
                    <h2 style="color: white">${product.productName} </h2>
                  </div>
                  <div class="anime__details__rating">
                    <div class="rating" id="rating">
                     
                    </div>
                    <span id="grade_value"></span>
                  </div>
                  <p style="font-size: 20px">${product.productContent}</p>
                  <div class="anime__details__widget">
                    <div class="row" style="justify-content: space-between">
                      <div class="product__item__text">
                        <ul>
                          <c:forEach
                            var="tagName"
                            items="${product.tagName}"
                            varStatus="status"
                          >
                            <li>${tagName}</li>
                          </c:forEach>
                        </ul>
                      </div>
                      <div>
                        <h2 style="color: white"> ₩${product.printPayPrice}</h2>
                      </div>
                    </div>
                  </div>
                  <div class="anime__details__btn" style="float: right">
                            <a href="javascript:void(0)" class="watch-btn" onclick="fn_productUpdate()"
                            ><span style="font-size: 16px" id="productStatusHtml"></span>
                            <i class="fa fa-angle-right" style="font-size: 25px"></i
                        ></a>
                  </div>
                </div>
                <div style="color:white">
                    할인 설정하기:
                    <input type="checkbox" id="discnt_set" <c:if test="${!empty discntCheck}">checked</c:if>>
                    <div id="discnt_value">
                        <ul>
                            <li>
                                할인율 : <input type="number" id="discnt_rate" min="1" max="100" <c:if test="${!empty discntCheck}"> value="${discntCheck.discntRate}"</c:if>>
                            </li>
                            <li>
                               시작날짜 : <input type="date" id="discnt_start_date" <c:if test="${!empty discntCheck}"> value="${discntCheck.discntStartDate}"</c:if>>
                            </li>
                            <li>
                              종료날짜 : <input type="date" id="discnt_end_date" <c:if test="${!empty discntCheck}"> value="${discntCheck.discntEndDate}"</c:if>>
                            </li>
                            <li>
                                <c:choose>
                                    <c:when test="${empty discntCheck}">
                                        <div class="anime__details__btn">
                                            <a href="javascript:void(0)" class="watch-btn" onclick="fn_discnt_insert()"
                                            ><span style="font-size: 16px" id="productStatusHtml">설정하기</span>
                                           </a>
                                        </div>
                                    </c:when>
                                    <c:otherwise>
                                        <c:if test="${discntCheck.discntStatus eq 'N'.charAt(0)}">
                                            <br/>
                                            <div class="anime__details__btn">
                                                <a href="javascript:void(0)" class="watch-btn" onclick="fn_discnt_delete(${discntCheck.discntSeq})"
                                                ><span style="font-size: 16px" id="productStatusHtml">삭제하기</span>
                                               </a>
                                            </div>
                                        </c:if>                                      
                                    </c:otherwise>
                                </c:choose>
                            </li>
                            <c:if test="${!empty discntCheck}">
                                <li>
                                    할인적용 여부 : ${discntCheck.discntStatus}
                                </li>
                                <input type="hidden" id="discntStatus" value="${discntCheck.discntStatus}">
                            </c:if>
                        </ul>
                    </div>
                </div>
              </div>
            </div>
          </div>
          <input type="hidden" id="productStatus" value="${product.productStatus}"/>
          <div class="row">
            <div class="col-lg-12 col-md-12">
              <div class="anime__details__review">
                
                <br/><br/><br/>
                <div class="section-title">
                  <h5 style="font-size: 22px">리뷰</h5>
                </div>
                <c:if test="${!empty reviewList}">
                  <c:forEach var="review" items="${reviewList}" varStatus="status">
                    
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
                        <p id="myContent">
                          ${review.reviewContent}
                        </p>
                        <div class="anime__details__btn" style="float: right">
                            <a href="javascript:void(0)" onclick="fn_delete(${review.reviewSeq})" class="follow-btn" style="font-size: 16px"
                            >삭제</a>
                          </div>
                      </div>
                    </div>
                    
                  </c:forEach>
                </c:if>
                <c:if test="${empty reviewList}">
                  <div class="anime__review__item__text">
                    <h4 style="color:white">
                      현재 등록된 리뷰가 없습니다.
                    </h4>
                  </div>
                </c:if>
                <div class="close_button">
                  <div class="anime__details__btn" style="float: right">
                    <a href="javascript:void(0)" onclick="fn_close()" class="follow-btn" style="font-size: 16px"
                    >닫기</a>
                  </div>
                </div>
            </div>
            <div class="product__pagination">
              <c:if test ="${paging.totalCount ne 0}">
                <c:if test="${paging.prevBlockPage gt 0}">
                  <a href="javascript:void(0)" onclick="fn_list('${paging.prevBlockPage}')"><i class="fa fa-angle-double-left"></i></a>
                </c:if>
                <c:forEach var="i" begin="${paging.startPage}" end="${paging.endPage}">
                  <c:choose>
                    <c:when test="${i ne paging.curPage}">                    
                    <a href="javascript:void(0)" onclick="fn_list('${i}')">${i}</a>
                    </c:when>
                    <c:otherwise>
                      <a class="current-page">${i}</a>
                    </c:otherwise>
                  </c:choose>
                </c:forEach>
                <c:if test="${paging.nextBlockPage gt 0}">
                  <a href="javascript:void(0)" onclick="fn_list('${paging.nextBlockPage}')"><i class="fa fa-angle-double-right"></i></a>
                </c:if>
              </c:if>
            </div>
            <!-- <button onclick="fn_close()">닫기</button> -->
          </div>
        </div>
      </section>
      <input type="hidden" id="productSeq" value="${product.productSeq}">
      <input type="hidden" id="productGrade" value="${product.productGrade}">
      <input type="hidden" id="reviewCnt" value="${product.reviewCnt}">
    </c:if>
    <!-- Anime Section End -->
    <c:if test="${empty product}">
      <h2 style="color: whitesmoke">선택한 게시물이 존재하지 않습니다</h2>
      <a  onclick="fn_close()" style="color: whitesmoke">닫기</a>
    </c:if>

   <%@ include file="/WEB-INF/views/include/footer.jsp" %>

    <script>
      $(document).ready(function (e) {
        
        if($("#discnt_set").is(':checked'))
            {
                $("#discnt_value").css("display","block");
            }
            else
            {
                $("#discnt_value").css("display","none");
            }

            $("#detailMain").html(
          "<img src='/resources/img_gamedetail/${product.productName}_1.jpg' width='100%' height='550px'>"
        );
        $("#img1").on("click", function () {
          $("#detailMain").html(
            "<img src='/resources/img_gamedetail/${product.productName}_1.jpg' width='100%' height='550px'>"
          );
        });
        $("#img2").on("click", function () {
          $("#detailMain").html(
            "<img src='/resources/img_gamedetail/${product.productName}_2.jpg' width='100%' height='550px'>"
          );
        });
        $("#img3").on("click", function () {
          $("#detailMain").html(
            "<img src='/resources/img_gamedetail/${product.productName}_3.jpg' width='100%' height='550px'>"
          );
        });
        
     // productGrade 별점갯수
        const productGrade = parseInt($("#productGrade").val());
        const reviewCnt =$("#reviewCnt").val();

        grade_a = parseInt(productGrade/10);
        grade_b = parseInt(productGrade%10);

        grade_a = grade_check(grade_a);
        grade_b = grade_check(grade_b);
        grade_c = grade_a+ "." + grade_b
        $("#grade_value").html(grade_c + " / 5.0");
        
        const rating = $("#rating");
        var rating_html = "";
        if(grade_a > 0)
            {
              for(var i = 0; i < 5; i++)
              {
                if(grade_a>i)
                {
                  rating_html =
                  rating_html +   `<i class="fa fa-star"></i>`;         
                }
                else
                {
                  if(grade_b > 0)
                  {
                    rating_html =
                    rating_html +   `<i class="fa fa-star-half-o"></i>` ;   
                    grade_b = 0; 
                  }
                  else
                  {
                    rating_html =
                    rating_html +   `<i class="fa fa-star-o"></i>`;
                  }
                }
              }            
                          
            }  
            else
            {
              rating_html =
              rating_html +   `<i class="fa fa-star-o"></i><i class="fa fa-star-o"></i><i class="fa fa-star-o"></i><i class="fa fa-star-o"></i><i class="fa fa-star-o"></i>` ;
            }      
       

        rating.append(rating_html);

        

        $(document).on("click","#review_default", function(){
          $("#review_fix").css("display",'block');
          $("#review_default").css("display",'none');
          $("#review_content").focus();
          $(".anime__details__form").css("height", "460px");
          
        })
        
        $(".anime-details").on("mouseleave",function(){
          $("#review_fix").css("display",'none');
          $("#review_default").css("display",'block');
          $(".anime__details__form").css("height", "auto");

        })

        if($("#productStatus").val() == 'Y')
        {
            $("#productStatusHtml").html("상품정지");
        }
        else if($("#productStatus").val() == 'N')
        {
            $("#productStatusHtml").html("상품수락");
        }
        else if($("#productStatus").val() == 'S')
        {
            $("#productStatusHtml").html("상품수락");
        }

        $("#discnt_set").on("change",function(){
            if($("#discnt_set").is(':checked'))
            {
                $("#discnt_value").css("display","block");
            }
            else
            {
                $("#discnt_value").css("display","none");
            }
        })

      });

      //페이지 이동 함수
      function fn_list(curPage) {
        const productSeq = $("#productSeq").val();

        const url = "/storeDetail?productSeq=" + productSeq + "&curPage=" + curPage;
        console.log(url);
        location.href = url;

      }


      //inf체크
      function grade_check(a)
      {
        if(!isFinite(a))
        {
          a = 0;
          return a;
        }
        return a;
      }

      //창닫기 함수
      function fn_close() {
        window.close();
      }

      

      //리뷰 삭제 함수
      function fn_delete(reviewSeq)
      {
        
        const productSeq = $("#productSeq").val();
        

        $.ajax({
          type: "POST",
          url: "/review/delete",
          data: {
            productSeq : productSeq,
            reviewSeq : reviewSeq
          },
          datatype: "JSON",
          beforeSend: function (xhr) {
            xhr.setRequestHeader("AJAX", "true");
          },
          success: function (response) {
            
            if(response.code == 0)
            {
              
              location.reload();
            }
            else if(response.code == -1)
            {
              alert("리뷰 삭제 가 완료되지 않았습니다." + response.msg);
              location.reload();
            }
            else if(response.code == 400)
            {
              alert("오류발생" + response.msg);
              window.close();
            }
            else if(response.code == 500)
            {
              alert(response.msg);
              location.reload();
            }

          },
          error: function (){
            //game.common.error(error);
          }
        });
      }

      function fn_productUpdate()
      {
        const productSeq = $("#productSeq").val();
        const productStatus = $("#productStatus").val();

        $.ajax({
          type: "POST",
          url: "/admin/productStatusUpdate",
          data: {
            productStatus : productStatus,
            productSeq : productSeq
          },
          datatype: "JSON",
          beforeSend: function (xhr) {
            xhr.setRequestHeader("AJAX", "true");
          },
          success: function (response) {
            if(response.code == 0)
            {
            	opener.parent.product_ajax();
                location.reload();
            }
            else if(response.code == 400)
            {
                alert(response.msg);
              window.close();
            }
            else if(response.code == 404)
            {
                alert(response.msg);
              window.close();
            }
            else if(response.code == 500)
            {
                alert(response.msg);
              window.close();
            }
        },
          error: function (){
            //game.common.error(error);
          }
        });
      }

      function fn_discnt_insert(){
        const productSeq = $("#productSeq").val();
        const discntRate = parseInt($("#discnt_rate").val());
        var discntStartDate =  $("#discnt_start_date").val();
        var discntEndDate = $("#discnt_end_date").val();
        const today = new Date();
        const year = today.getFullYear(); // 년도
        const month = fillZero(2,(today.getMonth() + 1));  // 월
        const date = fillZero(2,today.getDate());  // 날짜
        const sysDate = ''+year+month+date;

        discntStartDate = discntStartDate.replaceAll("-","");
        discntEndDate = discntEndDate.replaceAll("-","");

        console.log(sysDate);
        console.log(discntRate);
        console.log(discntEndDate);
        console.log(discntEndDate > sysDate);
        
        if(discntRate <= 0 || discntRate > 100)
        {
            alert("할인율 값이 잘못되었습니다.");
            return;
        }

        if(discntEndDate < sysDate)
        {
            alert("할인종료날짜는 오늘날짜보다 더 늦은날짜여야 합니다.");
            return;
        }

        if(discntStartDate > discntEndDate)
        {
            alert("할인종료날짜는 할인시작날짜보다 더 늦은날짜여야 합니다.");
            return;
        }

        $.ajax({
          type: "POST",
          url: "/admin/discntInsert",
          data: {
            productSeq : productSeq,
            discntRate : discntRate,
            discntStartDate : discntStartDate,
            discntEndDate : discntEndDate
          },
          datatype: "JSON",
          beforeSend: function (xhr) {
            xhr.setRequestHeader("AJAX", "true");
          },
          success: function (response) {
            if(response.code == 0)
            {
                alert(response.msg);
                location.reload();
            }
            else if(response.code == 400)
            {
                alert(response.msg);
                window.close();
            }
            else if(response.code == 500)
            {
                alert(response.msg);
                window.close();
            }

        },
          error: function (){
            //game.common.error(error);
          }
        });
      }

      function fn_discnt_update(discntSeq){
        const productSeq = $("#productSeq").val();
        const discntRate = parseInt($("#discnt_rate").val());
        const discntStatus = $("#discntStatus").val();
        var discntStartDate =  $("#discnt_start_date").val();
        var discntEndDate = $("#discnt_end_date").val();
        const today = new Date();
        const year = today.getFullYear(); // 년도
        const month = fillZero(2,(today.getMonth() + 1));  // 월
        const date = today.getDate();  // 날짜
        const sysDate = ''+year+month+date;

        discntStartDate = discntStartDate.replaceAll("-","");
        discntEndDate = discntEndDate.replaceAll("-","");

        
        console.log(discntRate);
        if(discntRate <= 0 || discntRate > 100)
        {
            alert("할인율 값이 잘못되었습니다.");
            return;
        }

        if(discntEndDate < sysDate)
        {
            alert("할인종료날짜는 오늘날짜보다 더 늦은날짜여야 합니다.");
            return;
        }

        if(discntStartDate > discntEndDate)
        {
            alert("할인종료날짜는 할인시작날짜보다 더 늦은날짜여야 합니다.");
            return;
        }

        $.ajax({
          type: "POST",
          url: "/admin/discntUpdate",
          data: {
            productSeq : productSeq,
            discntRate : discntRate,
            discntStartDate : discntStartDate,
            discntEndDate : discntEndDate,
            discntStatus : discntStatus
          },
          datatype: "JSON",
          beforeSend: function (xhr) {
            xhr.setRequestHeader("AJAX", "true");
          },
          success: function (response) {
            if(response.code == 0)
            {
                alert(response.msg);
                location.reload();
            }
            else if(response.code == 400)
            {
                alert(response.msg);
                window.close();
            }
            else if(response.code == 500)
            {
                alert(response.msg);
                window.close();
            }

        },
          error: function (){
            //game.common.error(error);
          }
        });

      }
      function fn_discnt_delete(discntSeq){

        $.ajax({
          type: "POST",
          url: "/admin/discntDelete",
          data: {
            discntSeq : discntSeq,
            
          },
          datatype: "JSON",
          beforeSend: function (xhr) {
            xhr.setRequestHeader("AJAX", "true");
          },
          success: function (response) {
            if(response.code == 0)
            {
                alert(response.msg);
                location.reload();
            }
            else if(response.code == 400)
            {
                alert(response.msg);
                window.close();
            }
            else if(response.code == 500)
            {
                alert(response.msg);
                window.close();
            }
        },
          error: function (){
            //game.common.error(error);
          }
        });
      }
    
      function fillZero(width, str){
       return str.length >= width ? str:'0'+str;//남는 길이만큼 0으로 채움  
    }
    
    </script>
    
  </body>
</html>
