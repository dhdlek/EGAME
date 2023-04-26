package com.game.web.controller;

import java.util.ArrayList;
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
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.game.common.util.StringUtil;
import com.game.web.model.Discnt;
import com.game.web.model.Paging;
import com.game.web.model.Product;
import com.game.web.model.ProductSearch;
import com.game.web.model.Response;
import com.game.web.model.Review;
import com.game.web.model.User;
import com.game.web.service.AdminService;
import com.game.web.service.EGameService;
import com.game.web.service.UserService;
import com.game.web.util.CookieUtil;
import com.game.web.util.HttpUtil;

@Controller("adminController")
public class AdminController {
	
	private static Logger logger = LoggerFactory.getLogger(AdminController.class);
	
	@Autowired
	private EGameService eGameService;
	
	@Autowired
	private AdminService adminService;
	
	@Autowired
	private UserService userService;
	
	//한 페이지당 리뷰 갯수
	private final long PAGE_REVIEW = 5;
	
	//한 페이지당 글 갯수
	private final long PAGE_VIEW = 10;
	
	//한 페이지당 글 갯수(상품)
	private final long PAGE_PRODCUT_VIEW = 12;
	
	//한 페이지당 페이징 갯수
	private final long PAGE_LIST = 5;
	
	//유저 쿠키 이름
	@Value("#{env['auth.cookie.name']}")
	private String AUTH_COOKIE_NAME;
		
	//관리자 유저 관리 사이트 이동
	@RequestMapping(value="/admin/index")
	public String adminIndex(HttpServletRequest request, HttpServletResponse response)
	{
		String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME, ""); 
		
		if(!StringUtil.isEmpty(cookieUserId))						//아이디 어드민 체크
		{
			User user = eGameService.userSelect(cookieUserId);
			logger.debug("user.getUserClass() : "+user.getUserClass());

			if(user != null)
			{
				
				if(user.getUserClass() != 'a')
				{
					
					return "/index";
				}
			}
			
		}
		
		return "/admin/index";
	}
	
	//유저 리스트 ajax
	@RequestMapping(value="/admin/user", method=RequestMethod.POST)
	@ResponseBody
	public Response<Object> adminUserList(HttpServletRequest request, HttpServletResponse response)
	{
		Response<Object> ajaxResponse = new Response<Object>();
		
		String userStatus = HttpUtil.get(request, "userStatus", "");
		String userClass = HttpUtil.get(request, "userClass", "");
		String searchType = HttpUtil.get(request, "searchType", "");
		String searchValue = HttpUtil.get(request, "searchValue", "");
		
		long curPage = HttpUtil.get(request, "curPage", (long)1);
		logger.debug("=================================");
		logger.debug("curPage : " + curPage);
		logger.debug("=================================");
		int userCount = 0;
		User user = new User();
		Paging paging = null;
		List<User> userList = null;
		Map<String,Object> responseMap = new HashMap<String, Object>();
		
		
		if(!StringUtil.isEmpty(userStatus))
		{
			user.setUserStatus(userStatus.charAt(0));
		}
		
		if(!StringUtil.isEmpty(userClass))
		{
			user.setUserClass(userClass.charAt(0));
		}
		
		if(!StringUtil.isEmpty(searchType)&& !StringUtil.isEmpty(searchValue))
		{
			user.setSearchType(searchType);
			user.setSearchValue(searchValue);
		}
		
		userCount = adminService.userCount(user);
		
		paging = new Paging("/admin/user", userCount, PAGE_VIEW, PAGE_LIST, curPage, "curpage");
		
		user.setStartRow(paging.getStartRow());
		user.setEndRow(paging.getEndRow());
		
		userList = adminService.userList(user);
		
		responseMap.put("userList", userList);
		responseMap.put("paging", paging);
		responseMap.put("curPage", curPage);
		
		ajaxResponse.setResponse(0, "성공", responseMap);
		
		return ajaxResponse;
	}
	//유저관리 상세페이지
	@RequestMapping(value="/admin/userDetail")
	public String userDetail(HttpServletRequest request, HttpServletResponse response, Model model)
	{
		String userId = HttpUtil.get(request, "userId", "");
		User user = null;
		
		user = userService.userSelect(userId);
		int countGame = userService.countGame(userId);						//보유게임
		long expenditure = userService.expenditure(userId);					//사용포인트(지출합계)
		int countCart = userService.countCart(userId);						//장바구니 보유 갯수
		int countFriend = userService.countFriend(userId);					//친구 수
		int countQna = userService.countQna(userId);							//문의 작성 수
		int countQnaReview = userService.countQnaReview(userId);				//문의 답변 수
		int countReview = userService.countReview(userId);					//리뷰 작성 수
		int countReport = userService.countReport(userId);					//신고 작성 수
		int countCompleteReport = userService.countCompleteReport(userId);	//신고 답변 수
		model.addAttribute("user", user);
		model.addAttribute("countGame", countGame);
		model.addAttribute("expenditure", expenditure);
		model.addAttribute("countCart", countCart);
		model.addAttribute("countFriend", countFriend);
		model.addAttribute("countQna", countQna);
		model.addAttribute("countQnaReview", countQnaReview);
		model.addAttribute("countReview", countReview);
		model.addAttribute("countReport", countReport);
		model.addAttribute("countCompleteReport", countCompleteReport);
		
		return "/admin/userDetail";
	}
	
	//유저 업데이트
	@RequestMapping(value="/admin/userUpdate", method=RequestMethod.POST)
	@ResponseBody
	public Response<Object> userUpdate(HttpServletRequest request, HttpServletResponse response)
	{
		Response<Object> ajaxResponse = new Response<Object>();
		String userId = HttpUtil.get(request, "userId", "");
		String tmpStatus = HttpUtil.get(request, "userStatus","");
		char userStatus = tmpStatus.charAt(0);
		User user = null;
		
		if(!StringUtil.isEmpty(userId) && !StringUtil.isEmpty(tmpStatus))
		{
			if(userStatus == '0' || userStatus == '1')
			{
				user = userService.userSelect(userId);
				if(user != null)
				{
					user.setUserStatus(userStatus);
					if(adminService.userUpdate(user) > 0)
					{
						ajaxResponse.setResponse(0, "성공");
					}
					else
					{
						ajaxResponse.setResponse(500, "업데이트중 오류 발생");
					}
				}
				else
				{
					ajaxResponse.setResponse(404, "존재하지 않는 아이디 입니다.");
				}
			}
			else
			{
				ajaxResponse.setResponse(400, "유저 스테이터스 값이 잘못되었습니다.");
			}
		}
		else
		{
			ajaxResponse.setResponse(400, "파라미터 값이 잘못되었습니다.");
		}
		
		return ajaxResponse;
	}
	
	//상품관리 페이지 이동
	@RequestMapping(value="/admin/product")
	public String adminProduct(HttpServletRequest request, HttpServletResponse response)
	{
		String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME, ""); 
		
		if(!StringUtil.isEmpty(cookieUserId))						//아이디 어드민 체크
		{
			User user = eGameService.userSelect(cookieUserId);
			logger.debug("user.getUserClass() : "+user.getUserClass());

			if(user != null)
			{
				
				if(user.getUserClass() != 'a')
				{
					
					return "/index";
				}
			}
			
		}
		
		return "/admin/product";
	}
	
	//상품 리스트 ajax
	@RequestMapping(value="/admin/productForm")
	@ResponseBody
	public Response<Object> adminProductAjax(HttpServletRequest request, HttpServletResponse response,
			@RequestParam(value="tagNum[]") List<String> tagNum)
	{
		Response<Object> ajaxResponse = new Response<Object>();						//responseBody
		Map<String, Object> modelMap = new HashMap<String, Object>();				//responseBody 용 리스트 객체
		String productName = HttpUtil.get(request, "productName", "");				//게임이름 검색 밸류
		String discntCheck = HttpUtil.get(request, "discntCheck", "");				//할인여부 체크
		long minPrice = HttpUtil.get(request, "minPrice", (long)0);					//결제가격 최솟값
		long maxPrice = HttpUtil.get(request, "maxPrice", (long)0);					//결제가격 최대값
		String productStatus = HttpUtil.get(request, "productStatus", "");				//정렬방법
		
		long curPage = HttpUtil.get(request, "curPage", (long)1);					//현재 페이지값		
		String tagParentNum = HttpUtil.get(request, "tagParentNum", "");			//태그 대분류 넘버
		ProductSearch productSearch = new ProductSearch();							//상품 검색용 모델 객체 생성

		if(!StringUtil.isEmpty(productName))	//상품이름검색 에 값이있으면 서치객체에 세팅	
		{
			productSearch.setProductName(productName);
		}
		
		if(!StringUtil.isEmpty(discntCheck)) //할인여부체크 되어있으면 세팅
		{
			productSearch.setDiscntCheck(discntCheck);			
		}
			
		if(!StringUtil.isEmpty(productStatus))	//상품 상태
		{
			
			productSearch.setProductStatus(productStatus);
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
		
		long productListCnt = adminService.productCnt(productSearch); //게시물 총 수 가져오기
		
		Paging paging = new Paging("/test/product", productListCnt, PAGE_PRODCUT_VIEW, PAGE_LIST, curPage, "curPage");	//페이징 객체 생성
		
		if(paging != null)			//페이징 널체크
		{
			productSearch.setStartRow(paging.getStartRow());		//게시글 시작번호
			productSearch.setEndRow(paging.getEndRow());			//끝번호
		}
		
		List<Product> productList = adminService.productList(productSearch); //게시물 가져오기
		
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
	
	//관리자 상품 상세 페이지
	@RequestMapping(value="/admin/productDetail")
	public String storeDetail(Model model, HttpServletRequest request, HttpServletResponse response)
	{
		
		long productSeq = HttpUtil.get(request, "productSeq", (long)0);
		long curPage = HttpUtil.get(request, "curPage", (long)1);
		List<Review> reviewList = null;
		Discnt discntCheck = null;
		Paging paging =null;
		Product product = null;
		Review review = null;		//리뷰 검색용
		
		if(productSeq > 0)
		{
			
			product = adminService.productSelect(productSeq);
			
			long reviewCnt = eGameService.reviewCount(productSeq);
			paging = new Paging("/storeDetail", reviewCnt, PAGE_REVIEW, PAGE_LIST, curPage, "curPage");
			
			review = new Review();
			review.setProductSeq(product.getProductSeq());
			review.setStartRow(paging.getStartRow());
			review.setEndRow(paging.getEndRow());
			reviewList = eGameService.reviewList(review);
			
			discntCheck = adminService.productDiscntCheck(productSeq);
			if(discntCheck != null)
			{
				String startDate = discntCheck.getDiscntStartDate().substring(0,4) + "-" + discntCheck.getDiscntStartDate().substring(4,6) + "-" +discntCheck.getDiscntStartDate().substring(6,8); 
				String endDate = discntCheck.getDiscntEndDate().substring(0,4) + "-" + discntCheck.getDiscntEndDate().substring(4,6) + "-" +discntCheck.getDiscntEndDate().substring(6,8);
				discntCheck.setDiscntStartDate(startDate);
				discntCheck.setDiscntEndDate(endDate);
			}
		}
		
		model.addAttribute("discntCheck", discntCheck);
		model.addAttribute("product", product);
		model.addAttribute("reviewList", reviewList);
		model.addAttribute("paging", paging);
		return"/admin/productDetail";
	}
	
	//상품 스테이터스 업데이트
	@RequestMapping(value="/admin/productStatusUpdate", method=RequestMethod.POST)
	@ResponseBody
	public Response<Object> productStatusUpdate(HttpServletRequest request, HttpServletResponse response)
	{
		Response<Object> ajaxResponse = new Response<Object>();
		long productSeq = HttpUtil.get(request, "productSeq", (long)0);
		String productStatus = HttpUtil.get(request, "productStatus", "");
		Product product = null;
		
		if(!StringUtil.isEmpty(productStatus) && productSeq > 0)
		{
			product = adminService.productSelect(productSeq);
			if(product != null)
			{
				if(StringUtil.equals(productStatus, "Y"))
				{
					product.setProductStatus('S');
				}
				else if(StringUtil.equals(productStatus, "N"))
				{
					product.setProductStatus('Y');					
				}
				else if(StringUtil.equals(productStatus, "S"))
				{
					product.setProductStatus('Y');	
				}
				else
				{
					ajaxResponse.setResponse(400, "상품 스테이터스 값이 잘못되었습니다.");
					return ajaxResponse;
				}
				
				if(adminService.productStatusUpdate(product) > 0)
				{
					ajaxResponse.setResponse(0, "성공");
				}
				else
				{
					ajaxResponse.setResponse(500, "업데이트 중 오류발생");
				}
			}
			else
			{
				ajaxResponse.setResponse(404, "상품을 찾을 수 없습니다.");				
			}
		}
		else
		{
			ajaxResponse.setResponse(400, "파라미터값이 잘못되었습니다.");
		}
		
		
		return ajaxResponse;
	}
	
	//상품 할인테이블 인서트
	@RequestMapping(value="/admin/discntInsert", method=RequestMethod.POST)
	@ResponseBody
	public Response<Object> discntInsert(HttpServletRequest request, HttpServletResponse response)
	{
		Response<Object> ajaxResponse = new Response<Object>();
		long productSeq = HttpUtil.get(request, "productSeq", (long)0);
		long discntRate = HttpUtil.get(request, "discntRate", (long)0);
		String discntStartDate = HttpUtil.get(request, "discntStartDate", "");
		String discntEndDate = HttpUtil.get(request, "discntEndDate", "");
		Discnt discnt = null;
		
		if(productSeq > 0 && discntRate > 0 && !StringUtil.isEmpty(discntStartDate) && !StringUtil.isEmpty(discntEndDate))
		{
			if(adminService.productDiscntCheck(productSeq) == null)
			{
				discnt = new Discnt();
				
				discnt.setProductSeq(productSeq);
				discnt.setDiscntRate(discntRate);
				discnt.setDiscntStartDate(discntStartDate);
				discnt.setDiscntEndDate(discntEndDate);
				
				if(adminService.discntInsert(discnt) > 0)
				{
					ajaxResponse.setResponse(0, "할인 등록성공");
				}
				else
				{
					ajaxResponse.setResponse(500, "할인 등록중 오류 발생");
				}
			}
			else
			{
				ajaxResponse.setResponse(400, "이 상픔에 할인이 이미 존재합니다.");
			}
		}
		else
		{
			ajaxResponse.setResponse(400, "파라미터 값이 잘못되었습니다.");
		}
		
		
		return ajaxResponse;
	}
	
	//상품 할인테이블 업데이트
	@RequestMapping(value="/admin/discntUpdate", method=RequestMethod.POST)
	@ResponseBody
	public Response<Object> discntUpdate(HttpServletRequest request, HttpServletResponse response)
	{
		Response<Object> ajaxResponse = new Response<Object>();
		long productSeq = HttpUtil.get(request, "productSeq", (long)0);
		long discntRate = HttpUtil.get(request, "discntRate", (long)0);
		String discntStartDate = HttpUtil.get(request, "discntStartDate", "");
		String discntEndDate = HttpUtil.get(request, "discntEndDate", "");
		String discntStatus = HttpUtil.get(request, "discntStatus", "");
		Discnt discnt = null;
		
		if(productSeq > 0 && discntRate > 0 && !StringUtil.isEmpty(discntStartDate) && !StringUtil.isEmpty(discntEndDate))
		{
			
				discnt = new Discnt();
				
				discnt.setProductSeq(productSeq);
				discnt.setDiscntRate(discntRate);
				discnt.setDiscntStartDate(discntStartDate);
				discnt.setDiscntEndDate(discntEndDate);
				
				if(!StringUtil.isEmpty(discntStatus))
				{
					discnt.setDiscntStatus(discntStatus.charAt(0));
				}
				
				if(adminService.discntUpdate(discnt) > 0)
				{
					ajaxResponse.setResponse(0, "할인 수정성공");
				}
				else
				{
					ajaxResponse.setResponse(500, "할인 등록중 오류 발생");
				}
			
		}
		else
		{
			ajaxResponse.setResponse(400, "파라미터 값이 잘못되었습니다.");
		}
		
		
		return ajaxResponse;
	}
	
	//상품 할인 삭제
	@RequestMapping(value="/admin/discntDelete", method=RequestMethod.POST)
	@ResponseBody
	public Response<Object> discntDelete(HttpServletRequest request, HttpServletResponse response)
	{
		Response<Object> ajaxResponse = new Response<Object>();
		long discntSeq = HttpUtil.get(request, "discntSeq", (long)0);
		
		if(discntSeq > 0)
		{
			if(adminService.discntDelete(discntSeq)>0)
			{
				ajaxResponse.setResponse(0, "할인 삭제성공");
			}
			else
			{
				ajaxResponse.setResponse(500, "할인 삭제중 오류 발생");
			}
		}
		else
		{
			ajaxResponse.setResponse(400, "파라미터값이 잘못되었습니다.");
		}
		
		return ajaxResponse;
	}
	
	//관리자 할인 관리 페이지 이동
	@RequestMapping(value="/admin/discnt")
	public String admindiscnt(HttpServletRequest request, HttpServletResponse response)
	{
		
		String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME, ""); 
		
		if(!StringUtil.isEmpty(cookieUserId))						//아이디 어드민 체크
		{
			User user = eGameService.userSelect(cookieUserId);
			logger.debug("user.getUserClass() : "+user.getUserClass());

			if(user != null)
			{
				
				if(user.getUserClass() != 'a')
				{
					
					return "/index";
				}
			}
			
		}
		
		
		return "/admin/discnt";
	}
	
	//할인 리스트 ajax
	@RequestMapping(value="/admin/discntAjax", method=RequestMethod.POST)
	@ResponseBody
	public Response<Object> discntAjax(HttpServletRequest request, HttpServletResponse response)
	{
		Response<Object> ajaxResponse = new Response<Object>();
		String searchValue = HttpUtil.get(request, "searchValue");
		String discntStatus = HttpUtil.get(request, "discntStatus", "");
		String dateSearch = HttpUtil.get(request, "dateSearch","");
		long curPage = HttpUtil.get(request, "curPage", (long)1);
		List<Discnt> discntList = null;
		Map<String,Object> modelMap = new HashMap<String, Object>();
		
		Paging paging = null;
		Discnt discntSearch = new Discnt();										//할인 검색용 객체
		int discntCount = 0;													//할인 열 총 카운트
		
		if(!StringUtil.isEmpty(searchValue))
		{
			discntSearch.setSearchValue(searchValue);
		}
				
		if(!StringUtil.isEmpty(discntStatus))
		{
			discntSearch.setDiscntStatus(discntStatus.charAt(0));
		}
		else
		{
			discntSearch.setDiscntStatus(' ');
		}
		
		if(!StringUtil.isEmpty(dateSearch))
		{
			discntSearch.setDateSearch(dateSearch);
		}
		
		discntCount = adminService.discntCount(discntSearch);
		
		if(discntCount>0)
		{
			paging = new Paging("/admin/discnt", discntCount, PAGE_VIEW, PAGE_LIST, curPage, "curPage");
			
			discntSearch.setStartRow(paging.getStartRow());
			discntSearch.setEndRow(paging.getEndRow());
			
			discntList = adminService.discntList(discntSearch);
			
			if(discntList != null && discntList.size() > 0)
			{
				for(int i = 0; i < discntList.size(); i++)
				{
					String startDate = discntList.get(i).getDiscntStartDate().substring(0,4) + "-" + discntList.get(i).getDiscntStartDate().substring(4,6) + "-" +discntList.get(i).getDiscntStartDate().substring(6,8); 
					String endDate = discntList.get(i).getDiscntEndDate().substring(0,4) + "-" + discntList.get(i).getDiscntEndDate().substring(4,6) + "-" +discntList.get(i).getDiscntEndDate().substring(6,8);
					
					discntList.get(i).setDiscntStartDate(startDate);
					discntList.get(i).setDiscntEndDate(endDate);						
				}
			}
			
		}
		else
		{
			discntList = new ArrayList<Discnt>();
		}
		
		modelMap.put("paging", paging);
		modelMap.put("discntList", discntList);
		modelMap.put("curPage", curPage);
		
		ajaxResponse.setResponse(0, "success", modelMap);
		
		return ajaxResponse;
	}
	
	//할인 일괄적용 ajax
	@RequestMapping(value="/admin/discntBeforeSubmit", method=RequestMethod.POST)
	@ResponseBody
	public Response<Object> discntBeforeSubmit(HttpServletRequest request, HttpServletResponse response)
	{
		Response<Object> ajaxResponse = new Response<Object>();
		
		try
		{
			int count = adminService.discntBeforeSubmit();
			
			if(count > 0)
			{
				ajaxResponse.setResponse(0, "success",count);
			}
			else
			{
				ajaxResponse.setResponse(404, "업데이트 할 할인이 없습니다.");
			}
		}
		catch(Exception e)
		{
			logger.error("[AdminController]discntBeforeSubmit Exception", e);
		}
		
		return ajaxResponse;
	}
	
	//할인 일괄해제 ajax
	@RequestMapping(value="/admin/discntEndSubmit", method=RequestMethod.POST)
	@ResponseBody
	public Response<Object> discntEndSubmit(HttpServletRequest request, HttpServletResponse response)
	{
		Response<Object> ajaxResponse = new Response<Object>();
		
		try
		{
			int count = adminService.discntEndSubmit();
			if(count > 0)
			{
				ajaxResponse.setResponse(0, "success", count);
			}
			else
			{
				ajaxResponse.setResponse(404, "업데이트 할 할인이 없습니다.");
			}
		}
		catch(Exception e)
		{
			logger.error("[AdminController]discntEndSubmit Exception", e);
		}
		
		return ajaxResponse;
	}

	//리뷰 상세 이동
	@RequestMapping(value="/admin/reviewDetail")
	public String reviewDetail(Model model, HttpServletRequest request, HttpServletResponse response)
	{
		long reviewSeq = HttpUtil.get(request, "reviewSeq", (long)0);
		Review review = null;
		
		if(reviewSeq > 0)
		{
			review = eGameService.reviewSeqSelect(reviewSeq);
		}
		
		
		model.addAttribute("review", review);
		return "/admin/reviewDetail";
	}
		
}	
