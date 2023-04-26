package com.game.web.controller;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.game.common.model.FileData;
import com.game.common.util.FileUtil;
import com.game.common.util.StringUtil;
import com.game.web.model.Friend;
import com.game.web.model.Paging;
import com.game.web.model.Pay;
import com.game.web.model.Product;
import com.game.web.model.Response;
import com.game.web.model.User;
import com.game.web.service.EGameService;
import com.game.web.service.MailSendService;
import com.game.web.service.PayService;
import com.game.web.service.SellerService;
import com.game.web.service.UserService;
import com.game.web.util.CookieUtil;
import com.game.web.util.HttpUtil;
import com.game.web.util.JsonUtil;

@Controller("userController")
public class UserController {
	
	private static Logger logger = LoggerFactory.getLogger(UserController.class);
	
	//한 페이지당 페이징 갯수
	private static final long PAGE_LIST = 5;
	
	//친구페이지 : 한페이지 당 친구 수
	private static final int FR_LIST_COUNT = 9;	
		
	//쿠키명
	@Value("#{env['auth.cookie.name']}")
	private String AUTH_COOKIE_NAME;
	
	//파일 저장 경로
	@Value("#{env['user.upload.save.dir']}") 
	private String USER_UPLOAD_SAVE_DIR;
	
	@Autowired
	private UserService userService;
	
	@Autowired
	private EGameService eGameService;
	
	@Autowired
	private PayService payService;
	
	@Autowired
	private SellerService sellerService;
	
	@Autowired
	private MailSendService mailService;
	
	//회원가입 페이지
	@RequestMapping(value="/user/signUp", method=RequestMethod.GET)
	public String regForm(HttpServletRequest request, HttpServletResponse response)
	{
		String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME);
		
		if(StringUtil.isEmpty(cookieUserId))
		{
			return "/user/signUp";
		}
		else
		{
			CookieUtil.deleteCookie(request, response, AUTH_COOKIE_NAME);
			return "redirect:/";
		}
	}
	
	//아이디 중복 체크
	@RequestMapping(value="/user/idCheck", method=RequestMethod.POST)
	@ResponseBody
	public Response<Object> idCheck(HttpServletRequest request, HttpServletResponse response)
	{
		Response<Object> ajaxResponse = new Response<Object>();
		String userId = HttpUtil.get(request, "userId", "");
		
		if(!StringUtil.isEmpty(userId))
		{
			logger.debug("zzzzzzzzzzzzzzzzzzzzzzzzzzzz");
			logger.debug("userSeect : " + StringUtil.isNull(userService.userSelect(userId)));
			logger.debug("zzzzzzzzzzzzzzzzzzzzzzzzzzzz");
			
			if(StringUtil.isNull(userService.userSelect(userId)))
			{
				ajaxResponse.setResponse(0, "Success");
			}
			else
			{
				ajaxResponse.setResponse(100, "Duplicate ID");
			}
		}
		else
		{
			ajaxResponse.setResponse(400, "Bad Request");
		}
		
		if(logger.isDebugEnabled())
		{
			logger.debug("[UserController] /user/idCheck response\n" + JsonUtil.toJsonPretty(ajaxResponse));
		}
		
		return ajaxResponse;
	}
	
	//사업자번호 중복 체크
	@RequestMapping(value="/user/businessNumCheck", method=RequestMethod.POST)
	@ResponseBody
	public Response<Object> businessNumCheck(HttpServletRequest request, HttpServletResponse response)
	{
		Response<Object> ajaxResponse = new Response<Object>();
		String businessNum = HttpUtil.get(request, "userBusinessNum", "");
		
		logger.debug("zzzzzzzzzzzzzzzzzzzzzzzzzzzz");
		logger.debug("businessNum" + businessNum);
		logger.debug("zzzzzzzzzzzzzzzzzzzzzzzzzzzz");
		
		if(!StringUtil.isEmpty(businessNum))
		{
			
			if(StringUtil.isNull(userService.businessNumCheck(businessNum)))
			{
				ajaxResponse.setResponse(0, "Success");
			}
			else
			{
				ajaxResponse.setResponse(100, "Duplicate businessNum");
			}
		}
		else
		{
			ajaxResponse.setResponse(400, "Bad Request");
		}
		
		if(logger.isDebugEnabled())
		{
			logger.debug("[UserController] /user/idCheck response\n" + JsonUtil.toJsonPretty(ajaxResponse));
		}
		
		return ajaxResponse;
	}

	//회원가입
	@RequestMapping(value="/user/regProc", method=RequestMethod.POST)
	@ResponseBody
	public Response<Object> regProc(HttpServletRequest request, HttpServletResponse response)
	{
		logger.debug("1111111111111111111111111111111111");
		Response<Object> ajaxResponse = new Response<Object>();
		String userId = HttpUtil.get(request, "userId");
		String userPwd = HttpUtil.get(request, "userPwd");
		String userName = HttpUtil.get(request, "userName");
		String userEmail = HttpUtil.get(request, "userEmail");
		String userNickname = HttpUtil.get(request, "userNickname", "");
		String userClass = HttpUtil.get(request, "userClass", "Y");
		String userBusinessNum = HttpUtil.get(request, "userBusinessNum", "");
		
		logger.debug("222222222222222222222222222222222");
		logger.debug("userClass : " + userClass);
		if(!StringUtil.isEmpty(userId) && !StringUtil.isEmpty(userPwd) && 
		   !StringUtil.isEmpty(userName) && !StringUtil.isEmpty(userEmail) && 
		   !StringUtil.isEmpty(userNickname))
		{
			logger.debug("333333333333333333333333333333");
			if(userService.userSelect(userId) == null)
			{
				User user = new User();
				user.setUserId(userId);
				user.setUserPwd(userPwd);
				user.setUserName(userName);
				user.setUserEmail(userEmail);
				user.setUserNickname(userNickname);
				user.setUserImg("default.jpg");
				
				
				if(StringUtil.equals(userClass, "Y"))
				{
					user.setUserClass('s');
					if(StringUtil.isEmpty(userBusinessNum))
					{
						ajaxResponse.setResponse(400, "Bad Request");
						return ajaxResponse;
					}
					user.setBusinessNum(userBusinessNum);
				}
				else 
				{
					user.setUserClass('u');
				}
				
				user.setUserStatus('1');
				
				
				
				if(userService.userInsert(user) > 0)
				{
					ajaxResponse.setResponse(0, "Success");
				}
				else
				{
					ajaxResponse.setResponse(500, "Internal Server Error");
				}
			}
			else
			{
				ajaxResponse.setResponse(100, "Duplicate ID");
			}
		}
		else
		{
			ajaxResponse.setResponse(400, "Bad Request");
		}
		
		return ajaxResponse;
	}
	
	//로그인 페이지
	@RequestMapping(value="/user/login")
	public String login(HttpServletRequest request, HttpServletResponse response)
	{
		return "/user/login";
	}
	
	//로그인 ajax
	@RequestMapping(value="/user/loginProc", method=RequestMethod.POST)
	@ResponseBody
	public Response<Object> loginProc(HttpServletRequest request, HttpServletResponse response)
	{
		String userId = HttpUtil.get(request, "userId");
		String userPwd = HttpUtil.get(request, "userPwd");
		Response<Object> ajaxResponse = new Response<Object>();
		
		if(!StringUtil.isEmpty(userId) && !StringUtil.isEmpty(userPwd))
		{
			User user = userService.userSelect(userId);
			
			if(user != null)
			{
				if(StringUtil.equals(user.getUserPwd(), userPwd))
				{
					if(user.getUserStatus() == '0')
					{
						ajaxResponse.setResponse(405, "정지된 사용자");
					}
					else
					{
						CookieUtil.addCookie(response, "/", -1, AUTH_COOKIE_NAME, CookieUtil.stringToHex(userId));
					
						ajaxResponse.setResponse(0, "Success"); // 로그인 성공
					}
				}
				else
				{
					ajaxResponse.setResponse(-1, "Passwords do not match"); // 비밀번호 불일치
				}
			}
			else
			{
				ajaxResponse.setResponse(404, "Not Found"); // 사용자 정보 없음 (Not Found)
			}
		}
		else
		{
			ajaxResponse.setResponse(400, "Bad Request"); // 파라미터가 올바르지 않음 (Bad Request)
		}
		
		if(logger.isDebugEnabled())
		{
			logger.debug("[UserController] /user/login response\n" + JsonUtil.toJsonPretty(ajaxResponse));
		}
		
		return ajaxResponse;
	}
	
	//로그아웃
	@RequestMapping(value="/user/loginOutProc", method=RequestMethod.GET)
	public String loginOut(HttpServletRequest request, HttpServletResponse response)
	{
		if(CookieUtil.getCookie(request, AUTH_COOKIE_NAME) != null)
		{
			CookieUtil.deleteCookie(request, response, "/", AUTH_COOKIE_NAME);
		}
		
		return "redirect:/";
	}
	
	//회원정보수정 페이지 폼
	@RequestMapping(value="/user/userUpdate")
	public String userUpdate(ModelMap model, HttpServletRequest request, HttpServletResponse response)
	{
		String cookieUserId = "";
		
		if(CookieUtil.getCookie(request, AUTH_COOKIE_NAME) != null)
		{
			cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME);
		
			User user = userService.userSelect(cookieUserId);
		
			model.addAttribute("user", user);
			
			return "/user/userUpdate";
		}
		else
		{
			return "redirect:/";
		}
	}
	
	//회원정보수정 ajax
	@RequestMapping(value="/user/userUpdateProc", method=RequestMethod.POST)
	@ResponseBody
	public Response<Object> userUpdateProc(HttpServletRequest request, HttpServletResponse response)
	{
		Response<Object> ajaxResponse = new Response<Object>();
		String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME);
		String userPwd = HttpUtil.get(request, "userPwd");
		String userName = HttpUtil.get(request, "userName");
		
		if(!StringUtil.isEmpty(cookieUserId))
		{	
			User user = userService.userSelect(cookieUserId);
			
			if(user != null)
			{
				if(user.getUserStatus() == '1')
				{
					if(!StringUtil.isEmpty(userPwd) && !StringUtil.isEmpty(userName))
					{	
						user.setUserPwd(userPwd);
						user.setUserName(userName);
						
						if(userService.userUpdate(user) > 0)
						{
							ajaxResponse.setResponse(0, "Success");
						}
						else
						{
							ajaxResponse.setResponse(500, "Internal Server Error");
						}
					}
					
					else
					{
						ajaxResponse.setResponse(400, "Bad Request3");
					}
				}
				else
				{
					//정지된 사용자
					CookieUtil.deleteCookie(request, response, AUTH_COOKIE_NAME);
					ajaxResponse.setResponse(400, "Bad Request2");
				}
			}
			else
			{
				//사용자 정보 없음(쿠키 삭제)
				CookieUtil.deleteCookie(request, response, AUTH_COOKIE_NAME);
				ajaxResponse.setResponse(404, "Not Found");
			}
		}
		else
		{
			ajaxResponse.setResponse(400, "Bad Request");
		}
		
		return ajaxResponse;
	}
	
	//마이페이지 폼
	@RequestMapping(value="/user/myPage")
	public String myPage(ModelMap model, HttpServletRequest request, HttpServletResponse response)
	{
		String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME);		
		User user = null;
						
		user = userService.userSelect(cookieUserId);
		int countSaleGame = userService.countSaleGame(cookieUserId);				//판매게임
		int countGame = userService.countGame(cookieUserId);						//보유게임
		long expenditure = userService.expenditure(cookieUserId);					//사용포인트(지출합계)
		long expenditureRefund = userService.expenditureRefund(cookieUserId);		//사용포인트(환불합계)
		int countCart = userService.countCart(cookieUserId);						//장바구니 보유 갯수
		int countFriend = userService.countFriend(cookieUserId);					//친구 수
		int countQna = userService.countQna(cookieUserId);							//문의 작성 수
		int countQnaReview = userService.countQnaReview(cookieUserId);				//문의 답변 수
		int countReview = userService.countReview(cookieUserId);					//리뷰 작성 수
		int countReport = userService.countReport(cookieUserId);					//신고 작성 수
		int countCompleteReport = userService.countCompleteReport(cookieUserId);	//신고 답변 수
		long totalAmount = sellerService.totalAmount(cookieUserId);					//상품 총 매출액
				
		long result = expenditure - expenditureRefund;
		
		model.addAttribute("user", user);
		model.addAttribute("cookieUserId", cookieUserId);
		model.addAttribute("countSaleGame", countSaleGame);
		model.addAttribute("countGame", countGame);
		model.addAttribute("expenditure", result);
		model.addAttribute("countCart", countCart);
		model.addAttribute("countFriend", countFriend);
		model.addAttribute("countQna", countQna);
		model.addAttribute("countQnaReview", countQnaReview);
		model.addAttribute("countReview", countReview);
		model.addAttribute("countReport", countReport);
		model.addAttribute("countCompleteReport", countCompleteReport);
		model.addAttribute("totalAmount", totalAmount);
		
		return "/user/myPage";		
	}
	
	//친구 마이페이지 폼
	@RequestMapping(value="/user/friendPage")
	public String friendPage(ModelMap model, HttpServletRequest request, HttpServletResponse response)
	{
		String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME);
		String friendId = HttpUtil.get(request, "friendId", "");
		User user = null;		
		Friend friend = new Friend();
		Pay pay = new Pay();
		List<Pay> list = null;
		
		if(StringUtil.equals(cookieUserId, friendId))
		{
			user = userService.userSelect(cookieUserId);
			int countGame = userService.countGame(cookieUserId);						//보유게임
			long expenditure = userService.expenditure(cookieUserId);					//사용포인트(지출합계)
			long expenditureRefund = userService.expenditureRefund(cookieUserId);		//사용포인트(환불합계)
			int countCart = userService.countCart(cookieUserId);						//장바구니 보유 갯수
			int countFriend = userService.countFriend(cookieUserId);					//친구 수
			int countQna = userService.countQna(cookieUserId);							//문의 작성 수
			int countQnaReview = userService.countQnaReview(cookieUserId);				//문의 답변 수
			int countReview = userService.countReview(cookieUserId);					//리뷰 작성 수
			int countReport = userService.countReport(cookieUserId);					//신고 작성 수
			int countCompleteReport = userService.countCompleteReport(cookieUserId);	//신고 답변 수
					
			long result = expenditure - expenditureRefund;
			
			model.addAttribute("user", user);
			model.addAttribute("cookieUserId", cookieUserId);
			model.addAttribute("countGame", countGame);
			model.addAttribute("expenditure", result);
			model.addAttribute("countCart", countCart);
			model.addAttribute("countFriend", countFriend);
			model.addAttribute("countQna", countQna);
			model.addAttribute("countQnaReview", countQnaReview);
			model.addAttribute("countReview", countReview);
			model.addAttribute("countReport", countReport);
			model.addAttribute("countCompleteReport", countCompleteReport);		
			
			return "/user/myPage";
		}
		
		user = userService.userSelect(friendId);
		friend.setUserId(cookieUserId);
		friend.setFrUserId(friendId);
		friend.setFrStatus(userService.frStatus(friend));
		pay.setUserId(friendId);
		list = payService.libraryAllList(pay);
		
		model.addAttribute("user", user);
		model.addAttribute("friend", friend);
		model.addAttribute("list", list);
		
		return "/user/friendPage";
	}
	
	//프로필 변경
	@RequestMapping(value="/user/updateImg", method=RequestMethod.POST)
	@ResponseBody
	public Response<Object> updateImg(MultipartHttpServletRequest request, HttpServletResponse response)
	{
		Response<Object> ajaxResponse = new Response<Object>();
		String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME);
						
		//저장경로에 파일 저장됨
		FileData fileData = HttpUtil.getFile(request, "userFile", USER_UPLOAD_SAVE_DIR, cookieUserId, "userInfo");	
		
		User user = new User();			

		try
		{		
			if(fileData != null && fileData.getFileSize() > 0)						
			{
				user.setUserId(cookieUserId);
				user.setUserImg(fileData.getFileName());
				
				if(userService.updateImg(user) > 0)
				{
					ajaxResponse.setResponse(0, "Success");
				}
				else
				{
					ajaxResponse.setResponse(500, "internal server error1");
				}
			}
			else
			{
				//이전이미지 userId.jpg가 남아있으므로 default 확인이 되지 않음. -> 먼저 파일 삭제를 해준다.
				FileUtil.deleteFile(USER_UPLOAD_SAVE_DIR + FileUtil.getFileSeparator() + cookieUserId + ".jpg");
				
				logger.debug("=================");
				logger.debug(USER_UPLOAD_SAVE_DIR + FileUtil.getFileSeparator() + cookieUserId + ".jpg");
				logger.debug("=================");
				
				if(userService.updateImgToDf(cookieUserId) > 0)
				{									
					ajaxResponse.setResponse(1, "basic.jpg");
				}
				else
				{
					ajaxResponse.setResponse(500, "internal server error2");					
				}
			}
		}
		catch(Exception e)
		{
			logger.error("[UserController] /user/updateImg Exception", e);
			ajaxResponse.setResponse(500, "internal server error3");
		}			
		
		if(logger.isDebugEnabled())
		{		
			logger.debug("[UserController] /user/updateImg response\n" + JsonUtil.toJsonPretty(ajaxResponse));
		}
		
		return ajaxResponse;
	}
	
	//친구페이지 폼
	@RequestMapping(value="/user/friend")
	public String friend(ModelMap model, HttpServletRequest request, HttpServletResponse response)
	{
		String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME);
		List<Friend> friendSide = null;
		List<Friend> friend = null;
		Friend listFriend = new Friend();
		long curPage = HttpUtil.get(request, "curPage", (long)1);
		long totalCount = 0;
		Paging paging = null;
		
		totalCount = userService.countFriend(cookieUserId);
		
		listFriend.setUserId(cookieUserId);
		
		logger.debug("============================");
		logger.debug("totalCount : " + totalCount);
		logger.debug("============================");
		
		if(totalCount > 0)
		{
			paging = new Paging("user/friend", totalCount, FR_LIST_COUNT, PAGE_LIST, curPage, "curPage");
		
			paging.addParam("curPage", curPage);
			
			listFriend.setStartRow(paging.getStartRow());
			listFriend.setEndRow(paging.getEndRow()); 
			
			
			logger.debug("============================================================");
			logger.debug("startPage : " + paging.getStartPage());
			logger.debug("endPage : " + paging.getEndPage());
			logger.debug("nextBlockPage : " + paging.getNextBlockPage());
			logger.debug("============================================================");
			
			friend = userService.friendList(listFriend);
			friendSide = userService.friendSide(cookieUserId);
		}
		
		model.addAttribute("friend", friend);
		model.addAttribute("friendSide", friendSide);
		model.addAttribute("curPage", curPage);
		model.addAttribute("paging", paging);
		
		return "/user/friend";
	}
	
	//친구추가
	@RequestMapping(value="/user/addFriend", method=RequestMethod.GET)
	@ResponseBody
	public Response<Object> addFriend(HttpServletRequest request, HttpServletResponse response)
	{
		Response<Object> ajaxResponse = new Response<Object>();
		Friend friend = new Friend();
		String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME,"");
 		String friendId = HttpUtil.get(request, "friendId", "");
 		friend.setUserId(friendId);
 		friend.setFrUserId(cookieUserId);
 		
 		//friendId(상대)의 frStatus 조회
		friend.setFrStatus(userService.frStatus(friend));
		if(!StringUtil.isEmpty(cookieUserId))
		{
			
			if(StringUtil.isEmpty(friend.getFrStatus()))
			{
				try
				{
					if((userService.insertAcceptFrStatus(friend) > 0 && userService.insertProposalFrStatus(friend) > 0))
						//insertAcceptStatus(friend)		friendId(기준) - userId 로 frStatus - 2(수락대기) INSERT
						//insertProposalFrStatus(friend)	cookieUserId(기준) - frUserId 로 frStatus - 1(신청) INSERT
					{
						ajaxResponse.setResponse(0, "친구신청");
					}
					else
					{					
						ajaxResponse.setResponse(500, "internal server error1");
					}
					
				}
				catch(Exception e)
				{
					logger.error("[UserController] /user/addFriend Exception1", e);
					ajaxResponse.setResponse(500, "internal server error1");
				}			
			}
			else if(StringUtil.equals(friend.getFrStatus(), "1"))
			{
				try
				{
					if(userService.updateRegFrStatus(friend) > 0 && userService.updateMyRegFrStatus(friend) > 0)
						//updateRegFrStatus(friend)		friendId(기준) - userId 로 frStatus - 4(친구) UPDATE
						//updateMyRegFrStatus(friend)	cookieUserId(기준) - frUserId 로 frStatus - 4(친구) UPDATE	
					{
						ajaxResponse.setResponse(1, "친구등록");
					}
					else
					{
						ajaxResponse.setResponse(500, "internal server error2");
					}
				}
				catch(Exception e)
				{
					logger.error("[UserController] /user/addFriend Exception2", e);
					ajaxResponse.setResponse(500, "internal server error2");
				}
			}
			else if(StringUtil.equals(friend.getFrStatus(), "2"))
			{
				ajaxResponse.setResponse(400, "수락대기");
			}
			else if(StringUtil.equals(friend.getFrStatus(), "3"))
			{
				ajaxResponse.setResponse(401, "차단");
			}
			else if(StringUtil.equals(friend.getFrStatus(), "4"))
			{
				ajaxResponse.setResponse(402, "친구");
			}
		}
		else
		{
			ajaxResponse.setResponse(-2, "not found");
		}

		//ajaxResponse code debug
		if(logger.isDebugEnabled())
		{
			logger.debug("[UserController] /user/addFriend response\n" + JsonUtil.toJsonPretty(ajaxResponse));
		}
		
		return ajaxResponse;
	}
	
	//친구 끊기
	@RequestMapping(value="/user/cancleFriend", method=RequestMethod.GET)
	@ResponseBody
	public Response<Object> cancleFriend(HttpServletRequest request, HttpServletResponse response)
	{
		Response<Object> ajaxResponse = new Response<Object>();
		Friend friend = new Friend();
		String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME);
 		String friendId = HttpUtil.get(request, "friendId", "");
 		
 		logger.debug("============================");
 		logger.debug("friendId : " + friendId + " cookieUserId : " + cookieUserId);
 		logger.debug("============================");
 		
 		friend.setUserId(friendId);
 		friend.setFrUserId(cookieUserId);
 		
 		//friendId(상대)의 frStatus 조회
		friend.setFrStatus(userService.frStatus(friend));
		
		if(StringUtil.isEmpty(friend.getFrStatus()) || StringUtil.equals(friend.getFrStatus(), "3"))
		{
			ajaxResponse.setResponse(400, "결과 없음");
		}
		else if(StringUtil.equals(friend.getFrStatus(), "1"))
		{
			try
			{
				if(userService.deleteFrStatus(friend) > 0 && userService.deleteMyFrStatus(friend) > 0)
				//deleteFrStatus(friend)		friendId(기준) - userId 로 frStatus - 1(신청) DELETE
				//deleteMyFrStatus(friend)		cookieUserId(기준) - frUserId 로 frStatus - 2(수락대기) DELETE	
				{
					ajaxResponse.setResponse(1, "친구 신청 거절");
				}
				else
				{
					ajaxResponse.setResponse(500, "internal server error3");
				}
			}
			catch(Exception e)
			{
				logger.error("[UserController] /user/cancleFriend Exception3", e);
				ajaxResponse.setResponse(500, "internal server error33");
			}
		}
		else if(StringUtil.equals(friend.getFrStatus(), "2"))
		{
			try
			{
				if(userService.deleteFrStatus(friend) > 0 && userService.deleteMyFrStatus(friend) > 0)
				//deleteFrStatus(friend)		friendId(기준) - userId 로 frStatus - 2(수락대기) DELETE
				//deleteMyFrStatus(friend)		cookieUserId(기준) - frUserId 로 frStatus - 1(신청) DELETE	
				{
					ajaxResponse.setResponse(2, "친구 신청 취소");
				}
				else
				{
					ajaxResponse.setResponse(500, "internal server error4");
				}
			}
			catch(Exception e)
			{
				logger.error("[UserController] /user/cancleFriend Exception4", e);
				ajaxResponse.setResponse(500, "internal server error44");
			}
		}
		else if(StringUtil.equals(friend.getFrStatus(), "4"))
		{
			try
			{
				if(userService.deleteFrStatus(friend) > 0 && userService.deleteMyFrStatus(friend) > 0)
				//deleteFrStatus(friend)		friendId(기준) - userId 로 frStatus - 4(친구) DELETE
				//deleteMyFrStatus(friend)		cookieUserId(기준) - frUserId 로 frStatus - 4(친구) DELETE	
				{
					ajaxResponse.setResponse(3, "친구 목록 삭제");
				}
				else
				{
					ajaxResponse.setResponse(500, "internal server error5");
				}
			}
			catch(Exception e)
			{
				logger.error("[UserController] /user/cancleFriend Exception5", e);
				ajaxResponse.setResponse(500, "internal server error55");
			}
		}
		
		//ajaxResponse code debug
		if(logger.isDebugEnabled())
		{
			logger.debug("[UserController] /user/cancleFriend response\n" + JsonUtil.toJsonPretty(ajaxResponse));
		}

		return ajaxResponse;
	}
	
	//유저 이메일인증
	@RequestMapping(value="/user/emailCheck")
	@ResponseBody
	public Response<Object> emailCheck(HttpServletRequest request, HttpServletResponse response)
	{
		Response<Object> ajaxResponse = new Response<Object>();
		
		String email = HttpUtil.get(request, "userEmail", "");
		
		if(userService.userEmailCheck(email) > 0)
		{
			ajaxResponse.setResponse(-1, " 중복된 이메일 입니다.");
			return ajaxResponse;
		}
		
		if(!StringUtil.isEmpty(email))
		{
			ajaxResponse.setResponse(0, "success", mailService.joinEmail(email));			
		}
		else
		{
			ajaxResponse.setResponse(400, "파라미터값이 잘못되었습니다.");
		}
		
		
		return ajaxResponse;
	}
}
