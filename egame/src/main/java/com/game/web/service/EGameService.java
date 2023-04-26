package com.game.web.service;

import java.text.DecimalFormat;
import java.util.ArrayList;
import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.game.web.dao.EGameDao;
import com.game.web.dao.UserDao;
import com.game.web.model.Cart;
import com.game.web.model.Discnt;
import com.game.web.model.Pay;
import com.game.web.model.Product;
import com.game.web.model.ProductSearch;
import com.game.web.model.ProductTag;
import com.game.web.model.Review;
import com.game.web.model.User;


@Service("eGameServidce")
public class EGameService {
	
	private static Logger logger = LoggerFactory.getLogger(EGameService.class);
	
	@Autowired
	private EGameDao eGameDao;
	
	@Autowired
	private UserDao userDao;
	
	//상품 인서트 서비스
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor=Exception.class)
	public int productInsert(Product product, List<String> tags) throws Exception
	{
		int count = 0;
		
		long productSeq;
		
		ProductTag productTag = new ProductTag();
		
		count = eGameDao.productInsert(product);
		
		productSeq = eGameDao.productSeqSelect(product.getProductName());
		
		productTag.setProductSeq(productSeq);
		
		if(count > 0)
		{
			for(int i = 0; i < tags.size(); i++)
			{
				productTag.setTagNum(tags.get(i));
				
				count = eGameDao.productTagInsert(productTag);
			}
		}
		
		return count;
	}
	
	//상품 총 갯수
	public long productCnt(ProductSearch productSearch)
	{
		long cnt = 0;
		
		try
		{
			cnt = eGameDao.productListCnt(productSearch);
		}
		catch(Exception e)
		{
			logger.error("[EGameService]productCnt Exception", e);
		}
		return cnt;
	}
	
	//상품 리스트 가져오는 서비스
	public List<Product> productList(ProductSearch productSearch)
	{
		List<Product> productList = null;
		List<String> tagName = null;
		try
		{
			productList = eGameDao.productList(productSearch);
			if(productList != null && productList.size() > 0)
			{
				for(int i = 0; i < productList.size(); i++)
				{
					tagName = eGameDao.productTagNameSelect(productList.get(i).getProductSeq());
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
						Discnt discnt = eGameDao.discntSelect(productList.get(i).getDiscntSeq());
						String endDate = discnt.getDiscntEndDate().substring(0,4) + "-" + discnt.getDiscntEndDate().substring(4,6) + "-" +discnt.getDiscntEndDate().substring(6,8);
						
						productList.get(i).setDiscntRate(discnt.getDiscntRate());
						productList.get(i).setDiscntEndDate(endDate);
					}
					
				}
			}
		}
		catch(Exception e)
		{
			logger.error("[EGameService]productList Exception", e);
		}
		
		
		return productList;
	}
	
	//상품 단일 셀렉트
	public Product productSelect(long productSeq)
	{
		Product product = null;
		List<String> tagName=null;
		try
		{
			product = eGameDao.productSelect(productSeq);
			if(product != null)
			{
				//태그이름 가져오기
				tagName = eGameDao.productTagNameSelect(product.getProductSeq());
				product.setTagName(tagName);
				//상품이름 공백, 특수문자 제거
				String productName = product.getProductName();
				String tmp = productName.replaceAll(" ", "").replaceAll(":", "").replaceAll("\'", "").replaceAll("_","");
				product.setProductImgName(tmp);
				
				//상품가격 포멧설정
				DecimalFormat priceFormat = new DecimalFormat("###,###");
				String printProductPrice = priceFormat.format(product.getProductPrice());
				String printPayPrice = priceFormat.format(product.getPayPrice());
				
				//상품 내용 엔터키 넣기
				String productContent = product.getProductContent();
				productContent = productContent.replace(".", ".<br/>");
				product.setProductContent(productContent);
				
				//화면에보여줄 가격설정
				product.setPrintProductPrice(printProductPrice);
				product.setPrintPayPrice(printPayPrice);
				
				//할인번호가 있을 시 할인율과 할인종료날짜 세팅
				if(product.getDiscntSeq() > 0)
				{
					Discnt discnt = eGameDao.discntSelect(product.getDiscntSeq());
					String endDate = discnt.getDiscntEndDate().substring(0,4) + "-" + discnt.getDiscntEndDate().substring(4,6) + "-" +discnt.getDiscntEndDate().substring(6,8);
					
					product.setDiscntRate(discnt.getDiscntRate());
					product.setDiscntEndDate(endDate);
				}
			}
		}
		catch(Exception e)
		{
			logger.error("[EGameService]productSelect Exception", e);
		}
		
		
		return product;
	}
	//리뷰 총 갯수
	public long reviewCount(long productSeq)
	{
		long count = 0;
		
		try
		{
			count = eGameDao.reviewCount(productSeq);
		}
		catch(Exception e)
		{
			logger.error("[EGameService]reviewCount Exception", e);
		}
		
		return count;
	}
	
	//리뷰 리스트
	public List<Review> reviewList(Review review)
	{
		List<Review> reviewList = null;
		
		try
		{
			reviewList = eGameDao.reviewList(review);
		}
		catch(Exception e)
		{
			logger.error("[EGameService]reviewList Exception", e);
		}
		return reviewList;
	}
	
	//단일 리뷰 가져오기 이름과 상품번호로 검색
	public Review reviewSelect(Review review) 
	{
		Review myReview = null;
		
		try
		{
			myReview = eGameDao.reviewSelect(review);
		}
		catch(Exception e)
		{
			logger.error("[EGameService]reviewSelect Exception", e);
		}
		return myReview;
	}
		
	//리뷰단일 가져오기 리뷰번호로 검색
	public Review reviewSeqSelect(long reviewSeq) 
	{
		Review review = null;
		
		try
		{
			review = eGameDao.reviewSeqSelect(reviewSeq);
		}
		catch(Exception e)
		{
			logger.error("[EGameService]reviewSeqSelect Exception", e);
		}
		
		return review;
	}
	
	//유저 아이디 체크
	public long userCheck(String userId)
	{
		long count = 0;
		
		try
		{
			count = userDao.userCheck(userId);
		}
		catch(Exception e)
		{
			logger.error("[EGameService]userCheck Exception", e);
		}
		
		return count;
	}
	
	//유저 셀렉트
	public User userSelect(String userId)
	{
		User user = null;
		
		try
		{
			user = userDao.userSelect(userId);
		}
		catch(Exception e)
		{
			logger.error("[EGameService]userSelect Exception", e);
		}
		
		return user;
	}
	
	//리뷰 작성여부 체크
	public long reviewCheck(Review review)
	{
		long count = 0;
		
		try
		{
			count = eGameDao.reviewCheck(review);
		}
		catch(Exception e)
		{
			logger.error("[EGameService]reviewCheck Exception", e);
		}
		
		return count;
	}
	
	//리뷰작성
	public int reviewInsert(Review review)
	{
		int count = 0;
		
		try
		{
			count = eGameDao.reviewInsert(review);
		}
		catch(Exception e)
		{
			logger.error("[EGameService]reviewInsert Exception", e);	
		}
		
		return count;
	}
	
	//상품 평점, 리뷰수 업데이트
	public int productReviewUpdate(long productSeq)
	{
		int count = 0;
		
		try
		{
			Product product = eGameDao.productSelect(productSeq);
			long reviewCnt  = eGameDao.reviewCount(productSeq);
			long productGrade = eGameDao.productGradeSum(productSeq);
			
			product.setReviewCnt(reviewCnt);
			
			if(reviewCnt > 0)
			{
				long gradeVal = productGrade/reviewCnt;
				product.setProductGrade(gradeVal);				
			}
			else
			{
				product.setProductGrade(reviewCnt);	
			}
			count = eGameDao.productUpdate(product);
		}
		catch(Exception e)
		{
			logger.error("[EGameService]productReviewUpdate Exception", e);
		}
		
		return count;
	}
	
	//리뷰 삭제
	public int reviewDelete(long reviewSeq)
	{
		int count = 0;
		
		try
		{
			count = eGameDao.reviewDelete(reviewSeq);
		}
		catch(Exception e)
		{
			logger.error("[EGameService]reviewDelete Exception", e);
		}
		
		return count;
	}
	
	//리뷰 업데이트
	public int reviewUpdate(Review review)
	{
		int count = 0;
		
		try
		{
			count = eGameDao.reviewUpdate(review);
		}
		catch(Exception e)
		{
			logger.error("[EGameService]reviewUpdate Exception", e);
		}
		
		
		return count;
	}
	
	//상품 구매여부 체크
	public int productBuyCheck(Pay pay)
	{
		int count = 0;
		
		try
		{
			count = eGameDao.productBuyCheck(pay);
		}
		catch(Exception e)
		{
			logger.error("[EGameService]productBuyCheck Exception", e);
		}
		
		return count;		
	}
	
	//장바구니 보유여부 체크
	public int cartCheck(Cart cart)
	{
		int count = 0;
		
		try
		{
			count = eGameDao.cartCheck(cart);
		}
		catch(Exception e)
		{
			logger.error("[EGameService]cartCheck Exception", e);
		}
		
		return count;
	}
	
	//장바구니 추가
	public int cartInsert(Cart cart)
	{
		int count = 0;
		
		try
		{
			count = eGameDao.cartInsert(cart);
		}
		catch(Exception e)
		{
			logger.error("[EGameService]cartInsert Exception", e);
		}
		
		return count;
	}
	
	//장바구니 삭제
	public int cartDelete(Cart cart) 
	{
		int count = 0;
		
		try
		{
			count = eGameDao.cartDelete(cart);
		}
		catch(Exception e)
		{
			logger.error("[EGameService]cartDelete Exception", e);
		}
		return count;
	}
	
	//장바구니 목록 조회
	public List<Cart> cartSelect(String userId) {
		
		List<Cart> cartList = null;
		
		try
		{
			cartList = eGameDao.cartSelect(userId);
		}
		catch(Exception e)
		{
			logger.error("[EGameService]cartSelect Exception", e);
		}
		
		return cartList;
	}
	
	//쿠키 상품 리스트 반환
	public List<Product> cookieProductList(String[] cookieSeqArray)
	{
		List<Product> cookieProductList = new ArrayList<Product>();
		List<String> tagName=null;
		
		try
		{
			for(int i = cookieSeqArray.length-1; i >= 0; i--)
			{
				Product product = eGameDao.productSelect(Long.parseLong(cookieSeqArray[i]));
				
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
					String endDate = discnt.getDiscntEndDate().substring(0,4) + "-" + discnt.getDiscntEndDate().substring(4,6) + "-" +discnt.getDiscntEndDate().substring(6,8);
					
					product.setDiscntRate(discnt.getDiscntRate());
					product.setDiscntEndDate(endDate);
				}
				cookieProductList.add(product);
			}
		}
		catch(Exception e)
		{
			logger.error("[EGameService]cookieProductList Exception", e);
		}
		
		return cookieProductList;
	}
	
	//상품 구매 카운트 업데이트
	public int buyCountUpdate(Product product)
	{
		int count = 0;
		
		try
		{
			count = eGameDao.buyCountUpdate(product);
		}
		catch(Exception e)
		{
			logger.error("[EGameService] buyCountUpdate Exception", e);
		}
		
		return count;
	}
	
	//상품 환불 카운트 업데이트
	public int refundCountUpdate(Product product)
	{
		int count = 0;
		
		try
		{
			count = eGameDao.refundCountUpdate(product);
		}
		catch(Exception e)
		{
			logger.error("[EGameService] refundCountUpdate Exception", e);
		}
	
		return count;
	}
}
