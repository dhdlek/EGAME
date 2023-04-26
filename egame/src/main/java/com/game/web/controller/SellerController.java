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
import org.springframework.web.bind.annotation.ResponseBody;

import com.game.common.util.StringUtil;
import com.game.web.model.Paging;
import com.game.web.model.Pay;
import com.game.web.model.Product;
import com.game.web.model.Response;
import com.game.web.service.EGameService;
import com.game.web.service.SellerService;
import com.game.web.service.UserService;
import com.game.web.util.CookieUtil;
import com.game.web.util.HttpUtil;

@Controller("sellerController")
public class SellerController
{
	private static Logger logger = LoggerFactory.getLogger(SellerController.class);
	
	//쿠키명
	@Value("#{env['auth.cookie.name']}")
	private String AUTH_COOKIE_NAME;
	
	//판매게임 
	private static final int LIST_COUNT = 5;
	
	//판매게임
	private static final int PAGE_COUNT = 5;
	
	//판매내역 한 페이지의 게시물 수
	private static final int SELL_LIST_COUNT = 10;
		
	//판매내역 페이징 수
	private static final int SELL_PAGE_COUNT = 5;
	
	@Autowired
	private SellerService sellerService;
	
	@Autowired
	private UserService userService;
	
	@Autowired
	private EGameService eGameService;
	
	//판매게임 페이지 폼
	@RequestMapping(value="/seller/saleGame")
	public String saleGames(ModelMap model, HttpServletRequest request, HttpServletResponse response)
	{
		String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME);
		List<Product> list = null;
		Product product = new Product();
		long curPage = HttpUtil.get(request, "curPage", (long)1);
		Paging paging = null;
		
		product.setUserSellerId(cookieUserId);
		long saleGamesCount = sellerService.countSaleGame(cookieUserId);
		
		logger.debug("===========================================");
		logger.debug("saleGamesCount : " + saleGamesCount);
		logger.debug("===========================================");
		
		if(saleGamesCount > 0)
		{
			paging = new Paging("/seller/saleGame", saleGamesCount, LIST_COUNT, PAGE_COUNT, curPage, "curPage");
		
			paging.addParam("curPage", curPage);
			
			product.setStartRow(paging.getStartRow());
			product.setEndRow(paging.getEndRow());
			
			logger.debug("==================================");
			logger.debug("userSellerId : " + product.getUserSellerId());
			logger.debug("==================================");
			
			list = sellerService.sellGameList(product);
		}
		
		logger.debug("==================================");
		logger.debug("list : " + list);
		logger.debug("==================================");
		
		model.addAttribute("list", list);
		model.addAttribute("curPage", curPage);
		model.addAttribute("paging", paging);
		
		return "/seller/saleGame";
	}
	
	//판매정지
	@RequestMapping(value="/saleGame/waitStatusPrd", method=RequestMethod.POST)
	@ResponseBody
	public Response<Object> waitStatusPrd(HttpServletRequest request, HttpServletResponse response)
	{
		Response<Object> ajaxResponse = new Response<Object>();
		String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME);
		long productSeq = HttpUtil.get(request, "productSeq", (long)0);
		
		logger.debug("===========================================");
		logger.debug("productSeq : " + productSeq);
		logger.debug("===========================================");
		
		if(!StringUtil.isEmpty(cookieUserId))
		{
			if(userService.userCheck(cookieUserId) > 0)
			{
				if(productSeq > 0)
				{
					Product product = eGameService.productSelect(productSeq);
					
					if(product != null)
					{
						if(product.getProductStatus() == 'Y')
						{
							try
							{
								if(sellerService.waitStatusPrd(product) > 0)
								{
									ajaxResponse.setResponse(0, "Success");
								}
								else
								{
									ajaxResponse.setResponse(500, "Internal Server Error2");
								}
							}
							catch(Exception e)
							{
								logger.error("[SellerController] /saleGames/waitStatusPrd Exception", e);
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
	
	//판매내역 페이지 폼
	@RequestMapping(value="/seller/saleDetail")
	public String saleDetail(ModelMap model, HttpServletRequest request, HttpServletResponse response)
	{
		String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME);
		List<Pay> list = null;
		long curPage = HttpUtil.get(request, "curPage", (long)1);
		Paging paging = null;
		Pay pay = new Pay();
		
		pay.setUserSellerId(cookieUserId);
		long sellCount = sellerService.sellDetailCount(cookieUserId);
		
		logger.debug("===========================================");
		logger.debug("sellCount : " + sellCount);
		logger.debug("===========================================");
		
		if(sellCount > 0)
		{
			paging = new Paging("/seller/saleDetail", sellCount, SELL_LIST_COUNT, SELL_PAGE_COUNT, curPage, "curPage");
			
			paging.addParam("curPage", curPage);
			
			pay.setStartRow(paging.getStartRow());
			pay.setEndRow(paging.getEndRow());
			
			list = sellerService.sellDetailList(pay);
		}
		
		model.addAttribute("list", list);
		model.addAttribute("curPage", curPage);
		model.addAttribute("paging", paging);
		
		return "/seller/saleDetail";
	}
}
