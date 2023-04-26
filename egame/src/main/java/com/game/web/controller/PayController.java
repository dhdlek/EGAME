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

import com.game.common.util.StringUtil;
import com.game.web.model.Cart;
import com.game.web.model.Paging;
import com.game.web.model.Pay;
import com.game.web.model.Product;
import com.game.web.model.Response;
import com.game.web.model.Review;
import com.game.web.model.User;
import com.game.web.model.UserPoint;
import com.game.web.service.EGameService;
import com.game.web.service.PayService;
import com.game.web.service.UserService;
import com.game.web.util.CookieUtil;
import com.game.web.util.HttpUtil;

@Controller("payController")
public class PayController {
	
	private static Logger logger = LoggerFactory.getLogger(PayController.class);
	
	//쿠키명
	@Value("#{env['auth.cookie.name']}")
	private String AUTH_COOKIE_NAME;
	
	//보유게임
	private static final int LIST_COUNT = 5;
	
	//보유게임
	private static final int PAGE_COUNT = 5;
	
	//포인트내역 한 페이지의 게시물 수
	private static final int POINT_LIST_COUNT = 10;
	
	//포인트내역 페이징 수
	private static final int POINT_PAGE_COUNT = 5;
	
	@Autowired
	private PayService payService;
	
	@Autowired
	private UserService userService;
	
	@Autowired
	private EGameService eGameService;
	
	//장바구니 상품결제
	@RequestMapping(value="/cart/payProc", method=RequestMethod.POST)
	@ResponseBody
	public Response<Object> payProc(HttpServletRequest request, HttpServletResponse response)
	{
		Response<Object> ajaxResponse = new Response<Object>();
		String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME);
		String[] payArr = request.getParameterValues("tdArray[]");
		
		if(!StringUtil.isEmpty(cookieUserId))
		{
			if(userService.userCheck(cookieUserId) > 0)
			{
				if(payArr != null && payArr.length > 0)
				{
					long payPrice = 0;
					long productSeq = 0;
					long result = 0;
					
					for(int i = 0; i < payArr.length / 2; i++)
					{
						payPrice = Integer.parseInt(payArr[i * 2]);
						
						result += payPrice;
					}
					
					User user = userService.userSelect(cookieUserId);
					
					if(user.getPointPos() >= result)
					{
						logger.debug("===========================================");
						logger.debug("PointPos : " + user.getPointPos());
						logger.debug("payPrice : " + result);
						logger.debug("===========================================");
						
						for(int i = 0; i < payArr.length / 2; i++)
						{
							payPrice = Integer.parseInt(payArr[i * 2]);
							productSeq = Integer.parseInt(payArr[i * 2 + 1]);
							
							logger.debug("===========================================");
							logger.debug("i : " + i);
							logger.debug("productSeq : " + productSeq);
							logger.debug("payPrice : " + payPrice);
							logger.debug("===========================================");
							
							if(eGameService.productSelect(productSeq) != null)
							{
								if(payPrice != 0L)
								{
									Pay pay = new Pay();
									
									pay.setProductSeq(productSeq);
									pay.setUserId(cookieUserId);
									pay.setPayPrice(payPrice);
									pay.setPayStatus("1");			//구매
									pay.setPayMethod("p");			//포인트로 상품 구매
									
									try
									{
										if(payService.payInsert(pay) > 0)
										{
											//포인트 계산
											result = 0;
											long pointPos = user.getPointPos();			//보유포인트
											long pointVar = pay.getPayPrice();			//상품가격
											result = pointPos - pointVar;
											
											UserPoint userPoint = new UserPoint();
											
											userPoint.setPaySeq(pay.getPaySeq());
											userPoint.setUserId(cookieUserId);
											userPoint.setPointPos(result);
											userPoint.setPointVar(pay.getPayPrice());
											userPoint.setPointStatus("N");				//포인트 감소
											
											logger.debug("===========================================");
											logger.debug("paySeq : " + pay.getPaySeq());
											logger.debug("UserId : " + cookieUserId);
											logger.debug("PointPos : " + result);
											logger.debug("PointVar : " + pay.getPayPrice());
											logger.debug("PointStatus : " + userPoint.getPointStatus());
											logger.debug("===========================================");
											
											if(payService.userPointInsert(userPoint) > 0)
											{
												user.setUserId(cookieUserId);
												user.setPointPos(result);
												
												if(userService.updatePoint(user) > 0)
												{
													Cart cart = new Cart();
													cart.setProductSeq(productSeq);
													cart.setUserId(cookieUserId);
													
													if(eGameService.cartDelete(cart) > 0)
													{	
														Product product = new Product();
														product.setProductSeq(productSeq);
														
														if(eGameService.buyCountUpdate(product) > 0)
														{
															ajaxResponse.setResponse(0, "Success");
														}
														else
														{
															ajaxResponse.setResponse(500, "Internal Server Error 6");
														}
													}
													else
													{
														ajaxResponse.setResponse(500, "Internal Server Error 5");
													}
												}
												else
												{
													ajaxResponse.setResponse(500, "Internal Server Error 4");
												}
											}
											else
											{
												ajaxResponse.setResponse(500, "Internal Server Error 3");
											}
										}
										else
										{
											ajaxResponse.setResponse(500, "Internal Server Error 2");
										}
									}
									catch(Exception e)
									{
										logger.error("[PayController] /cart/payProc Exception", e);
										ajaxResponse.setResponse(500, "Internal Server Error");
									}
								}
								else
								{
									ajaxResponse.setResponse(400, "Bad Request");
								}
							}
							else
							{
								ajaxResponse.setResponse(404, "Not Found");
							}
						}
					}
					else
					{
						ajaxResponse.setResponse(402, "보유포인트가 부족합니다.");
					}
				}
				else
				{
					ajaxResponse.setResponse(400, "Bad Request");
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
	
	//포인트충전 인서트
	@RequestMapping(value="/pointCharge", method=RequestMethod.POST)
	@ResponseBody
	public Response<Object> pointCharge(HttpServletRequest request, HttpServletResponse response)
	{
		Response<Object> ajaxResponse = new Response<Object>();
		String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME);
		long payPrice = HttpUtil.get(request, "payPrice", (long)0);
		
		logger.debug("===========================================");
		logger.debug("payPrice : " + payPrice);
		logger.debug("===========================================");
		
		if(!StringUtil.isEmpty(cookieUserId))
		{
			if(userService.userCheck(cookieUserId) > 0)
			{
				if(payPrice != 0L)
				{
					Pay pay = new Pay();
					
					pay.setUserId(cookieUserId);
					pay.setPayPrice(payPrice);
					pay.setPayStatus("1");			//구매
					pay.setPayMethod("c");			//포인트 충전
					
					try
					{
						if(payService.payInsert(pay) > 0)
						{
							User user = userService.userSelect(cookieUserId);
							UserPoint userPoint = new UserPoint();
							
							//포인트 계산
							long result = 0;
							long pointPos = user.getPointPos();			//보유포인트
							long pointVar = pay.getPayPrice();			//포인트충전 금액
							result = pointPos + pointVar;
							
							userPoint.setPaySeq(pay.getPaySeq());
							userPoint.setUserId(cookieUserId);
							userPoint.setPointPos(result);
							userPoint.setPointVar(pay.getPayPrice());
							userPoint.setPointStatus("Y");				//포인트 증가
							
							logger.debug("===========================================");
							logger.debug("paySeq : " + pay.getPaySeq());
							logger.debug("UserId : " + cookieUserId);
							logger.debug("PointPos : " + result);
							logger.debug("PointVar : " + pay.getPayPrice());
							logger.debug("PointStatus : " + userPoint.getPointStatus());
							logger.debug("===========================================");
							
							
							if(payService.userPointInsert(userPoint) > 0)
							{
								user.setUserId(cookieUserId);
								user.setPointPos(result);
								
								if(userService.updatePoint(user) > 0)
								{
									ajaxResponse.setResponse(0, "Success");
								}
								else
								{
									ajaxResponse.setResponse(500, "Internal Server Error 4");
								}
							}
							else
							{
								ajaxResponse.setResponse(500, "Internal Server Error 3");
							}
						}
						else
						{
							ajaxResponse.setResponse(500, "Internal Server Error 2");
						}
					}
					catch(Exception e)
					{
						logger.error("[PayController] /pointCharge Exception", e);
						ajaxResponse.setResponse(500, "Internal Server Error");
					}
				}
				else
				{
					ajaxResponse.setResponse(400, "Bad Request");
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
	
	//보유게임 리스트
	@RequestMapping(value="/user/library")
	public String library(ModelMap model, HttpServletRequest request, HttpServletResponse response)
	{
		String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME);
		long curPage = HttpUtil.get(request, "curPage", (long)1);
		List<Pay> list = null;
		Paging paging = null;
		Pay pay = new Pay();
		
		pay.setUserId(cookieUserId);
		long libraryCount = payService.libraryCount(cookieUserId);
		
		logger.debug("===========================================");
		logger.debug("libraryCount : " + libraryCount);
		logger.debug("===========================================");
		
		if(libraryCount > 0)
		{
			paging = new Paging("/user/library", libraryCount, LIST_COUNT, PAGE_COUNT, curPage, "curPage");
			
			paging.addParam("curPage", curPage);
			
			pay.setStartRow(paging.getStartRow());
			pay.setEndRow(paging.getEndRow());
			
			list = payService.libraryList(pay);
		}

		model.addAttribute("list", list);
		model.addAttribute("curPage", curPage);
		model.addAttribute("paging", paging);
		
		return "/user/library";
	}
	
	//보유게임환불
	@RequestMapping(value="/library/refund", method=RequestMethod.POST)
	@ResponseBody
	public Response<Object> refund(HttpServletRequest request, HttpServletResponse response)
	{
		Response<Object> ajaxResponse = new Response<Object>();
		String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME);
		long paySeq = HttpUtil.get(request, "paySeq", (long)0);
		long productSeq = HttpUtil.get(request, "productSeq", (long)0);
		Review review = null;
		
		logger.debug("===========================================");
		logger.debug("paySeq : " + paySeq);
		logger.debug("productSeq : " + productSeq);
		logger.debug("===========================================");
		
		if(!StringUtil.isEmpty(cookieUserId) && productSeq > 0)
		{
			review = new Review();
			review.setProductSeq(productSeq);
			review.setUserId(cookieUserId);
			
				if(userService.userCheck(cookieUserId) > 0)
				{
					if(paySeq > 0)
					{
						Pay pay = payService.librarySelect(paySeq);
						
						if(pay != null)
						{
							if(StringUtil.equals(pay.getPayStatus(), "1"))			//구매했던 상품인지 확인
							{
								pay.setPaySeq(paySeq);
								Review userReview = eGameService.reviewSelect(review);
								
								if(userReview != null)
								{
									eGameService.reviewDelete(userReview.getReviewSeq());
								}
			
								try
								{
									if(payService.libraryRefund(pay) > 0)
									{
										User user = userService.userSelect(cookieUserId);
										UserPoint userPoint = new UserPoint();
										
										//포인트 계산
										long pointVar = pay.getPayPrice();			//보유포인트
										long pointPos = user.getPointPos();			//환불포인트
										long result = pointVar + pointPos;
										
										userPoint.setPaySeq(pay.getPaySeq());
										userPoint.setUserId(cookieUserId);
										userPoint.setPointPos(result);
										userPoint.setPointVar(pay.getPayPrice());
										userPoint.setPointStatus("Y");				//포인트 증가
										
										logger.debug("===========================================");
										logger.debug("paySeq : " + pay.getPaySeq());
										logger.debug("UserId : " + cookieUserId);
										logger.debug("PointPos : " + result);
										logger.debug("PointVar : " + pay.getPayPrice());
										logger.debug("PointStatus : " + userPoint.getPointStatus());
										logger.debug("===========================================");
										
										if(payService.userPointInsert(userPoint) > 0)
										{
											user.setUserId(cookieUserId);
											user.setPointPos(result);
											
											if(userService.updatePoint(user) > 0)
											{
												Product product = new Product();
												product.setProductSeq(productSeq);
												
												if(eGameService.refundCountUpdate(product) > 0)
												{
													ajaxResponse.setResponse(0, "Success");
												}
												else
												{
													ajaxResponse.setResponse(500, "Internal Server Error 4");
												}
											}
											else
											{
												ajaxResponse.setResponse(500, "Internal Server Error 3");
											}
										}
										else
										{
											ajaxResponse.setResponse(500, "Internal Server Error 2");
										}
									}
									else
									{
										ajaxResponse.setResponse(500, "Internal Server Error");
									}
									
								}
								catch(Exception e)
								{
									logger.error("[PayController] /library/refund Exception", e);
									ajaxResponse.setResponse(500, "Internal Server Error");
								}
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
					}
					else
					{
						ajaxResponse.setResponse(400, "Bad Request");
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
	
	//포인트 상세내역
	@RequestMapping(value="/user/point")
	public String point(ModelMap model, HttpServletRequest request, HttpServletResponse response)
	{
		String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME);
		long curPage = HttpUtil.get(request, "curPage", (long)1);
		List<UserPoint> list = null;
		Paging paging = null;
		UserPoint userPoint = new UserPoint();
		
		userPoint.setUserId(cookieUserId);
		long pointCount = payService.pointCount(cookieUserId);
		
		logger.debug("===========================================");
		logger.debug("pointCount : " + pointCount);
		logger.debug("===========================================");
		
		if(pointCount > 0)
		{
			paging = new Paging("/user/point", pointCount, POINT_LIST_COUNT, POINT_PAGE_COUNT, curPage, "curPage");
			
			paging.addParam("curPage", curPage);
			
			userPoint.setStartRow(paging.getStartRow());
			userPoint.setEndRow(paging.getEndRow());
			
			list = payService.pointList(userPoint);
		}
	
		model.addAttribute("list", list);
		model.addAttribute("curPage", curPage);
		model.addAttribute("paging", paging);
		
		return "/user/point";
	}
}
