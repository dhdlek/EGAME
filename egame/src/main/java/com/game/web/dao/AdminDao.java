package com.game.web.dao;

import java.util.List;

import org.springframework.stereotype.Repository;

import com.game.web.model.Discnt;
import com.game.web.model.Product;
import com.game.web.model.ProductSearch;
import com.game.web.model.User;

@Repository("adminDao")
public interface AdminDao {
	
	//유저 총 카운트 수
	public int userCount(User user);

	//유저 리스트(페이징)
	public List<User> userList(User user);
	
	//우자 업데이트
	public int userUpdate(User user);
	
	//상품 리스트
	public List<Product> productList(ProductSearch productSearch);
	
	//할인테이블 셀렉트
	public Discnt discntSelect(long discntSeq);
	
	//상품태그번호 이름으로 전환
	public List<String> productTagNameSelect(long productSeq);
	//총 게시물 수 
	public int productListCnt(ProductSearch productSearch);
	//상품 단일객체 셀렉트
	public Product productSelect(long productSeq);
	
	//상품 스테이터스 업데이트
	public int productStatusUpdate(Product product);
	
	//상품 날짜안지난 할인 열이 있는지 체크
	public Discnt productDiscntCheck(long productSeq);
	
	//할인 인서트
	public int discntInsert(Discnt discnt);
	
	//할인 업데이트
	public int discntUpdate(Discnt discnt);
	
	//할인 삭제
	public int discntDelete(long discntSeq);
	
	//할인 총 갯수
	public int discntCount(Discnt discntSearch);
	
	//할인 리스트
	public List<Discnt> discntList(Discnt discntSearch);
	
	//할인시작날짜가 현재날짜와 같거나 이전이면서 종료날짜가 지나지않고 할인 적용이 안된 할인객체를 가져온다
	public List<Discnt> discntBeforeSubmit();
	
	//할인종료날짜가 현재날짜와 같거나 지났을때 할인해제가 안된 할인객체를 가져온다
	public List<Discnt> discntEndSubmit();
	
	public int discntSeqUpdate(Discnt discnt);
	}
