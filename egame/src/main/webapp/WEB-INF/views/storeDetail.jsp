p<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%> <%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<!DOCTYPE html>
<html lang="ko">
  <head>
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
    <%@ include file="/WEB-INF/views/include/head.jsp" %>
    <link
  href="https://fonts.googleapis.com/css2?family=Oswald:wght@300;400;500;600;700&display=swap"
  rel="stylesheet"
/>
<link
  href="https://fonts.googleapis.com/css2?family=Mulish:wght@300;400;500;600;700;800;900&display=swap"
  rel="stylesheet"
/>

<!-- Css Styles -->
<link
  rel="stylesheet"
  href="/resources/css/report-reg-form.css"
  type="text/css"
/>
<link
  rel="stylesheet"
  href="/resources/css/bootstrap.min.css"
  type="text/css"
/>
<link rel="stylesheet" href="/resources/css/style.css" type="text/css" />
<link
  rel="stylesheet"
  href="/resources/css/elegant-icons.css"
  type="text/css"
/>
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
      #discnt_div
      {
        margin-right: 0;
        text-align: right;
      }
      img   
      {
        background-size: 100% 100%;
      }
      #product_button
      {
        display: flex;
        justify-content: space-between;
        width: 1150px;
      }
      #review_title
      {
        display: flex;
        justify-content: space-between;
      }
      .modal {
  top: 0;
  left: 0;

  width: 100%;
  height: 100%;

  display: none;

  background-color: rgba(0, 0, 0, 0.4);
}

.modal.show {
  display: block;
}

.modal_body {
  position: absolute;
  top: 50%;
  left: 50%;

  width: 500px;
  height: 600px;

  padding: 40px;

  text-align: center;

  background-color: rgb(255, 255, 255);
  border-radius: 10px;
  box-shadow: 0 2px 3px 0 rgba(34, 36, 38, 0.15);

  transform: translateX(-50%) translateY(-50%);
}
#reportContent
{
  position: unset;
}
.nice-select.open .list
{
  color:black;
}

  #product_kategori,
  #review_kategori {
    display: none;
  }
  *,
  ::after,
  ::before {
    margin-bottom: 0;
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
                  <p style="font-size: 20px; white-space: pre-line;">${product.productContent}</p>
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
                        <c:choose>
                          <c:when test="${product.discntSeq gt 0}">
                            <h2 style="color: white"><strike>₩ ${product.printProductPrice}</strike> -&gt;  ₩ ${product.printPayPrice}</h2>
                                  <br/>
                            <div id="discnt_div">
                              <span style="color:red;">${product.discntRate} % 할인 중!</span>
                          <br/>
                          <u style="color:red;">${product.discntEndDate}</u><span style="color:white"> 일 종료</span>
                            </div>
                          </c:when>
                          <c:otherwise>
                            <h2 style="color: white"> ₩${product.printPayPrice}</h2>
                          </c:otherwise>
                      </c:choose>
                        
                      </div>
                    </div>
                  </div>
                  <div class="modal">
                    <div class="modal_body">
                      <section class="report_section">
                        <form name="reportRegForm" id="reportRegForm" method="post">
                          <div class="report_form">
                            <div class="report_context">
                              <div style="text-align: left;">
                                <a 
                                  style="color: white; margin-bottom: 10px;"
                                  href="javascript:void(0)"
                                  onclick="fn_modal_off()"
                                  >X</a
                                >
                              </div>
                              <h2 style="margin-bottom: 20px">신고하기</h2>
                              <div class="report_wrapper">
                                <h4 id="report_pr_html" style="color:white; margin-top: 10px;"></h4>
                              </div>
                              <div class="report_wrapper" id="detail_kategori">
                                <div id="product_kategori">
                                  <select required class="report_tag" name="product_report_Tag" id="product_report_Tag" >
                                    <option value="">상품신고 태그</option>
                                    <option value="저작권위반">저작권위반</option>
                                    <option value="아동학대">아동학대</option>
                                    <option value="법률위반">법률위반</option>
                                    <option value="악성코드">악성코드</option>
                                    <option value="사기">사기</option>
                                    <option value="카테고리">카테고리</option>
                                    <option value="기타">기타</option>
                                  </select>
                                </div>
                                <div id="review_kategori">
                                  <select required class="report_tag" name="review_report_Tag" id="review_report_Tag" >
                                    <option value="">리뷰신고 태그</option>
                                    <option value="홍보글">홍보글</option>
                                    <option value="음란성">음란성</option>
                                    <option value="혐오">혐오</option>
                                  </select>
                                </div>
                              </div>
                              <div class="report_context_tbox">
                                <textarea
                                  class="report_context_text"
                                  name="reportContent"
                                  id="reportContent"
                                  maxlength="500"
                                  placeholder="자세한 내용을 적어주세요(500자 이내)"
                                ></textarea>
                              </div>
                              
                              <button class="report_btn" id="btnWrite">제출</button>
                              <input type="hidden" name="reportPr" id="reportPr" />
                              <input type="hidden" name="report_product_seq" id="report_product_seq" />
                              <input type="hidden" name="report_review_seq" id="report_review_seq" />
                              <input type="hidden" name="reportProductTag" id="reportProductTag" />
                              <input type="hidden" name="reportReviewTag" id="reportReviewTag" />
                            </div>
                          </div>
                        </form>
                      </section>

                    </div>
                  </div>
                  
                  <div class="anime__details__btn" style="float: right" id="product_button">
                    <div>
                      <a href="javascript:void(0)" onclick="fn_product_modal_on(${product.productSeq})" class="follow-btn btn-open-popup" style="font-size: 16px"
                        ><i class="fa fa-flag"></i> 신고하기</a>
                    </div>
                        <div>
                          <c:choose>
                          <c:when test="${buyCheck le 0}">
                            <c:choose>
                              <c:when test="${cartCheck le 0}">
                                <a href="javascript:void(0)" onclick="fn_cartInsert()" class="follow-btn" style="font-size: 16px"
                                  ><i class="fa fa-star-o"></i> 장바구니 추가</a>
                              </c:when>
                              <c:otherwise>
                                <a href="javascript:void(0)" onclick="fn_cartDelete()" class="follow-btn" style="font-size: 16px"
                                  ><i class="fa fa-star"></i> 장바구니 삭제</a>
                              </c:otherwise>
                            </c:choose>
                    <a href="javascript:void(0)" class="watch-btn" onclick="fn_cart()"
                      ><span style="font-size: 16px">구매하러 가기</span>
                      <i class="fa fa-angle-right" style="font-size: 25px"></i
                    ></a>
                  </c:when>
                  <c:otherwise>
                  
                    <a href="javascript:void(0)" class="watch-btn"
                      ><span style="font-size: 16px">게임실행</span>
                      <i class="fa fa-angle-right" style="font-size: 25px"></i
                    ></a>
                  </c:otherwise>
                </c:choose>
              </div>
                  </div>
                </div>
              </div>
            </div>
          </div>
          <div class="row">
            <div class="col-lg-12 col-md-12">
              <div class="anime__details__review">
                <c:choose>
                <c:when test="${empty myReview}">
                <div class="anime__details__form">
                  <div class="section-title">
                    <div>
                      <h5 style="font-size: 22px">리뷰 작성</h5>
                    </div>
                  </div>
                    <form name="review_form" id="review_form">
                      <textarea placeholder="내용을 작성해주세요" id="review_content" style="color:black"></textarea>
                      <div class="product__page__filter">
                        <select name="product_grade" id="product_grade">
                          <option value="">평점</option>
                          <option value="10">★☆☆☆☆</option>
                          <option value="20">★★☆☆☆</option>
                          <option value="30">★★★☆☆</option>
                          <option value="40">★★★★☆</option>
                          <option value="50">★★★★★</option>
                        </select>
                      </div>
                      <div class="review_button">
                        <button type="button" onclick="fn_reviewInsert()">
                            <i class="fa fa-location-arrow"></i> 리뷰 등록
                        </button>
                      </div>
                      <p id="review_check" style="color:red"></p>
                    </form>
                </div>
                </c:when>
                <c:otherwise>
                <div class="anime__details__form">
                  <div class="section-title">
                    <h5 style="font-size: 22px">내가 작성한 리뷰</h5>
                  </div>
                  <div id ="review_fix" style="display: none;">
                      <div class="anime__review__item">
                        <div class="anime__review__item__pic">
                          <img src="/resources/img_userimg/${myReview.userImg}" alt="" />
                        </div>
                        <div class="anime__review__item__text">
                          <h6>
                            ${myReview.userNickName} &nbsp;&nbsp;&nbsp;
                            <span>${myReview.reviewRegDate}</span>
                          </h6>
                        </div>
                        <div class="anime__details__form">
                          <form name="review_form">
                            <textarea placeholder="내용을 작성해주세요" id="review_content" style="color:black">${myReview.reviewContent}</textarea>
                            <div class="product__page__filter">
                              <select name="product_grade" id="product_grade">
                                <option value="">평점</option>
                                <option value="10" >★☆☆☆☆</option>
                                <option value="20" >★★☆☆☆</option>
                                <option value="30" >★★★☆☆</option>
                                <option value="40" >★★★★☆</option>
                                <option value="50" >★★★★★</option>
                              </select>
                            </div>
                            <div class="anime__details__btn" style="float: right" id="review_fix">
                              <a href="javascript:void(0)"  onclick="fn_update()" class="follow-btn" style="font-size: 14px"
                              >수정</a>
                            </div>
                            <div class="anime__details__btn" style="float: right" id="review_delete">
                              <a href="javascript:void(0)" onclick="fn_delete()" class="follow-btn" style="font-size: 14px"
                              >삭제</a>
                            </div>
                          </form>
                          </div>
                        
                        <br/>
                          
                        </div>
                      <input type="hidden" id="reviewSeq" value="${myReview.reviewSeq}"/>
                      <input type="hidden" id="reviewGrade" value="${myReview.productGrade}"/>
                    </div>
                  </div>
                  <div id="review_default">
                    <div class="anime__review__item">
                      
                      <div class="anime__review__item__pic">
                        <img src="/resources/img_userimg/${myReview.userImg}" alt="" />
                          <div class="review_rating">
                            <c:forEach var="i" begin="1" end="${myReview.productGrade}" step="10">
                              <i class="fa fa-star"></i>
                            </c:forEach> 
                          </div>
                      </div>
                      <div class="anime__review__item__text">
                        <h6>
                          ${myReview.userNickName} &nbsp;&nbsp;&nbsp;
                          
                          <span>${myReview.reviewRegDate}</span>
                        </h6>
                        <p>
                          ${myReview.reviewContent}
                        </p>
                      </div>
                    </div>
                  </div>
                </c:otherwise>
              </c:choose>
                <br/><br/><br/>
                <div class="section-title">
                  <h5 style="font-size: 22px">리뷰</h5>
                </div>
                <c:if test="${!empty reviewList}">
                  <c:forEach var="review" items="${reviewList}" varStatus="status">
                    
                    <div class="anime__review__item">
                      
                      <div class="anime__review__item__pic">
                        <a target="_blank" href="/user/friendPage?friendId=${review.userId}"><img src="/resources/img_userimg/${review.userImg}" alt="" /></a>
                          <div class="review_rating">
                            <c:forEach var="i" begin="1" end="${review.productGrade}" step="10">
                              <i class="fa fa-star"></i>
                            </c:forEach> 
                          </div>
                      </div>
                      <div class="anime__review__item__text">
                        <h6 id="review_title">
                          <span><a href="/user/friendPage?friendId=${review.userId}" target="_blank" style="color:white">${review.userNickName}</a> &nbsp;&nbsp;&nbsp;
                          
                          ${review.reviewRegDate}</span>
                          <c:if test="${cookieUserId ne review.userId}"><span><a href="javascript:void(0)" onclick="fn_review_modal_on(${review.reviewSeq})">신고<i class="fa fa-flag"></i></a></span></c:if>
                        </h6>
                        <p id="myContent">
                          ${review.reviewContent}
                        </p>
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
        window.resizeTo(1500, 1080);
        
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

        const reviewGrade = $("#reviewGrade").val()

        $("#review_form").on("click",function(){
          fn_review_user_check();
        })

        if(reviewGrade == 0)
        {
          $(".current").html("평점");
          $("select[name='product_grade'] option:eq(0)").prop("selected", true);
        }
        else if(reviewGrade == 10)
        {
          $(".current").html("★☆☆☆☆");
          $("select[name='product_grade'] option:eq(1)").prop("selected", true);
        }
        else if(reviewGrade == 20)
        {
          $(".current").html("★★☆☆☆");
          $("select[name='product_grade'] option:eq(2)").prop("selected", true);
        }
        else if(reviewGrade == 30)
        {
          $(".current").html("★★★dd☆☆");
          $("select[name='product_grade'] option:eq(3)").prop("selected", true);
        }
        else if(reviewGrade == 40)
        {
          $(".current").html("★★★★☆");
          $("select[name='product_grade'] option:eq(4)").prop("selected", true);
        }
        else if(reviewGrade == 50)
        {
          $(".current").html("★★★★★");
          $("select[name='product_grade'] option:eq(5)").prop("selected", true);
        }

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

        //모달 이벤트

    $(document).on("change", "#product_report_Tag", function () {
      console.log(1);
      $("#reportProductTag").val($("#product_report_Tag").val());
    });

    $(document).on("change", "#review_report_Tag", function () {
      console.log(2);
      $("#reportReviewTag").val($("#review_report_Tag").val());
    });

    $("#btnWrite").on("click", function () {
      $("#btnWrite").prop("disabled", true);
      var report_tag;
      console.log($("#report_product_seq").val());
      console.log($("#report_review_seq").val());
      console.log($("#reportProductTag").val());
      console.log($("#reportReviewTag").val());

      if ($("#reportPr").val() == "상품") {
        if (
          $.trim($("#product_report_Tag").val()).length <= 0 ||
          $.trim($("#product_report_Tag").val()).length == null
        ) {
          alert("신고 옵션을 선택하세요.");
          $("#btnWrite").prop("disabled", false);
          return;
        }
        report_tag = $("#product_report_Tag").val();
      } else if ($("#reportPr").val() == "리뷰") {
        if (
          $.trim($("#review_report_Tag").val()).length <= 0 ||
          $.trim($("#review_report_Tag").val()).length == null
        ) {
          alert("신고 옵션을 선택하세요.");
          $("#btnWrite").prop("disabled", false);
          return;
        }
        report_tag = $("#review_report_Tag").val();
      } else {
        alert("메인태그를 선택해주세요");
        return;
      }

      if ($.trim($("#reportContent").val()).length <= 0) {
        alert("내용을 입력하세요.");
        $("#reportContent").val("");
        $("#reportContent").focus();
        $("#btnWrite").prop("disabled", false);
        return;
      }


      var form = $("#reportRegForm")[0];
      var formData = new FormData(form);

      $.ajax({
        type: "POST",
        url: "/board/reportWriteProc",
        data: formData,
        processData: false,
        contentType: false,
        cache: false,
        beforeSend: function (xhr) {
          xhr.setRequestHeader("AJAX", "true");
        },
        success: function (response) {
          if (response.code == 0) {
            alert("신고가 정상적으로 접수 되었습니다.");
            location.reload();
          } else if (response.code == 400) {
            alert("파라미터 값이 올바르지 않습니다.");
            $("#btnWrite").prop("disabled", false);
          } else {
            alert("신고 접수 중 오류가 발생하였습니다.");
            $("#btnWrite").prop("disabled", false);
          }
        },
        error: function (error) {
          game.common.error(error);
          alert("신고 접수 중 오류가 발생하였습니다.");
          $("#btnWrite").prop("disabled", false);
        },
      });
    });

      });

      //모달 띄우기(상품) 함수
      function fn_product_modal_on(a)
      {
    	  $.ajax({
              type: "GET",
              url: "/store/loginCheck",
              datatype: "JSON",
              beforeSend: function (xhr) {
                xhr.setRequestHeader("AJAX", "true");
              },
              success: function (response) {
                 
                if(response.code == 404)
                  {
                	alert("로그인이 필요합니다.");
                    location.reload();
                  }
                else if(response.code == 0)
                  {
                	$(".current").html("상품신고 태그");
                    $("#report_product_seq").val(a);
                    $("#reportPr").val('상품');
                    $("#report_pr_html").html('상품');
                    $("#review_kategori").css("display", "none");
                    $("#product_kategori").css("display", "block");
                    $(".modal").css('display','block');
                  }
                },
                error: function () {
                  game.common.error(error);
                }
              });
      }

      //모달 띄우기(리뷰) 함수
      function fn_review_modal_on(a)
      {
    	  $.ajax({
              type: "GET",
              url: "/store/loginCheck",
              datatype: "JSON",
              beforeSend: function (xhr) {
                xhr.setRequestHeader("AJAX", "true");
              },
              success: function (response) {
                 
                if(response.code == 404)
                  {
                	alert("로그인이 필요합니다.");
                    location.reload();
                  }
                else if(response.code == 0)
                  {
                	$(".current").html("리뷰신고 태그");
                    $("#report_review_seq").val(a);
                    $("#reportPr").val('리뷰');
                    $("#report_pr_html").html('리뷰');
                    $("#product_kategori").css("display", "none");
                    $("#review_kategori").css("display", "block");
                    $(".modal").css('display','block');
                  }
                },
                error: function () {
                  game.common.error(error);
                }
              });
    	
      }

      //모달 닫기 함수
      function fn_modal_off()
      {
    	  const reviewGrade = $("#reviewGrade").val()
    	  
    	   if(reviewGrade == 0)
        {
          $(".current").html("평점");
          $("select[name='product_grade'] option:eq(0)").prop("selected", true);
        }
        else if(reviewGrade == 10)
        {
          $(".current").html("★☆☆☆☆");
          $("select[name='product_grade'] option:eq(1)").prop("selected", true);
        }
        else if(reviewGrade == 20)
        {
          $(".current").html("★★☆☆☆");
          $("select[name='product_grade'] option:eq(2)").prop("selected", true);
        }
        else if(reviewGrade == 30)
        {
          $(".current").html("★★★☆☆");
          $("select[name='product_grade'] option:eq(3)").prop("selected", true);
        }
        else if(reviewGrade == 40)
        {
          $(".current").html("★★★★☆");
          $("select[name='product_grade'] option:eq(4)").prop("selected", true);
        }
        else if(reviewGrade == 50)
        {
          $(".current").html("★★★★★");
          $("select[name='product_grade'] option:eq(5)").prop("selected", true);
        }
    	  
        $("#reportContent").val("");
        $(".modal").css('display','none');
      }

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

      //리뷰 텍스트박스 선택시 로그인상태와 상품 구매여부 체크 
      function fn_review_user_check()
      {
        const productSeq = $("#productSeq").val();
        $.ajax({
          type: "POST",
          url: "/review/userCheck",
          data: {
            productSeq : productSeq
          },
          datatype: "JSON",
          beforeSend: function (xhr) {
            xhr.setRequestHeader("AJAX", "true");
          },
          success: function (response) {
            if(response.code == -1)
            {
             
              alert(response.msg);
              opener.parent.fn_login();
              window.close();
            }
            else if(response.code == -2)
            {
              alert(response.msg);
              location.reload();
            }
            else if(response.code == 400)
            {
             
              alert(response.msg);
              opener.parent.fn_index();
              window.close();
            }
            else if(response.code == 404)
            {
              
              alert(response.msg);
              opener.parent.fn_index();
              window.close();
            }


          },
          error: function (){
            //game.common.error(error);
          }
        });
      }

      //리뷰 삭제 함수
      function fn_delete()
      {
        
        const reviewSeq = $("#reviewSeq").val();
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
            
       	  const storeCheck = opener.window.document.getElementById("store_check").value;
            if(response.code == 0)
            {
              if(storeCheck == 1)
              {
                opener.parent.product_ajax();
              }
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

      //리뷰 등록 함수
      function fn_reviewInsert()
      {
        const productSeq = $("#productSeq").val();
        const reviewContent = $("#review_content").val();
        const grade = $("#product_grade").val();
        
        if($.trim(reviewContent).length <= 0)
        {
          $("#review_check").html("내용을 입력해주세요");
          return;
        }

        if(grade == "")
        {
          $("#review_check").html("평점을 선택해주세요");
          return;
        }

        $.ajax({
          type: "GET",
          url: "/review/reviewForm",
          data: {
            productSeq : productSeq,
            reviewContent : reviewContent,
            grade : grade
          },
          datatype: "JSON",
          beforeSend: function (xhr) {
            xhr.setRequestHeader("AJAX", "true");
          },
          success: function (response) {
        	  
      	  const storeCheck = opener.window.document.getElementById("store_check").value;
            if(response.code == 0)
            {
              if(storeCheck == 1)
              {
                opener.parent.product_ajax();
              }
              location.reload();
            }
            else if(response.code == 400)
            {
              alert("파라미터값이 잘못되었습니다.");
              return;
            }
            else if(response.code == 401)
            {
              alert("정지된 계정입니다.");
              window.close();
            }
            else if(response.code == 402)
            {
              alert("리뷰는 중복작성이 불가능합니다.");
              location.reload();
            }
            else if(response.code == 404)
            {
              alert("리뷰를 작성할려면 로그인해야 합니다.");
              window.close();
            }
            else if(response.code == 500)
            {
              alert("리뷰작성중 오류가 발생했습니다." + response.msg);
              window.close();
            }
          },
          error: function () {
            game.common.error(error);
          }
      });
      }

      
      function fn_update()
      {
        const productSeq = $("#productSeq").val();
        const reviewContent = $("#review_content").val();
        const grade = $("#product_grade").val();
        const reviewSeq = $("#reviewSeq").val();
        if($.trim(reviewContent).length <= 0)
        {
          $("#review_check").html("내용을 입력해주세요");
          return;
        }

        if(grade == "")
        {
          $("#review_check").html("평점을 선택해주세요");
          return;
        }

        $.ajax({
          type: "POST",
          url: "/review/update",
          data: {
            productSeq : productSeq,
            reviewContent : reviewContent,
            grade : grade,
            reviewSeq : reviewSeq,
          },
          datatype: "JSON",
          beforeSend: function (xhr) {
            xhr.setRequestHeader("AJAX", "true");
          },
          success: function (response) {

      	  const storeCheck = opener.window.document.getElementById("store_check").value;
            if(response.code == 0)
            {
              if(storeCheck == 1)
              {
                opener.parent.product_ajax();
              }
              location.reload();
            }
            else if(response.code == 400)
            {
              alert(response.msg);
              location.reload();
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
          error: function () {
            game.common.error(error);
          }
      });
      }
      //장바구니 추가 함수
      function fn_cartInsert()
      {
        const productSeq = $("#productSeq").val();

        $.ajax({
          type: "POST",
          url: "/cart/insert",
          data: {
            productSeq : productSeq,
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
              location.reload();
            }
            else if(response.code == -1)
            {
              alert("로그인이 필요합니다.");
              opener.parent.fn_login();
              window.close();
            }
            else if(response.code == 405)
              {
                alert(response.msg);
                location.reload();
              }

          },
          error: function () {
            game.common.error(error);
          }
      });

      }
      //장바구니 삭제 함수
      function fn_cartDelete()
      {
        const productSeq = $("#productSeq").val();

          $.ajax({
            type: "POST",
            url: "/cart/delete",
            data: {
              productSeq : productSeq,
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
                location.reload();
              }
              else if(response.code == -1)
              {
                alert("로그인이 필요합니다.");
                opener.parent.fn_login();
                window.close();
              }
              else if(response.code == 405)
              {
                alert(response.msg);
                location.reload();
              }
            },
            error: function () {
              game.common.error(error);
            }
          });
      }

      //카트 이동 함수
      function fn_cart(){
        const productSeq = $("#productSeq").val();

        $.ajax({
          type: "POST",
          url: "/user/cartProc",
          data: {
            productSeq : productSeq,
          },
          datatype: "JSON",
          beforeSend: function (xhr) {
            xhr.setRequestHeader("AJAX", "true");
          },
          success: function (response) {
             
            if(response.code == 0)
              {
                var url = "/user/cart";
                var openNewWindow = window.open("about:blank");
                location.reload();
                openNewWindow.location.href = url;
              }
              else if(response.code == 400)
              {
                alert(response.msg);
                window.close();
              }
              else if(response.code == 500)
              {
                alert(response.msg);
                location.reload();
              }
              else if(response.code == -1)
              {
                alert("로그인이 필요합니다.");
                opener.parent.fn_login();
                window.close();
              }
            },
            error: function () {
              game.common.error(error);
            }
          });
      }

    </script>
  </body>
</html>
