package com.game.web.service;

import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import com.game.web.dao.SellerDao;
import com.game.web.model.Pay;
import com.game.web.model.Product;
import com.game.web.model.User;
import com.game.web.util.CookieUtil;

@Service("sellerService")
public class SellerService
{
	private static Logger logger = LoggerFactory.getLogger(SellerService.class);
	
	@Autowired
	private SellerDao sellerDao;
	
	//판매게임 리스트 (페이징 O)
	public List<Product> sellGameList(Product product) {
		
		List<Product> list = null;
		
		try
		{
			list = sellerDao.sellGameList(product);
			if(list != null && list.size() > 0)
			{
				Pay pay = new Pay();
				long amount = 0;
				long totalPrice = 0;
				
				for(int i = 0; i < list.size(); i++)
				{
					long productSeq = list.get(i).getProductSeq();
					String userSellerId = list.get(i).getUserSellerId();
					
					pay.setProductSeq(productSeq);
					pay.setUserSellerId(userSellerId);
					
					amount = sellerDao.amount(pay);
					totalPrice += amount;
					
					System.out.println(amount);
					System.out.println(totalPrice);
					
					list.get(i).setAmount(amount);
					list.get(i).setTotalPrice(totalPrice);
				}
			}
		}
		catch(Exception e)
		{
			logger.error("[SellerService] sellGameList Exception", e);
		}
		
		return list;
	}
	
	//게임 판매정지
	public int waitStatusPrd(Product product) {
		
		int count = 0;
		
		try
		{
			count = sellerDao.waitStatusPrd(product);
		}
		catch(Exception e)
		{
			logger.error("[SellerService] waitStatusPrd Exception", e);
		}
		
		return count;
	}
		
	//마이페이지 판매게임
	public int countSaleGame(String userId) {
	
		int count = 0;
		
		try
		{
			count = sellerDao.countSaleGame(userId);
		}
		catch(Exception e)
		{
			logger.error("[SellerService] countSaleGame Exception", e);
		}
		
		return count;
	}
	
	//판매내역 게임수
	public long sellDetailCount(String userId) {
		
		long count = 0;
		
		try
		{
			count = sellerDao.sellDetailCount(userId);
		}
		catch(Exception e)
		{
			logger.error("[SellerService] sellDetailCount Exception", e);
		}
		
		return count;
	}

	//판매내역 리스트
	public List<Pay> sellDetailList(Pay pay) {
		
		List<Pay> list = null;
		
		try
		{
			list = sellerDao.sellDetailList(pay);
		}
		catch(Exception e)
		{
			logger.error("[SellerService] sellDetailList Exception", e);
		}
		
		return list;
	}
	
	//상품 별 매출액
	public long amount(Pay pay)
	{
		long amount = 0;
		
		try
		{
			amount = sellerDao.amount(pay);
		}
		catch(Exception e)
		{
			logger.error("[SellerService] amount Exception", e);
		}
		
		return amount;
	}
	
	//상품 총 매출액
	public long totalAmount(String userId)
	{
		long totalAmount = 0;
		
		try
		{
			totalAmount = sellerDao.totalAmount(userId);
		}
		catch(Exception e)
		{
			logger.error("[SellerService] totalAmount Exception", e);
		}
		
		return totalAmount;
	}
}