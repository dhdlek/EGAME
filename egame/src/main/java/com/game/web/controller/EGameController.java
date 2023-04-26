package com.game.web.controller;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.game.common.model.FileData;
import com.game.common.util.StringUtil;
import com.game.web.model.Cart;
import com.game.web.model.Paging;
import com.game.web.model.Pay;
import com.game.web.model.Product;
import com.game.web.model.ProductSearch;
import com.game.web.model.Response;
import com.game.web.model.Review;
import com.game.web.model.User;
import com.game.web.service.EGameService;
import com.game.web.service.UserService;
import com.game.web.util.CookieUtil;
import com.game.web.util.HttpUtil;

@Controller("egameController")
public class EGameController {

	private static Logger logger = LoggerFactory.getLogger(EGameController.class);
	
	//한 페이지당 글 갯수
	private final long PAGE_VIEW = 12;
	
	//한 페이지당 페이징 갯수
	private final long PAGE_LIST = 5;
	
	//한 페이지당 리뷰 갯수
	private final long PAGE_REVIEW = 5;
	
	//유저 쿠키 이름
	@Value("#{env['auth.cookie.name']}")
	private String AUTH_COOKIE_NAME;
	
	//상품 쿠키 번호
	@Value("#{env['product.cookie.name']}")
	private String PRODUCT_COOKIE_SEQ;
	
	//메인 파일 저장 경로
	@Value("#{env['upload.main.save.dir']}")
	private String UPLOAD_MAIN_SAVE_DIR;
	
	//디테일 파일 저장 경로
	@Value("#{env['upload.detail.save.dir']}")
	private String UPLOAD_DETAIL_SAVE_DIR;
	
	@Autowired
	private EGameService eGameService;
	
	@Autowired
	private UserService userService;
	
	//상품페이지 이동 메서드
	@RequestMapping(value="/store")
	public String store(Model model, HttpServletRequest request, HttpServletResponse response)
	{
		//CookieUtil.addCookie(response, "/", -1, AUTH_COOKIE_NAME, CookieUtil.stringToHex("user2"));
		String productName = HttpUtil.get(request, "productName", "");
		String tagParentNum = HttpUtil.get(request, "tagParentNum","");
		String orderValue = HttpUtil.get(request, "orderValue", "");
		String discntCheck = HttpUtil.get(request, "discntCheck","");
		
		
		model.addAttribute("discntCheck", discntCheck);
		model.addAttribute("orderValue",orderValue);
		model.addAttribute("productName", productName);
		model.addAttribute("tagParentNum", tagParentNum);
		return "/store";
	}
	
	//상품 상세페이지 이동 메서드
	@RequestMapping(value="/storeDetail")
	public String storeDetail(Model model, HttpServletRequest request, HttpServletResponse response)
	{
		
		long productSeq = HttpUtil.get(request, "productSeq", (long)0);
		String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME);
		//쿠키 상품번호 배열
	    List<String> productCookieSeq = new ArrayList<String>();
		
		long curPage = HttpUtil.get(request, "curPage", (long)1);
		List<Review> reviewList = null;
		Paging paging =null;
		Product product = null;
		Review review = null;		//리뷰 검색용
		Review myReview = null;		//로그인한 유저의 리뷰
		Pay pay = null;				//구매여부 확인용 객체
		Cart cart = null;			//장바구니 보유여부 체크
		int cartCheck = 0; 			//카트 보유여부 체크
		int buyCheck = 0;			//구매여부 체크
		
		if(productSeq > 0)
		{
			
			product = eGameService.productSelect(productSeq);
			
			long reviewCnt = eGameService.reviewCount(productSeq);
			paging = new Paging("/storeDetail", reviewCnt, PAGE_REVIEW, PAGE_LIST, curPage, "curPage");
			
			review = new Review();
			review.setProductSeq(product.getProductSeq());
			review.setStartRow(paging.getStartRow());
			review.setEndRow(paging.getEndRow());
			reviewList = eGameService.reviewList(review);	//전체 리뷰 리스트

			if(reviewList != null && reviewList.size() > 0)
			{
				if(!StringUtil.isEmpty(cookieUserId))		//내가쓴 리뷰가 있는지 확인
				{
					myReview = new Review();
					myReview.setProductSeq(productSeq);
					myReview.setUserId(cookieUserId);
					
					if(eGameService.reviewSelect(myReview) != null) 
					{
						myReview = eGameService.reviewSelect(myReview);
					}
					else
					{
						myReview = null;
					}
					
				}
			}
		}
		
		//상품구매여부 체크
		if(!StringUtil.isEmpty(cookieUserId))
		{
			pay = new Pay();
			pay.setProductSeq(productSeq);
			pay.setUserId(cookieUserId);
			buyCheck = eGameService.productBuyCheck(pay);	
			if(buyCheck <=0)
			{
				cart = new Cart();
				cart.setProductSeq(productSeq);
				cart.setUserId(cookieUserId);
				cartCheck = eGameService.cartCheck(cart);
			}
		}
		
		//최근본게임 쿠키처리영역
		String[] cookieSeq = null;
		if(!StringUtil.isEmpty(CookieUtil.getHexValue(request, PRODUCT_COOKIE_SEQ, "")))
		{
			cookieSeq = CookieUtil.getHexValue(request, PRODUCT_COOKIE_SEQ, "").replaceAll(" ", "").replaceAll("\\[", "").replaceAll("\\]", "").split(",");
		}
		
		
		boolean seqDupCheck = true;
		int dupIndex = 0;
		
		if(cookieSeq != null)
		{
			for(int i = 0; i<cookieSeq.length; i++)
			{
				productCookieSeq.add(cookieSeq[i]);
				if(StringUtil.equals(cookieSeq[i], String.valueOf(productSeq)))
				{
					seqDupCheck = false;
					dupIndex = i;
				}
			}
			if(seqDupCheck == true)				//쿠키리스트에 같은 상품이 있는지 확인
			{
				productCookieSeq.add(String.valueOf(productSeq));				
			}
			else if(!StringUtil.equals(cookieSeq[cookieSeq.length-1], String.valueOf(productSeq)))		//같은 상품이 있으면서 제일뒤가 아니면 제일뒤로 변경
			{
				productCookieSeq.remove(dupIndex);
				productCookieSeq.add(String.valueOf(productSeq));
			}
			
		}
		else
		{
			productCookieSeq.add(String.valueOf(productSeq));
		}
		
		productCookieSeq.removeAll(Arrays.asList("", null));			//쿠키리스트에 널값 제거
		
		//쿠키생성 3개이상 들어가면 가장 먼저추가된 상품번호를 지움
		if(productCookieSeq.size() <= 3 && productCookieSeq.size() > 0)
		{
			CookieUtil.addCookie(response, "/", -1, PRODUCT_COOKIE_SEQ, CookieUtil.stringToHex(productCookieSeq.toString()));		
		}
		else if(productCookieSeq.size() > 3)
		{
			productCookieSeq.remove(0);
			CookieUtil.addCookie(response, "/", -1, PRODUCT_COOKIE_SEQ, CookieUtil.stringToHex(productCookieSeq.toString()));
		}
		
		model.addAttribute("cartCheck", cartCheck);
		model.addAttribute("buyCheck", buyCheck);
		model.addAttribute("myReview", myReview);
		model.addAttribute("product", product);
		model.addAttribute("reviewList", reviewList);
		model.addAttribute("paging", paging);
		model.addAttribute("cookieUserId", cookieUserId);
		return "/storeDetail";
	}
	
	//리뷰 작성 메서드
	@RequestMapping(value="/review/reviewForm")
	@ResponseBody
	@Transactional
	public Response<Object> reviewInsert(HttpServletRequest request, HttpServletResponse response)
	{
		Response<Object> ajaxResponse = new Response<Object>();
		String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME, "");
		long productSeq = HttpUtil.get(request, "productSeq", (long)0);
		String reviewContent = HttpUtil.get(request, "reviewContent", "");
		long grade = HttpUtil.get(request, "grade", (long)0);
		Review review = null;
		
		if(!StringUtil.isEmpty(cookieUserId))
		{
			if(eGameService.userCheck(cookieUserId) > 0)
			{
				review = new Review();
				review.setUserId(cookieUserId);
				review.setProductSeq(productSeq);
				if(eGameService.reviewCheck(review) <= 0)
				{
					if(productSeq > 0 && !StringUtil.isEmpty(reviewContent) && grade>0)
					{
						review.setReviewContent(reviewContent);
						review.setProductGrade(grade);
						
						if(eGameService.reviewInsert(review) > 0)
						{
							if(eGameService.productReviewUpdate(productSeq)>0)
							{
								ajaxResponse.setResponse(0, "success"); //성공								
							}
							else
							{
								ajaxResponse.setResponse(500, "update error"); //update중 오류발생
							}
						}
						else
						{
							ajaxResponse.setResponse(500, "insert error"); //insert중 오류발생
						}
					}
					else
					{
						ajaxResponse.setResponse(400, "bad Reque");	//request 파라미터값이 잘못됨
					}
				}
				else
				{
					ajaxResponse.setResponse(402, "duplication"); //작성된 리뷰가 이미 있음
				}
			}
			else
			{
				ajaxResponse.setResponse(401, "bad Cookie OR bad Status");	//쿠키아이디가 DB아이디와 안맞거나 정지된 계정
			}
		}
		else
		{
			ajaxResponse.setResponse(404, "Id Not Found"); //로그인 안한상태
		}
		
		
		return ajaxResponse;
	}
	
	//리뷰 삭제 메서드
	@RequestMapping(value="/review/delete", method=RequestMethod.POST)
	@ResponseBody
	public Response<Object> reviewDelete(HttpServletRequest request, HttpServletResponse response)
	{
		Response<Object> ajaxResponse = new Response<Object>();
		long reviewSeq = HttpUtil.get(request, "reviewSeq", (long)0);
		String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME, "");
		long productSeq = HttpUtil.get(request, "productSeq", (long)0);
		Review review = null;
		
		
		if(!StringUtil.isEmpty(cookieUserId))
		{
			if(eGameService.userCheck(cookieUserId)>0)
			{
				review = eGameService.reviewSeqSelect(reviewSeq);
				if(eGameService.reviewDelete(reviewSeq)>0)
				{
					if(eGameService.productReviewUpdate(review.getProductSeq())>0)
					{
						logger.debug("1111111111111111111111111111111111111111111111111111111111111111111111");
						ajaxResponse.setResponse(0, "성공"); 		
						logger.debug("222222222222222222222222222");
					}
					else
					{
						ajaxResponse.setResponse(500, "삭제도중 오류발생");
					}
				}
				else
				{
					ajaxResponse.setResponse(-1, "존재하지않거나 이미 삭제된 리뷰입니다.");
				}
			}
			else
			{
				ajaxResponse.setResponse(400,"잘못된 요청입니다.");
			}
		}
		else
		{
			ajaxResponse.setResponse(400,"잘못된 접근방식입니다.");
		}
		
		logger.debug("3333333333333333333333333333333");
		
		logger.debug("ajaxResponse.getCode() : " + ajaxResponse.getCode());
		
		
		return ajaxResponse;
	}
	
	//리뷰 수정 메서드
	@RequestMapping(value="/review/update", method=RequestMethod.POST)
	@ResponseBody
	public Response<Object> reviewUpdate(HttpServletRequest request, HttpServletResponse response)
	{
		Response<Object> ajaxResponse = new Response<Object>();
		String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME);
		long productSeq = HttpUtil.get(request, "productSeq", (long)0);
		long grade = HttpUtil.get(request, "grade", (long)0);
		long reviewSeq = HttpUtil.get(request, "reviewSeq", (long)0);
		String reviewContent = HttpUtil.get(request, "reviewContent", "");
		Review review = null;
		if(!StringUtil.isEmpty(cookieUserId))
		{
			if(eGameService.userCheck(cookieUserId)>0)
			{
				if(productSeq > 0 && grade > 0 && reviewSeq > 0 && !StringUtil.isEmpty(reviewContent))
				{
					review = eGameService.reviewSeqSelect(reviewSeq);
					if(review != null)
					{
						review.setReviewContent(reviewContent);
						review.setProductGrade(grade);
						if(eGameService.reviewUpdate(review)>0)
						{
							if(eGameService.productReviewUpdate(productSeq)>0)
							{
								ajaxResponse.setResponse(0, "성공");
							}
							else
							{
								ajaxResponse.setResponse(500, "상품 업데이트 도중 오류발생");
							}
						}
						else
						{
							ajaxResponse.setResponse(500, "업데이트 도중 오류발생");
						}
					}
					else
					{
						ajaxResponse.setResponse(404, "이미 삭제되었거나 없는 리뷰입니다.");
					}
				}
				else
				{
					ajaxResponse.setResponse(400, "입력값이 올바르지 않습니다.");
				}
			}
			else
			{
				ajaxResponse.setResponse(404, "잘못된 아이디 입니다.");
			}
		}
		else
		{
			ajaxResponse.setResponse(404, "잘못된 접근입니다.");
		}
		
		return ajaxResponse;
	}
	
	//리뷰권한 체크
	@RequestMapping(value="/review/userCheck", method=RequestMethod.POST)
	@ResponseBody
	public Response<Object> reviewUserCheck(HttpServletRequest request, HttpServletResponse response)
	{
		Response<Object> ajaxResponse = new Response<Object>();
		String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME, "");
		long productSeq = HttpUtil.get(request, "productSeq", (long)0);
		
		if(productSeq > 0)
		{
			if(!StringUtil.isEmpty(cookieUserId))
			{
				if(eGameService.userCheck(cookieUserId) > 0)
				{
					if(eGameService.productSelect(productSeq) != null)
					{
						Pay pay = new Pay();
						pay.setProductSeq(productSeq);
						pay.setUserId(cookieUserId);
						int check = eGameService.productBuyCheck(pay);
						logger.debug("==============================================");
						logger.debug("check : " + check);
						logger.debug("==============================================");
						if(check > 0)
						{
							ajaxResponse.setResponse(0, "성공");
						}
						else
						{
							ajaxResponse.setResponse(-2, "상품을 구매해야 리뷰를 작성할 수 있습니다.");
						}
					}
					else
					{
						ajaxResponse.setResponse(404, "존재하지않는 상품입니다.");
					}
				}
				else
				{
					ajaxResponse.setResponse(404, "이미 탈퇴한 아이디 거나 정지된 아이디 입니다.");
				}
			}
			else
			{
				ajaxResponse.setResponse(-1, "로그인을해야 리뷰를 작성할 수 있습니다.");
			}			
		}
		else
		{
			ajaxResponse.setResponse(400, "잘못된 접근방식");
		}
		
		return ajaxResponse;
	}
	
	//장바구니 담기 메서드
	@RequestMapping(value="/cart/insert", method=RequestMethod.POST)
	@ResponseBody
	public Response<Object> cartInsert(HttpServletRequest request, HttpServletResponse response)
	{
		Response<Object> ajaxResponse = new Response<Object>();
		String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME);
		long productSeq = HttpUtil.get(request, "productSeq", (long)0);
		Cart cart = null;
		
		if(!StringUtil.isEmpty(cookieUserId))
		{
			if(eGameService.userCheck(cookieUserId) > 0)
			{
				if(eGameService.productSelect(productSeq) != null)
				{
					cart = new Cart();
					cart.setProductSeq(productSeq);
					cart.setUserId(cookieUserId);
					if(eGameService.cartDelete(cart) <= 0)
					{
						if(eGameService.cartInsert(cart) > 0)
						{
							ajaxResponse.setResponse(0, "장바구니 추가 성공");
						}
						else
						{
							ajaxResponse.setResponse(500, "장바구니 추가 중 오류발생");
						}						
					}
					else
					{
						ajaxResponse.setResponse(405, "장바구니안에 상품이 이미 추가되어 있습니다.");
					}
				}
				else
				{
					ajaxResponse.setResponse(404, "존재하지않는 상품입니다.");
				}
			}
			else
			{
				ajaxResponse.setResponse(404, "정지됐거나 없는 아이디 입니다.");
			}
		}
		else
		{
			ajaxResponse.setResponse(-1, "로그인이 필요합니다");				
		}
		
		return ajaxResponse;
	}
	
	//장바구니 삭제 메서드
	@RequestMapping(value="/cart/delete", method=RequestMethod.POST)
	@ResponseBody
	public Response<Object> cartDelete(HttpServletRequest request, HttpServletResponse response)
	{
		Response<Object> ajaxResponse = new Response<Object>();
		String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME);
		long productSeq = HttpUtil.get(request, "productSeq", (long)0);
		Cart cart = null;
	
		if(!StringUtil.isEmpty(cookieUserId))
		{
			if(eGameService.userCheck(cookieUserId) > 0)
			{
				if(eGameService.productSelect(productSeq) != null)
				{
					cart = new Cart();
					cart.setProductSeq(productSeq);
					cart.setUserId(cookieUserId);
					if(eGameService.cartCheck(cart)> 0)
					{
						if(eGameService.cartDelete(cart) > 0)
						{
							ajaxResponse.setResponse(0, "장바구니 삭제 성공");
						}
						else
						{
							ajaxResponse.setResponse(500, "장바구니 추가 중 오류발생");
						}						
					}
					else
					{
						ajaxResponse.setResponse(405, "장바구니안에 상품이 존재하지 않습니다.");
					}
				}
				else
				{
					ajaxResponse.setResponse(404, "존재하지않는 상품입니다.");
				}
			}
			else
			{
				ajaxResponse.setResponse(-1, "로그인이 필요합니다");				
			}
		}
		else
		{
			ajaxResponse.setResponse(400, "잘못된 접근방식");
		}
		
		return ajaxResponse;
	}
	
	//장바구니 선택삭제 메서드
	@RequestMapping(value="/cart/selectDelete", method=RequestMethod.POST)
	@ResponseBody
	public Response<Object> cartSelectDelete(HttpServletRequest request, HttpServletResponse response)
	{
		Response<Object> ajaxResponse = new Response<Object>();
		String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME);
		String[] prdSeqArr = request.getParameterValues("tdArray[]");
		Cart cart = null;
	
		if(!StringUtil.isEmpty(cookieUserId))
		{
			if(eGameService.userCheck(cookieUserId) > 0)
			{
				if(prdSeqArr != null && prdSeqArr.length > 0)
				{
					long productSeq = (long)0;
					
					for(int i = 0; i < prdSeqArr.length; i++)
					{
						productSeq = Integer.parseInt(prdSeqArr[i]);
						
						logger.debug("===========================================");
						logger.debug("i : " + i);
						logger.debug("productSeq : " + productSeq);
						logger.debug("===========================================");
						
						if(eGameService.productSelect(productSeq) != null)
						{
							cart = new Cart();
							cart.setProductSeq(productSeq);
							cart.setUserId(cookieUserId);
							
							if(eGameService.cartCheck(cart)> 0)
							{
								if(eGameService.cartDelete(cart) > 0)
								{
									ajaxResponse.setResponse(0, "장바구니 삭제 성공");
								}
								else
								{
									ajaxResponse.setResponse(500, "장바구니 추가 중 오류발생");
								}						
							}
							else
							{
								ajaxResponse.setResponse(405, "장바구니안에 상품이 존재하지 않습니다.");
							}
						}
						else
						{
							ajaxResponse.setResponse(404, "존재하지않는 상품입니다.");
						}
					}
				}
				else
				{
					ajaxResponse.setResponse(400, "잘못된 접근방식.");
				}
			}
			else
			{
				ajaxResponse.setResponse(401, "정지된 아이디 입니다.");
			}
		}
		else
		{
			ajaxResponse.setResponse(-1, "로그인이 필요합니다");
		}
		
		return ajaxResponse;
	}
	
	//최근 본상품 쿠키 삭제
	@RequestMapping(value="/product/cookieDelete", method=RequestMethod.POST)
	@ResponseBody
	public Response<Object> productCookieDelete(HttpServletRequest request,HttpServletResponse response)
	{
		Response<Object> ajaxResponse = new Response<Object>();
		
		CookieUtil.deleteCookie(request, response, "/", PRODUCT_COOKIE_SEQ);
		
		return ajaxResponse;
	}
	
	//장바구니 페이지
	@RequestMapping(value="/user/cart")
	public String cart(ModelMap model, HttpServletRequest request, HttpServletResponse response)
	{
		String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME);
		List<Cart> cartList = eGameService.cartSelect(cookieUserId);	
		User user = userService.userSelect(cookieUserId);
		
		model.addAttribute("cartList", cartList);
		model.addAttribute("user", user);
		
		return "/user/cart";
	}
	
	@RequestMapping(value="/test/index")
	public String test(HttpServletRequest request, HttpServletResponse response)
	{
		
		logger.debug("==================================================================================");
		logger.debug("/test/index");
		logger.debug("==================================================================================");
		return "/test/index";
	}
	
	//상품 등록
	@RequestMapping(value="/test/productInsert", method=RequestMethod.POST)
	@ResponseBody
	public Response<Object> productInsert(MultipartHttpServletRequest request, HttpServletResponse response, 
			@RequestParam(value="tags[]") List<String> tags)
	{
		Response<Object> ajaxResponse = new Response<Object>();
		
		String productName = HttpUtil.get(request, "productName");
		String productContent = HttpUtil.get(request, "productContent");
		String userSellerId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME);
		long productPrice = HttpUtil.get(request, "productPrice", (long)0);
		long payPrice = HttpUtil.get(request, "payPrice", (long)0);
		FileData fileData = HttpUtil.getFile(request, "productImg", UPLOAD_MAIN_SAVE_DIR, productName);
		FileData fileData1 = HttpUtil.getFile(request, "productImg1", UPLOAD_DETAIL_SAVE_DIR, productName + "_1");
		FileData fileData2 = HttpUtil.getFile(request, "productImg2", UPLOAD_DETAIL_SAVE_DIR, productName + "_2");
		FileData fileData3 = HttpUtil.getFile(request, "productImg3", UPLOAD_DETAIL_SAVE_DIR, productName + "_3");
		
		logger.debug("userId : "+ userSellerId);
		logger.debug("productPrice : "+ productPrice);
		logger.debug("productImg : "+ fileData.getFileName());
		logger.debug("productImg1 : "+ fileData1.getFileName());
		logger.debug("productImg2 : "+ fileData2.getFileName());
		logger.debug("productImg3 : "+ fileData3.getFileName());
		
		if(!StringUtil.isEmpty(productName) && !StringUtil.isEmpty(productContent) &&
				!StringUtil.isEmpty(userSellerId) && productPrice >= 0 &&
				payPrice >= 0 && fileData != null && fileData1 != null && fileData2 != null && fileData3 != null &&
				fileData.getFileSize() > 0 && fileData1.getFileSize() > 0 && fileData2.getFileSize() > 0 && fileData3.getFileSize() > 0 )
		{
			Product product = new Product();
			product.setProductName(productName);
			product.setProductContent(productContent);
			product.setUserSellerId(userSellerId);
			product.setProductPrice(productPrice);
			product.setPayPrice(productPrice);
			
			try
			{				
				if(eGameService.productInsert(product, tags) >0)
				{
					ajaxResponse.setResponse(0, "success");
				}
				else
				{
					ajaxResponse.setResponse(500, "error");
				}
			}
			catch(Exception e)
			{
				logger.debug("[EGameController] productInsert Exception", e);
				ajaxResponse.setResponse(500, "error");
			}
		}
		else
		{
			System.out.println("333333333333333333333333333333333333333333333333333");
			ajaxResponse.setResponse(400, "Bad Request");
		}
		
		
		
		return ajaxResponse;
	}
	
	//상품 페이지 이동 메서드
	@RequestMapping(value="/test/product")
	public String product(HttpServletRequest request, HttpServletResponse response)
	{
		String productName = HttpUtil.get(request, "productName", "");
		String tagParentNum = HttpUtil.get(request, "tagParentNum","");
				
		logger.debug("=========================================================");
		logger.debug("productName : " + productName);
		logger.debug("tagparentNum : " + tagParentNum);
		logger.debug("=========================================================");
		
		
		return"/test/product";
	}
	
	//상품 페이지 이동
	@RequestMapping(value="/test/productRegForm")
	public String reportRegForm(ModelMap model, HttpServletRequest request, HttpServletResponse response)
	{
		String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME);
		
		if(!StringUtil.isEmpty(cookieUserId))
		{
			User user = userService.userSelect(cookieUserId);
			model.addAttribute("user", user);
		}
		return "/test/productRegForm";
	}
	
	//상품페이지 ajax 메서드
	@RequestMapping(value="/test/productForm")
	@ResponseBody
	public Response<Object> product(HttpServletRequest request, HttpServletResponse response,
			@RequestParam(value="tagNum[]") List<String> tagNum/* 태그 소분류 배열 태그에 아무값도 안넘어올땐 nill값이 들어감*/)
	{
		Response<Object> ajaxResponse = new Response<Object>();						//responseBody
		Map<String, Object> modelMap = new HashMap<String, Object>();							//responseBody 용 리스트 객체
		String productName = HttpUtil.get(request, "productName", "");				//게임이름 검색 밸류
		String discntCheck = HttpUtil.get(request, "discntCheck", "");				//할인여부 체크
		long minPrice = HttpUtil.get(request, "minPrice", (long)0);					//결제가격 최솟값
		long maxPrice = HttpUtil.get(request, "maxPrice", (long)0);					//결제가격 최대값
		String orderValue = HttpUtil.get(request, "orderValue", "");				//정렬방법
		long curPage = HttpUtil.get(request, "curPage", (long)1);					//현재 페이지값		
		String tagParentNum = HttpUtil.get(request, "tagParentNum", "");			//태그 대분류 넘버
		ProductSearch productSearch = new ProductSearch();							//상품 검색용 모델 객체 생성

		logger.debug("==============================================================================");
		logger.debug("orderValue : " + orderValue);
		logger.debug("==============================================================================");
		
		if(!StringUtil.isEmpty(productName))	//상품이름검색 에 값이있으면 서치객체에 세팅	
		{
			productSearch.setProductName(productName);
		}
		
		if(!StringUtil.isEmpty(discntCheck)) //할인여부체크 되어있으면 세팅
		{
			productSearch.setDiscntCheck(discntCheck);			
		}
			
		if(!StringUtil.isEmpty(orderValue))	//정렬방법 체크
		{
			productSearch.setOrderValue(orderValue);
		}
		
		productSearch.setMinPrice(minPrice);	//최소값 세팅
		
		if(maxPrice > 0 && maxPrice > minPrice)	//최대값이 0보다크고 최소값보다 크면 세팅
		{
			productSearch.setMaxPrice(maxPrice);
		}
		
		if(!StringUtil.isEmpty(tagParentNum))		//대분류 태그체크 확인
		{
			productSearch.setTagParentNum(tagParentNum);	//대분류 태그넘버 세팅
			
			if(!StringUtil.isEmpty(tagNum.get(0)))			//소분류 태그체크 확인
			{
				productSearch.setTagNum(tagNum);//소분류 태그 세팅
			}
		}
		productSearch.setCurPage(curPage);	//현재페이지 세팅
		
		long productListCnt = eGameService.productCnt(productSearch); //게시물 총 수 가져오기
		
		Paging paging = new Paging("/test/product", productListCnt, PAGE_VIEW, PAGE_LIST, curPage, "curPage");	//페이징 객체 생성
		
		if(paging != null)			//페이징 널체크
		{
			productSearch.setStartRow(paging.getStartRow());		//게시글 시작번호
			productSearch.setEndRow(paging.getEndRow());			//끝번호
		}
		
		List<Product> productList = eGameService.productList(productSearch); //게시물 가져오기
		
		if(productList != null)	//게시물 널체크
		{
			modelMap.put("productList", productList);	//ajax용 리스트에 추가
		}
		
		modelMap.put("paging", paging);
		modelMap.put("productName", productName);
		modelMap.put("discntCheck", discntCheck);
		modelMap.put("minPrice", minPrice);
		modelMap.put("maxPrice", maxPrice);
		modelMap.put("curPage", curPage);
		modelMap.put("tagParentNum", tagParentNum);
		modelMap.put("tagNum", tagNum);
		
		ajaxResponse.setResponse(0, "success", modelMap);
		
		return ajaxResponse;
	}
	
	//장바구니 이동 ajax
	@RequestMapping(value="/user/cartProc", method=RequestMethod.POST)
	@ResponseBody
	public Response<Object> cartProc(HttpServletRequest request, HttpServletResponse response)
	{
		Response<Object> ajaxResponse = new Response<Object>();
		String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME);
		long productSeq = HttpUtil.get(request, "productSeq", (long)0);
		Cart cart = null;
		
		if(!StringUtil.isEmpty(cookieUserId))
		{
			if(productSeq > 0)
			{
				cart = new Cart();
				
				cart.setUserId(cookieUserId);
				cart.setProductSeq(productSeq);
				if(eGameService.cartCheck(cart) > 0)
				{
					ajaxResponse.setResponse(0, "성공");
				}
				else
				{
					if(eGameService.cartInsert(cart)>0)
					{
						ajaxResponse.setResponse(0, "성공");
					}
					else
					{
						ajaxResponse.setResponse(500, "장바구니 추가중 오류가 발생했습니다.");
					}
				}
			}
			else
			{
				ajaxResponse.setResponse(400, "파라미터값이 잘못되었습니다.");
			}
		}
		else
		{
			ajaxResponse.setResponse(-1,"로그인이 필요합니다.");
		}
		
		
		
		return ajaxResponse;
	}
	
	//로그인체크
	@RequestMapping(value="/store/loginCheck")
	@ResponseBody
	public Response<Object> loginCheck(HttpServletRequest request, HttpServletResponse response)
	{
		Response<Object> ajaxResponse = new Response<Object>();
		String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME, "");
		
		if(!StringUtil.isEmpty(cookieUserId))
		{
			if(eGameService.userCheck(cookieUserId) > 0)
			{
				ajaxResponse.setResponse(0, "success");
			}
			else
			{
				ajaxResponse.setResponse(404, "Not Found 2");
			}
		}
		else
		{
			ajaxResponse.setResponse(404, "Not Found");
		}
		
		return ajaxResponse;
	}
}
