package com.game.web.model;

import java.io.Serializable;
import java.util.List;


//상품 테이블
public class Product implements Serializable{
	
	private static final long serialVersionUID = 1L;
	
	private long productSeq;				//상품번호
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
	private List<String> tagName; 			//상품 태그 이름 리스트
	private String tagParentnum;			//상품 상위태그번호
	
	private String productImgName;			//이미지형식으로 변경한 상품이름 
	private String printProductPrice;		//정규식 적용된 출력용 상품가격 		
	private String printPayPrice;			//정규식 적용된 출력용 결제가격 		
	
	private long amount;					//상품 매출액
	private long totalPrice;				//상품 총 매출액
	
	private long discntRate;				//할인율
	private String discntEndDate;			//할인 종료 날짜
	
	private long startRow;			//시작 row num
	private long endRow;			//끝 row num
	
	public Product()
	{
		productSeq = 0;
		userSellerId = "";
		discntSeq = 0;
		productName = "";
		productImgName = "";
		productPrice = 0;
		productContent = "";
		productBuyCnt = 0;
		payPrice = 0;
		reviewCnt = 0;
		productGrade = 0;
		productStatus = 'N';
		tagName = null;
		tagParentnum = "";
		printProductPrice = "";
		printPayPrice = "" ;
		amount = 0;
		totalPrice = 0;
		discntRate = 0;
		discntEndDate = "";
		
		startRow = 0;
		endRow = 0;
	}

	public long getProductSeq() {
		return productSeq;
	}

	public void setProductSeq(long productSeq) {
		this.productSeq = productSeq;
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

	public List<String> getTagName() {
		return tagName;
	}

	public void setTagName(List<String> tagName) {
		this.tagName = tagName;
	}

	public String getTagParentnum() {
		return tagParentnum;
	}

	public void setTagParentnum(String tagParentnum) {
		this.tagParentnum = tagParentnum;
	}

	public String getProductImgName() {
		return productImgName;
	}

	public void setProductImgName(String productImgName) {
		this.productImgName = productImgName;
	}

	public String getPrintProductPrice() {
		return printProductPrice;
	}

	public void setPrintProductPrice(String printProductPrice) {
		this.printProductPrice = printProductPrice;
	}

	public String getPrintPayPrice() {
		return printPayPrice;
	}

	public void setPrintPayPrice(String printPayPrice) {
		this.printPayPrice = printPayPrice;
	}
	
	public long getAmount() {
		return amount;
	}

	public void setAmount(long amount) {
		this.amount = amount;
	}
	
	public long getTotalPrice() {
		return totalPrice;
	}

	public void setTotalPrice(long totalPrice) {
		this.totalPrice = totalPrice;
	}

	public long getDiscntRate() {
		return discntRate;
	}

	public void setDiscntRate(long discntRate) {
		this.discntRate = discntRate;
	}

	public String getDiscntEndDate() {
		return discntEndDate;
	}

	public void setDiscntEndDate(String discntEndDate) {
		this.discntEndDate = discntEndDate;
	}

	public long getStartRow() {
		return startRow;
	}

	public void setStartRow(long startRow) {
		this.startRow = startRow;
	}

	public long getEndRow() {
		return endRow;
	}

	public void setEndRow(long endRow) {
		this.endRow = endRow;
	}
}
