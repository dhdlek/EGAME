package com.game.web.service;

import java.text.DecimalFormat;
import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Isolation;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.game.web.dao.AdminDao;
import com.game.web.dao.EGameDao;
import com.game.web.model.Discnt;
import com.game.web.model.Product;
import com.game.web.model.ProductSearch;
import com.game.web.model.User;


@Service("adminService")
public class AdminService {

	private static Logger logger = LoggerFactory.getLogger(AdminService.class);

	@Autowired
	private AdminDao adminDao;
	
	@Autowired
	private EGameDao eGameDao;
	
	//유저 카운트 가져오기
	public int userCount(User user)
	{
		int count = 0;
		
		try
		{
			count = adminDao.userCount(user);
		}
		catch(Exception e)
		{
			logger.error("[AdminService]userCount Exception", e);
		}
		
		return count;
	}
	
	//유저 리스트 가져오기
	public List<User> userList(User user)
	{
		List<User> userList = null;
		
		try
		{
			userList = adminDao.userList(user);
		}
		catch(Exception e)
		{
			logger.error("[AdminService]userList Exception", e);
		}
		
		return userList;
	}
	
	//유저 업데이트
	public int userUpdate(User user)
	{
		int count  = 0;
		
		try
		{
			count = adminDao.userUpdate(user);
		}
		catch(Exception e)
		{
			logger.error("[AdminService]userUpdate Exception", e);
		}
		
		return count;
	}
	
	//상품리스트
	public List<Product> productList(ProductSearch productSearch)
	{
		List<Product> productList = null;
		List<String> tagName = null;
		try
		{
			productList = adminDao.productList(productSearch);
			if(productList != null && productList.size() > 0)
			{
				for(int i = 0; i < productList.size(); i++)
				{
					tagName = adminDao.productTagNameSelect(productList.get(i).getProductSeq());
					productList.get(i).setTagName(tagName);
					String productName = productList.get(i).getProductName();
					String tmp = productName.replaceAll(" ", "").replaceAll(":", "").replaceAll("\'", "").replaceAll("_","");
					productList.get(i).setProductImgName(tmp);
					
					DecimalFormat priceFormat = new DecimalFormat("###,###");
					String printProductPrice = priceFormat.format(productList.get(i).getProductPrice());
					String printPayPrice = priceFormat.format(productList.get(i).getPayPrice());
					
					productList.get(i).setPrintProductPrice(printProductPrice);
					productList.get(i).setPrintPayPrice(printPayPrice);
					
					if(productList.get(i).getDiscntSeq() > 0)
					{
						Discnt discnt = adminDao.discntSelect(productList.get(i).getDiscntSeq());
						String endDate = discnt.getDiscntEndDate().substring(0,4) + "-" + discnt.getDiscntEndDate().substring(4,6) + "-" +discnt.getDiscntEndDate().substring(6,8);
						
						
						productList.get(i).setDiscntRate(discnt.getDiscntRate());
						productList.get(i).setDiscntEndDate(endDate);
					}
					
					
				}
			}
		}
		catch(Exception e)
		{
			logger.error("[AdminService]productList Exception", e);
		}
		
		
		return productList;
	}
	
	//상품 총 갯수
		public long productCnt(ProductSearch productSearch)
		{
			long cnt = 0;
			
			try
			{
				cnt = adminDao.productListCnt(productSearch);
			}
			catch(Exception e)
			{
				logger.error("[AdminService]productCnt Exception", e);
			}
			return cnt;
		}
		
		//상품 단일 셀렉트
		public Product productSelect(long productSeq)
		{
			Product product = null;
			List<String> tagName=null;
			try
			{
				product = adminDao.productSelect(productSeq);
				if(product != null)
				{
					tagName = eGameDao.productTagNameSelect(product.getProductSeq());
					product.setTagName(tagName);
					String productName = product.getProductName();
					String tmp = productName.replaceAll(" ", "").replaceAll(":", "").replaceAll("\'", "").replaceAll("_","");
					product.setProductImgName(tmp);
					
					DecimalFormat priceFormat = new DecimalFormat("###,###");
					String printProductPrice = priceFormat.format(product.getProductPrice());
					String printPayPrice = priceFormat.format(product.getPayPrice());
					
					product.setPrintProductPrice(printProductPrice);
					product.setPrintPayPrice(printPayPrice);
					if(product.getDiscntSeq() > 0)
					{
						Discnt discnt = eGameDao.discntSelect(product.getDiscntSeq());
						
						product.setDiscntRate(discnt.getDiscntRate());
						product.setDiscntEndDate(discnt.getDiscntEndDate());
					}
				}
			}
			catch(Exception e)
			{
				logger.error("[AdminService]productSelect Exception", e);
			}
			
			
			return product;
		}
		
	//상품 스테이터스 업데이트
	public int productStatusUpdate(Product product)
	{
		int count = 0;
		
		try
		{
			count = adminDao.productStatusUpdate(product);
		}
		catch(Exception e)
		{
			logger.error("[AdminService]productStatusUpdate Exception", e);
		}
		
		return count;
	}
	
	//할인 열 체크
	public Discnt productDiscntCheck(long productSeq)
	{
		Discnt discnt = null;
		
		try
		{
			discnt = adminDao.productDiscntCheck(productSeq);
		}
		catch(Exception e)
		{
			logger.error("[AdminService]productDiscntCheck Exception", e);
		}
		return discnt;
	}
	
	//할인 인서트
	public int discntInsert(Discnt discnt)
	{
		int count = 0;
		
		try
		{
			count = adminDao.discntInsert(discnt);
		}
		catch(Exception e)
		{
			logger.error("[AdminService]discntInsert Exception", e);
		}
		
		return count;
	}
	
	//할인 업데이트
	public int discntUpdate(Discnt discnt)
	{
		int count = 0;
			
		try
		{
			count = adminDao.discntUpdate(discnt);
		}
		catch(Exception e)
		{
			logger.error("[AdminService]discntupdate Exception", e);
		}
		
		return count;
	}
	
	//할인 삭제
	public int discntDelete(long discntSeq)
	{
		int count = 0;
		
		try
		{
			count = adminDao.discntDelete(discntSeq);
		}
		catch(Exception e)
		{
			logger.error("[AdminService]discntDelete Exception", e);
		}
		
		return count;
	}
	
	//할인 총 갯수
	public int discntCount(Discnt discntSearch)
	{
		int count = 0;
		
		try
		{
			count = adminDao.discntCount(discntSearch);
		}
		catch(Exception e)
		{
			logger.error("[AdminService]discntCount Exception", e);
		}
		
		return count;
	}
	
	//할인 리스트
	public List<Discnt> discntList(Discnt discntSearch)
	{
		List<Discnt> discntList = null;
		
		try
		{
			discntList = adminDao.discntList(discntSearch);
		}
		catch(Exception e)
		{
			logger.error("[AdminService]discntList Exception", e);
		}
		
		return discntList;
	}
	
	//할인시작날짜가 현재날짜와 같거나 이전이면서 할인 적용이 안된 상품번호를 가져와서 상품 업데이트
	@Transactional(rollbackFor=Exception.class, propagation = Propagation.REQUIRED,isolation = Isolation.SERIALIZABLE)
	public int discntBeforeSubmit() throws Exception
	{
		int count = 0;
		List<Discnt> discntList = null;
		Product product = null;
		
		discntList = adminDao.discntBeforeSubmit();
		
		if(discntList != null && discntList.size() > 0)
		{
			for(int i = 0; i <discntList.size(); i++)
			{
				product = eGameDao.productSelect(discntList.get(i).getProductSeq());
				product.setDiscntSeq(discntList.get(i).getDiscntSeq());
				product.setDiscntRate(discntList.get(i).getDiscntRate());
				product.setDiscntEndDate(discntList.get(i).getDiscntEndDate());
				
				long payPrice = (long)(product.getProductPrice() * ((100-discntList.get(i).getDiscntRate())/100.0));
				product.setPayPrice(payPrice);
				count += eGameDao.productUpdate(product);
			}
		}
		
		if(discntList.size() == count)
		{
			discntBeforeSubmitUpdate();
		}
		else
		{
			Exception e = new Exception("상품 업데이트 도중 오류발생");
			
			throw e;
		}
	
		
		return count;
	}
	
	//discntBeforeSubmit 메서드에서 업데이트된 할인들 스테이터스 변경
	@Transactional(rollbackFor=Exception.class, propagation = Propagation.REQUIRED,isolation = Isolation.SERIALIZABLE)
	public int discntBeforeSubmitUpdate() throws Exception
	{
		int count = 0;
		List<Discnt> discntList = null;
		discntList = adminDao.discntBeforeSubmit();
		Discnt discnt = null;
		
		if(discntList != null && discntList.size() > 0)
		{
			for(int i=0;i<discntList.size(); i++)
			{
				discnt = adminDao.discntSelect(discntList.get(i).getDiscntSeq());
				
				discnt.setDiscntStatus('Y');
				
				count += adminDao.discntSeqUpdate(discnt);
			}
			
			
			
			if(discntList.size() != count)
			{
				Exception e = new Exception("할인 업데이트 도중 오류발생");
				
				throw e;
			}
		}
		
		return count;
	}
	
	//할인종료날짜가 현재날짜와 같거나 지났을때 할인해제가 안된 할인객체를 가져와 상품 업데이트
	@Transactional(rollbackFor=Exception.class, propagation = Propagation.REQUIRED,isolation = Isolation.SERIALIZABLE)
	public int discntEndSubmit() throws Exception
	{
		int count = 0;
		List<Discnt> discntList = null;
		Product product = null;
		
		discntList = adminDao.discntEndSubmit();
		
		if(discntList != null && discntList.size() > 0)
		{
			
			for(int i = 0; i <discntList.size(); i++)
			{
				product = eGameDao.productSelect(discntList.get(i).getProductSeq());
				product.setDiscntSeq(0);
				product.setDiscntRate(0);
				product.setDiscntEndDate("");
				
				product.setPayPrice(product.getProductPrice());
				count += eGameDao.productUpdate(product);
			}
			
		}
		
		if(discntList.size() == count)
		{
			discntEndSubmitUpdate();
		}
		else
		{
			Exception e = new Exception("상품 업데이트 도중 오류발생");
			
			throw e;
		}
		
		return count;
	}
	
		//discntEndSubmit 메서드에서 업데이트된 할인들 스테이터스 변경
		@Transactional(rollbackFor=Exception.class, propagation = Propagation.REQUIRED,isolation = Isolation.SERIALIZABLE)
		public int discntEndSubmitUpdate() throws Exception
		{
			int count = 0;
			List<Discnt> discntList = null;
			discntList = adminDao.discntEndSubmit();
			Discnt discnt = null;
			
			if(discntList != null && discntList.size() > 0)
			{
				for(int i=0;i<discntList.size(); i++)
				{
					discnt = adminDao.discntSelect(discntList.get(i).getDiscntSeq());
					
					discnt.setDiscntStatus('N');
					
					count += adminDao.discntSeqUpdate(discnt);
				}
				
				
				
				if(discntList.size() != count)
				{
					Exception e = new Exception("할인 업데이트 도중 오류발생");
					
					throw e;
				}
			}
			
			return count;
		}
}
