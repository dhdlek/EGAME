<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>

<!DOCTYPE html>
<html lang="ko">

<head>
<%@ include file="/WEB-INF/views/include/head.jsp" %>
<title>Store eGame</title>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
<script>

//viewAll클릭시 상품페이지 이동함수
function fn_viewAll_store(a)
{
    var url;
    if(a == 'recomProductList')
    {
        url = "/store"
    }
    else if(a == 'buyCntProductList')
    {
        url =   "/store?orderValue=buy_cnt_desc"
    }
    else if(a == 'discntProductList')
    {
        url =   "/store?discntCheck=Y"
    }
    
    location.href = url;
    // location.href = "/store?orderValue=buy_cnt_desc";
}
//로그인 페이지 이동 함수
function fn_login()
{
  location.href = "/user/login";
}

//디테일 페이지 이동 함수
function fn_detail(product_seq)
{
const url = `/storeDetail?productSeq=${"${product_seq}"}`;
var popup = window.open(url, "_blank", 'width=1500, height=1200, scrollbars=yes, resizable =no')

}

function fn_cookie_delete()
{
        $.ajax({
          type: "POST",
          url: "/product/cookieDelete",
          data: {
          },
          datatype: "JSON",
          beforeSend: function (xhr) {
            xhr.setRequestHeader("AJAX", "true");
          },
          success: function (response) {
            location.reload();
          },
            error: function () {
            game.common.error(error);
          },
        });
}

</script>
<style>
    .filter__gallery
    {
        width: 80%;
    }
    .container
    {
        max-width: 1500px;
    }
    .popular__product {
    margin-bottom: 0;
    }

    .set-bg
    {
        background-size: 100% 100%;
    }

    .cookie_view
    {
        display: flex;
        justify-content: space-between;
    }

    #cookie_div
    {
        margin-right: 80px;
    }

</style>
</head>
<body>
<%@ include file="/WEB-INF/views/include/navigation.jsp" %>

<!-- Hero Section Begin -->
<section class="hero">
    <div class="container">
        <div class="hero__slider owl-carousel">
            <div class="hero__items set-bg" data-setbg="/resources/img_main/HogwartsLegacy.jpg">
                <div class="row">
                    <div class="col-lg-6">
                        <div class="hero__text">
                            <h2>Hogwarts Legacy</h2>
                            <a href="javascript:void(0)" onclick="fn_detail(103)"><span>지금 구매</span> <i class="fa fa-angle-right"></i></a>
                        </div>
                    </div>
                </div>
            </div>
            <div class="hero__items set-bg" data-setbg="/resources/img_main/DeadSpace.jpg">
                <div class="row">
                    <div class="col-lg-6">
                        <div class="hero__text">
                            <h2>Dead Space</h2>
                            <a href="javascript:void(0)" onclick="fn_detail(104)"><span>지금 구매</span> <i class="fa fa-angle-right"></i></a>
                        </div>
                    </div>
                </div>
            </div>
            <div class="hero__items set-bg" data-setbg="/resources/img_main/RedDeadRedemption2.jpg">
                <div class="row">
                    <div class="col-lg-6">
                        <div class="hero__text">
                            <h2>Red Dead Redemption 2</h2>
                            <a href="javascript:void(0)" onclick="fn_detail(102)"><span>지금 구매</span> <i class="fa fa-angle-right"></i></a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</section>
<!-- Hero Section End -->

<!-- Product Section Begin -->
   <section class="product spad">
       <div class="container">
           <div class="row">
               <div class="col-lg-8">
                   <div class="trending__product">
                       <div class="row">
                           <div class="col-lg-8 col-md-8 col-sm-8">
                               <div class="section-title">
                                   <h4>추천 게임</h4>
                               </div>
                           </div>
                           <div class="col-lg-4 col-md-4 col-sm-4">
                               <div class="btn__all">
                                   <a href="javascript:void(0)" onclick="fn_viewAll_store('recomProductList')" class="primary-btn">View All <span class="arrow_right"></span></a>
                               </div>
                           </div>
                       </div>
                       <c:if test="${!empty recomProductList}">
                       <div class="row">
                        <c:forEach
                            var="p"
                            items="${recomProductList}"
                            varStatus="status"
                          >
                           <div class="col-lg-4 col-md-6 col-sm-6">
                               <div class="product__item">
                                   <a href="javascript:void(0)" onclick="fn_detail(${p.productSeq})">
	                                   <div class="product__item__pic set-bg" data-setbg="/resources/img_gamemain/${p.productImgName}.jpg">                                 
	                                       <div class="comment"><i class="fa fa-comments"></i> ${p.reviewCnt}</div>
	                                       <div class="view"><i class="fa fa-download"></i> ${p.productBuyCnt}</div>
	                                   </div>
                                   </a>
                                   <div class="product__item__text">
                                       <ul>
                                            <c:forEach var="t" items="${p.tagName}" begin="1" end="3" varStatus="status">
                                                <li>${t}</li>
                                            </c:forEach>
                                       </ul>
                                       <h5><a href="javascript:void(0)" onclick="fn_detail(${p.productSeq})">${p.productName}<br>
                                        <c:choose>
                                            <c:when test="${p.discntSeq gt 0}">
                                                <strike>₩ ${p.printProductPrice}</strike> -&gt;  ₩ ${p.printPayPrice}
                                                    </a>
                                                    <br/> <span style="color:red">${p.discntRate} % 할인 중!</span>
                                                </h5>
                                                <u style="color:red">${p.discntEndDate}</u><span style="color:white"> 일 종료</span>
                                            </c:when>
                                            <c:otherwise>
                                                ₩ ${p.printPayPrice}</a></h5>
                                            </c:otherwise>
                                        </c:choose>
                                   </div>
                               </div>
                           </div>
                        </c:forEach>
                        </div>
                    </c:if>
                   </div>
                   <div class="popular__product">
                       <div class="row">
                           <div class="col-lg-8 col-md-8 col-sm-8">
                               <div class="section-title">
                                   <h4>특별 할인</h4>
                               </div>
                           </div>
                           <div class="col-lg-4 col-md-4 col-sm-4">
                               <div class="btn__all">
                                   <a href="javascript:void(0)" onclick="fn_viewAll_store('discntProductList')" class="primary-btn">View All <span class="arrow_right"></span></a>
                               </div>
                               </div>
                           </div>
                       </div>
                       <c:if test="${!empty discntProductList}">
                       <div class="row">
                        <c:forEach
                            var="p"
                            items="${discntProductList}"
                            varStatus="status"
                          >
                           <div class="col-lg-4 col-md-6 col-sm-6">
                               <div class="product__item">
                                   <a href="javascript:void(0)" onclick="fn_detail(${p.productSeq})">
	                                   <div class="product__item__pic set-bg" data-setbg="/resources/img_gamemain/${p.productImgName}.jpg">                                 
	                                       <div class="comment"><i class="fa fa-comments"></i> ${p.reviewCnt}</div>
	                                       <div class="view"><i class="fa fa-download"></i> ${p.productBuyCnt}</div>
	                                   </div>
                                   </a>
                                   <div class="product__item__text">
                                       <ul>
                                            <c:forEach var="t" items="${p.tagName}" begin="1" end="3" varStatus="status">
                                                <li>${t}</li>
                                            </c:forEach>
                                       </ul>
                                       <h5><a href="javascript:void(0)" onclick="fn_detail(${p.productSeq})">${p.productName}<br>
                                        <c:choose>
                                            <c:when test="${p.discntSeq gt 0}">
                                                <strike>₩ ${p.printProductPrice}</strike> -&gt;  ₩ ${p.printPayPrice}
                                                    </a>
                                                    <br/> <span style="color:red">${p.discntRate} % 할인 중!</span>
                                                </h5>
                                                <u style="color:red">${p.discntEndDate}</u><span style="color:white"> 일 종료</span>
                                            </c:when>
                                            <c:otherwise>
                                                ₩ ${p.printPayPrice}</a></h5>
                                            </c:otherwise>
                                        </c:choose>
                                   </div>
                               </div>
                           </div>
                        </c:forEach>
                        </div>
                    </c:if>
                   
                   <div class="recent__product">
                       <div class="row">
                           <div class="col-lg-8 col-md-8 col-sm-8">
                               <div class="section-title">
                                   <h4>베스트셀러</h4>
                               </div>
                           </div>
                           <div class="col-lg-4 col-md-4 col-sm-4">
                               <div class="btn__all">
                                <a href="javascript:void(0)" onclick="fn_viewAll_store('buyCntProductList')" class="primary-btn">View All <span class="arrow_right"></span></a>
                               </div>
                           </div>
                       </div>
                       <c:if test="${!empty buyCntProductList}">
                       <div class="row">
                        <c:forEach
                            var="p"
                            items="${buyCntProductList}"
                            varStatus="status"
                          >
                           <div class="col-lg-4 col-md-6 col-sm-6">
                               <div class="product__item">
                                   <a href="javascript:void(0)" onclick="fn_detail(${p.productSeq})">
	                                   <div class="product__item__pic set-bg" data-setbg="/resources/img_gamemain/${p.productImgName}.jpg">                                 
	                                       <div class="comment"><i class="fa fa-comments"></i> ${p.reviewCnt}</div>
	                                       <div class="view"><i class="fa fa-download"></i> ${p.productBuyCnt}</div>
	                                   </div>
                                   </a>
                                   <div class="product__item__text">
                                       <ul>
                                            <c:forEach var="t" items="${p.tagName}" begin="1" end="3" varStatus="status">
                                                <li>${t}</li>
                                            </c:forEach>
                                       </ul>
                                       <h5><a href="javascript:void(0)" onclick="fn_detail(${p.productSeq})">${p.productName}<br>
                                        <c:choose>
                                            <c:when test="${p.discntSeq gt 0}">
                                                <strike>₩ ${p.printProductPrice}</strike> -&gt;  ₩ ${p.printPayPrice}
                                                    </a>
                                                    <br/> <span style="color:red">${p.discntRate} % 할인 중!</span>
                                                </h5>
                                                <u style="color:red">${p.discntEndDate}</u><span style="color:white"> 일 종료</span>
                                            </c:when>
                                            <c:otherwise>
                                                ₩ ${p.printPayPrice}</a></h5>
                                            </c:otherwise>
                                        </c:choose>
                                   </div>
                               </div>
                           </div>
                        </c:forEach>
                        </div>
                    </c:if>
                   </div>
                   
               </div>
               <c:choose>
                <c:when test="${empty cookieProductList}">
                    <div class="col-lg-4 col-md-6 col-sm-8">
                        <div class="product__sidebar">
                            <div class="product__sidebar__view">
                                <div class="section-title">
                                    <h5>최고 평점</h5>
                                </div>
                                <div class="filter__gallery">
                                 <c:if test="${!empty gradeProductList}">
                                     <c:forEach
                                         var="p"
                                         items="${gradeProductList}"
                                         varStatus="status"
                                     >
                                     <div class="product__item">
                                         <a href="javascript:void(0)" onclick="fn_detail(${p.productSeq})">
                                         <div
                                           class="product__item__pic__store set-bg"
                                           data-setbg="/resources/img_gamemain/${p.productImgName}.jpg"
                                         >
                                           <div class="comment">
                                             <i class="fa fa-comments"></i> ${p.reviewCnt}
                                           </div>
                                           <div class="view"><i class="fa fa-download"></i> ${p.productBuyCnt}</div>
                                         </div>
                                     </a>
                                         <div class="product__item__text">
                                             <ul>
                                                 <c:forEach var="t" items="${p.tagName}" begin="1" end="3" varStatus="status">
                                                     <li>${t}</li>
                                                 </c:forEach>
                                            </ul>
                                           <h5>
                                             <a href="javascript:void(0)" onclick="fn_detail(${p.productSeq})">
                                               ${p.productName}     <br/>
                                               <c:choose>
                                                 <c:when test="${p.discntSeq gt 0}">
                                                     <strike>₩ ${p.printProductPrice}</strike> -&gt;  ₩ ${p.printPayPrice}
                                                         </a>
                                                         <br/><span style="color:red">${p.discntRate} % 할인 중!</span>
                                                     </h5>
                                                     <u style="color:red">${p.discntEndDate}</u><span style="color:white"> 일 종료</span>
                                                 </c:when>
                                                 <c:otherwise>
                                                     ₩ ${p.printPayPrice}</a></h5>
                                                 </c:otherwise>
                                             </c:choose>
                                         </div>
                                       </div>
                                       </c:forEach>
                                     </c:if>
                                 </div>
                             </div>
                         </div>
                        </div>
                        </c:when>
                        <c:otherwise>
                            
                            <div class="col-lg-4 col-md-6 col-sm-8">
                                <div class="product__sidebar">
                                    <div class="product__sidebar__view">
                                        <div class="cookie_view">
                                        <div class="section-title">
                                            <h5>최근 본 상품</h5>
                                        </div>
                                        <div class="col-lg-4 col-md-4 col-sm-4" id="cookie_div">
                                            <div class="btn__all">
                                             <a href="javascript:void(0)" onclick="fn_cookie_delete()" class="primary-btn">삭제하기 <i class="fa fa-trash"></i></a>
                                            </div>
                                        </div>
                                    </div>
                                        <div class="filter__gallery">
                                         <c:if test="${!empty cookieProductList}">
                                             <c:forEach
                                                 var="p"
                                                 items="${cookieProductList}"
                                                 varStatus="status"
                                             >
                                             <div class="product__item">
                                                 <a href="javascript:void(0)" onclick="fn_detail(${p.productSeq})">
                                                 <div
                                                   class="product__item__pic__store set-bg"
                                                   data-setbg="/resources/img_gamemain/${p.productImgName}.jpg"
                                                 >
                                                   <div class="comment">
                                                     <i class="fa fa-comments"></i> ${p.reviewCnt}
                                                   </div>
                                                   <div class="view"><i class="fa fa-download"></i> ${p.productBuyCnt}</div>
                                                 </div>
                                             </a>
                                                 <div class="product__item__text">
                                                     <ul>
                                                         <c:forEach var="t" items="${p.tagName}" begin="1" end="3" varStatus="status">
                                                             <li>${t}</li>
                                                         </c:forEach>
                                                    </ul>
                                                   <h5>
                                                     <a href="javascript:void(0)" onclick="fn_detail(${p.productSeq})">
                                                       ${p.productName}     <br/>
                                                       <c:choose>
                                                         <c:when test="${p.discntSeq gt 0}">
                                                             <strike>₩ ${p.printProductPrice}</strike> -&gt;  ₩ ${p.printPayPrice}
                                                                 </a>
                                                                 <br/><span style="color:red">${p.discntRate} % 할인 중!</span>
                                                             </h5>
                                                             <u style="color:red">${p.discntEndDate}</u><span style="color:white"> 일 종료</span>
                                                         </c:when>
                                                         <c:otherwise>
                                                             ₩ ${p.printPayPrice}</a></h5>
                                                         </c:otherwise>
                                                     </c:choose>
                                                 </div>
                                               </div>
                                               </c:forEach>
                                             </c:if>
                                         </div>
                                     </div>
                                 </div>
                                </div>
                        </c:otherwise>
                    </c:choose>
            </div>
</section>
<!-- Product Section End -->
<input type="hidden" id="store_check" value="0">
<%@ include file="/WEB-INF/views/include/footer.jsp" %>
</body>
</html>