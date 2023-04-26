<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>

<!DOCTYPE html>
<html lang="ko">

<head>
 <%@ include file="/WEB-INF/views/include/head.jsp" %>
<link rel="stylesheet" href="/resources/css/cart.css" type="text/css">
<title>Store eGame : 장바구니</title>
<script type="text/javascript" src="/resources/js/jquery-3.5.1.min.js"></script>
<script>
$(document).ready(function() {
	//장바구니 첫화면 금액 0원
	if($("input[name=payPrice]").is(":checked") == false)
	{
		$("#totalPrice").html(0);
	}
	
	//체크박스 클릭 시 전체선택/해제
	$("#selectAll").click(function(){
		if($("#selectAll").is(":checked"))
		{
			$("input[name=payPrice]").prop("checked", true);
			
			var totalPrice = 0;
			
			$("input[name=payPrice]:checked").each(function(i){
				totalPrice += parseInt($(this).val());
			});
			
			totalPrice = fn_comma(totalPrice);
			
			$("#totalPrice").html(totalPrice);
		}
		else
		{
			$("input[name=payPrice]").prop("checked", false);
			$("#totalPrice").html(0);
		}
	});
	
	//체크박스 체크 시 결제금액 출력
	$("input[name=payPrice]").on("click", function(){
		if($("input[name=payPrice]").is(":checked") == true)
		{
			var totalPrice = 0;
				
			$("input[name=payPrice]:checked").each(function(i){
				totalPrice += parseInt($(this).val());
			});
			
			price = totalPrice;
			
			totalPrice = fn_comma(totalPrice);
			
			$("#totalPrice").html(totalPrice);
		}
		else if($("input[name=payPrice]").is(":checked") == false)
		{
			$("#totalPrice").html(0);
		}
	});
	
	//상품결제
	$("#payBtn").on("click", function(){
		
		if($("input[name=payPrice]").is(":checked") == true)
		{
			var price = 0;
			var totalPrice = 0;
				
			$("input[name=payPrice]:checked").each(function(i){
				totalPrice += parseInt($(this).val());
			});
			
			price = totalPrice;
			
			totalPrice = fn_comma(totalPrice);
			
			$("#totalPrice").html(totalPrice);
		}
			
		console.log(price);
		console.log($("#pointPos").val());	
		
		var checkbox = $("input[name=payPrice]:checked");		//체크박스 체크된 값
		var tr = checkbox.parent().parent();					//tr값
		var td = tr.children();									//td값
		var payPrice = td.eq(0).children().val();				//첫번째 td값
		var productSeq = td.eq(1).children().val();				//두번째 td값
		
		var tdArray = new Array();
		
		checkbox.each(function(i){
			tr = checkbox.parent().parent().eq(i);
			td = tr.children();
			payPrice = td.eq(0).children().val();
			productSeq = td.eq(1).children().val();
			
			tdArray.push(payPrice);
			tdArray.push(productSeq);
		});
		
		console.log(tdArray);
		
		if(tdArray.length > 0)	
		{
			if(confirm("상품을 결제 하시겠습니까?") == true)
			{
				$.ajax({
					type:"POST",
					url:"/cart/payProc",
					data:{
						tdArray: tdArray
					},
					datatype:"JSON",
					beforeSend:function(xhr){
						xhr.setRequestHeader("AJAX", "true");
					},
					success:function(response)
					{
						if(response.code == 0)
						{
							alert("구매가 완료되었습니다.");
							location.reload();
						}
						else if(response.code == -1)
						{
							alert("로그인이 필요합니다.");
							location.href = "/user/login";
						}
						else if(response.code == 400)
						{
							alert("파라미터 값이 올바르지 않습니다.");
						}
						else if(response.code == 401)
						{
							alert("정지된 아이디 입니다.");
						}
						else if(response.code == 402)
						{
							alert("보유포인트가 부족합니다.");
						}
						else if(response.code == 404)
						{
							alert("상품을 찾을 수 없습니다.");
						}
						else if(response.code == 500)
						{
							alert("구매 중 오류가 발생하였습니다. 500");
						}
						else
						{
							alert("구매 중 오류가 발생하였습니다.");
						}
					},
					error:function(xhr, status, error)
					{
						game.common.error(error);
					}
				});
			}
		}
		else
		{
			alert("구매할 상품을 선택해주세요.");
			return;
		}
	});
});

//천단위 콤마 함수
function fn_comma(value)
{
	value = value.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
	
	return value;
}

//전체선택 클릭 함수
function fn_allSelect()
{
	var checkbox = $("input[name=payPrice]");
	
	if(checkbox.is(":checked") == false)
	{
		$("input[type=checkbox]").prop("checked", true);
		
		var totalPrice = 0;
		
		$("input[name=payPrice]:checked").each(function(i){
			totalPrice += parseInt($(this).val());
		});
		
		totalPrice = fn_comma(totalPrice);
		
		$("#totalPrice").html(totalPrice);
	}
	else
	{
		$("input[type=checkbox]").prop("checked", false);
		$("#totalPrice").html(0);
	}	
}

//전체삭제 클릭 함수
function fn_allDelete()
{
	var checkbox = $("input[name=payPrice]");				//체크박스 체크된 값
	var tr = checkbox.parent().parent();					//tr값
	var td = tr.children();									//td값
	var productSeq = td.eq(3).children().val();				//네번째 td값
	
	var tdArray = new Array();
	
	checkbox.each(function(i){
		tr = checkbox.parent().parent().eq(i);
		td = tr.children();
		productSeq = td.eq(3).children().val();
		
		tdArray.push(productSeq);
	});
	
	if(confirm("장바구니에서 상품을 전부 삭제하시겠습니까?") == true)
	{
		$.ajax({
			type:"POST",
			url:"/cart/selectDelete",
			data:{
				tdArray:tdArray
			},
			datatype:"JSON",
			beforeSend:function(xhr){
				xhr.setRequestHeader("AJAX", "true");
			},
			success:function(response){
				if(response.code == 0)
				{
					alert("장바구니에서 상품을 모두 삭제하였습니다.");
					location.reload();
				}
				else if(response.code == -1)
				{
					alert("로그인이 필요합니다.");
					location.href="/user/login";
				}
				else if(response.code == 401)
				{
					alert("정지된 아이디 입니다.");
				}
				else if(response.code == 400)
				{
					alert("잘못된 접근방식입니다.");
				}
				else if(response.code == 404)
				{
					alert("존재하지 않는 상품입니다.");					
				}
				else if(response.code == 405)
				{
					alert("장바구니에 상품이 존재하지 않습니다.");
				}
				else if(response.code == 500)
				{
					alert("장바구니에서 상품 삭제 중 오류가 발생하였습니다.");
				}
			},
			error:function(xhr, status, error){
				icia.common.error(error);
			}
		});
	}
}

//선택삭제 클릭 함수
function fn_selectDelete()
{
	var checkbox = $("input[name=payPrice]:checked");		//체크박스 체크된 값
	var tr = checkbox.parent().parent();					//tr값
	var td = tr.children();									//td값
	var productSeq = td.eq(3).children().val();				//네번째 td값
	
	var tdArray = new Array();
	
	checkbox.each(function(i){
		tr = checkbox.parent().parent().eq(i);
		td = tr.children();
		productSeq = td.eq(3).children().val();
		
		tdArray.push(productSeq);
	});
	
	if(checkbox.is(":checked") == true)
	{
		if(confirm("장바구니에서 선택하신 상품을 삭제하시겠습니까?") == true)
		{
			$.ajax({
				type:"POST",
				url:"/cart/selectDelete",
				data:{
					tdArray:tdArray
				},
				datatype:"JSON",
				beforeSend:function(xhr){
					xhr.setRequestHeader("AJAX", "true");
				},
				success:function(response){
					if(response.code == 0)
					{
						alert("장바구니에서 선택하신 상품을 삭제하였습니다.");
						location.href="/user/cart";
					}
					else if(response.code == -1)
					{
						alert("로그인이 필요합니다.");
						location.href="/user/login";
					}
					else if(response.code == 401)
					{
						alert("정지된 아이디 입니다.");
					}
					else if(response.code == 400)
					{
						alert("잘못된 접근방식입니다.");
					}
					else if(response.code == 404)
					{
						alert("존재하지 않는 상품입니다.");					
					}
					else if(response.code == 405)
					{
						alert("장바구니에 상품이 존재하지 않습니다.");
						location.href="/user/cart";
					}
					else if(response.code == 500)
					{
						alert("장바구니에서 상품 삭제 중 오류가 발생하였습니다.");
					}
				},
				error:function(xhr, status, error){
					icia.common.error(error);
				}
			});
		}
	}
	else
	{
		alert("선택된 상품이 없습니다.");
		return;
	}
	
}

//디테일 페이지 이동 함수
function fn_detail(product_seq)
{
  var popup = window.open(`/storeDetail?productSeq=${"${product_seq}"}`, "_blank", 'width=1000, height=1200, scrollbars=yes, resizable =no')
}

//장바구니 삭제 함수
function fn_deleteCart(prdSeq) {
	console.log(prdSeq);
	
	var prdSeq = prdSeq
	
	if(confirm("장바구니에서 상품을 삭제하시겠습니까?") == true)
	{
		$.ajax({
			type:"POST",
			url:"/cart/delete",
			data:{
				productSeq:prdSeq
			},
			datatype:"JSON",
			beforeSend:function(xhr){
				xhr.setRequestHeader("AJAX", "true");
			},
			success:function(response){
				if(response.code == 0)
				{
					location.href="/user/cart";
				}
				else if(response.code == -1)
				{
					alert("로그인이 필요합니다.");
					location.href="/user/login";
				}
				else if(response.code == 400)
				{
					alert("잘못된 접근방식입니다.");
					location.href="/index";
				}
				else if(response.code == 404)
				{
					alert("존재하지 않는 상품입니다.");
					location.href="/user/cart";						
				}
				else if(response.code == 405)
				{
					alert("장바구니에 상품이 존재하지 않습니다.");
					location.href="/user/cart";
				}
				else if(response.code == 500)
				{
					alert("장바구니에서 상품 삭제 중 오류가 발생하였습니다.");
				}
			},
			error:function(xhr, status, error){
				icia.common.error(error);
			}
		});
	}
}
</script>
</head>

<body>
<%@ include file="/WEB-INF/views/include/navigation.jsp" %>

<!-- Breadcrumb Begin -->
<div class="breadcrumb-option">
    <div class="container">
        <div class="row">
            <div class="col-lg-12">
                <div class="breadcrumb__links">
                    <a href="/index"><i class="fa fa-home"></i> Home</a>
                    <a href="/user/myPage">마이페이지</a>
                    <span>장바구니</span>
                </div>
            </div>
        </div>
    </div>
</div>
<!-- Breadcrumb End -->

<!-- 장바구니 -->
<c:choose>
	<c:when test="${!empty cartList}">
		<div id="cart" style="width: 60%; min-height: 540px; margin: 0 auto; margin-top: 50px; margin-bottom: 50px;">
		    <table class="cart_table" style="color: #ffffff;">
		        <thead>
		            <tr>
		                <th><input type="checkbox" id="selectAll" name="selectAll" /></th>               
		                <th style="width: 60%; text-align: left; padding-left: 10px;">상품 정보</th>
		                <th style="width: 20%;">상품 가격</th>
		                <th style="width: 20%;">선택</th>
		            </tr>
		        </thead>        
				<tbody id="tbody">        
			<c:forEach var="cartList" items="${cartList}" varStatus="status">         
		            <tr>
		                <td>
		                    <input type="checkbox" id="payPrice" name="payPrice" value="${cartList.payPrice}" />
		                </td>
		                <td class="cart_table_td1">
		                	<input type="hidden" id="productSeq" name="productSeq" value="${cartList.productSeq}"/>                 
		                    <a href="javascript:void(0)" onclick="fn_detail(${cartList.productSeq})">
		                    <img src="/resources/img_gamemain/${cartList.productName}.jpg" width="155px" height="110px">
		                    &nbsp;&nbsp;${cartList.productName}
		                    </a>
		                </td>
		                <td class="cart_table_td2">
					<c:choose>
						<c:when test="${cartList.discntSeq ne 0}">	              
							<span class="discnt">₩<fmt:formatNumber value="${cartList.productPrice}" pattern="#,###"/></span>                    
							<span style="margin-left: 5px;">₩<fmt:formatNumber value="${cartList.payPrice}" pattern="#,###"/></span>
						</c:when>
						<c:otherwise>
							<span style="margin-left: 5px;">₩<fmt:formatNumber value="${cartList.payPrice}" pattern="#,###"/></span>
						</c:otherwise>                    
					</c:choose>                    
		                </td>
		                <td class="cart_table_td2">
		                	<input type="hidden" id="productSeq" name="productSeq" value="${cartList.productSeq}"/>
		                	<button type="button" id="deleteBtn" class="site-btn" onclick="fn_deleteCart(${cartList.productSeq})">삭제</button>                    
		                </td>
		            </tr>
			</c:forEach>            
				</tbody>
			</table>
			
			<div>
				<div style="padding-top: 20px; padding-bottom: 30px;">
					<button type="button" class="site-btn" id="allSelect" onclick="fn_allSelect()">전체선택</button>
					<span style="padding-right: 750px;"></span>
					<button type="button" class="site-btn" id="selectDelete" onclick="fn_selectDelete()">선택삭제</button>
					&nbsp;&nbsp;
					<button type="button" class="site-btn" id="allDelete" onclick="fn_allDelete()">전체삭제</button>
				</div>
		        <div class="cart_pay">
		            <p style="font-size: 32px; font-weight: 800; padding-bottom: 4px;">총 결제 금액  : ₩<span id="totalPrice"></span></p>
		            <p>보유 포인트 : ₩<fmt:formatNumber value="${user.pointPos}" pattern="#,###"/></p>
		            <input type="hidden" id="pointPos" name="pointPos" value="${user.pointPos}">
		        </div>
		        <div style="text-align: right; padding-right: 10px; padding-top: 5px;">
		            <button id="payBtn" type="button" class="site-btn" style="margin-top: 10px; font-size: 22px;">결제</button>
		        </div>  
		    </div>   
		</div>
	</c:when>
	
	<c:otherwise>
		<div id="cart" style="width: 60%; min-height: 490px; margin: 0 auto; margin-top: 50px; margin-bottom: 50px;">
			<h2 style="color: #ffffff; font-weight: 700; margin-top: 100px; margin-bottom: 50px; text-align: center;">장바구니 목록이 없습니다.</h2>
		</div>
	</c:otherwise>
</c:choose>
<input type="hidden" id="store_check" value="0">
<%@ include file="/WEB-INF/views/include/footer.jsp" %>

</body>
</html>