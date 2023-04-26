package com.game.web.model;

import java.io.Serializable;

public class Cart implements Serializable{

	private static final long serialVersionUID = 1L;
	
	private long productSeq;				//상품번호
	private String userId;					//사용자 아이지
	private String cartDate;				//장바구니 등록일자
	
	private String userSellerId;			//판매자 아이디
	private long discntSeq;					//할인 번호
	private String productName;				//상품 이름
	private long productPrice;				//상품 가격
	private String productContent;			//상품 내용
	private long productBuyCnt;				//상품 구매 카운트
	private long payPrice;					//결제 가격
	private long reviewCnt;					//리뷰 갯수
	private long productGrade;				//상품 평점 결과값
	private char productStatus;				//상품 스테이터스
	
	Discnt prdDiscnt = new Discnt();
	private long discntRate = prdDiscnt.getDiscntRate();
	
	public Cart()
	{
		productSeq = 0;
		userId = "";
		cartDate = "";
				
		userSellerId = "";
		discntSeq = 0;
		productName = "";
		productPrice = 0;
		productContent = "";
		productBuyCnt = 0;		
		payPrice = productPrice * (1 - discntRate/100);		
		reviewCnt = 0;
		productGrade = 0;
		productStatus = 'N';
	}

	public long getProductSeq() {
		return productSeq;
	}

	public void setProductSeq(long productSeq) {
		this.productSeq = productSeq;
	}

	public String getUserId() {
		return userId;
	}

	public void setUserId(String userId) {
		this.userId = userId;
	}

	public String getCartDate() {
		return cartDate;
	}

	public void setCartDate(String cartDate) {
		this.cartDate = cartDate;
	}

	public String getUserSellerId() {
		return userSellerId;
	}

	public void setUserSellerId(String userSellerId) {
		this.userSellerId = userSellerId;
	}

	public long getDiscntSeq() {
		return discntSeq;
	}

	public void setDiscntSeq(long discntSeq) {
		this.discntSeq = discntSeq;
	}

	public String getProductName() {
		return productName;
	}

	public void setProductName(String productName) {
		this.productName = productName;
	}

	public long getProductPrice() {
		return productPrice;
	}

	public void setProductPrice(long productPrice) {
		this.productPrice = productPrice;
	}

	public String getProductContent() {
		return productContent;
	}

	public void setProductContent(String productContent) {
		this.productContent = productContent;
	}

	public long getProductBuyCnt() {
		return productBuyCnt;
	}

	public void setProductBuyCnt(long productBuyCnt) {
		this.productBuyCnt = productBuyCnt;
	}

	public long getPayPrice() {
		return payPrice;
	}

	public void setPayPrice(long payPrice) {
		this.payPrice = payPrice;
	}

	public long getReviewCnt() {
		return reviewCnt;
	}

	public void setReviewCnt(long reviewCnt) {
		this.reviewCnt = reviewCnt;
	}

	public long getProductGrade() {
		return productGrade;
	}

	public void setProductGrade(long productGrade) {
		this.productGrade = productGrade;
	}

	public char getProductStatus() {
		return productStatus;
	}

	public void setProductStatus(char productStatus) {
		this.productStatus = productStatus;
	}
	
}
