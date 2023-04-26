package com.game.web.dao;

import java.util.List;

import org.springframework.stereotype.Repository;

import com.game.web.model.Cart;
import com.game.web.model.Discnt;
import com.game.web.model.Pay;
import com.game.web.model.Product;
import com.game.web.model.ProductSearch;
import com.game.web.model.ProductTag;
import com.game.web.model.Review;

@Repository("eGameDao")
public interface EGameDao {

	//상품 insert
	public int productInsert(Product product);
	
	//상품태그 insert
	public int productTagInsert(ProductTag productTag);
	
	//상품번호 가져오기
	public long productSeqSelect(String productName);
	
	//총 게시물 수 
	public int productListCnt(ProductSearch productSearch);
	
	//상품 리스트(페이징)
	public List<Product> productList(ProductSearch productSearch);
	
	//상품태그번호 이름으로 전환
	public List<String> productTagNameSelect(long productSeq);
	
	//상품 단일객체 셀렉트
	public Product productSelect(long productSeq);
	
	//상품당 리뷰 총 갯수
	public int reviewCount(long productSeq);
	
	//리뷰 리스트
	public List<Review> reviewList(Review review);
	
	//리뷰 작성여부 체크
	public int reviewCheck(Review review);
	
	//리뷰 작성
	public int reviewInsert(Review review);
	
	//단일 리뷰 가져오기 이름과 상품번호로 검색
	public Review reviewSelect(Review review);
	
	//리뷰단일 가져오기 리뷰번호로 검색
	public Review reviewSeqSelect(long review);
	
	//상품 리뷰 합산값 가져오기
	public long productGradeSum(long productSeq);
	
	//상품 업데이트
	public int productUpdate(Product product);
	
	//리뷰 삭제
	public int reviewDelete(long reviewSeq);
	
	//리뷰 업데이트
	public int reviewUpdate(Review review);
	
	//상품 구매여부 체크
	public int productBuyCheck(Pay pay);
	
	//장바구니 보유여부 체크
	public int cartCheck(Cart cart);
	
	//장바구니 추가
	public int cartInsert(Cart cart);
	
	//장바구니 삭제
	public int cartDelete(Cart cart);
	
	//장바구니 상품목록 조회
	public List<Cart> cartSelect(String userId);
	
	//할인테이블 셀렉트
	public Discnt discntSelect(long discntSeq);
	
	//상품 구매 카운트 업데이트
	public int buyCountUpdate(Product product);
	
	//상품 환불 카운트 업데이트
	public int refundCountUpdate(Product product);
}
