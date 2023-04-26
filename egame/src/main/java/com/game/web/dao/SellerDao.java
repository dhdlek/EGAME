package com.game.web.dao;

import java.util.List;

import org.springframework.stereotype.Repository;

import com.game.web.model.Pay;
import com.game.web.model.Product;

@Repository("sellerDao")
public interface SellerDao
{
	//판매게임 리스트 (페이징 O)
	public List<Product> sellGameList(Product product);
	
	//게임 판매정지
	public int waitStatusPrd(Product product);
	
	//마이페이지 판매게임
	public int countSaleGame(String userId);
	
	//판매내역 게임수
	public long sellDetailCount(String userId);

	//판매내역 리스트
	public List<Pay> sellDetailList(Pay pay);
	
	//상품 별 매출액
	public long amount(Pay pay);
	
	//상품 총 매출액
	public long totalAmount(String userId);
}
