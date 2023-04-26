package com.game.web.controller;

import java.util.List;

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

import com.game.common.util.StringUtil;
import com.game.web.model.Product;
import com.game.web.model.ProductSearch;
import com.game.web.model.User;
import com.game.web.service.EGameService;
import com.game.web.util.CookieUtil;

@Controller("indexController")
public class IndexController
{
	private static Logger logger = LoggerFactory.getLogger(IndexController.class);

	//유저 쿠키 이름
	@Value("#{env['auth.cookie.name']}")
	private String AUTH_COOKIE_NAME;
	
	//상품 쿠키 번호
	@Value("#{env['product.cookie.name']}")
	private String PRODUCT_COOKIE_SEQ;
	
	@Autowired
	private EGameService eGameService;
	
	@RequestMapping(value = "/index", method=RequestMethod.GET)
	public String index(Model model,HttpServletRequest request, HttpServletResponse response)
	{
		String productCookieSeq = CookieUtil.getHexValue(request, PRODUCT_COOKIE_SEQ, "").replaceAll(" ", "").replaceAll("\\[", "").replaceAll("\\]", "");
		String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME, "");
		String adminCheck = "";
		List<Product> recomProductList = null;			//추천게임 리스트
		List<Product> discntProductList = null;			//할인게임 리스트
		List<Product> buyCntProductList = null;			//판매량순 상품 리스트
		List<Product> gradeProductList = null;			//평점순 상품 리스트
		List<Product> cookieProductList = null;			//최근 본 상품 리스트
		
		if(!StringUtil.isEmpty(productCookieSeq))
		{
			String[] cookieSeqArray = productCookieSeq.split(",");
			if(cookieSeqArray.length > 0)
			{
				cookieProductList = eGameService.cookieProductList(cookieSeqArray);
			}
		}
		
		
		ProductSearch productSearch = new ProductSearch();			//검색객체 선언 
		productSearch.setStartRow(1);								//보여줄 글 갯수 시작번호
		productSearch.setEndRow(3);									//보여줄 글 갯수 시작번호
		
		productSearch.setOrderValue("random");						//정렬방법 : 랜덤
		recomProductList = eGameService.productList(productSearch);
		
		productSearch.setOrderValue("");						
		productSearch.setDiscntCheck("Y");							//할인여부 체크
		discntProductList = eGameService.productList(productSearch);
		
		productSearch.setOrderValue("buy_cnt_desc");				//정렬방법 : 판매량 높은순
		productSearch.setDiscntCheck("");
		buyCntProductList = eGameService.productList(productSearch);
		
		productSearch.setOrderValue("grade_desc");					//정렬방법 : 평점 높은순
		productSearch.setEndRow(3);									//글 갯수 5개로 설정
		gradeProductList = eGameService.productList(productSearch);
		
		if(!StringUtil.isEmpty(cookieUserId))						//아이디 어드민 체크
		{
			User user = eGameService.userSelect(cookieUserId);
			logger.debug("user.getUserClass() : "+user.getUserClass());

			if(user != null)
			{
				
				if(user.getUserClass() == 'a')
				{
					
					adminCheck = "Y";
				}
			}
			
		}
		
		
		model.addAttribute("cookieProductList", cookieProductList);
		model.addAttribute("adminCheck", adminCheck);
		model.addAttribute("recomProductList", recomProductList);
		model.addAttribute("discntProductList", discntProductList);
		model.addAttribute("buyCntProductList", buyCntProductList);
		model.addAttribute("gradeProductList", gradeProductList);
		
		return "/index";
	}

}
